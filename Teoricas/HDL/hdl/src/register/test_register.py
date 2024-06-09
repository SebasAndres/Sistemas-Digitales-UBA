import cocotb
from cocotb.triggers import Timer, FallingEdge
from cocotb.clock import Clock


@cocotb.test()
async def test_register(dut):
    # Run clock in the background.
    clock = Clock(dut.clk, 1, 'ns')
    await cocotb.start(clock.start())

    # Initial delay.
    await Timer(2, units="ns")
    await FallingEdge(dut.clk)

    # Initial input values.
    dut.rst.value = 0
    dut.en_write.value = 0
    dut.data_in.value = 0

    # Test write.
    dut.data_in.value = 0x42
    dut.en_write.value = 1
    await FallingEdge(dut.clk)
    assert dut.data_out == 0x42
    dut.en_write.value = 0

    # Test changing data_it without en_write.
    dut.data_in.value = 0x10
    await FallingEdge(dut.clk)
    assert dut.data_out == 0x42

    # Reset register to 0.
    dut.rst.value = 1
    await FallingEdge(dut.clk)
    assert dut.data_out == 0
    dut.rst.value = 0

    # Test write again.
    dut.en_write.value = 1
    await FallingEdge(dut.clk)
    assert dut.data_out == 0x10
