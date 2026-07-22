/*
 * This file is part of the µOS++ project (https://micro-os-plus.github.io/).
 * Copyright (c) 2014-2026 Liviu Ionescu. All rights reserved.
 *
 * Permission to use, copy, modify, and/or distribute this software for any
 * purpose is hereby granted, under the terms of the MIT license.
 *
 * If a copy of the license was not distributed with this file, it can be
 * obtained from https://opensource.org/licenses/mit.
 */

#ifndef MICRO_OS_PLUS_ARCHITECTURE_AARCH32_EXCEPTION_HANDLERS_H_
#define MICRO_OS_PLUS_ARCHITECTURE_AARCH32_EXCEPTION_HANDLERS_H_

// ----------------------------------------------------------------------------

// The file is also included in assembly.

#if defined(__cplusplus)
extern "C"
{
#endif

#if defined(__ARM_ARCH_7A__)

#if !defined(__ASSEMBLY__)

#include <stdint.h>

  void
  c_irq_handler (void);

  void
  c_data_abort_handler (uint32_t dfsr, uint32_t dfar);

#endif // !defined(__ASSEMBLY__)

// Definitions used in assembly.
// TODO

#endif // defined(__ARM_ARCH_7A__)

#if defined(__cplusplus)
}
#endif

// ----------------------------------------------------------------------------

#endif // MICRO_OS_PLUS_ARCHITECTURE_AARCH32_EXCEPTION_HANDLERS_H_

// ----------------------------------------------------------------------------
