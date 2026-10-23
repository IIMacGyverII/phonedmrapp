// FW1 post-script: report what the C-SKY listing achieved. Prints counts,
// xrefs to the plaintext string anchors (file offsets, link base 0), the
// functions containing the protocol-anchored sites, and the disassembly
// around the checksum routine so the listing can be compared against
// docs/grok-deep-dive/11 §10.1. Read-only.
// @category DMR.Analysis

import ghidra.app.script.GhidraScript;
import ghidra.program.model.address.Address;
import ghidra.program.model.listing.Function;
import ghidra.program.model.listing.Instruction;
import ghidra.program.model.symbol.Reference;

public class FwCskyStats extends GhidraScript {

    @Override
    public void run() throws Exception {
        println("======== FwCskyStats ========");
        println("language: " + currentProgram.getLanguageID());
        println("min: " + currentProgram.getMinAddress() + " max: " + currentProgram.getMaxAddress());
        println("functions: " + currentProgram.getFunctionManager().getFunctionCount());
        println("instructions: " + currentProgram.getListing().getNumInstructions());

        xrefs(0x3659CL, "rxvoice");
        xrefs(0x38464L, "DMR003.UV4T.V022");
        xrefs(0x365C8L, "encrypt");
        xrefs(0x35FE4L, "uC/OS-III Idle Task");
        xrefs(0x36534L, "PttTask");
        xrefs(0x365B4L, "cpchanscan");
        xrefs(0x323C4L, "play_sem");

        fnAt(0x7D94L, "checksum");
        fnAt(0x8E5CL, "checksum wrapper");
        fnAt(0x7DE8L, "send");
        fnAt(0x5EF4L, "uart put");
        fnAt(0x8E80L, "empty-frame builder");
        fnAt(0x8E7CL, "empty-frame ACK");
        fnAt(0x7C48L, "rx wait 0x68");
        fnAt(0x9A2CL, "analog unpack");
        fnAt(0x7A30L, "apply analog");
        fnAt(0x304E8L, "memcpy");

        listing(0x7D94L, 40, "checksum routine");
        listing(0x7C48L, 24, "rx waiter");
        listing(0x794CL, 24, "type->cmd mapper (0xE2804Fxx veneer)");

        // Count functions calling the empty-frame ACK: 11 §11.1 says 57 callers.
        Function ack = getFunctionAt(FwCskyMapRegions.addr(this, currentProgram, 0x8E7CL));
        if (ack != null) {
            println("callers of ACK +0x8E7C: " + ack.getCallingFunctions(monitor).size());
        }
        println("======== end FwCskyStats ========");
    }

    private void xrefs(long off, String label) {
        Address a = FwCskyMapRegions.addr(this, currentProgram, off);
        Reference[] refs = getReferencesTo(a);
        println(String.format("xrefs -> %06X (%s): %d", off, label, refs.length));
        int n = 0;
        for (Reference r : refs) {
            if (n++ >= 8) { println("  ..."); break; }
            Function f = getFunctionContaining(r.getFromAddress());
            println("  from " + r.getFromAddress() + " in " + (f == null ? "-" : f.getName()));
        }
    }

    private void fnAt(long off, String label) {
        Address a = FwCskyMapRegions.addr(this, currentProgram, off);
        Function f = getFunctionContaining(a);
        Instruction i = getInstructionAt(a);
        println(String.format("site %06X (%s): fn=%s instr=%s", off, label,
                f == null ? "-" : f.getName() + "@" + f.getEntryPoint(),
                i == null ? "-" : i.toString()));
    }

    private void listing(long off, int count, String label) {
        println("");
        println("---- " + label + " @ " + String.format("%06X", off));
        Instruction i = getInstructionAt(FwCskyMapRegions.addr(this, currentProgram, off));
        if (i == null) { i = getInstructionAfter(FwCskyMapRegions.addr(this, currentProgram, off)); }
        int n = 0;
        while (i != null && n++ < count) {
            println("  " + i.getAddress() + "  " + i.toString());
            i = i.getNext();
        }
    }
}
