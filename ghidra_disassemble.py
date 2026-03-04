# Ghidra Python script to disassemble code sections
# Run this in Ghidra: Window -> Script Manager -> Run

from ghidra.program.model.address import Address
from ghidra.app.cmd.disassemble import ArmDisassembleCommand
from ghidra.app.cmd.function import CreateFunctionCmd

# Code locations found
code_addrs = [
    0x08000c42, 0x08001272, 0x080012ea, 0x08001598,
    0x08001748, 0x08002068, 0x08002072, 0x080020a2,
    0x0800222c, 0x0800271e, 0x080029c4, 0x0800313c,
    0x08003414, 0x080034fa, 0x080034fc
]

currentProgram = getCurrentProgram()
monitor = getMonitor()

print("Disassembling and creating functions...")

for addr_val in code_addrs:
    addr = currentProgram.getAddressFactory().getAddress(hex(addr_val))
    print("Processing " + hex(addr_val))
    
    # Disassemble
    cmd = ArmDisassembleCommand(addr, None, True)
    cmd.applyTo(currentProgram, monitor)
    
    # Create function
    funcCmd = CreateFunctionCmd(addr)
    funcCmd.applyTo(currentProgram, monitor)

print("Done! Found " + str(currentProgram.getFunctionManager().getFunctionCount()) + " functions")
