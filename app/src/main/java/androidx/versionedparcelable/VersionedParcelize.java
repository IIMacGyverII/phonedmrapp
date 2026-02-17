package androidx.versionedparcelable;

import androidx.annotation.NonNull;
import androidx.annotation.RestrictTo;
import java.lang.annotation.ElementType;
import java.lang.annotation.Retention;
import java.lang.annotation.RetentionPolicy;
import java.lang.annotation.Target;

@Target({ElementType.TYPE})
@RestrictTo({RestrictTo.Scope.LIBRARY_GROUP_PREFIX})
@Retention(RetentionPolicy.CLASS)
public @interface VersionedParcelize {
    boolean allowSerialization() default false;

    @NonNull
    int[] deprecatedIds() default {};

    @NonNull
    Class<?> factory() default void.class;

    boolean ignoreParcelables() default false;

    boolean isCustom() default false;

    @NonNull
    String jetifyAs() default "";
}
