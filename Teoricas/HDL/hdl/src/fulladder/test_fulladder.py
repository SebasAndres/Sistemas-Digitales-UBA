import cocotb
from cocotb.triggers import Timer


@cocotb.test()
async def test_a_plus_b(dut):
    dut.a.value = 1
    dut.b.value = 0
    dut.cin.value = 0

    await Timer(10, "ns")

    assert dut.s == 1
    assert dut.cout == 0


@cocotb.test()
async def test_carry_in(dut):
    dut.a.value = 0
    dut.b.value = 0
    dut.cin.value = 1

    await Timer(10, "ns")

    assert dut.s == 1
    assert dut.cout == 0


@cocotb.test()
async def test_carry_out(dut):
    dut.a.value = 1
    dut.b.value = 1
    dut.cin.value = 1

    await Timer(10, "ns")

    assert dut.s == 1
    assert dut.cout == 1
