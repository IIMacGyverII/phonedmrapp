package com.dmrmod.hooks;

import android.app.Activity;
import android.app.AlertDialog;
import android.content.Context;
import android.content.SharedPreferences;
import android.database.Cursor;
import android.database.sqlite.SQLiteDatabase;
import android.database.sqlite.SQLiteOpenHelper;
import android.net.ConnectivityManager;
import android.net.NetworkCapabilities;
import android.os.Environment;
import android.os.Handler;
import android.os.Looper;
import android.util.Log;
import android.widget.ArrayAdapter;
import android.widget.Toast;

import java.io.BufferedInputStream;
import java.io.BufferedReader;
import java.io.File;
import java.io.FileInputStream;
import java.io.FileOutputStream;
import java.io.InputStream;
import java.io.InputStreamReader;
import java.net.HttpURLConnection;
import java.net.URL;
import java.nio.charset.StandardCharsets;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Collections;
import java.util.Date;
import java.util.List;
import java.util.Locale;

/**
 * Offline global DMR ID lookup database (separate from OEM contact_database).
 *
 * Data source: RadioID.net user.csv (or compatible CSV placed in Download/DMR/RadioID/).
 * Personal codeplug contacts are always checked first in MainHook.lookupContactName().
 */
public class RadioidDatabase extends SQLiteOpenHelper {

    private static final String TAG = "DMRModHooks_RadioID";

    public static final String DATABASE_NAME = "dmrmod_radioid.db";
    private static final int DATABASE_VERSION = 2;
    private static final String PREFS_NAME = "dmrmod_radioid_prefs";
    private static final String PREF_LAST_SYNC = "last_sync_ms";
    private static final String PREF_ENTRY_COUNT = "entry_count";
    private static final String PREF_SOURCE_FILE = "source_file";

    public static final String DOWNLOAD_URL = "https://www.radioid.net/static/user.csv";
    public static final String RADIOID_SUBDIR = "DMR/RadioID";
    public static final String DEFAULT_CSV_NAME = "user.csv";

    private static final String TABLE_USERS = "radioid_users";
    private static final String COL_DMR_ID = "dmr_id";
    private static final String COL_CALLSIGN = "callsign";
    private static final String COL_FIRST_NAME = "first_name";
    private static final String COL_LAST_NAME = "last_name";
    private static final String COL_CITY = "city";
    private static final String COL_STATE = "state";
    private static final String COL_COUNTRY = "country";
    private static final String COL_DISPLAY_NAME = "display_name";

    private static final int CONNECT_TIMEOUT_MS = 30000;
    private static final int READ_TIMEOUT_MS = 120000;

    private static RadioidDatabase instance;

    private RadioidDatabase(Context context) {
        super(context.getApplicationContext(), DATABASE_NAME, null, DATABASE_VERSION);
    }

    public static synchronized RadioidDatabase getInstance(Context context) {
        if (instance == null) {
            instance = new RadioidDatabase(context.getApplicationContext());
        }
        return instance;
    }

    @Override
    public void onCreate(SQLiteDatabase db) {
        db.execSQL(
            "CREATE TABLE " + TABLE_USERS + " (" +
            COL_DMR_ID + " INTEGER PRIMARY KEY, " +
            COL_CALLSIGN + " TEXT, " +
            COL_FIRST_NAME + " TEXT, " +
            COL_LAST_NAME + " TEXT, " +
            COL_CITY + " TEXT, " +
            COL_STATE + " TEXT, " +
            COL_COUNTRY + " TEXT, " +
            COL_DISPLAY_NAME + " TEXT NOT NULL)"
        );
    }

    @Override
    public void onUpgrade(SQLiteDatabase db, int oldVersion, int newVersion) {
        if (oldVersion < 2) {
            db.execSQL("ALTER TABLE " + TABLE_USERS + " ADD COLUMN " + COL_CITY + " TEXT DEFAULT ''");
            db.execSQL("ALTER TABLE " + TABLE_USERS + " ADD COLUMN " + COL_STATE + " TEXT DEFAULT ''");
            db.execSQL("ALTER TABLE " + TABLE_USERS + " ADD COLUMN " + COL_COUNTRY + " TEXT DEFAULT ''");
        }
    }

    /** Full RadioID row for caller detail UI. */
    public static class CallerRecord {
        public int dmrId;
        public String callsign;
        public String firstName;
        public String lastName;
        public String city;
        public String state;
        public String country;
        public String displayName;

        public String combinedName() {
            StringBuilder sb = new StringBuilder();
            if (firstName != null && !firstName.trim().isEmpty()) {
                sb.append(firstName.trim());
            }
            if (lastName != null && !lastName.trim().isEmpty()) {
                if (sb.length() > 0) sb.append(' ');
                sb.append(lastName.trim());
            }
            return sb.toString();
        }
    }

    // =====================================================================
    //  Lookup
    // =====================================================================

    /**
     * Resolve a DMR ID to a display name from the global cache.
     * Returns null if not found or DB is empty.
     */
    public String lookupDisplayName(int dmrId) {
        CallerRecord record = lookupRecord(dmrId);
        if (record == null || record.displayName == null || record.displayName.trim().isEmpty()) {
            return null;
        }
        return record.displayName.trim();
    }

    public CallerRecord lookupRecord(int dmrId) {
        if (dmrId <= 0 || dmrId >= 16777215) {
            return null;
        }
        Cursor cursor = null;
        try {
            SQLiteDatabase db = getReadableDatabase();
            cursor = db.query(
                TABLE_USERS,
                new String[]{
                    COL_DMR_ID, COL_CALLSIGN, COL_FIRST_NAME, COL_LAST_NAME,
                    COL_CITY, COL_STATE, COL_COUNTRY, COL_DISPLAY_NAME
                },
                COL_DMR_ID + " = ?",
                new String[]{String.valueOf(dmrId)},
                null, null, null
            );
            if (cursor != null && cursor.moveToFirst()) {
                CallerRecord record = new CallerRecord();
                record.dmrId = cursor.getInt(0);
                record.callsign = cursor.getString(1);
                record.firstName = cursor.getString(2);
                record.lastName = cursor.getString(3);
                record.city = cursor.getString(4);
                record.state = cursor.getString(5);
                record.country = cursor.getString(6);
                record.displayName = cursor.getString(7);
                return record;
            }
        } catch (Exception e) {
            Log.e(TAG, "Record lookup failed for ID " + dmrId + ": " + e.getMessage());
        } finally {
            if (cursor != null) {
                try { cursor.close(); } catch (Exception ignored) {}
            }
        }
        return null;
    }

    public int getEntryCount(Context context) {
        SharedPreferences prefs = context.getApplicationContext()
            .getSharedPreferences(PREFS_NAME, Context.MODE_PRIVATE);
        return prefs.getInt(PREF_ENTRY_COUNT, 0);
    }

    /**
     * True if imported rows include city/state/country (full user.csv schema).
     * Older imports only stored callsign + name.
     */
    public boolean hasLocationData() {
        Cursor cursor = null;
        try {
            SQLiteDatabase db = getReadableDatabase();
            cursor = db.rawQuery(
                "SELECT 1 FROM " + TABLE_USERS +
                " WHERE " + COL_CITY + " IS NOT NULL AND TRIM(" + COL_CITY + ") != '' LIMIT 1",
                null
            );
            return cursor != null && cursor.moveToFirst();
        } catch (Exception e) {
            Log.e(TAG, "hasLocationData check failed: " + e.getMessage());
            return false;
        } finally {
            if (cursor != null) {
                try { cursor.close(); } catch (Exception ignored) {}
            }
        }
    }

    public String getStatusSummary(Context context) {
        SharedPreferences prefs = context.getApplicationContext()
            .getSharedPreferences(PREFS_NAME, Context.MODE_PRIVATE);
        int count = prefs.getInt(PREF_ENTRY_COUNT, 0);
        long lastSync = prefs.getLong(PREF_LAST_SYNC, 0);
        String source = prefs.getString(PREF_SOURCE_FILE, "");
        if (count == 0) {
            return "Global DMR ID database: not loaded\nSource: radioid.net/static/user.csv";
        }
        String when = "unknown";
        if (lastSync > 0) {
            when = new SimpleDateFormat("yyyy-MM-dd HH:mm", Locale.US).format(new Date(lastSync));
        }
        String src = (source == null || source.isEmpty()) ? "user.csv" : source;
        StringBuilder sb = new StringBuilder();
        sb.append(count).append(" global IDs loaded");
        if (!hasLocationData()) {
            sb.append("\n⚠ Names only — Download again for city/state/country");
        } else {
            sb.append(" (full location data)");
        }
        sb.append("\nLast update: ").append(when);
        sb.append("\nSource: radioid.net/").append(src);
        return sb.toString();
    }

    // =====================================================================
    //  Download + import UI entry points
    // =====================================================================

    public static void downloadAndImport(final Context context, final String userAgent) {
        downloadAndImport(context, userAgent, null);
    }

    public static void downloadAndImport(final Context context, final String userAgent,
                                         final Runnable onComplete) {
        new Thread(() -> {
            if (!isNetworkAvailable(context)) {
                showToast(context, "No network connection");
                return;
            }
            ProgressDialogHolder progress = ProgressDialogHolder.show(context, "Downloading RadioID database…");
            try {
                File dir = getRadioIdDir();
                if (!dir.exists() && !dir.mkdirs()) {
                    throw new Exception("Could not create " + dir.getAbsolutePath());
                }
                File outFile = new File(dir, DEFAULT_CSV_NAME);
                progress.update("Downloading from radioid.net…");
                downloadCsv(DOWNLOAD_URL, outFile, userAgent, progress);
                progress.update("Importing " + outFile.getName() + "…");
                ImportResult result = getInstance(context).importFromCsvFile(context, outFile, progress);
                progress.dismiss();
                if (result.success) {
                    String locNote = getInstance(context).hasLocationData()
                        ? " (with location)" : "";
                    showToast(context, "✓ RadioID DB loaded: " + result.imported + " IDs" + locNote);
                } else {
                    showToast(context, "❌ Import failed: " + result.error);
                }
                runOnComplete(onComplete);
            } catch (Exception e) {
                progress.dismiss();
                Log.e(TAG, "Download/import failed: " + e.getMessage(), e);
                showToast(context, "❌ Download failed: " + e.getMessage());
                runOnComplete(onComplete);
            }
        }).start();
    }

    public static void showImportDialog(final Context context) {
        showImportDialog(context, null);
    }

    public static void showImportDialog(final Context context, final Runnable onComplete) {
        new Thread(() -> {
            try {
                File dir = getRadioIdDir();
                if (!dir.exists()) {
                    dir.mkdirs();
                }
                File[] files = dir.listFiles();
                List<String> csvNames = new ArrayList<>();
                if (files != null) {
                    for (File f : files) {
                        if (f.isFile() && f.getName().toLowerCase(Locale.US).endsWith(".csv")) {
                            csvNames.add(f.getName());
                        }
                    }
                }
                Collections.sort(csvNames, Collections.reverseOrder());

                if (csvNames.isEmpty()) {
                    showToast(context,
                        "No CSV in Download/" + RADIOID_SUBDIR + "/\n" +
                        "Copy user.csv there or use Download button.");
                    return;
                }

                final String[] choices = csvNames.toArray(new String[0]);
                if (!(context instanceof Activity)) {
                    showToast(context, "Cannot show import dialog — no activity");
                    return;
                }
                final Activity activity = (Activity) context;
                mainHandler().post(() -> {
                    if (activity.isFinishing() || activity.isDestroyed()) {
                        return;
                    }
                    AlertDialog.Builder builder = new AlertDialog.Builder(activity);
                    builder.setTitle("Import RadioID CSV");
                    builder.setMessage(
                        "Files in Download/" + RADIOID_SUBDIR + "/\n\n" +
                        getInstance(context).getStatusSummary(context));
                    ArrayAdapter<String> adapter = new ArrayAdapter<>(
                        context, android.R.layout.select_dialog_singlechoice, choices);
                    final int[] selected = {0};
                    builder.setSingleChoiceItems(adapter, 0, (dialog, which) -> selected[0] = which);
                    builder.setPositiveButton("Import", (dialog, which) -> {
                        File csvFile = new File(getRadioIdDir(), choices[selected[0]]);
                        importCsvInBackground(context, csvFile, onComplete);
                    });
                    builder.setNegativeButton("Cancel", null);
                    builder.show();
                });
            } catch (Exception e) {
                Log.e(TAG, "Import dialog error: " + e.getMessage(), e);
                showToast(context, "Error: " + e.getMessage());
            }
        }).start();
    }

    private static void importCsvInBackground(final Context context, final File csvFile,
                                             final Runnable onComplete) {
        new Thread(() -> {
            ProgressDialogHolder progress = ProgressDialogHolder.show(
                context, "Importing " + csvFile.getName() + "…");
            try {
                ImportResult result = getInstance(context).importFromCsvFile(context, csvFile, progress);
                progress.dismiss();
                if (result.success) {
                    showToast(context, "✓ Imported " + result.imported + " global DMR IDs");
                } else {
                    showToast(context, "❌ Import failed: " + result.error);
                }
                runOnComplete(onComplete);
            } catch (Exception e) {
                progress.dismiss();
                showToast(context, "❌ Import failed: " + e.getMessage());
                runOnComplete(onComplete);
            }
        }).start();
    }

    private static void runOnComplete(Runnable onComplete) {
        if (onComplete != null) {
            mainHandler().post(onComplete);
        }
    }

    // =====================================================================
    //  CSV import
    // =====================================================================

    public static class ImportResult {
        public boolean success;
        public int imported;
        public int skipped;
        public String error;
    }

    private ImportResult importFromCsvFile(Context context, File csvFile,
                                           ProgressDialogHolder progress) {
        ImportResult result = new ImportResult();
        BufferedReader reader = null;
        SQLiteDatabase db = null;
        try {
            if (csvFile == null || !csvFile.exists()) {
                result.error = "File not found";
                return result;
            }
            reader = openCsvReader(csvFile);
            String headerLine = reader.readLine();
            if (headerLine == null) {
                result.error = "Empty file";
                return result;
            }
            headerLine = stripBom(headerLine);
            CsvFormat format = detectFormat(headerLine);
            if (format == CsvFormat.UNKNOWN) {
                result.error = "Unrecognized CSV format";
                return result;
            }
            db = getWritableDatabase();
            db.beginTransaction();
            db.delete(TABLE_USERS, null, null);

            String sql = "INSERT OR REPLACE INTO " + TABLE_USERS + " (" +
                COL_DMR_ID + "," + COL_CALLSIGN + "," + COL_FIRST_NAME + "," +
                COL_LAST_NAME + "," + COL_CITY + "," + COL_STATE + "," + COL_COUNTRY + "," +
                COL_DISPLAY_NAME + ") VALUES (?,?,?,?,?,?,?,?)";

            android.database.sqlite.SQLiteStatement stmt = db.compileStatement(sql);
            int imported = 0;
            int skipped = 0;
            int lineNum = 0;

            String line = (format == CsvFormat.RADIOID_HEADER) ? reader.readLine() : headerLine;
            while (line != null) {
                lineNum++;
                if (lineNum % 20000 == 0 && progress != null) {
                    progress.update("Importing… " + imported + " IDs");
                }
                Row row = parseLine(line, format);
                if (row == null) {
                    skipped++;
                } else {
                    bindRow(stmt, row);
                    stmt.executeInsert();
                    imported++;
                }
                line = reader.readLine();
            }

            db.setTransactionSuccessful();
            result.success = true;
            result.imported = imported;
            result.skipped = skipped;

            SharedPreferences prefs = context.getApplicationContext()
                .getSharedPreferences(PREFS_NAME, Context.MODE_PRIVATE);
            prefs.edit()
                .putInt(PREF_ENTRY_COUNT, imported)
                .putLong(PREF_LAST_SYNC, System.currentTimeMillis())
                .putString(PREF_SOURCE_FILE, csvFile.getName())
                .apply();

            Log.i(TAG, "Import complete: " + imported + " imported, " + skipped + " skipped from "
                + csvFile.getName());
        } catch (Exception e) {
            result.success = false;
            result.error = e.getMessage();
            Log.e(TAG, "CSV import error: " + e.getMessage(), e);
        } finally {
            if (db != null) {
                try {
                    db.endTransaction();
                } catch (Exception ignored) {}
            }
            if (reader != null) {
                try { reader.close(); } catch (Exception ignored) {}
            }
        }
        return result;
    }

    private void bindRow(android.database.sqlite.SQLiteStatement stmt, Row row) {
        stmt.bindLong(1, row.dmrId);
        stmt.bindString(2, row.callsign != null ? row.callsign : "");
        stmt.bindString(3, row.firstName != null ? row.firstName : "");
        stmt.bindString(4, row.lastName != null ? row.lastName : "");
        stmt.bindString(5, row.city != null ? row.city : "");
        stmt.bindString(6, row.state != null ? row.state : "");
        stmt.bindString(7, row.country != null ? row.country : "");
        stmt.bindString(8, row.displayName);
    }

    private enum CsvFormat {
        RADIOID_HEADER,
        RADIOID_NO_HEADER,
        DMR_DATABASE,
        QUOTED_THREE_COL,
        UNKNOWN
    }

    private static class Row {
        int dmrId;
        String callsign;
        String firstName;
        String lastName;
        String city;
        String state;
        String country;
        String displayName;
    }

    private CsvFormat detectFormat(String headerLine) {
        String upper = headerLine.toUpperCase(Locale.US);
        if (upper.contains("RADIO_ID") && upper.contains("CALLSIGN")) {
            return CsvFormat.RADIOID_HEADER;
        }
        if (headerLine.startsWith("Private Call,") || headerLine.startsWith("\"Private Call\"")) {
            return CsvFormat.DMR_DATABASE;
        }
        String[] fields = splitCsvLine(headerLine);
        if (fields.length >= 3 && looksLikeQuotedId(fields[0])) {
            return CsvFormat.QUOTED_THREE_COL;
        }
        if (fields.length >= 2) {
            try {
                Integer.parseInt(fields[0].trim().replace("\"", ""));
                return CsvFormat.RADIOID_NO_HEADER;
            } catch (NumberFormatException ignored) {}
        }
        return CsvFormat.UNKNOWN;
    }

    private boolean looksLikeQuotedId(String field) {
        String t = field.trim().replace("\"", "");
        try {
            int id = Integer.parseInt(t);
            return id > 0 && id < 16777215;
        } catch (NumberFormatException e) {
            return false;
        }
    }

    private Row parseLine(String line, CsvFormat format) {
        if (line == null || line.trim().isEmpty()) {
            return null;
        }
        String[] fields = splitCsvLine(line);
        try {
            switch (format) {
                case RADIOID_HEADER:
                case RADIOID_NO_HEADER: {
                    if (format == CsvFormat.RADIOID_HEADER) {
                        // skip accidental re-read of header
                        if (fields.length > 0 && fields[0].toUpperCase(Locale.US).contains("RADIO")) {
                            return null;
                        }
                    }
                    if (fields.length < 2) return null;
                    int id = Integer.parseInt(fields[0].trim().replace("\"", ""));
                    String callsign = clean(fields[1]);
                    String first = fields.length > 2 ? clean(fields[2]) : "";
                    String last = fields.length > 3 ? clean(fields[3]) : "";
                    String city = fields.length > 4 ? clean(fields[4]) : "";
                    String state = fields.length > 5 ? clean(fields[5]) : "";
                    String country = fields.length > 6 ? clean(fields[6]) : "";
                    return buildRow(id, callsign, first, last, city, state, country);
                }
                case DMR_DATABASE: {
                    if (fields.length < 6) return null;
                    int id = Integer.parseInt(fields[fields.length - 1].trim().replace("\"", ""));
                    String callField = clean(fields[1]);
                    String callsign = callField;
                    int spaceIdx = callField.lastIndexOf(' ');
                    if (spaceIdx > 0) {
                        String tail = callField.substring(spaceIdx + 1).trim();
                        try {
                            if (Integer.parseInt(tail) == id) {
                                callsign = callField.substring(0, spaceIdx).trim();
                            }
                        } catch (NumberFormatException ignored) {}
                    }
                    String first = clean(fields[2]);
                    String city = fields.length > 3 ? clean(fields[3]) : "";
                    return buildRow(id, callsign, first, "", city, "", "");
                }
                case QUOTED_THREE_COL: {
                    if (fields.length < 3) return null;
                    int id = Integer.parseInt(fields[0].trim().replace("\"", ""));
                    String callsign = clean(fields[1]);
                    String name = fields.length > 2 ? clean(fields[2]) : "";
                    return buildRow(id, callsign, name, "", "", "", "");
                }
                default:
                    return null;
            }
        } catch (Exception e) {
            return null;
        }
    }

    private Row buildRow(int id, String callsign, String firstName, String lastName,
                         String city, String state, String country) {
        if (id <= 0 || id >= 16777215) {
            return null;
        }
        Row row = new Row();
        row.dmrId = id;
        row.callsign = callsign != null ? callsign : "";
        row.firstName = firstName != null ? firstName : "";
        row.lastName = lastName != null ? lastName : "";
        row.city = city != null ? city : "";
        row.state = state != null ? state : "";
        row.country = country != null ? country : "";
        row.displayName = formatDisplayName(row.callsign, row.firstName, row.lastName);
        if (row.displayName.isEmpty()) {
            return null;
        }
        return row;
    }

    static String formatDisplayName(String callsign, String firstName, String lastName) {
        String call = callsign != null ? callsign.trim() : "";
        StringBuilder namePart = new StringBuilder();
        if (firstName != null && !firstName.trim().isEmpty()) {
            namePart.append(firstName.trim());
        }
        if (lastName != null && !lastName.trim().isEmpty()) {
            if (namePart.length() > 0) namePart.append(' ');
            namePart.append(lastName.trim());
        }
        if (!call.isEmpty() && namePart.length() > 0) {
            return call + " " + namePart;
        }
        if (!call.isEmpty()) {
            return call;
        }
        return namePart.toString().trim();
    }

    private static String clean(String s) {
        if (s == null) return "";
        return s.trim().replace("\"", "");
    }

    private static String stripBom(String line) {
        if (line != null && !line.isEmpty() && line.charAt(0) == '\uFEFF') {
            return line.substring(1);
        }
        return line;
    }

    private static BufferedReader openCsvReader(File file) throws Exception {
        InputStream in = new BufferedInputStream(new FileInputStream(file));
        return new BufferedReader(new InputStreamReader(in, StandardCharsets.UTF_8));
    }

    /** Simple CSV splitter — handles quoted fields with commas. */
    static String[] splitCsvLine(String line) {
        List<String> fields = new ArrayList<>();
        StringBuilder current = new StringBuilder();
        boolean inQuotes = false;
        for (int i = 0; i < line.length(); i++) {
            char c = line.charAt(i);
            if (c == '"') {
                inQuotes = !inQuotes;
            } else if (c == ',' && !inQuotes) {
                fields.add(current.toString());
                current.setLength(0);
            } else {
                current.append(c);
            }
        }
        fields.add(current.toString());
        return fields.toArray(new String[0]);
    }

    // =====================================================================
    //  Download
    // =====================================================================

    private static void downloadCsv(String urlString, File outFile, String userAgent,
                                    ProgressDialogHolder progress) throws Exception {
        HttpURLConnection connection = null;
        InputStream in = null;
        FileOutputStream out = null;
        try {
            URL url = new URL(urlString);
            connection = (HttpURLConnection) url.openConnection();
            connection.setRequestMethod("GET");
            connection.setConnectTimeout(CONNECT_TIMEOUT_MS);
            connection.setReadTimeout(READ_TIMEOUT_MS);
            connection.setRequestProperty("User-Agent", userAgent);
            connection.setRequestProperty("Accept", "text/csv,*/*");

            int code = connection.getResponseCode();
            if (code != HttpURLConnection.HTTP_OK) {
                throw new Exception("HTTP " + code);
            }

            int total = connection.getContentLength();
            in = new BufferedInputStream(connection.getInputStream());
            out = new FileOutputStream(outFile);
            byte[] buffer = new byte[8192];
            int read;
            int downloaded = 0;
            while ((read = in.read(buffer)) != -1) {
                out.write(buffer, 0, read);
                downloaded += read;
                if (total > 0 && progress != null && downloaded % (256 * 1024) < 8192) {
                    int pct = (int) ((downloaded * 100L) / total);
                    progress.update("Downloading… " + pct + "%");
                }
            }
            out.flush();
            Log.i(TAG, "Downloaded " + downloaded + " bytes to " + outFile.getAbsolutePath());
        } finally {
            if (out != null) {
                try { out.close(); } catch (Exception ignored) {}
            }
            if (in != null) {
                try { in.close(); } catch (Exception ignored) {}
            }
            if (connection != null) {
                connection.disconnect();
            }
        }
    }

    public static File getRadioIdDir() {
        File downloadDir = Environment.getExternalStoragePublicDirectory(Environment.DIRECTORY_DOWNLOADS);
        return new File(downloadDir, RADIOID_SUBDIR);
    }

    private static boolean isNetworkAvailable(Context context) {
        try {
            ConnectivityManager cm = (ConnectivityManager)
                context.getSystemService(Context.CONNECTIVITY_SERVICE);
            if (cm == null) return false;
            android.net.Network network = cm.getActiveNetwork();
            if (network == null) return false;
            NetworkCapabilities caps = cm.getNetworkCapabilities(network);
            return caps != null && (
                caps.hasTransport(NetworkCapabilities.TRANSPORT_WIFI) ||
                caps.hasTransport(NetworkCapabilities.TRANSPORT_CELLULAR) ||
                caps.hasTransport(NetworkCapabilities.TRANSPORT_ETHERNET));
        } catch (Exception e) {
            return true; // optimistic if check fails
        }
    }

    // =====================================================================
    //  UI helpers
    // =====================================================================

    private static void showToast(Context context, final String message) {
        if (context == null || message == null) {
            return;
        }
        Context toastContext = context.getApplicationContext();
        mainHandler().post(() ->
            Toast.makeText(toastContext, message, Toast.LENGTH_LONG).show());
    }

    private static Handler mainHandler() {
        return new Handler(Looper.getMainLooper());
    }

    private static class ProgressDialogHolder {
        private AlertDialog dialog;
        private final Activity activity;
        private final boolean dialogEnabled;

        static ProgressDialogHolder show(Context context, String message) {
            Activity activity = context instanceof Activity ? (Activity) context : null;
            ProgressDialogHolder holder = new ProgressDialogHolder(activity);
            holder.showInternal(message);
            return holder;
        }

        private ProgressDialogHolder(Activity activity) {
            this.activity = activity;
            this.dialogEnabled = activity != null && !activity.isFinishing()
                && !activity.isDestroyed();
        }

        private void showInternal(String message) {
            if (!dialogEnabled) {
                showToast(activity != null ? activity : null, message);
                return;
            }
            activity.runOnUiThread(() -> {
                if (!canShowDialog()) {
                    return;
                }
                try {
                    AlertDialog.Builder builder = new AlertDialog.Builder(activity);
                    builder.setTitle("RadioID Database");
                    builder.setMessage(message);
                    builder.setCancelable(false);
                    dialog = builder.create();
                    dialog.show();
                } catch (Exception e) {
                    Log.e(TAG, "Could not show progress dialog: " + e.getMessage());
                    dialog = null;
                }
            });
        }

        void update(final String message) {
            if (!dialogEnabled || dialog == null) {
                if (activity != null) {
                    showToast(activity, message);
                }
                return;
            }
            activity.runOnUiThread(() -> {
                try {
                    if (dialog != null && dialog.isShowing()) {
                        dialog.setMessage(message);
                    }
                } catch (Exception e) {
                    Log.e(TAG, "Progress update failed: " + e.getMessage());
                }
            });
        }

        void dismiss() {
            if (!dialogEnabled || dialog == null) {
                return;
            }
            activity.runOnUiThread(() -> {
                try {
                    if (dialog != null && dialog.isShowing()) {
                        dialog.dismiss();
                    }
                } catch (Exception e) {
                    Log.e(TAG, "Progress dismiss failed: " + e.getMessage());
                }
                dialog = null;
            });
        }

        private boolean canShowDialog() {
            return activity != null && !activity.isFinishing() && !activity.isDestroyed();
        }
    }
}