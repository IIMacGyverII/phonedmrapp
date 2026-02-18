package com.pri.prizeinterphone.config.data;
/* loaded from: classes4.dex */
public class ParseConfig {
    private InsertConfig insertConfig;
    private boolean isError;

    private ParseConfig() {
        this.isError = true;
        this.insertConfig = null;
    }

    public ParseConfig(Builder builder) {
        this.isError = true;
        this.insertConfig = null;
        this.isError = builder.isError;
        this.insertConfig = builder.insertConfig;
    }

    public boolean isError() {
        return this.isError;
    }

    public void setError(boolean z) {
        this.isError = z;
    }

    public InsertConfig getInsertConfig() {
        return this.insertConfig;
    }

    public void setInsertConfig(InsertConfig insertConfig) {
        this.insertConfig = insertConfig;
    }

    /* loaded from: classes4.dex */
    public static final class Builder {
        private InsertConfig insertConfig;
        private boolean isError;

        public Builder withIsError(boolean z) {
            this.isError = z;
            return this;
        }

        public Builder withInsertConfig(InsertConfig insertConfig) {
            this.insertConfig = insertConfig;
            return this;
        }

        public ParseConfig build() {
            return new ParseConfig(this);
        }
    }
}
