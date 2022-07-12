/*
 * This file is part of the µOS++ distribution.
 *   (https://github.com/micro-os-plus/)
 * Copyright (c) 2022 Liviu Ionescu.
 *
 * Permission to use, copy, modify, and/or distribute this software
 * for any purpose is hereby granted, under the terms of the MIT license.
 *
 * If a copy of the license was not distributed with this file, it can
 * be obtained from https://opensource.org/licenses/MIT/.
 */

// ----------------------------------------------------------------------------

#if defined(__ARM_EABI__)

// ----------------------------------------------------------------------------

// AArch64 GCC does not support naked functions, so everything should be
// written in assembly.

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

    // Only CPU 0 performs the initializations. All other CPUs go into WFI.
    // To do this, first work out which CPU this is by reading MPIDR.
    mrc     p15, 0, r1, c0, c0, 5 // Read Multiprocessor Affinity Register
    and     r1, r1, #0x3 // Extract CPU ID bits
    cmp     r1, #0
    beq     .Lcpu0_initialize // If we’re on CPU0 goto the start.

.Lcpu_sleep:
    wfi     // Other CPUs are left sleeping.
    b       .Lcpu_sleep

.Lcpu0_initialize:
    ldr     r0, =__stack
    // Enter each mode in turn and set up the stack pointer
#if 0
    MSR     CPSR_c, #Mode_FIQ:OR:I_Bit:OR:F_Bit
    MOV     SP, R0
    SUB     R0, R0, #FIQ_Stack_Size
    MSR     CPSR_c, #Mode_IRQ:OR:I_Bit:OR:F_Bit
#endif
    mov     sp, r0

    // Disable MMU.
    mrc     p15, 0, r1, c1, c0, 0 // Read Control Register configuration data
    bic     r1, r1, #0x1
    mcr     p15, 0, r1, c1, c0, 0 // Write Control Register configuration data

    // Use bl instead of b to have a proper stack record for GDB
    // to display a full stack trace.
    bl      _start

#else
#error "Unsupported architecture."
#endif

// ----------------------------------------------------------------------------

#endif // defined(__ARM_EABI__)

// ----------------------------------------------------------------------------
