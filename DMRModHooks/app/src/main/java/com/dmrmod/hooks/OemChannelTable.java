package com.dmrmod.hooks;

import android.content.Context;
import android.content.SharedPreferences;

/**
 * Resolves the OEM channel table that is currently selected in the PriInterPhone app.
 *
 * The OEM keeps one SQLite file per channel "area": {@code database_<areaKey>.db}, with a table of
 * the same name ({@code DBChannelHelper}: {@code "database_" + areaKey}). A stock UV module has 14
 * areas ({@code channel_area_default_uhf}, {@code channel_area_default_vhf}, 12 regional ones) and
 * the user can add more. Which one is live is stored in the OEM's own SharedPreferences
 * ({@code Constants.getSelectedChannelArea}). Because the module runs inside the OEM process, the
 * hooked app's {@link Context} reads those prefs directly.
 *
 * Before v3.4.7 every backup/export/import/PDF/dump path hard-coded
 * {@code database_channel_area_default_uhf}, so users on any other area silently exported and
 * restored the wrong codeplug. All of those paths now go through this helper.
 */
final class OemChannelTable {

    /** OEM prefs file ({@code PersonSharePrefData.PREF_PERSON_DATA}). */
    static final String OEM_PREFS = "com.pri.prizeinterphone.data.person";
    /** OEM key holding the selected area ({@code Constants.getSelectedChannelArea}). */
    static final String KEY_SELECTED_AREA = "pref_person_channel_area_selected_index";
    /** OEM key holding the module version string, e.g. {@code DMR003.UV4T.V022}. */
    static final String KEY_MODULE_VERSION = "pref_person_device_dmr_version";
    static final String DEFAULT_MODULE_VERSION = "DMR003.UV4T.V022";

    static final String AREA_DEFAULT_UHF = "channel_area_default_uhf";
    static final String AREA_DEFAULT = "channel_area_default";

    private OemChannelTable() {}

    /**
     * The area key the OEM app is currently using, e.g. {@code channel_area_default_uhf}.
     * Mirrors {@code Constants.getSelectedChannelArea()}: the saved pref, else the module's default
     * area, which is {@code channel_area_default_uhf} for a UV module and {@code channel_area_default}
     * for a single-band module ({@code Constants.KEY_DEF_AREA}).
     */
    static String areaKey(Context context) {
        try {
            SharedPreferences prefs = context.getSharedPreferences(OEM_PREFS, Context.MODE_PRIVATE);
            String selected = prefs.getString(KEY_SELECTED_AREA, null);
            if (selected != null && !selected.trim().isEmpty()) {
                return selected.trim();
            }
            return defaultAreaKey(prefs.getString(KEY_MODULE_VERSION, DEFAULT_MODULE_VERSION));
        } catch (Exception e) {
            return AREA_DEFAULT_UHF;
        }
    }

    /** {@code Constants.KEY_DEF_AREA} logic: UV modules default to the UHF area. */
    static String defaultAreaKey(String moduleVersion) {
        // DmrManager.getUVBandFromVersion(): split on '.', take [2] for 4 segments else [1]
        String band;
        try {
            String[] parts = moduleVersion.split("\\.");
            band = parts.length == 4 ? parts[2] : parts[1];
        } catch (Exception e) {
            band = "U";
        }
        return band.startsWith("UV") ? AREA_DEFAULT_UHF : AREA_DEFAULT;
    }

    /** SQLite table name for the selected area, e.g. {@code database_channel_area_default_uhf}. */
    static String tableName(Context context) {
        return "database_" + areaKey(context);
    }

    /** SQLite file name for the selected area, e.g. {@code database_channel_area_default_uhf.db}. */
    static String dbFileName(Context context) {
        return tableName(context) + ".db";
    }
}
