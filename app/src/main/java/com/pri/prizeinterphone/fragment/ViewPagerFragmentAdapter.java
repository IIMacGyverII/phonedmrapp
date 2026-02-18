package com.pri.prizeinterphone.fragment;

import androidx.fragment.app.Fragment;
import androidx.fragment.app.FragmentManager;
import androidx.fragment.app.FragmentPagerAdapter;
import java.util.ArrayList;
import java.util.Iterator;
/* loaded from: classes4.dex */
public class ViewPagerFragmentAdapter extends FragmentPagerAdapter {
    private ArrayList<BaseViewPagerFragment> mFragments;

    public ViewPagerFragmentAdapter(FragmentManager fragmentManager) {
        super(fragmentManager);
        this.mFragments = new ArrayList<>();
    }

    public void add(BaseViewPagerFragment baseViewPagerFragment) {
        this.mFragments.add(baseViewPagerFragment);
    }

    public ArrayList<BaseViewPagerFragment> getmFragments() {
        return this.mFragments;
    }

    public void updateFragmentView() {
        ArrayList<BaseViewPagerFragment> arrayList = this.mFragments;
        if (arrayList == null || arrayList.size() <= 0) {
            return;
        }
        Iterator<BaseViewPagerFragment> it = this.mFragments.iterator();
        while (it.hasNext()) {
            it.next().updateView();
        }
    }

    public void updateFragmentView(int i) {
        ArrayList<BaseViewPagerFragment> arrayList = this.mFragments;
        if (arrayList == null || arrayList.size() <= 0) {
            return;
        }
        int i2 = 0;
        Iterator<BaseViewPagerFragment> it = this.mFragments.iterator();
        while (it.hasNext()) {
            BaseViewPagerFragment next = it.next();
            if (i == i2) {
                next.updateView();
            }
            i2++;
        }
    }

    @Override // androidx.fragment.app.FragmentPagerAdapter
    public Fragment getItem(int i) {
        return this.mFragments.get(i);
    }

    @Override // androidx.viewpager.widget.PagerAdapter
    public int getCount() {
        return this.mFragments.size();
    }
}
