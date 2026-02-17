package com.pri.support.common;

public interface ListenerStubs {

    public static class OverScrollStateListenerStub implements IOverScrollStateListener {
        public void onOverScrollStateChange(IOverScrollDecor iOverScrollDecor, int i, int i2) {
        }
    }

    public static class OverScrollUpdateListenerStub implements IOverScrollUpdateListener {
        public void onOverScrollUpdate(IOverScrollDecor iOverScrollDecor, int i, float f) {
        }
    }
}
