package com.macdmr.radio;

import android.app.Activity;
import android.content.Intent;
import android.net.Uri;
import android.os.Bundle;
import android.widget.Toast;

import java.io.File;
import java.io.FileOutputStream;
import java.nio.charset.StandardCharsets;
import java.util.ArrayList;

/**
 * Share target and file opener for shared channels: text with an SDCP1 code (from any app), a SignalDeck file or a
 * CHIRP CSV. No screen of its own: it reads what arrived, keeps it in the cache and hands it to {@link MainActivity},
 * which shows the import preview. Nothing is imported without the owner ticking it there.
 */
public class ImportCodeplugActivity extends Activity {
    @Override protected void onCreate(Bundle b) {
        super.onCreate(b);
        Intent in = getIntent();
        new Thread(() -> {
            String text = null, name = null;
            try {
                if (in != null) {
                    ArrayList<Uri> uris = new ArrayList<>();
                    if (Intent.ACTION_VIEW.equals(in.getAction()) && in.getData() != null) uris.add(in.getData());
                    Uri one = in.getParcelableExtra(Intent.EXTRA_STREAM); if (one != null) uris.add(one);
                    ArrayList<Uri> many = in.getParcelableArrayListExtra(Intent.EXTRA_STREAM); if (many != null) uris.addAll(many);
                    for (Uri u : uris) {                                   // a SignalDeck file first, then a CHIRP CSV
                        String t = com.macdmr.radio.ui.CodeplugDialog.read(this, u);
                        if (Codeplug.read(t, null) != null) { text = t; name = com.macdmr.radio.ui.CodeplugDialog.displayName(this, u); if (Codeplug.fromCode(t) != null) break; }
                    }
                    if (text == null) { CharSequence t = in.getCharSequenceExtra(Intent.EXTRA_TEXT); if (t != null && Codeplug.read(t.toString(), null) != null) text = t.toString(); }
                }
            } catch (Throwable ignored) { }
            final String fText = text, fName = name;
            runOnUiThread(() -> {
                if (fText == null) Toast.makeText(this, "No SignalDeck channels or CHIRP CSV in what was shared", Toast.LENGTH_LONG).show();
                else {
                    try {
                        File f = new File(getCacheDir(), "incoming_codeplug.txt");
                        try (FileOutputStream o = new FileOutputStream(f)) { o.write(fText.getBytes(StandardCharsets.UTF_8)); }
                        startActivity(new Intent(this, MainActivity.class).addFlags(Intent.FLAG_ACTIVITY_NEW_TASK | Intent.FLAG_ACTIVITY_CLEAR_TOP | Intent.FLAG_ACTIVITY_SINGLE_TOP)
                                .putExtra(MainActivity.EXTRA_CODEPLUG, true).putExtra(MainActivity.EXTRA_CODEPLUG_NAME, fName));
                    } catch (Throwable t) { Toast.makeText(this, "Could not open it: " + t.getMessage(), Toast.LENGTH_LONG).show(); }
                }
                finish();
            });
        }, "codeplug-import").start();
    }
}
