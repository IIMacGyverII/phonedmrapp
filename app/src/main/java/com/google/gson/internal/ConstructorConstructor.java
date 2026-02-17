package com.google.gson.internal;

import com.google.gson.InstanceCreator;
import com.google.gson.JsonIOException;
import com.google.gson.ReflectionAccessFilter;
import com.google.gson.reflect.TypeToken;
import java.lang.reflect.Modifier;
import java.lang.reflect.ParameterizedType;
import java.lang.reflect.Type;
import java.util.ArrayDeque;
import java.util.ArrayList;
import java.util.Collection;
import java.util.EnumMap;
import java.util.EnumSet;
import java.util.LinkedHashMap;
import java.util.LinkedHashSet;
import java.util.List;
import java.util.Map;
import java.util.Queue;
import java.util.Set;
import java.util.SortedMap;
import java.util.SortedSet;
import java.util.TreeMap;
import java.util.TreeSet;
import java.util.concurrent.ConcurrentHashMap;
import java.util.concurrent.ConcurrentMap;
import java.util.concurrent.ConcurrentNavigableMap;
import java.util.concurrent.ConcurrentSkipListMap;

public final class ConstructorConstructor {
    private final Map<Type, InstanceCreator<?>> instanceCreators;
    private final List<ReflectionAccessFilter> reflectionFilters;
    private final boolean useJdkUnsafe;

    public ConstructorConstructor(Map<Type, InstanceCreator<?>> map, boolean z, List<ReflectionAccessFilter> list) {
        this.instanceCreators = map;
        this.useJdkUnsafe = z;
        this.reflectionFilters = list;
    }

    static String checkInstantiable(Class<?> cls) {
        int modifiers = cls.getModifiers();
        if (Modifier.isInterface(modifiers)) {
            return "Interfaces can't be instantiated! Register an InstanceCreator or a TypeAdapter for this type. Interface name: " + cls.getName();
        } else if (!Modifier.isAbstract(modifiers)) {
            return null;
        } else {
            return "Abstract classes can't be instantiated! Register an InstanceCreator or a TypeAdapter for this type. Class name: " + cls.getName();
        }
    }

    public <T> ObjectConstructor<T> get(TypeToken<T> typeToken) {
        final Type type = typeToken.getType();
        Class<? super T> rawType = typeToken.getRawType();
        final InstanceCreator instanceCreator = this.instanceCreators.get(type);
        if (instanceCreator != null) {
            return new ObjectConstructor<T>() {
                public T construct() {
                    return instanceCreator.createInstance(type);
                }
            };
        }
        final InstanceCreator instanceCreator2 = this.instanceCreators.get(rawType);
        if (instanceCreator2 != null) {
            return new ObjectConstructor<T>() {
                public T construct() {
                    return instanceCreator2.createInstance(type);
                }
            };
        }
        ObjectConstructor<T> newSpecialCollectionConstructor = newSpecialCollectionConstructor(type, rawType);
        if (newSpecialCollectionConstructor != null) {
            return newSpecialCollectionConstructor;
        }
        ReflectionAccessFilter.FilterResult filterResult = ReflectionAccessFilterHelper.getFilterResult(this.reflectionFilters, rawType);
        ObjectConstructor<T> newDefaultConstructor = newDefaultConstructor(rawType, filterResult);
        if (newDefaultConstructor != null) {
            return newDefaultConstructor;
        }
        ObjectConstructor<T> newDefaultImplementationConstructor = newDefaultImplementationConstructor(type, rawType);
        if (newDefaultImplementationConstructor != null) {
            return newDefaultImplementationConstructor;
        }
        final String checkInstantiable = checkInstantiable(rawType);
        if (checkInstantiable != null) {
            return new ObjectConstructor<T>() {
                public T construct() {
                    throw new JsonIOException(checkInstantiable);
                }
            };
        }
        if (filterResult == ReflectionAccessFilter.FilterResult.ALLOW) {
            return newUnsafeAllocator(rawType);
        }
        final String str = "Unable to create instance of " + rawType + "; ReflectionAccessFilter does not permit using reflection or Unsafe. Register an InstanceCreator or a TypeAdapter for this type or adjust the access filter to allow using reflection.";
        return new ObjectConstructor<T>() {
            public T construct() {
                throw new JsonIOException(str);
            }
        };
    }

    private static <T> ObjectConstructor<T> newSpecialCollectionConstructor(final Type type, Class<? super T> cls) {
        if (EnumSet.class.isAssignableFrom(cls)) {
            return new ObjectConstructor<T>() {
                public T construct() {
                    Type type = type;
                    if (type instanceof ParameterizedType) {
                        Type type2 = ((ParameterizedType) type).getActualTypeArguments()[0];
                        if (type2 instanceof Class) {
                            return EnumSet.noneOf((Class) type2);
                        }
                        throw new JsonIOException("Invalid EnumSet type: " + type.toString());
                    }
                    throw new JsonIOException("Invalid EnumSet type: " + type.toString());
                }
            };
        }
        if (cls == EnumMap.class) {
            return new ObjectConstructor<T>() {
                public T construct() {
                    Type type = type;
                    if (type instanceof ParameterizedType) {
                        Type type2 = ((ParameterizedType) type).getActualTypeArguments()[0];
                        if (type2 instanceof Class) {
                            return new EnumMap((Class) type2);
                        }
                        throw new JsonIOException("Invalid EnumMap type: " + type.toString());
                    }
                    throw new JsonIOException("Invalid EnumMap type: " + type.toString());
                }
            };
        }
        return null;
    }

    /* JADX WARNING: Code restructure failed: missing block: B:19:0x004c, code lost:
        r4 = com.google.gson.internal.reflect.ReflectionHelper.tryMakeAccessible(r2);
     */
    /* Code decompiled incorrectly, please refer to instructions dump. */
    private static <T> com.google.gson.internal.ObjectConstructor<T> newDefaultConstructor(java.lang.Class<? super T> r4, com.google.gson.ReflectionAccessFilter.FilterResult r5) {
        /*
            int r0 = r4.getModifiers()
            boolean r0 = java.lang.reflect.Modifier.isAbstract(r0)
            r1 = 0
            if (r0 == 0) goto L_0x000c
            return r1
        L_0x000c:
            r0 = 0
            java.lang.Class[] r2 = new java.lang.Class[r0]     // Catch:{ NoSuchMethodException -> 0x005e }
            java.lang.reflect.Constructor r2 = r4.getDeclaredConstructor(r2)     // Catch:{ NoSuchMethodException -> 0x005e }
            com.google.gson.ReflectionAccessFilter$FilterResult r3 = com.google.gson.ReflectionAccessFilter.FilterResult.ALLOW
            if (r5 == r3) goto L_0x002b
            boolean r1 = com.google.gson.internal.ReflectionAccessFilterHelper.canAccess(r2, r1)
            if (r1 == 0) goto L_0x002c
            com.google.gson.ReflectionAccessFilter$FilterResult r1 = com.google.gson.ReflectionAccessFilter.FilterResult.BLOCK_ALL
            if (r5 != r1) goto L_0x002b
            int r1 = r2.getModifiers()
            boolean r1 = java.lang.reflect.Modifier.isPublic(r1)
            if (r1 == 0) goto L_0x002c
        L_0x002b:
            r0 = 1
        L_0x002c:
            if (r0 != 0) goto L_0x004a
            java.lang.StringBuilder r5 = new java.lang.StringBuilder
            r5.<init>()
            java.lang.String r0 = "Unable to invoke no-args constructor of "
            r5.append(r0)
            r5.append(r4)
            java.lang.String r4 = "; constructor is not accessible and ReflectionAccessFilter does not permit making it accessible. Register an InstanceCreator or a TypeAdapter for this type, change the visibility of the constructor or adjust the access filter."
            r5.append(r4)
            java.lang.String r4 = r5.toString()
            com.google.gson.internal.ConstructorConstructor$7 r5 = new com.google.gson.internal.ConstructorConstructor$7
            r5.<init>(r4)
            return r5
        L_0x004a:
            if (r5 != r3) goto L_0x0058
            java.lang.String r4 = com.google.gson.internal.reflect.ReflectionHelper.tryMakeAccessible(r2)
            if (r4 == 0) goto L_0x0058
            com.google.gson.internal.ConstructorConstructor$8 r5 = new com.google.gson.internal.ConstructorConstructor$8
            r5.<init>(r4)
            return r5
        L_0x0058:
            com.google.gson.internal.ConstructorConstructor$9 r4 = new com.google.gson.internal.ConstructorConstructor$9
            r4.<init>(r2)
            return r4
        L_0x005e:
            return r1
        */
        throw new UnsupportedOperationException("Method not decompiled: com.google.gson.internal.ConstructorConstructor.newDefaultConstructor(java.lang.Class, com.google.gson.ReflectionAccessFilter$FilterResult):com.google.gson.internal.ObjectConstructor");
    }

    private static <T> ObjectConstructor<T> newDefaultImplementationConstructor(Type type, Class<? super T> cls) {
        if (Collection.class.isAssignableFrom(cls)) {
            if (SortedSet.class.isAssignableFrom(cls)) {
                return new ObjectConstructor<T>() {
                    public T construct() {
                        return new TreeSet();
                    }
                };
            }
            if (Set.class.isAssignableFrom(cls)) {
                return new ObjectConstructor<T>() {
                    public T construct() {
                        return new LinkedHashSet();
                    }
                };
            }
            if (Queue.class.isAssignableFrom(cls)) {
                return new ObjectConstructor<T>() {
                    public T construct() {
                        return new ArrayDeque();
                    }
                };
            }
            return new ObjectConstructor<T>() {
                public T construct() {
                    return new ArrayList();
                }
            };
        } else if (!Map.class.isAssignableFrom(cls)) {
            return null;
        } else {
            if (ConcurrentNavigableMap.class.isAssignableFrom(cls)) {
                return new ObjectConstructor<T>() {
                    public T construct() {
                        return new ConcurrentSkipListMap();
                    }
                };
            }
            if (ConcurrentMap.class.isAssignableFrom(cls)) {
                return new ObjectConstructor<T>() {
                    public T construct() {
                        return new ConcurrentHashMap();
                    }
                };
            }
            if (SortedMap.class.isAssignableFrom(cls)) {
                return new ObjectConstructor<T>() {
                    public T construct() {
                        return new TreeMap();
                    }
                };
            }
            if (!(type instanceof ParameterizedType) || String.class.isAssignableFrom(TypeToken.get(((ParameterizedType) type).getActualTypeArguments()[0]).getRawType())) {
                return new ObjectConstructor<T>() {
                    public T construct() {
                        return new LinkedTreeMap();
                    }
                };
            }
            return new ObjectConstructor<T>() {
                public T construct() {
                    return new LinkedHashMap();
                }
            };
        }
    }

    private <T> ObjectConstructor<T> newUnsafeAllocator(final Class<? super T> cls) {
        if (this.useJdkUnsafe) {
            return new ObjectConstructor<T>() {
                public T construct() {
                    try {
                        return UnsafeAllocator.INSTANCE.newInstance(cls);
                    } catch (Exception e) {
                        throw new RuntimeException("Unable to create instance of " + cls + ". Registering an InstanceCreator or a TypeAdapter for this type, or adding a no-args constructor may fix this problem.", e);
                    }
                }
            };
        }
        final String str = "Unable to create instance of " + cls + "; usage of JDK Unsafe is disabled. Registering an InstanceCreator or a TypeAdapter for this type, adding a no-args constructor, or enabling usage of JDK Unsafe may fix this problem.";
        return new ObjectConstructor<T>() {
            public T construct() {
                throw new JsonIOException(str);
            }
        };
    }

    public String toString() {
        return this.instanceCreators.toString();
    }
}
