package androidx.fragment.app;

import android.util.Log;
import android.view.View;
import android.view.ViewGroup;
import androidx.annotation.IdRes;
import androidx.annotation.NonNull;
import androidx.annotation.Nullable;
import java.io.FileDescriptor;
import java.io.PrintWriter;
import java.util.ArrayList;
import java.util.Collections;
import java.util.HashMap;
import java.util.Iterator;
import java.util.List;

class FragmentStore {
    private static final String TAG = "FragmentManager";
    private final HashMap<String, FragmentStateManager> mActive = new HashMap<>();
    private final ArrayList<Fragment> mAdded = new ArrayList<>();
    private FragmentManagerViewModel mNonConfig;
    private final HashMap<String, FragmentState> mSavedState = new HashMap<>();

    FragmentStore() {
    }

    /* access modifiers changed from: package-private */
    public void setNonConfig(@NonNull FragmentManagerViewModel fragmentManagerViewModel) {
        this.mNonConfig = fragmentManagerViewModel;
    }

    /* access modifiers changed from: package-private */
    public FragmentManagerViewModel getNonConfig() {
        return this.mNonConfig;
    }

    /* access modifiers changed from: package-private */
    public void resetActiveFragments() {
        this.mActive.clear();
    }

    /* access modifiers changed from: package-private */
    public void restoreAddedFragments(@Nullable List<String> list) {
        this.mAdded.clear();
        if (list != null) {
            for (String next : list) {
                Fragment findActiveFragment = findActiveFragment(next);
                if (findActiveFragment != null) {
                    if (FragmentManager.isLoggingEnabled(2)) {
                        Log.v("FragmentManager", "restoreSaveState: added (" + next + "): " + findActiveFragment);
                    }
                    addFragment(findActiveFragment);
                } else {
                    throw new IllegalStateException("No instantiated fragment for (" + next + ")");
                }
            }
        }
    }

    /* access modifiers changed from: package-private */
    public void makeActive(@NonNull FragmentStateManager fragmentStateManager) {
        Fragment fragment = fragmentStateManager.getFragment();
        if (!containsActiveFragment(fragment.mWho)) {
            this.mActive.put(fragment.mWho, fragmentStateManager);
            if (fragment.mRetainInstanceChangedWhileDetached) {
                if (fragment.mRetainInstance) {
                    this.mNonConfig.addRetainedFragment(fragment);
                } else {
                    this.mNonConfig.removeRetainedFragment(fragment);
                }
                fragment.mRetainInstanceChangedWhileDetached = false;
            }
            if (FragmentManager.isLoggingEnabled(2)) {
                Log.v("FragmentManager", "Added fragment to active set " + fragment);
            }
        }
    }

    /* access modifiers changed from: package-private */
    public void addFragment(@NonNull Fragment fragment) {
        if (!this.mAdded.contains(fragment)) {
            synchronized (this.mAdded) {
                this.mAdded.add(fragment);
            }
            fragment.mAdded = true;
            return;
        }
        throw new IllegalStateException("Fragment already added: " + fragment);
    }

    /* access modifiers changed from: package-private */
    public void dispatchStateChange(int i) {
        for (FragmentStateManager next : this.mActive.values()) {
            if (next != null) {
                next.setFragmentManagerState(i);
            }
        }
    }

    /* access modifiers changed from: package-private */
    public void moveToExpectedState() {
        Iterator<Fragment> it = this.mAdded.iterator();
        while (it.hasNext()) {
            FragmentStateManager fragmentStateManager = this.mActive.get(it.next().mWho);
            if (fragmentStateManager != null) {
                fragmentStateManager.moveToExpectedState();
            }
        }
        for (FragmentStateManager next : this.mActive.values()) {
            if (next != null) {
                next.moveToExpectedState();
                Fragment fragment = next.getFragment();
                if (fragment.mRemoving && !fragment.isInBackStack()) {
                    if (fragment.mBeingSaved && !this.mSavedState.containsKey(fragment.mWho)) {
                        next.saveState();
                    }
                    makeInactive(next);
                }
            }
        }
    }

    /* access modifiers changed from: package-private */
    public void removeFragment(@NonNull Fragment fragment) {
        synchronized (this.mAdded) {
            this.mAdded.remove(fragment);
        }
        fragment.mAdded = false;
    }

    /* access modifiers changed from: package-private */
    public void makeInactive(@NonNull FragmentStateManager fragmentStateManager) {
        Fragment fragment = fragmentStateManager.getFragment();
        if (fragment.mRetainInstance) {
            this.mNonConfig.removeRetainedFragment(fragment);
        }
        if (this.mActive.put(fragment.mWho, (Object) null) != null && FragmentManager.isLoggingEnabled(2)) {
            Log.v("FragmentManager", "Removed fragment from active set " + fragment);
        }
    }

    /* access modifiers changed from: package-private */
    public void burpActive() {
        this.mActive.values().removeAll(Collections.singleton((Object) null));
    }

    /* access modifiers changed from: package-private */
    @Nullable
    public FragmentState getSavedState(@NonNull String str) {
        return this.mSavedState.get(str);
    }

    /* access modifiers changed from: package-private */
    @Nullable
    public FragmentState setSavedState(@NonNull String str, @Nullable FragmentState fragmentState) {
        if (fragmentState != null) {
            return this.mSavedState.put(str, fragmentState);
        }
        return this.mSavedState.remove(str);
    }

    /* access modifiers changed from: package-private */
    public void restoreSaveState(@NonNull ArrayList<FragmentState> arrayList) {
        this.mSavedState.clear();
        Iterator<FragmentState> it = arrayList.iterator();
        while (it.hasNext()) {
            FragmentState next = it.next();
            this.mSavedState.put(next.mWho, next);
        }
    }

    /* access modifiers changed from: package-private */
    @NonNull
    public ArrayList<FragmentState> getAllSavedState() {
        return new ArrayList<>(this.mSavedState.values());
    }

    /* access modifiers changed from: package-private */
    @NonNull
    public ArrayList<String> saveActiveFragments() {
        ArrayList<String> arrayList = new ArrayList<>(this.mActive.size());
        for (FragmentStateManager next : this.mActive.values()) {
            if (next != null) {
                Fragment fragment = next.getFragment();
                next.saveState();
                arrayList.add(fragment.mWho);
                if (FragmentManager.isLoggingEnabled(2)) {
                    Log.v("FragmentManager", "Saved state of " + fragment + ": " + fragment.mSavedFragmentState);
                }
            }
        }
        return arrayList;
    }

    /* access modifiers changed from: package-private */
    @Nullable
    public ArrayList<String> saveAddedFragments() {
        synchronized (this.mAdded) {
            if (this.mAdded.isEmpty()) {
                return null;
            }
            ArrayList<String> arrayList = new ArrayList<>(this.mAdded.size());
            Iterator<Fragment> it = this.mAdded.iterator();
            while (it.hasNext()) {
                Fragment next = it.next();
                arrayList.add(next.mWho);
                if (FragmentManager.isLoggingEnabled(2)) {
                    Log.v("FragmentManager", "saveAllState: adding fragment (" + next.mWho + "): " + next);
                }
            }
            return arrayList;
        }
    }

    /* access modifiers changed from: package-private */
    @NonNull
    public List<FragmentStateManager> getActiveFragmentStateManagers() {
        ArrayList arrayList = new ArrayList();
        for (FragmentStateManager next : this.mActive.values()) {
            if (next != null) {
                arrayList.add(next);
            }
        }
        return arrayList;
    }

    /* access modifiers changed from: package-private */
    @NonNull
    public List<Fragment> getFragments() {
        ArrayList arrayList;
        if (this.mAdded.isEmpty()) {
            return Collections.emptyList();
        }
        synchronized (this.mAdded) {
            arrayList = new ArrayList(this.mAdded);
        }
        return arrayList;
    }

    /* access modifiers changed from: package-private */
    @NonNull
    public List<Fragment> getActiveFragments() {
        ArrayList arrayList = new ArrayList();
        for (FragmentStateManager next : this.mActive.values()) {
            if (next != null) {
                arrayList.add(next.getFragment());
            } else {
                arrayList.add((Object) null);
            }
        }
        return arrayList;
    }

    /* access modifiers changed from: package-private */
    public int getActiveFragmentCount() {
        return this.mActive.size();
    }

    /* access modifiers changed from: package-private */
    @Nullable
    public Fragment findFragmentById(@IdRes int i) {
        for (int size = this.mAdded.size() - 1; size >= 0; size--) {
            Fragment fragment = this.mAdded.get(size);
            if (fragment != null && fragment.mFragmentId == i) {
                return fragment;
            }
        }
        for (FragmentStateManager next : this.mActive.values()) {
            if (next != null) {
                Fragment fragment2 = next.getFragment();
                if (fragment2.mFragmentId == i) {
                    return fragment2;
                }
            }
        }
        return null;
    }

    /* access modifiers changed from: package-private */
    @Nullable
    public Fragment findFragmentByTag(@Nullable String str) {
        if (str != null) {
            for (int size = this.mAdded.size() - 1; size >= 0; size--) {
                Fragment fragment = this.mAdded.get(size);
                if (fragment != null && str.equals(fragment.mTag)) {
                    return fragment;
                }
            }
        }
        if (str == null) {
            return null;
        }
        for (FragmentStateManager next : this.mActive.values()) {
            if (next != null) {
                Fragment fragment2 = next.getFragment();
                if (str.equals(fragment2.mTag)) {
                    return fragment2;
                }
            }
        }
        return null;
    }

    /* access modifiers changed from: package-private */
    public boolean containsActiveFragment(@NonNull String str) {
        return this.mActive.get(str) != null;
    }

    /* access modifiers changed from: package-private */
    @Nullable
    public FragmentStateManager getFragmentStateManager(@NonNull String str) {
        return this.mActive.get(str);
    }

    /* access modifiers changed from: package-private */
    @Nullable
    public Fragment findFragmentByWho(@NonNull String str) {
        Fragment findFragmentByWho;
        for (FragmentStateManager next : this.mActive.values()) {
            if (next != null && (findFragmentByWho = next.getFragment().findFragmentByWho(str)) != null) {
                return findFragmentByWho;
            }
        }
        return null;
    }

    /* access modifiers changed from: package-private */
    @Nullable
    public Fragment findActiveFragment(@NonNull String str) {
        FragmentStateManager fragmentStateManager = this.mActive.get(str);
        if (fragmentStateManager != null) {
            return fragmentStateManager.getFragment();
        }
        return null;
    }

    /* access modifiers changed from: package-private */
    public int findFragmentIndexInContainer(@NonNull Fragment fragment) {
        View view;
        View view2;
        ViewGroup viewGroup = fragment.mContainer;
        if (viewGroup == null) {
            return -1;
        }
        int indexOf = this.mAdded.indexOf(fragment);
        for (int i = indexOf - 1; i >= 0; i--) {
            Fragment fragment2 = this.mAdded.get(i);
            if (fragment2.mContainer == viewGroup && (view2 = fragment2.mView) != null) {
                return viewGroup.indexOfChild(view2) + 1;
            }
        }
        while (true) {
            indexOf++;
            if (indexOf >= this.mAdded.size()) {
                return -1;
            }
            Fragment fragment3 = this.mAdded.get(indexOf);
            if (fragment3.mContainer == viewGroup && (view = fragment3.mView) != null) {
                return viewGroup.indexOfChild(view);
            }
        }
    }

    /* access modifiers changed from: package-private */
    public void dump(@NonNull String str, @Nullable FileDescriptor fileDescriptor, @NonNull PrintWriter printWriter, @Nullable String[] strArr) {
        String str2 = str + "    ";
        if (!this.mActive.isEmpty()) {
            printWriter.print(str);
            printWriter.println("Active Fragments:");
            for (FragmentStateManager next : this.mActive.values()) {
                printWriter.print(str);
                if (next != null) {
                    Fragment fragment = next.getFragment();
                    printWriter.println(fragment);
                    fragment.dump(str2, fileDescriptor, printWriter, strArr);
                } else {
                    printWriter.println("null");
                }
            }
        }
        int size = this.mAdded.size();
        if (size > 0) {
            printWriter.print(str);
            printWriter.println("Added Fragments:");
            for (int i = 0; i < size; i++) {
                printWriter.print(str);
                printWriter.print("  #");
                printWriter.print(i);
                printWriter.print(": ");
                printWriter.println(this.mAdded.get(i).toString());
            }
        }
    }
}
