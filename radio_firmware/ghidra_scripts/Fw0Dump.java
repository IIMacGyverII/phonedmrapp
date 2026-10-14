// Dump load-base evidence, UART cmd immediates, and the retired 0x18F2C site.
// Run on the existing project with -noanalysis.
// @category DMR.Analysis

import ghidra.app.script.GhidraScript;
import ghidra.program.model.address.Address;
import ghidra.program.model.listing.Data;
import ghidra.program.model.listing.Function;
import ghidra.program.model.listing.Instruction;
import ghidra.program.model.symbol.Reference;
import ghidra.program.model.symbol.ReferenceIterator;

public class Fw0Dump extends GhidraScript {

    @Override
    public void run() throws Exception {
        println("======== Fw0Dump ========");
        println("language: " + currentProgram.getLanguageID());
        println("min: " + currentProgram.getMinAddress() + " max: " + currentProgram.getMaxAddress());
        println("functions: " + currentProgram.getFunctionManager().getFunctionCount());
        println("instructions: " + currentProgram.getListing().getNumInstructions());

        dumpAround("version-string LDR site", 0x08038310L, 12);
        dumpXrefsTo(0x08038464L, "version bytes DMR003...");
        dumpXrefsTo(0x080365c8L, "encrypt string");
        dumpXrefsTo(0x08042ee0L, "in-image ptr to encrypt (file +0x42EE0)");
        dumpXrefsTo(0x08035fe4L, "uC/OS-III Idle Task");
        dumpXrefsTo(0x08036534L, "PttTask");

        dumpAround("retired PATCH14 0x18F2C", 0x08018F2CL, 8);

        dumpMovImm("movs .*#0x22", "SET_DIGITAL");
        dumpMovImm("movs .*#0x23", "SET_ANALOG");
        dumpMovImm("movs .*#0x2b", "Q_DIG_AUDIO");
        dumpMovImm("movs .*#0x36", "STATUS");
        dumpMovImm("movs .*#0x68", "frame-head-imm");
        dumpMovImm("movs .*#0x10", "frame-tail-imm");
        dumpMovImm("movs .*#0xaa", "MODULE_INIT");

        countAbsoluteFlashLiterals();
        println("======== end Fw0Dump ========");
    }

    private void dumpXrefsTo(long addr, String label) {
        Address a = toAddr(addr);
        Reference[] refs = getReferencesTo(a);
        Data data = getDataAt(a);
        println("");
        println(String.format("xrefs -> %08X (%s) data=%s count=%d",
                addr, label, data != null ? data.toString() : "-", refs.length));
        int n = 0;
        for (Reference ref : refs) {
            if (n++ >= 16) {
                println("  ...");
                break;
            }
            Address from = ref.getFromAddress();
            Instruction instr = getInstructionAt(from);
            Function fn = getFunctionContaining(from);
            println("  from " + from
                    + "  " + (instr != null ? instr.toString() : "(no instr)")
                    + "  fn=" + (fn != null ? fn.getName() : "-")
                    + "  " + ref.getReferenceType());
        }
    }

    private void dumpAround(String title, long addr, int radius) {
        println("");
        println(String.format("---- %s @ %08X ----", title, addr));
        Address a = toAddr(addr);
        Instruction cur = getInstructionContaining(a);
        if (cur == null) {
            cur = getInstructionBefore(a);
        }
        Instruction it = cur;
        for (int i = 0; i < radius && it != null; i++) {
            it = it.getPrevious();
        }
        for (int i = 0; i < radius * 2 + 1 && it != null; i++) {
            String mark = it.getAddress().getOffset() == addr ? ">>" : "  ";
            println(mark + " " + it.getAddress() + "  " + it);
            it = it.getNext();
        }
        if (getInstructionContaining(a) == null) {
            println("  (no instruction containing " + a + ")");
            try {
                byte[] b = getBytes(a, 8);
                StringBuilder sb = new StringBuilder();
                for (byte v : b) {
                    sb.append(String.format("%02x ", v & 0xff));
                }
                println("  raw: " + sb);
            } catch (Exception e) {
                println("  raw read failed: " + e.getMessage());
            }
        }
    }

    private void dumpMovImm(String needle, String name) {
        println("");
        println("instructions matching /" + needle + "/  (" + name + ")");
        int n = 0;
        int shown = 0;
        Instruction instr = getFirstInstruction();
        String pat = needle.replace(".*", "");
        // crude: contains "movs" and the #imm substring
        String imm = "";
        int hash = needle.lastIndexOf('#');
        if (hash >= 0) {
            imm = needle.substring(hash);
        }
        while (instr != null && !monitor.isCancelled()) {
            String s = instr.toString().toLowerCase();
            if (s.startsWith("movs") && s.contains(imm)) {
                n++;
                if (shown < 25) {
                    Function fn = getFunctionContaining(instr.getAddress());
                    println("  " + instr.getAddress() + "  " + instr
                            + "  fn=" + (fn != null ? fn.getName() : "-"));
                    shown++;
                }
            }
            instr = instr.getNext();
        }
        println("  count: " + n);
    }

    private void countAbsoluteFlashLiterals() {
        println("");
        println("data refs whose target is inside the image (absolute or PC-rel):");
        long lo = currentProgram.getMinAddress().getOffset();
        long hi = currentProgram.getMaxAddress().getOffset();
        int inImage = 0;
        int shown = 0;
        ReferenceIterator it = currentProgram.getReferenceManager().getReferenceIterator(currentProgram.getMinAddress());
        while (it.hasNext() && !monitor.isCancelled()) {
            Reference ref = it.next();
            long to = ref.getToAddress().getOffset();
            if (to < lo || to > hi) {
                continue;
            }
            if (!ref.getReferenceType().isRead() && !ref.getReferenceType().isData()) {
                continue;
            }
            inImage++;
            if (shown < 20) {
                Instruction instr = getInstructionAt(ref.getFromAddress());
                if (instr != null && instr.toString().toLowerCase().contains("ldr")) {
                    println("  " + ref.getFromAddress() + " -> " + ref.getToAddress()
                            + "  " + instr + "  " + ref.getReferenceType());
                    shown++;
                }
            }
        }
        println("  in-image data/read refs (all types counted, ldr samples shown): " + inImage);
    }
}
