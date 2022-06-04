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

#if defined(MICRO_OS_PLUS_INCLUDE_CONFIG_H)
#include <micro-os-plus/config.h>
#endif // MICRO_OS_PLUS_INCLUDE_CONFIG_H

#include "micro-os-plus/device.h"

// ----------------------------------------------------------------------------

#define SYSTEM_CLOCK (16000000UL)
uint32_t SystemCoreClock = SYSTEM_CLOCK;

// ----------------------------------------------------------------------------

void
SystemInit (void)
{
  // TBD
}

void
SystemCoreClockUpdate (void)
{
  SystemCoreClock = SYSTEM_CLOCK;
}

// ----------------------------------------------------------------------------