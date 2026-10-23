// FW8 post-script: write every user-named function and label in the C-SKY
// project to radio_firmware/symbols.export.csv (offset,kind,name,comment), so
// names given interactively in Ghidra can be merged into the committed
// radio_firmware/symbols.csv. External rows already in symbols.csv are kept
// there by hand (Ghidra holds no memory for them). Read-only on the program.
// @category DMR.Analysis

import ghidra.app.script.GhidraScript;
import ghidra.program.model.listing.CodeUnit;
import ghidra.program.model.listing.Function;
import ghidra.program.model.symbol.SourceType;
import ghidra.program.model.symbol.Symbol;
import ghidra.program.model.symbol.SymbolIterator;

import java.io.File;
import java.io.PrintWriter;
import java.util.TreeMap;

public class FwCskyExportSymbols extends GhidraScript {

    @Override
    public void run() throws Exception {
        File out = new File(getSourceFile().getParentFile().getParentFile().getFile(false), "symbols.export.csv");
        TreeMap<Long, String> rows = new TreeMap<>();
        SymbolIterator it = currentProgram.getSymbolTable().getAllSymbols(true);
        while (it.hasNext()) {
            Symbol s = it.next();
            if (s.getSource() != SourceType.USER_DEFINED || s.isExternal()) continue;
            long off = fileOffset(s.getAddress().getOffset());
            if (off < 0) continue;
            Function fn = getFunctionAt(s.getAddress());
            String kind = (fn != null && fn.getName().equals(s.getName())) ? "fn" : "label";
            String c = currentProgram.getListing().getComment(CodeUnit.PLATE_COMMENT, s.getAddress());
            rows.put(off, String.format("0x%06X,%s,%s,%s", off, kind, s.getName(), quote(c == null ? "" : c)));
        }
        try (PrintWriter w = new PrintWriter(out, "UTF-8")) {
            w.print("offset,kind,name,comment\n");
            for (String r : rows.values()) w.print(r + "\n");
        }
        println("FwCskyExportSymbols: " + rows.size() + " rows -> " + out);
    }

    /** Address -> file offset for the HR-C7000 layout (11 §21.0); identity for a flat import. */
    private long fileOffset(long a) {
        if (currentProgram.getMemory().getBlock("iram") == null) return a;
        if (a >= 0x0301A000L && a < 0x0301A000L + 0x39408L) return a - 0x0301A000L;
        if (a >= 0x10000L && a < 0x10000L + 0x21AF4L) return a - 0x10000L + 0x39408L;
        return -1; // RAM/peripheral labels have no file offset
    }

    private static String quote(String s) {
        s = s.replace("\r", " ").replace("\n", " ");
        if (s.contains(",") || s.contains("\"")) return "\"" + s.replace("\"", "\"\"") + "\"";
        return s;
    }
}
