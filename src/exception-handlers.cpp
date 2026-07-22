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

// ----------------------------------------------------------------------------

#if defined(__ARM_EABI__)

// ----------------------------------------------------------------------------

#if __has_include(<micro-os-plus/project-config.h>)
#include <micro-os-plus/project-config.h>
#elif __has_include(<micro-os-plus/config.h>)
#pragma message "micro-os-plus/config.h is deprecated, rename to micro-os-plus/project-config.h and include it instead of micro-os-plus/config.h"
#include <micro-os-plus/config.h>
#endif // __has_include(<micro-os-plus/project-config.h>)

// #include <micro-os-plus/device.h>
#include <micro-os-plus/architecture-aarch32/exception-handlers.h>

#include <micro-os-plus/diag/trace.h>

// ----------------------------------------------------------------------------

using namespace micro_os_plus;

// ----------------------------------------------------------------------------

#if defined(__ARM_ARCH_7A__)

void
c_data_abort_handler (uint32_t dfsr, uint32_t dfar)
{
  trace::printf ("Data Abort Exception!\n");
  trace::printf ("DFSR (Data Fault Status): 0x%08X\n", dfsr);
  trace::printf ("DFAR (Fault Address): 0x%08X\n", dfar);

  // Decode fault type
  uint32_t fault_status = dfsr & 0x40F; // Bits [10,3:0]

  switch (fault_status)
    {
    case 0x001:
      trace::printf ("Alignment fault\n");
      break;
    case 0x002:
      trace::printf ("Debug event\n");
      break;
    case 0x003:
      trace::printf ("Access flag fault (section)\n");
      break;
    // Add more cases as needed
    default:
      trace::printf ("Unknown fault type: 0x%03X\n", fault_status);
      break;
    }

  // For now, halt the system
  while (1)
    {
      __asm__ ("wfi");
    }
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
