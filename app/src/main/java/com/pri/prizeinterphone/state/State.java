package com.pri.prizeinterphone.state;

import android.os.Message;
/* loaded from: classes4.dex */
public class State implements IState {
    @Override // com.pri.prizeinterphone.state.IState
    public void enter() {
    }

    @Override // com.pri.prizeinterphone.state.IState
    public void exit() {
    }

    @Override // com.pri.prizeinterphone.state.IState
    public boolean processMessage(Message message) {
        return false;
    }

    @Override // com.pri.prizeinterphone.state.IState
    public String getName() {
        String name = getClass().getName();
        return name.substring(name.lastIndexOf(36) + 1);
    }
}
