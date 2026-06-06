/*
 * This file is part of the µOS++ project (https://micro-os-plus.github.io/).
 * Copyright (c) 2022-2026 Liviu Ionescu. All rights reserved.
 *
 * Permission to use, copy, modify, and/or distribute this software
 * for any purpose is hereby granted, under the terms of the MIT license.
 *
 * If a copy of the license was not distributed with this file, it can
 * be obtained from https://opensource.org/licenses/mit.
 */

// ----------------------------------------------------------------------------

#if defined(__ARM_EABI__)

// ----------------------------------------------------------------------------

// In `architecture-cortexa/linker-scripts/sections-flash.ld` there is an
// `ENTRY(Reset_Handler)` to tell QEMU where to start.

    .section .after_vectors,"awx",%progbits

    .align 2
    .globl Reset_Handler
    .type Reset_Handler, %function
Reset_Handler:

#if defined(__ARM_ARCH_7A__)

    // DEN0013D_cortex_a_series_PG.pdf
    // 13.1 Booting a bare-metal system

    // Note: Do not use any call here, the stack pointer is set just before
    // calling the startup.

    // Only CPU 0 performs initialization. Other CPUs go into WFI
    // to do this, first work out which CPU this is
    // this code typically is run before any other initialization step
    mrc     p15, 0, r1, c0, c0, 5   // Read Multiprocessor Affinity Register
    and     r1, r1, #0x3            // Extract CPU ID bits
    cmp     r1, #0
    beq     .Lcpu0_initialize       // If we’re on CPU0 goto the start.

.Lcpu_sleep:
    wfi     // Other CPUs are left sleeping.
    b       .Lcpu_sleep

.Lcpu0_initialize:
    // --- Set vector base ---
    ldr     r0, =_interrupt_vectors
    mcr     p15, 0, r0, c12, c0, 0
    dsb

    // --- Disable MMU ---
    mrc     p15, 0, r1, c1, c0, 0   // Read Control Register configuration data
    bic     r1, r1, #0x1
    mcr     p15, 0, r1, c1, c0, 0   // Write Control Register configuration data

    // --- Disable L1 Caches ---
    mrc     p15, 0, r1, c1, c0, 0   // Read Control Register configuration data
    bic     r1, r1, #(0x1 << 12)    // Disable I Cache
    bic     r1, r1, #(0x1 << 2)     // Disable D Cache
    mcr     p15, 0, r1, c1, c0, 0   // Write Control Register configuration data

    // --- Invalidate L1 Caches ---
    // Invalidate Instruction cache
    mov     r1, #0
    mcr     p15, 0, r1, c7, c5, 0

    // --- Invalidate Data cache ---
    // to make the code general purpose, we calculate the
    // cache size first and loop through each set + way
    mrc     p15, 1, r0, c0, c0, 0   // Read Cache Size ID
    ldr     r3, =#0x1ff
    and     r0, r3, r0, LSR #13     // r0 = no. of sets - 1

    mov     r1, #0                  // r1 = way counter way_loop
.Lway_loop:
    mov     r3, #0                  // r3 = set counter set_loop
.Lset_loop:
    mov     r2, r1, LSL #30
    orr     r2, r3, LSL #5          // r2 = set/way cache operation format
    mcr     p15, 0, r2, c7, c6, 2   // Invalidate line described by r2
    add     r3, r3, #1              // Increment set counter
    cmp     r0, r3                  // Last set reached yet?
    bgt     .Lset_loop                // if not, iterate set_loop
    add     r1, r1, #1              // else, next
    cmp     r1, #4                  // Last way reached yet?

    bne     .Lway_loop                // if not, iterate way_loop

    // Invalidate TLB
    mcr     p15, 0, r1, c8, c7, 0

    // --- Enable Branch Prediction ---
    mov     r1, #0
    mrc     p15, 0, r1, c1, c0, 0   // Read Control Register configuration data
    orr     r1, r1, #(0x1 << 11)    // Global BP Enable bit
    mcr     p15, 0, r1, c1, c0, 0   // Write Control Register configuration data

    // --- Enable D-side Prefetch ---
    mrc     p15, 0, r1, c1, c0, 1   // Read Auxiliary Control Register
    orr     r1, r1, #(0x1 <<2)      // Enable D-side prefetch
    mcr     p15, 0, r1, c1, c0, 1   // Write Auxiliary Control Register

    // dsb causes completion of all cache maintenance operations
    // appearing in program order before the dsb instruction
    dsb
    // An isb instruction causes the effect of all branch predictor maintenance
    // operations before the isb instruction to be visible to all instructions
    // after the isb instruction.
    isb

    // --- Initialize PageTable ---
    // This will create a basic L1 page table in RAM, with 1MB sections
    // containing a flat (VA=PA) mapping, all pages Full Access, Strongly Ordered
    // It would be faster to create this in a read-only section in an assembly file
    ldr     r0, =0b00000000000000000000110111100010 // r0 is the non-address part of the descriptor
    ldr     r1, ttb_address
    ldr     r3, = 4095              // loop counter
.Lwrite_pte:
    orr     r2, r0, r3, LSL #20     // OR together address & default PTE bits
    str     r2, [r1, r3, LSL #2]    // write PTE to TTB
    subs    r3, r3, #1              // decrement loop counter
    bne     .Lwrite_pte

    // for the very first entry in the table, we will make it cacheable,
    // normal, write-back, write allocate
    bic     r0, r0, #0b1100               // clear CB bits
    orr     r0, r0, #0b0100               // inner write-back, write allocate
    bic     r0, r0, #0b111000000000000      // clear TEX bits
    orr     r0, r0, #0b101000000000000      // set TEX as write-back, write allocate
    orr     r0, r0, #0b10000000000000000    // shareable
    str     r0, [r1]

    // --- Initialize MMU ---
    mov     r1,#0x0
    mcr     p15, 0, r1, c2, c0, 2   // Write Translation Table Base Control Register
    ldr     r1, ttb_address
    mcr     p15, 0, r1, c2, c0, 0   // Write Translation Table Base Register 0

    // In this simple example, we don't use TRE or Normal Memory Remap Register.
    // Set all Domains to Client
    ldr     r1, =0x55555555
    mcr     p15, 0, r1, c3, c0, 0   // Write Domain Access Control Register

    // --- Enable MMU ---
    mrc     p15, 0, r1, c1, c0, 0   // Read Control Register configuration data
    orr     r1, r1, #0x1            // Bit 0 is the MMU enable
    mcr     p15, 0, r1, c1, c0, 0   // Write Control Register configuration data

    // The L2 cache, if present, and if running without an operating system,
    // might also require invalidating and enabling at this point.
    // NEON or VFP access must also be enabled. If the system
    // makes use of the TrustZone Security Extensions, it might have
    // to switch to the Normal world when the Secure world is initialized.
    // See Chapter 21 Security for details of this.

    // --- Enable unaligned access ---
    // Note: disabling the alignment fault checking is mandatory,
    // the toolchain libraries are not built with -fstrict-align, and
    // will fail.
    mrc     p15, 0, r1, c1, c0, 0   // Read SCTLR once
    bic     r1, r1, #(1 << 1)       // Clear A bit (alignment faults)
    mcr     p15, 0, r1, c1, c0, 0   // Write SCTLR once

    // Test unaligned access.
    ldr     r0, =(__data_start__+1) // Odd address (unaligned for 32-bit load)
    ldr     r1, [r0]                // This should work with the MMU enabled

    // --- Configure stack ---
    ldr     r0, =__stack
#if 0
    // Enter each mode in turn and set up the stack pointer
    msr     CPSR_c, #Mode_FIQ:OR:I_Bit:OR:F_Bit
    mov     sp, r0
    sub     r0, r0, #FIQ_Stack_Size
    msr     CPSR_c, #Mode_IRQ:OR:I_Bit:OR:F_Bit
#endif
    mov     sp, r0

    // Use bl instead of b to have a proper stack record for GDB
    // to display a full stack trace.
    bl      _start

// ----------------------------------------------------------------------------

ttb_address:
    .word   ttb_base

    // Cannot be in the standard .bss, since it is cleared at startup.
    .section .noinit, "aw", %nobits
    .align  14                      // 16KB alignment
ttb_base:
    .space  16384                   // 16KB

// ----------------------------------------------------------------------------

#else
#error "Unsupported architecture."
#endif

// ----------------------------------------------------------------------------

#endif // defined(__ARM_EABI__)

// ----------------------------------------------------------------------------
