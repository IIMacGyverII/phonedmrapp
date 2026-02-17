package com.mediatek.boostfwk;

public class BoostFwkFactoryImpl extends BoostFwkFactory {
    public BoostFwkManager makeBoostFwkManager() {
        return BoostFwkManagerImpl.getInstance();
    }
}
