package com.macdmr.radio;

import android.app.Activity;
import android.content.Intent;
import android.os.Bundle;
import android.widget.Toast;

/**
 * Share target for maps apps: "Share" a place from Google Maps, Organic Maps, OsmAnd… to DMR Radio and its
 * coordinates go to the open channel editor (or to a channel you pick). No screen of its own: it resolves the
 * shared text (following short links), then hands the position to {@link MainActivity}.
 */
public class ShareLocationActivity extends Activity {
    @Override protected void onCreate(Bundle b) {
        super.onCreate(b);
        Intent in = getIntent();
        final String text = in == null ? null : (in.getStringExtra(Intent.EXTRA_TEXT) != null ? in.getStringExtra(Intent.EXTRA_TEXT) + " " + (in.getStringExtra(Intent.EXTRA_SUBJECT) == null ? "" : in.getStringExtra(Intent.EXTRA_SUBJECT)) : in.getDataString());
        new Thread(() -> {
            final double[] p = GeoLink.resolve(text);
            runOnUiThread(() -> {
                if (p == null) Toast.makeText(this, "No coordinates found in what was shared", Toast.LENGTH_LONG).show();
                else startActivity(new Intent(this, MainActivity.class).addFlags(Intent.FLAG_ACTIVITY_NEW_TASK | Intent.FLAG_ACTIVITY_CLEAR_TOP | Intent.FLAG_ACTIVITY_SINGLE_TOP)
                        .putExtra(MainActivity.EXTRA_LAT, p[0]).putExtra(MainActivity.EXTRA_LON, p[1]));
                finish();
            });
        }).start();
    }
}
