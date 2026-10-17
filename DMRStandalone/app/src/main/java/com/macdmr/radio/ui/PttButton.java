package com.macdmr.radio.ui;

import android.content.Context;
import android.view.MotionEvent;
import android.widget.ImageView;

import com.macdmr.radio.R;

/**
 * The push-to-talk key, using the module's own artwork: amber when idle (`interphone_talkback_record`),
 * red while transmitting (`…_recording`), green while receiving (`…_recv`). 176 dp like the OEM's.
 * Press-and-hold semantics via {@link Listener}.
 */
public class PttButton extends ImageView {
    public interface Listener { void onPtt(boolean down); }
    public enum State { IDLE, TX, RX, BUSY }

    private boolean down;
    private State state = State.IDLE;
    private Listener listener;

    public PttButton(Context c) {
        super(c);
        setClickable(true);
        setScaleType(ScaleType.FIT_CENTER);
        setState(State.IDLE);
    }

    public void setListener(Listener l) { listener = l; }

    public void setState(State s) {
        state = s;
        int res = s == State.TX ? R.drawable.interphone_talkback_recording : s == State.RX ? R.drawable.interphone_talkback_recv : R.drawable.interphone_talkback_record;
        setImageResource(res);
        setAlpha(s == State.BUSY ? 0.45f : 1f);
    }

    public State getState() { return state; }

    @Override protected void onMeasure(int w, int h) { int s = Theme.dp(getContext(), 176); setMeasuredDimension(resolveSize(s, w), resolveSize(s, h)); }

    @Override public boolean onTouchEvent(MotionEvent e) {
        switch (e.getAction()) {
            case MotionEvent.ACTION_DOWN: if (!down) { down = true; setScaleX(0.97f); setScaleY(0.97f); if (listener != null) listener.onPtt(true); } return true;
            case MotionEvent.ACTION_UP: case MotionEvent.ACTION_CANCEL: if (down) { down = false; setScaleX(1f); setScaleY(1f); if (listener != null) listener.onPtt(false); } return true;
        }
        return super.onTouchEvent(e);
    }
}
