# SPDX-FileCopyrightText: © 2024 Tiny Tapeout
# SPDX-License-Identifier: Apache-2.0

import cocotb
from cocotb.clock import Clock
from cocotb.triggers import ClockCycles


@cocotb.test()
async def test_project(dut):
    dut._log.info("Start")

    # Set the clock period to 10 us (100 KHz)
    clock = Clock(dut.clk, 10, units="us")
    cocotb.start_soon(clock.start())

    # Reset
    dut._log.info("Reset")
    dut.ena.value = 1
    dut.ui_in.value = 0
    dut.uio_in.value = 0
    dut.rst_n.value = 0
    await ClockCycles(dut.clk, 10)
    dut.rst_n.value = 1

    dut._log.info("Test project behavior")

    n = 8
    for i in range(2**n):
        for j in range(2**n):
            # Set the input values you want to test
            dut.ui_in.value = i
            dut.uio_in.value = j

            # Wait for one clock cycle to see the output values
            await ClockCycles(dut.clk, 1)

            # The following assersion is just an example of how to check the output values.
            # Change it to match the actual expected output of your module:
            if i == j:
                assert dut.uo_out.value == 0
            else:
                assert dut.uo_out.value == max(i, j)

    # Keep testing the module by changing the input values, waiting for
    # one or more clock cycles, and asserting the expected output values.
