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

#ifndef MICRO_OS_PLUS_DEVICE_H_
#define MICRO_OS_PLUS_DEVICE_H_

// ----------------------------------------------------------------------------

#if defined(__cplusplus)
#if !(__cplusplus >= 202002L || (defined(_MSVC_LANG) && _MSVC_LANG >= 202002L))
#error "C++20 or higher is required"
#endif
#endif // defined(__cplusplus)

#if __has_include("micro-os-plus/project-config.h")
#include "micro-os-plus/project-config.h"
#endif // __has_include("micro-os-plus/project-config.h")

#if __has_include("micro-os-plus/device-defines.h")
#include "micro-os-plus/device-defines.h"
#endif // __has_include("micro-os-plus/device-defines.h")

// ----------------------------------------------------------------------------

#include "micro-os-plus/architecture.h"

#include "micro-os-plus/architecture-aarch32/exception-handlers.h"

// ----------------------------------------------------------------------------

#if defined(__cplusplus)
extern "C"
{
#endif // defined(__cplusplus)

  // --------------------------------------------------------------------------

#if defined(MICRO_OS_PLUS_DEVICE_QEMU_CORTEX_A15)

  // TODO

#else
#error "Device not supported"
#endif

#if 0
  extern uint32_t SystemCoreClock; /*!< System Clock Frequency (Core Clock) */

  extern void
  SystemInit (void);
  extern void
  SystemCoreClockUpdate (void);
#endif // 0-1

  // --------------------------------------------------------------------------

#if defined(__cplusplus)
}
#endif // defined(__cplusplus)

// ----------------------------------------------------------------------------

#endif // MICRO_OS_PLUS_DEVICE_H_

// ----------------------------------------------------------------------------
