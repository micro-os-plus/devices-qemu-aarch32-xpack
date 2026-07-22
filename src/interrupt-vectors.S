/*
 * This file is part of the µOS++ project (https://micro-os-plus.github.io/).
 * Copyright (c) 2022-2026 Liviu Ionescu. All rights reserved.
 *
 * Permission to use, copy, modify, and/or distribute this software for any
 * purpose is hereby granted, under the terms of the MIT license.
 *
 * If a copy of the license was not distributed with this file, it can be
 * obtained from https://opensource.org/licenses/mit.
 */

// ----------------------------------------------------------------------------

#if defined(__ARM_EABI__)

// ----------------------------------------------------------------------------

#define __ASSEMBLY__ 1
#include "micro-os-plus/architecture-aarch32/exception-handlers.h"

// ----------------------------------------------------------------------------

#if defined(__ARM_ARCH_7A__)

    .globl _interrupt_vectors
    // "x" makes it visible in the listing.
    .section .interrupt_vectors,"awx",%progbits

    .align  7
_interrupt_vectors:

    .balign 4
    b     Reset_Handler
    b     undefined_handler
    b     swi_handler
    b     prefetch_handler
    b     data_handler
    nop   // Reserved vector
    b     irq_handler
    b     fiq_handler

// ----------------------------------------------------------------------------

    .section .after_vectors,"awx",%progbits

    .balign 4
undefined_handler:
    wfi
    b     undefined_handler

    .balign 4
swi_handler:
    wfi
    b     swi_handler

    .balign 4
prefetch_handler:
    wfi
    b     prefetch_handler

    .balign 4
data_handler:
    // Save return address (adjust for data abort)
    sub     lr, lr, #8

    // Save state using SRS (Store Return State)
    srsfd   sp!, #0x1f          // Save LR and SPSR to System mode stack

    // Switch to System mode
    cps     #0x1f

    // Save caller-saved registers
    push    {r0-r3, r12}

    // Ensure stack is 8-byte aligned (AAPCS requirement)
    and     r1, sp, #4          // Check if SP is 8-byte aligned
    sub     sp, sp, r1          // Adjust if needed
    push    {r1, lr}            // Save alignment and LR

    // Read fault status and address registers
    mrc     p15, 0, r0, c5, c0, 0   // Read DFSR (Data Fault Status Register)
    mrc     p15, 0, r1, c6, c0, 0   // Read DFAR (Data Fault Address Register)

    // Call C handler: c_data_abort_handler(dfsr, dfar)
    bl      c_data_abort_handler

    // Restore stack alignment and LR
    pop     {r1, lr}
    add     sp, sp, r1

    // Restore caller-saved registers
    pop     {r0-r3, r12}

    // Return from exception using RFE (Return From Exception)
    rfefd   sp!

    .balign 4
irq_handler:
    SUB   lr, lr, #4
    SRSFD sp!, #0x1f
    CPS   #0x1f
    PUSH  {r0-r3, r12}
    AND   r1, sp, #4
    SUB   sp, sp, r1
    PUSH  {r1, lr}
    BL    identify_and_clear_source
    CPSIE i
    BL    c_irq_handler
    CPSID i
    POP   {r1, lr}
    ADD   sp, sp, r1
    POP   {r0-r3, r12}
    RFEFD sp!

identify_and_clear_source:
    bx    lr

    .balign 4
fiq_handler:
    wfi
    b     fiq_handler

// ----------------------------------------------------------------------------

#else
#error "Unsupported architecture."
#endif

// ----------------------------------------------------------------------------

#endif // defined(__ARM_EABI__)

// ----------------------------------------------------------------------------
