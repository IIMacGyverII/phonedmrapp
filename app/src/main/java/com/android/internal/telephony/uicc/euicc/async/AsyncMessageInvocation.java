package com.android.internal.telephony.uicc.euicc.async;

import android.os.AsyncResult;
import android.os.Handler;
import android.os.Message;

public abstract class AsyncMessageInvocation<Request, Response> implements Handler.Callback {
    /* access modifiers changed from: protected */
    public abstract Response parseResult(AsyncResult asyncResult) throws Throwable;

    /* access modifiers changed from: protected */
    public abstract void sendRequestMessage(Request request, Message message);

    public final void invoke(Request request, AsyncResultCallback<Response> asyncResultCallback, Handler handler) {
        sendRequestMessage(request, new Handler(handler.getLooper(), this).obtainMessage(0, asyncResultCallback));
    }

    public boolean handleMessage(Message message) {
        AsyncResult asyncResult = (AsyncResult) message.obj;
        AsyncResultCallback asyncResultCallback = (AsyncResultCallback) asyncResult.userObj;
        try {
            asyncResultCallback.onResult(parseResult(asyncResult));
            return true;
        } catch (Throwable th) {
            asyncResultCallback.onException(th);
            return true;
        }
    }
}
