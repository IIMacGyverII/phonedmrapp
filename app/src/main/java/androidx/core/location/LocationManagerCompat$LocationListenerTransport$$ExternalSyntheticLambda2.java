package androidx.core.location;

import androidx.core.location.LocationManagerCompat;
import java.util.List;

/* compiled from: R8$$SyntheticClass */
public final /* synthetic */ class LocationManagerCompat$LocationListenerTransport$$ExternalSyntheticLambda2 implements Runnable {
    public final /* synthetic */ LocationManagerCompat.LocationListenerTransport f$0;
    public final /* synthetic */ List f$1;

    public /* synthetic */ LocationManagerCompat$LocationListenerTransport$$ExternalSyntheticLambda2(LocationManagerCompat.LocationListenerTransport locationListenerTransport, List list) {
        this.f$0 = locationListenerTransport;
        this.f$1 = list;
    }

    public final void run() {
        this.f$0.lambda$onLocationChanged$1(this.f$1);
    }
}
