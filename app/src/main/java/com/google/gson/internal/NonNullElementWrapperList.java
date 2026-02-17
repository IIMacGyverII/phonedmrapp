package com.google.gson.internal;

import java.util.AbstractList;
import java.util.ArrayList;
import java.util.Collection;
import java.util.Objects;
import java.util.RandomAccess;

public class NonNullElementWrapperList<E> extends AbstractList<E> implements RandomAccess {
    private final ArrayList<E> delegate;

    public NonNullElementWrapperList(ArrayList<E> arrayList) {
        Objects.requireNonNull(arrayList);
        ArrayList arrayList2 = arrayList;
        this.delegate = arrayList;
    }

    public E get(int i) {
        return this.delegate.get(i);
    }

    public int size() {
        return this.delegate.size();
    }

    private E nonNull(E e) {
        if (e != null) {
            return e;
        }
        throw new NullPointerException("Element must be non-null");
    }

    public E set(int i, E e) {
        return this.delegate.set(i, nonNull(e));
    }

    public void add(int i, E e) {
        this.delegate.add(i, nonNull(e));
    }

    public E remove(int i) {
        return this.delegate.remove(i);
    }

    public void clear() {
        this.delegate.clear();
    }

    public boolean remove(Object obj) {
        return this.delegate.remove(obj);
    }

    public boolean removeAll(Collection<?> collection) {
        return this.delegate.removeAll(collection);
    }

    public boolean retainAll(Collection<?> collection) {
        return this.delegate.retainAll(collection);
    }

    public boolean contains(Object obj) {
        return this.delegate.contains(obj);
    }

    public int indexOf(Object obj) {
        return this.delegate.indexOf(obj);
    }

    public int lastIndexOf(Object obj) {
        return this.delegate.lastIndexOf(obj);
    }

    public Object[] toArray() {
        return this.delegate.toArray();
    }

    public <T> T[] toArray(T[] tArr) {
        return this.delegate.toArray(tArr);
    }

    public boolean equals(Object obj) {
        return this.delegate.equals(obj);
    }

    public int hashCode() {
        return this.delegate.hashCode();
    }
}
