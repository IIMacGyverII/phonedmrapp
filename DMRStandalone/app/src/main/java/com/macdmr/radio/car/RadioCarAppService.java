package com.macdmr.radio.car;

import android.content.Intent;

import androidx.annotation.NonNull;
import androidx.car.app.CarAppService;
import androidx.car.app.Screen;
import androidx.car.app.Session;
import androidx.car.app.validation.HostValidator;

/**
 * "Radio controls" on the car screen: the radio's own Android Auto screen beside its media app, with a big Talk
 * button (Android Auto gives media apps only small buttons). A personal, side-loaded app: any host is accepted.
 */
public class RadioCarAppService extends CarAppService {
    @NonNull @Override public HostValidator createHostValidator() { return HostValidator.ALLOW_ALL_HOSTS_VALIDATOR; }

    @NonNull @Override public Session onCreateSession() {
        return new Session() {
            @NonNull @Override public Screen onCreateScreen(@NonNull Intent intent) {
                com.macdmr.radio.RadioService rs = com.macdmr.radio.RadioService.running;
                if (rs != null) rs.carEvent("🚗 Android Auto opened Radio controls");
                return new RadioControlScreen(getCarContext());
            }
        };
    }
}
