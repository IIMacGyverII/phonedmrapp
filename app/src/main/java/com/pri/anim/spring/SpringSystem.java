package com.pri.anim.spring;

public class SpringSystem extends BaseSpringSystem {
    public static SpringSystem create() {
        return new SpringSystem(ChoreographerSpringLooper.create());
    }

    private SpringSystem(SpringLooper springLooper) {
        super(springLooper);
    }
}
