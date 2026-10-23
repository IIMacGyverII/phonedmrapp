// FW8 post-script: apply radio_firmware/symbols.csv (offset,kind,name,comment)
// to the C-SKY project so names found in docs/grok-deep-dive/11 survive a
// re-import. Offsets are file offsets at link base 0. kind = fn (function,
// created if missing), label (data or an instruction site), ext (outside the
// image: the 0xFCFF.../0xFD01... region; reported, not applied).
// Sets a plate comment from the comment column. Read-only on firmware bytes.
// @category DMR.Analysis

import ghidra.app.script.GhidraScript;
import ghidra.program.model.address.Address;
import ghidra.program.model.listing.CodeUnit;
import ghidra.program.model.listing.Function;
import ghidra.program.model.symbol.SourceType;

import java.io.BufferedReader;
import java.io.File;
import java.io.FileReader;
import java.util.ArrayList;
import java.util.List;

public class FwCskyImportSymbols extends GhidraScript {

    @Override
    public void run() throws Exception {
        File csv = new File(getSourceFile().getParentFile().getParentFile().getFile(false), "symbols.csv");
        println("======== FwCskyImportSymbols: " + csv + " ========");
        int fns = 0, labels = 0, ext = 0;
        try (BufferedReader r = new BufferedReader(new FileReader(csv))) {
            String line = r.readLine(); // header
            while ((line = r.readLine()) != null) {
                List<String> f = split(line);
                if (f.size() < 3 || f.get(2).isEmpty()) continue;
                long off = Long.decode(f.get(0));
                String kind = f.get(1), name = f.get(2);
                String comment = f.size() > 3 ? f.get(3) : "";
                Address a = FwCskyMapRegions.addr(this, currentProgram, off);
                if (kind.equals("ext") || !currentProgram.getMemory().contains(a)) {
                    println("external, not applied: " + f.get(0) + " " + name);
                    ext++;
                    continue;
                }
                if (kind.equals("fn")) {
                    Function fn = getFunctionAt(a);
                    if (fn == null) {
                        if (getInstructionAt(a) == null) disassemble(a);
                        fn = createFunction(a, name);
                    }
                    if (fn != null) {
                        fn.setName(name, SourceType.USER_DEFINED);
                        fns++;
                    } else {
                        createLabel(a, name, true, SourceType.USER_DEFINED);
                        println("no function could be created, labelled: " + f.get(0) + " " + name);
                        labels++;
                    }
                } else {
                    createLabel(a, name, true, SourceType.USER_DEFINED);
                    labels++;
                }
                if (!comment.isEmpty()) {
                    currentProgram.getListing().setComment(a, CodeUnit.PLATE_COMMENT, comment);
                }
            }
        }
        println("functions: " + fns + ", labels: " + labels + ", external: " + ext);
    }

    /** Minimal RFC 4180 split: commas, double-quoted fields, "" escapes. */
    static List<String> split(String line) {
        List<String> out = new ArrayList<>();
        StringBuilder cur = new StringBuilder();
        boolean q = false;
        for (int i = 0; i < line.length(); i++) {
            char c = line.charAt(i);
            if (q) {
                if (c == '"' && i + 1 < line.length() && line.charAt(i + 1) == '"') { cur.append('"'); i++; }
                else if (c == '"') q = false;
                else cur.append(c);
            } else if (c == '"') q = true;
            else if (c == ',') { out.add(cur.toString()); cur.setLength(0); }
            else cur.append(c);
        }
        out.add(cur.toString());
        return out;
    }
}
