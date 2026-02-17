package com.android.internal.telephony;

import java.io.Writer;

@Deprecated
public class IndentingPrintWriter extends AndroidUtilIndentingPrintWriter {
    public IndentingPrintWriter(Writer writer, String str) {
        super(writer, str, -1);
    }

    public IndentingPrintWriter(Writer writer, String str, int i) {
        super(writer, str, i);
    }

    public IndentingPrintWriter(Writer writer, String str, String str2, int i) {
        super(writer, str, str2, i);
    }

    public IndentingPrintWriter setIndent(String str) {
        super.setIndent(str);
        return this;
    }

    public IndentingPrintWriter setIndent(int i) {
        super.setIndent(i);
        return this;
    }

    public IndentingPrintWriter increaseIndent() {
        super.increaseIndent();
        return this;
    }

    public IndentingPrintWriter decreaseIndent() {
        super.decreaseIndent();
        return this;
    }

    public IndentingPrintWriter printPair(String str, Object obj) {
        super.print(str, obj);
        return this;
    }

    public IndentingPrintWriter printPair(String str, Object[] objArr) {
        super.print(str, objArr);
        return this;
    }

    public IndentingPrintWriter printHexPair(String str, int i) {
        super.printHexInt(str, i);
        return this;
    }
}
