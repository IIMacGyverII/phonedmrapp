package com.pri.anim.spring;

public interface SpringListener {
    void onSpringActivate(Spring spring);

    void onSpringAtRest(Spring spring);

    void onSpringEndStateChange(Spring spring);

    void onSpringUpdate(Spring spring);
}
