package androidx.transition;

import android.animation.Animator;
import android.animation.AnimatorListenerAdapter;
import androidx.annotation.NonNull;

class AnimatorUtils {

    interface AnimatorPauseListenerCompat {
        void onAnimationPause(Animator animator);

        void onAnimationResume(Animator animator);
    }

    static void addPauseListener(@NonNull Animator animator, @NonNull AnimatorListenerAdapter animatorListenerAdapter) {
        animator.addPauseListener(animatorListenerAdapter);
    }

    static void pause(@NonNull Animator animator) {
        animator.pause();
    }

    static void resume(@NonNull Animator animator) {
        animator.resume();
    }

    private AnimatorUtils() {
    }
}
