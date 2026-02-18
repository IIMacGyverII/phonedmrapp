package com.pri.prizeinterphone.ymodem;

import java.util.Locale;
/* loaded from: classes4.dex */
public enum SourceScheme {
    FILE("file"),
    ASSETS("assets"),
    UNKNOWN("");
    
    private final String scheme;
    private final String uriPrefix;

    SourceScheme(String str) {
        this.scheme = str;
        this.uriPrefix = str + "://";
    }

    public static SourceScheme ofUri(String str) {
        SourceScheme[] values;
        if (str != null) {
            for (SourceScheme sourceScheme : values()) {
                if (sourceScheme.belongsTo(str)) {
                    return sourceScheme;
                }
            }
        }
        return UNKNOWN;
    }

    private boolean belongsTo(String str) {
        return str.toLowerCase(Locale.US).startsWith(this.uriPrefix);
    }

    public String crop(String str) {
        if (!belongsTo(str)) {
            throw new IllegalArgumentException(String.format("URI [%1$s] doesn't have expected scheme [%2$s]", str, this.scheme));
        }
        return str.substring(this.uriPrefix.length());
    }

    public String getUriPrefix() {
        return this.uriPrefix;
    }
}
