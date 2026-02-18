package com.pri.anim.spring;
/* loaded from: classes4.dex */
public class SpringSystem extends BaseSpringSystem {
    public static SpringSystem create() {
        return new SpringSystem(ChoreographerSpringLooper.create());
    }

    private SpringSystem(SpringLooper springLooper) {
        super(springLooper);
    }
}
