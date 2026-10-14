// FW1 pre-script for the C-SKY v2 processor module (CSKY_V2:LE:32:default).
// Raw binary at base 0 has no entry point, so seed disassembly at every
// 16-bit push16 prologue (0x14C0..0x14DF, even-aligned) and the known
// protocol-anchored sites from docs/grok-deep-dive/11 §10-11, then let
// auto-analysis follow calls. Disables the analyzers the module author
// flags as unsafe. Does not patch or flash anything.
// @category DMR.Analysis

import ghidra.app.script.GhidraScript;
import ghidra.program.model.address.Address;
import ghidra.program.model.mem.Memory;
import ghidra.program.model.mem.MemoryBlock;

public class FwCskySeed extends GhidraScript {

    // Protocol-anchored file offsets (link base 0) named in grok-deep-dive 11.
    private static final long[] KNOWN = {
        0x7D94L, // checksum (one's complement, BE words)
        0x8E5CL, // checksum wrapper, writes buf[4..5]
        0x7DE8L, // send
        0x5EF4L, // UART put bytes (MMIO 0x1409xxxx)
        0x8E80L, 0x901CL, // empty-frame builders
        0x8E7CL, // empty-frame ACK
        0x7C48L, // RX wait for 0x68
        0x9A2CL, 0x9866L, 0x9D08L, // analog unpack copies
        0x7A30L, // apply analog config
        0x304E8L, // memcpy
        0x794CL, 0x788CL, 0x7E94L, 0x2474L, 0x3DDCL, 0x3E40L,
    };

    @Override
    public void run() throws Exception {
        println("======== FwCskySeed ========");
        println("language: " + currentProgram.getLanguageID());

        setAnalysisOption(currentProgram, "Aggressive Instruction Finder", "false");
        setAnalysisOption(currentProgram, "Decompiler Parameter ID", "false");
        setAnalysisOption(currentProgram, "Non-Returning Functions - Discovered", "false");

        Memory mem = currentProgram.getMemory();
        int seeded = 0, known = 0;
        for (long off : KNOWN) {
            Address a = toAddr(off);
            if (mem.contains(a)) {
                disassemble(a);
                if (getFunctionAt(a) == null) createFunction(a, null);
                known++;
            }
        }
        println("known anchors seeded: " + known);

        for (MemoryBlock blk : mem.getBlocks()) {
            if (!blk.isInitialized()) continue;
            long start = blk.getStart().getOffset();
            long end = blk.getEnd().getOffset();
            byte[] buf = new byte[(int) (end - start + 1)];
            mem.getBytes(blk.getStart(), buf);
            for (int i = 0; i + 1 < buf.length; i += 2) {
                int hw = (buf[i] & 0xFF) | ((buf[i + 1] & 0xFF) << 8);
                if (hw >= 0x14C0 && hw <= 0x14DF) { // push16
                    Address a = toAddr(start + i);
                    if (getInstructionAt(a) == null) {
                        disassemble(a);
                    }
                    if (getFunctionAt(a) == null && getInstructionAt(a) != null) {
                        createFunction(a, null);
                    }
                    seeded++;
                }
                if (monitor.isCancelled()) return;
            }
        }
        println("push16 prologues seeded: " + seeded);
        println("======== end FwCskySeed ========");
    }
}
