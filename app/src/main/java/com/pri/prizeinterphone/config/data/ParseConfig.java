package com.pri.prizeinterphone.config.data;

public class ParseConfig {
    private InsertConfig insertConfig = null;
    private boolean isError = true;

    private ParseConfig() {
    }

    public ParseConfig(Builder builder) {
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

    public void setInsertConfig(InsertConfig insertConfig2) {
        this.insertConfig = insertConfig2;
    }

    public static final class Builder {
        /* access modifiers changed from: private */
        public InsertConfig insertConfig;
        /* access modifiers changed from: private */
        public boolean isError;

        public Builder withIsError(boolean z) {
            this.isError = z;
            return this;
        }

        public Builder withInsertConfig(InsertConfig insertConfig2) {
            this.insertConfig = insertConfig2;
            return this;
        }

        public ParseConfig build() {
            return new ParseConfig(this);
        }
    }
}
