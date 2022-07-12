/*
 * This file is part of the µOS++ distribution.
 *   (https://github.com/micro-os-plus/)
 * Copyright (c) 2014 Liviu Ionescu.
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

#if defined(MICRO_OS_PLUS_INCLUDE_CONFIG_H)
#include <micro-os-plus/config.h>
#endif // MICRO_OS_PLUS_INCLUDE_CONFIG_H

// #include <micro-os-plus/device.h>
#include <micro-os-plus/architecture-aarch32/exception-handlers.h>

// #include <micro-os-plus/diag/trace.h>

// ----------------------------------------------------------------------------

// using namespace micro_os_plus;

// ----------------------------------------------------------------------------

#if defined(__ARM_ARCH_7A__)

extern "C"
{
  void
  c_irq_handler (void);
}

void
c_irq_handler (void)
{
  return;
}

#endif // defined(__ARM_ARCH_7A__)

// ----------------------------------------------------------------------------

#endif // defined(__ARM_EABI__)

// ----------------------------------------------------------------------------
