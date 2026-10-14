// Conservative pre-script. Do NOT spray disassemble() at every 0xB5xx PUSH —
// that defined 37k bogus instructions (FW0 pass 2).
// Set TMode=1, then seed only the lower-entropy windows identified in
// docs/grok-deep-dive/11-firmware-fw0-results.md §7.6.
// @category DMR.Analysis

import ghidra.app.script.GhidraScript;
import ghidra.program.model.lang.Register;
import ghidra.program.model.lang.RegisterValue;
import ghidra.program.model.listing.Instruction;
import ghidra.program.model.mem.MemoryBlock;
import java.math.BigInteger;

public class Fw0SetThumb extends GhidraScript {

    // File offsets (added to image min) of 4 KiB windows with entropy ~5.2–6.4
    // plus the page just before the known string pool at +0x35000.
    private static final long[] WINDOW_FILE_OFFS = {
        0x21000L, 0x22000L, 0x23000L, 0x24000L, 0x25000L,
        0x26000L, 0x27000L, 0x28000L, 0x29000L, 0x2A000L,
        0x2B000L, 0x2C000L, 0x2D000L, 0x2E000L,
        0x34000L,
        0x58000L,
    };

    @Override
    public void run() throws Exception {
        println("======== Fw0SetThumb STRICT ========");
        Register tmode = currentProgram.getProgramContext().getRegister("TMode");
        if (tmode == null) {
            println("No TMode register");
        } else {
            RegisterValue rv = new RegisterValue(tmode, BigInteger.ONE);
            for (MemoryBlock block : currentProgram.getMemory().getBlocks()) {
                currentProgram.getProgramContext().setRegisterValue(
                    block.getStart(), block.getEnd(), rv);
                println("TMode=1 on " + block.getName() + " "
                        + block.getStart() + "-" + block.getEnd()
                        + " exec=" + block.isExecute());
                if (!block.isExecute()) {
                    block.setExecute(true);
                    println("  set execute=true");
                }
            }
        }

        setAnalysisOption(currentProgram, "ARM Aggressive Instruction Finder", "true");
        setAnalysisOption(currentProgram, "ASCII Strings", "true");
        setAnalysisOption(currentProgram, "Embedded Media", "false");
        setAnalysisOption(currentProgram, "Create Address Tables", "true");
        setAnalysisOption(currentProgram, "Reference", "true");
        setAnalysisOption(currentProgram, "Disassemble Entry Points", "true");
        setAnalysisOption(currentProgram, "Decompiler Parameter ID", "false");

        long min = currentProgram.getMinAddress().getOffset();
        int ok = 0;
        for (long fileOff : WINDOW_FILE_OFFS) {
            long addr = min + fileOff;
            boolean created = disassemble(toAddr(addr));
            Instruction instr = getInstructionAt(toAddr(addr));
            println(String.format("  seed 0x%08X (file+%#x) disassemble=%s instr=%s",
                    addr, fileOff, created, instr != null ? instr.toString() : "null"));
            if (instr != null) {
                ok++;
            }
        }
        println("strict window seeds with an instruction: " + ok + "/" + WINDOW_FILE_OFFS.length);
        println("======== end Fw0SetThumb STRICT ========");
    }
}
