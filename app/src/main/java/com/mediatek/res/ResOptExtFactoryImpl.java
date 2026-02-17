package com.mediatek.res;

public class ResOptExtFactoryImpl extends ResOptExtFactory {
    public ResOptExt makeResOptExt() {
        return ResOptExtImpl.getInstance();
    }
}
