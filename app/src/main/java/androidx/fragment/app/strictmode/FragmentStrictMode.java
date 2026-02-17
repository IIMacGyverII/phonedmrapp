package androidx.fragment.app.strictmode;

import android.annotation.SuppressLint;
import android.os.Handler;
import android.os.Looper;
import android.util.Log;
import android.view.ViewGroup;
import androidx.annotation.NonNull;
import androidx.annotation.Nullable;
import androidx.annotation.RestrictTo;
import androidx.annotation.VisibleForTesting;
import androidx.fragment.app.Fragment;
import androidx.fragment.app.FragmentManager;
import java.util.Collection;
import java.util.HashMap;
import java.util.HashSet;
import java.util.Map;
import java.util.Set;

@SuppressLint({"SyntheticAccessor"})
public final class FragmentStrictMode {
    private static final String TAG = "FragmentStrictMode";
    private static Policy defaultPolicy = Policy.LAX;

    private enum Flag {
        PENALTY_LOG,
        PENALTY_DEATH,
        DETECT_FRAGMENT_REUSE,
        DETECT_FRAGMENT_TAG_USAGE,
        DETECT_RETAIN_INSTANCE_USAGE,
        DETECT_SET_USER_VISIBLE_HINT,
        DETECT_TARGET_FRAGMENT_USAGE,
        DETECT_WRONG_FRAGMENT_CONTAINER
    }

    public interface OnViolationListener {
        void onViolation(@NonNull Violation violation);
    }

    private FragmentStrictMode() {
    }

    public static final class Policy {
        @NonNull
        public static final Policy LAX = new Policy(new HashSet(), (OnViolationListener) null, new HashMap());
        /* access modifiers changed from: private */
        public final Map<Class<? extends Fragment>, Set<Class<? extends Violation>>> mAllowedViolations;
        /* access modifiers changed from: private */
        public final Set<Flag> mFlags;
        /* access modifiers changed from: private */
        public final OnViolationListener mListener;

        private Policy(@NonNull Set<Flag> set, @Nullable OnViolationListener onViolationListener, @NonNull Map<Class<? extends Fragment>, Set<Class<? extends Violation>>> map) {
            this.mFlags = new HashSet(set);
            this.mListener = onViolationListener;
            HashMap hashMap = new HashMap();
            for (Map.Entry next : map.entrySet()) {
                hashMap.put((Class) next.getKey(), new HashSet((Collection) next.getValue()));
            }
            this.mAllowedViolations = hashMap;
        }

        public static final class Builder {
            private final Map<Class<? extends Fragment>, Set<Class<? extends Violation>>> mAllowedViolations = new HashMap();
            private final Set<Flag> mFlags = new HashSet();
            private OnViolationListener mListener;

            @SuppressLint({"BuilderSetStyle"})
            @NonNull
            public Builder penaltyLog() {
                this.mFlags.add(Flag.PENALTY_LOG);
                return this;
            }

            @SuppressLint({"BuilderSetStyle"})
            @NonNull
            public Builder penaltyDeath() {
                this.mFlags.add(Flag.PENALTY_DEATH);
                return this;
            }

            @SuppressLint({"BuilderSetStyle"})
            @NonNull
            public Builder penaltyListener(@NonNull OnViolationListener onViolationListener) {
                this.mListener = onViolationListener;
                return this;
            }

            @SuppressLint({"BuilderSetStyle"})
            @NonNull
            public Builder detectFragmentReuse() {
                this.mFlags.add(Flag.DETECT_FRAGMENT_REUSE);
                return this;
            }

            @SuppressLint({"BuilderSetStyle"})
            @NonNull
            public Builder detectFragmentTagUsage() {
                this.mFlags.add(Flag.DETECT_FRAGMENT_TAG_USAGE);
                return this;
            }

            @SuppressLint({"BuilderSetStyle"})
            @NonNull
            public Builder detectRetainInstanceUsage() {
                this.mFlags.add(Flag.DETECT_RETAIN_INSTANCE_USAGE);
                return this;
            }

            @SuppressLint({"BuilderSetStyle"})
            @NonNull
            public Builder detectSetUserVisibleHint() {
                this.mFlags.add(Flag.DETECT_SET_USER_VISIBLE_HINT);
                return this;
            }

            @SuppressLint({"BuilderSetStyle"})
            @NonNull
            public Builder detectTargetFragmentUsage() {
                this.mFlags.add(Flag.DETECT_TARGET_FRAGMENT_USAGE);
                return this;
            }

            @SuppressLint({"BuilderSetStyle"})
            @NonNull
            public Builder detectWrongFragmentContainer() {
                this.mFlags.add(Flag.DETECT_WRONG_FRAGMENT_CONTAINER);
                return this;
            }

            @SuppressLint({"BuilderSetStyle"})
            @NonNull
            public Builder allowViolation(@NonNull Class<? extends Fragment> cls, @NonNull Class<? extends Violation> cls2) {
                Set set = this.mAllowedViolations.get(cls);
                if (set == null) {
                    set = new HashSet();
                }
                set.add(cls2);
                this.mAllowedViolations.put(cls, set);
                return this;
            }

            @NonNull
            public Policy build() {
                if (this.mListener == null && !this.mFlags.contains(Flag.PENALTY_DEATH)) {
                    penaltyLog();
                }
                return new Policy(this.mFlags, this.mListener, this.mAllowedViolations);
            }
        }
    }

    @NonNull
    public static Policy getDefaultPolicy() {
        return defaultPolicy;
    }

    public static void setDefaultPolicy(@NonNull Policy policy) {
        defaultPolicy = policy;
    }

    private static Policy getNearestPolicy(@Nullable Fragment fragment) {
        while (fragment != null) {
            if (fragment.isAdded()) {
                FragmentManager parentFragmentManager = fragment.getParentFragmentManager();
                if (parentFragmentManager.getStrictModePolicy() != null) {
                    return parentFragmentManager.getStrictModePolicy();
                }
            }
            fragment = fragment.getParentFragment();
        }
        return defaultPolicy;
    }

    @RestrictTo({RestrictTo.Scope.LIBRARY})
    public static void onFragmentReuse(@NonNull Fragment fragment, @NonNull String str) {
        FragmentReuseViolation fragmentReuseViolation = new FragmentReuseViolation(fragment, str);
        logIfDebuggingEnabled(fragmentReuseViolation);
        Policy nearestPolicy = getNearestPolicy(fragment);
        if (nearestPolicy.mFlags.contains(Flag.DETECT_FRAGMENT_REUSE) && shouldHandlePolicyViolation(nearestPolicy, fragment.getClass(), FragmentReuseViolation.class)) {
            handlePolicyViolation(nearestPolicy, fragmentReuseViolation);
        }
    }

    @RestrictTo({RestrictTo.Scope.LIBRARY})
    public static void onFragmentTagUsage(@NonNull Fragment fragment, @Nullable ViewGroup viewGroup) {
        FragmentTagUsageViolation fragmentTagUsageViolation = new FragmentTagUsageViolation(fragment, viewGroup);
        logIfDebuggingEnabled(fragmentTagUsageViolation);
        Policy nearestPolicy = getNearestPolicy(fragment);
        if (nearestPolicy.mFlags.contains(Flag.DETECT_FRAGMENT_TAG_USAGE) && shouldHandlePolicyViolation(nearestPolicy, fragment.getClass(), FragmentTagUsageViolation.class)) {
            handlePolicyViolation(nearestPolicy, fragmentTagUsageViolation);
        }
    }

    @RestrictTo({RestrictTo.Scope.LIBRARY})
    public static void onSetRetainInstanceUsage(@NonNull Fragment fragment) {
        SetRetainInstanceUsageViolation setRetainInstanceUsageViolation = new SetRetainInstanceUsageViolation(fragment);
        logIfDebuggingEnabled(setRetainInstanceUsageViolation);
        Policy nearestPolicy = getNearestPolicy(fragment);
        if (nearestPolicy.mFlags.contains(Flag.DETECT_RETAIN_INSTANCE_USAGE) && shouldHandlePolicyViolation(nearestPolicy, fragment.getClass(), SetRetainInstanceUsageViolation.class)) {
            handlePolicyViolation(nearestPolicy, setRetainInstanceUsageViolation);
        }
    }

    @RestrictTo({RestrictTo.Scope.LIBRARY})
    public static void onGetRetainInstanceUsage(@NonNull Fragment fragment) {
        GetRetainInstanceUsageViolation getRetainInstanceUsageViolation = new GetRetainInstanceUsageViolation(fragment);
        logIfDebuggingEnabled(getRetainInstanceUsageViolation);
        Policy nearestPolicy = getNearestPolicy(fragment);
        if (nearestPolicy.mFlags.contains(Flag.DETECT_RETAIN_INSTANCE_USAGE) && shouldHandlePolicyViolation(nearestPolicy, fragment.getClass(), GetRetainInstanceUsageViolation.class)) {
            handlePolicyViolation(nearestPolicy, getRetainInstanceUsageViolation);
        }
    }

    @RestrictTo({RestrictTo.Scope.LIBRARY})
    public static void onSetUserVisibleHint(@NonNull Fragment fragment, boolean z) {
        SetUserVisibleHintViolation setUserVisibleHintViolation = new SetUserVisibleHintViolation(fragment, z);
        logIfDebuggingEnabled(setUserVisibleHintViolation);
        Policy nearestPolicy = getNearestPolicy(fragment);
        if (nearestPolicy.mFlags.contains(Flag.DETECT_SET_USER_VISIBLE_HINT) && shouldHandlePolicyViolation(nearestPolicy, fragment.getClass(), SetUserVisibleHintViolation.class)) {
            handlePolicyViolation(nearestPolicy, setUserVisibleHintViolation);
        }
    }

    @RestrictTo({RestrictTo.Scope.LIBRARY})
    public static void onSetTargetFragmentUsage(@NonNull Fragment fragment, @NonNull Fragment fragment2, int i) {
        SetTargetFragmentUsageViolation setTargetFragmentUsageViolation = new SetTargetFragmentUsageViolation(fragment, fragment2, i);
        logIfDebuggingEnabled(setTargetFragmentUsageViolation);
        Policy nearestPolicy = getNearestPolicy(fragment);
        if (nearestPolicy.mFlags.contains(Flag.DETECT_TARGET_FRAGMENT_USAGE) && shouldHandlePolicyViolation(nearestPolicy, fragment.getClass(), SetTargetFragmentUsageViolation.class)) {
            handlePolicyViolation(nearestPolicy, setTargetFragmentUsageViolation);
        }
    }

    @RestrictTo({RestrictTo.Scope.LIBRARY})
    public static void onGetTargetFragmentUsage(@NonNull Fragment fragment) {
        GetTargetFragmentUsageViolation getTargetFragmentUsageViolation = new GetTargetFragmentUsageViolation(fragment);
        logIfDebuggingEnabled(getTargetFragmentUsageViolation);
        Policy nearestPolicy = getNearestPolicy(fragment);
        if (nearestPolicy.mFlags.contains(Flag.DETECT_TARGET_FRAGMENT_USAGE) && shouldHandlePolicyViolation(nearestPolicy, fragment.getClass(), GetTargetFragmentUsageViolation.class)) {
            handlePolicyViolation(nearestPolicy, getTargetFragmentUsageViolation);
        }
    }

    @RestrictTo({RestrictTo.Scope.LIBRARY})
    public static void onGetTargetFragmentRequestCodeUsage(@NonNull Fragment fragment) {
        GetTargetFragmentRequestCodeUsageViolation getTargetFragmentRequestCodeUsageViolation = new GetTargetFragmentRequestCodeUsageViolation(fragment);
        logIfDebuggingEnabled(getTargetFragmentRequestCodeUsageViolation);
        Policy nearestPolicy = getNearestPolicy(fragment);
        if (nearestPolicy.mFlags.contains(Flag.DETECT_TARGET_FRAGMENT_USAGE) && shouldHandlePolicyViolation(nearestPolicy, fragment.getClass(), GetTargetFragmentRequestCodeUsageViolation.class)) {
            handlePolicyViolation(nearestPolicy, getTargetFragmentRequestCodeUsageViolation);
        }
    }

    @RestrictTo({RestrictTo.Scope.LIBRARY})
    public static void onWrongFragmentContainer(@NonNull Fragment fragment, @NonNull ViewGroup viewGroup) {
        WrongFragmentContainerViolation wrongFragmentContainerViolation = new WrongFragmentContainerViolation(fragment, viewGroup);
        logIfDebuggingEnabled(wrongFragmentContainerViolation);
        Policy nearestPolicy = getNearestPolicy(fragment);
        if (nearestPolicy.mFlags.contains(Flag.DETECT_WRONG_FRAGMENT_CONTAINER) && shouldHandlePolicyViolation(nearestPolicy, fragment.getClass(), WrongFragmentContainerViolation.class)) {
            handlePolicyViolation(nearestPolicy, wrongFragmentContainerViolation);
        }
    }

    @VisibleForTesting
    static void onPolicyViolation(@NonNull Violation violation) {
        logIfDebuggingEnabled(violation);
        Fragment fragment = violation.getFragment();
        Policy nearestPolicy = getNearestPolicy(fragment);
        if (shouldHandlePolicyViolation(nearestPolicy, fragment.getClass(), violation.getClass())) {
            handlePolicyViolation(nearestPolicy, violation);
        }
    }

    private static void logIfDebuggingEnabled(@NonNull Violation violation) {
        if (FragmentManager.isLoggingEnabled(3)) {
            Log.d(FragmentManager.TAG, "StrictMode violation in " + violation.getFragment().getClass().getName(), violation);
        }
    }

    private static boolean shouldHandlePolicyViolation(@NonNull Policy policy, @NonNull Class<? extends Fragment> cls, @NonNull Class<? extends Violation> cls2) {
        Set set = (Set) policy.mAllowedViolations.get(cls);
        if (set == null) {
            return true;
        }
        if (cls2.getSuperclass() == Violation.class || !set.contains(cls2.getSuperclass())) {
            return !set.contains(cls2);
        }
        return false;
    }

    private static void handlePolicyViolation(@NonNull final Policy policy, @NonNull final Violation violation) {
        Fragment fragment = violation.getFragment();
        final String name = fragment.getClass().getName();
        if (policy.mFlags.contains(Flag.PENALTY_LOG)) {
            Log.d(TAG, "Policy violation in " + name, violation);
        }
        if (policy.mListener != null) {
            runOnHostThread(fragment, new Runnable() {
                public void run() {
                    Policy.this.mListener.onViolation(violation);
                }
            });
        }
        if (policy.mFlags.contains(Flag.PENALTY_DEATH)) {
            runOnHostThread(fragment, new Runnable() {
                public void run() {
                    Log.e(FragmentStrictMode.TAG, "Policy violation with PENALTY_DEATH in " + name, violation);
                    throw violation;
                }
            });
        }
    }

    private static void runOnHostThread(@NonNull Fragment fragment, @NonNull Runnable runnable) {
        if (fragment.isAdded()) {
            Handler handler = fragment.getParentFragmentManager().getHost().getHandler();
            if (handler.getLooper() == Looper.myLooper()) {
                runnable.run();
            } else {
                handler.post(runnable);
            }
        } else {
            runnable.run();
        }
    }
}
