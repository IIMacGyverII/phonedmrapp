// Ghidra post-script: prove load base via xrefs to version / uC/OS strings,
// then list UART-ish immediates in *code* (not ASCII pools).
// @category DMR.Analysis
// Does not patch. Safe to run headless.

import ghidra.app.script.GhidraScript;
import ghidra.program.model.address.Address;
import ghidra.program.model.listing.Data;
import ghidra.program.model.listing.Function;
import ghidra.program.model.listing.Instruction;
import ghidra.program.model.mem.Memory;
import ghidra.program.model.symbol.Reference;
import java.nio.charset.StandardCharsets;
import java.util.ArrayList;
import java.util.List;

public class Fw0Identify extends GhidraScript {

    private static final String[] NEEDLES = {
        "DMR003.UV4T.V022",
        "uC/OS-III Idle Task",
        "uC/OS-III Tick Task",
        "uC/OS-III Timer Task",
        "uC/OS-III Stat Task",
        "PttTask",
        "encrypt",
        "encrec_sem",
        "cpchanscan",
        "task init",
    };

    @Override
    public void run() throws Exception {
        println("======== Fw0Identify ========");
        println("program: " + currentProgram.getName());
        println("language: " + currentProgram.getLanguageID());
        println("compiler: " + currentProgram.getCompilerSpec().getCompilerSpecID());
        println("imageBase: " + currentProgram.getImageBase());
        println("min: " + currentProgram.getMinAddress() + "  max: " + currentProgram.getMaxAddress());
        println("functions: " + currentProgram.getFunctionManager().getFunctionCount());
        println("instructions defined: " + currentProgram.getListing().getNumInstructions());

        Memory mem = currentProgram.getMemory();
        Address min = currentProgram.getMinAddress();

        int xrefTotal = 0;
        for (String needle : NEEDLES) {
            byte[] raw = needle.getBytes(StandardCharsets.US_ASCII);
            List<Address> found = new ArrayList<Address>();
            Address cursor = min;
            while (!monitor.isCancelled()) {
                Address hit = mem.findBytes(cursor, raw, null, true, monitor);
                if (hit == null) {
                    break;
                }
                found.add(hit);
                try {
                    cursor = hit.add(1);
                } catch (Exception e) {
                    break;
                }
            }
            println("");
            println("string " + quote(needle) + " hits=" + found.size());
            for (Address hit : found) {
                Data data = getDataAt(hit);
                println("  at " + hit + (data != null ? " data=" + data : " (undefined)"));
                Reference[] refs = getReferencesTo(hit);
                println("    xrefs: " + refs.length);
                xrefTotal += refs.length;
                int shown = 0;
                for (Reference ref : refs) {
                    if (shown++ >= 12) {
                        println("    ...");
                        break;
                    }
                    Address from = ref.getFromAddress();
                    Instruction instr = getInstructionAt(from);
                    Function fn = getFunctionContaining(from);
                    println("    from " + from
                            + "  " + (instr != null ? instr.toString() : "(no instr)")
                            + "  fn=" + (fn != null ? fn.getName() : "-")
                            + "  type=" + ref.getReferenceType());
                }
            }
        }
        println("");
        println("total xrefs across needles: " + xrefTotal);

        searchImmInCode((byte) 0x68, "frame-head");
        searchImmInCode((byte) 0x10, "frame-tail");
        searchImmInCode((byte) 0x22, "SET_DIGITAL");
        searchImmInCode((byte) 0x23, "SET_ANALOG");
        searchImmInCode((byte) 0x2B, "Q_DIG_AUDIO");
        searchImmInCode((byte) 0x36, "STATUS");
        println("======== end Fw0Identify ========");
    }

    private void searchImmInCode(byte imm, String name) throws Exception {
        println("");
        println("code immediates == 0x" + String.format("%02X", imm & 0xff) + " (" + name + ")");
        int n = 0;
        int shown = 0;
        Instruction instr = getFirstInstruction();
        while (instr != null && !monitor.isCancelled()) {
            String s = instr.toString().toLowerCase();
            String hex = String.format("#0x%x", imm & 0xff);
            String dec = "#" + (imm & 0xff);
            if (s.contains(hex) || s.contains(dec)) {
                n++;
                if (shown < 20) {
                    Function fn = getFunctionContaining(instr.getAddress());
                    println("  " + instr.getAddress() + "  " + instr
                            + "  fn=" + (fn != null ? fn.getName() : "-"));
                    shown++;
                }
            }
            instr = instr.getNext();
        }
        println("  count: " + n + " (showing min(20,count))");
    }

    private static String quote(String s) {
        return "\"" + s + "\"";
    }
}
