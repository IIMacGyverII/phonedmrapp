package com.pri.anim.spring;

import java.util.ArrayList;
import java.util.Collection;
import java.util.Collections;
import java.util.HashMap;
import java.util.Iterator;
import java.util.List;
import java.util.Map;
import java.util.Set;
import java.util.concurrent.CopyOnWriteArraySet;
/* loaded from: classes4.dex */
public class BaseSpringSystem {
    private final SpringLooper mSpringLooper;
    private final Map<String, Spring> mSpringRegistry = new HashMap();
    private final Set<Spring> mActiveSprings = new CopyOnWriteArraySet();
    private final CopyOnWriteArraySet<SpringSystemListener> mListeners = new CopyOnWriteArraySet<>();
    private boolean mIdle = true;

    public BaseSpringSystem(SpringLooper springLooper) {
        if (springLooper == null) {
            throw new IllegalArgumentException("springLooper is required");
        }
        this.mSpringLooper = springLooper;
        springLooper.setSpringSystem(this);
    }

    public boolean getIsIdle() {
        return this.mIdle;
    }

    public Spring createSpring() {
        Spring spring = new Spring(this);
        registerSpring(spring);
        return spring;
    }

    public Spring getSpringById(String str) {
        if (str == null) {
            throw new IllegalArgumentException("id is required");
        }
        return this.mSpringRegistry.get(str);
    }

    public List<Spring> getAllSprings() {
        List arrayList;
        Collection<Spring> values = this.mSpringRegistry.values();
        if (values instanceof List) {
            arrayList = (List) values;
        } else {
            arrayList = new ArrayList(values);
        }
        return Collections.unmodifiableList(arrayList);
    }

    void registerSpring(Spring spring) {
        if (spring == null) {
            throw new IllegalArgumentException("com.pri.anim.com.pri.anim.spring.com.pri.anim.spring is required");
        }
        if (this.mSpringRegistry.containsKey(spring.getId())) {
            throw new IllegalArgumentException("com.pri.anim.com.pri.anim.spring.com.pri.anim.spring is already registered");
        }
        this.mSpringRegistry.put(spring.getId(), spring);
    }

    /* JADX INFO: Access modifiers changed from: package-private */
    public void deregisterSpring(Spring spring) {
        if (spring == null) {
            throw new IllegalArgumentException("com.pri.anim.com.pri.anim.spring.com.pri.anim.spring is required");
        }
        this.mActiveSprings.remove(spring);
        this.mSpringRegistry.remove(spring.getId());
    }

    void advance(double d) {
        for (Spring spring : this.mActiveSprings) {
            if (spring.systemShouldAdvance()) {
                spring.advance(d / 1000.0d);
            } else {
                this.mActiveSprings.remove(spring);
            }
        }
    }

    public void loop(double d) {
        Iterator<SpringSystemListener> it = this.mListeners.iterator();
        while (it.hasNext()) {
            it.next().onBeforeIntegrate(this);
        }
        advance(d);
        if (this.mActiveSprings.isEmpty()) {
            this.mIdle = true;
        }
        Iterator<SpringSystemListener> it2 = this.mListeners.iterator();
        while (it2.hasNext()) {
            it2.next().onAfterIntegrate(this);
        }
        if (this.mIdle) {
            this.mSpringLooper.stop();
        }
    }

    /* JADX INFO: Access modifiers changed from: package-private */
    public void activateSpring(String str) {
        Spring spring = this.mSpringRegistry.get(str);
        if (spring == null) {
            throw new IllegalArgumentException("springId " + str + " does not reference a registered com.pri.anim.com.pri.anim.spring.com.pri.anim.spring");
        }
        this.mActiveSprings.add(spring);
        if (getIsIdle()) {
            this.mIdle = false;
            this.mSpringLooper.start();
        }
    }

    public void addListener(SpringSystemListener springSystemListener) {
        if (springSystemListener == null) {
            throw new IllegalArgumentException("newListener is required");
        }
        this.mListeners.add(springSystemListener);
    }

    public void removeListener(SpringSystemListener springSystemListener) {
        if (springSystemListener == null) {
            throw new IllegalArgumentException("listenerToRemove is required");
        }
        this.mListeners.remove(springSystemListener);
    }

    public void removeAllListeners() {
        this.mListeners.clear();
    }
}
