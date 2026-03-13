package com.dmrmod.hooks;

import android.app.ProgressDialog;
import android.content.Context;
import android.content.Intent;
import android.graphics.Color;
import android.os.AsyncTask;
import android.widget.Button;
import android.widget.LinearLayout;
import android.widget.TextView;
import android.widget.Toast;

import java.io.BufferedReader;
import java.io.File;
import java.io.FileInputStream;
import java.io.FileOutputStream;
import java.io.InputStream;
import java.io.InputStreamReader;

import de.robv.android.xposed.XposedBridge;

/**
 * One-Tap Patch Reload Helper
 * 
 * Provides user-friendly UI for reloading DMR firmware patch after device reboot.
 * 
 * Features:
 * - Single-button patch reload (embedded PATCH14.bin in APK assets)
 * - Real-time status indicator (Active/Lost)
 * - Progress dialog during reload (~2 minutes)
 * - Automatic cleanup and app restart
 * - Background patch monitoring
 * 
 * Usage:
 * 1. Place PATCH14.bin in app/src/main/assets/
 * 2. Call injectReloadButton(layout, context) in Information screen hook
 * 3. User taps button when patch status shows "Lost"
 * 
 * Workflow:
 * - Copy assets/PATCH14.bin → /sdcard/DMR/DMRDEBUG.bin
 * - Launch UpdateFirmwareActivity (triggers YModem)
 * - Monitor completion (~2 min)
 * - Auto-cleanup + force-stop + restart
 * - Update status indicator
 */
public class PatchReloadHelper {
    
    private static final String TAG = "DMRModHooks:PatchReload";
    private static final String SOURCE_PATH = "/sdcard/DMR/PATCH14_BACKUP.bin";  // Source firmware
    private static final String DEST_PATH = "/sdcard/DMR/DMRDEBUG.bin";  // Destination for update
    private static final String PACKAGE_NAME = "com.pri.prizeinterphone";
    private static final String UPDATE_ACTIVITY = PACKAGE_NAME + ".activity.UpdateFirmwareActivity";
    private static final String HOME_ACTIVITY = PACKAGE_NAME + ".InterPhoneHomeActivity";
    
    private static TextView statusIndicator = null;
    
    /**
     * Inject reload button and status indicator into UI
     * 
     * Call this from hookFragmentLocalInformationActivity() or similar.
     * 
     * @param parent Parent layout to add button to
     * @param context Application context
     */
    public static void injectReloadButton(LinearLayout parent, Context context) {
        try {
            // Create status indicator
            statusIndicator = new TextView(context);
            statusIndicator.setText("🔍 Checking patch status...");
            statusIndicator.setTextSize(14);
            statusIndicator.setPadding(20, 10, 20, 10);
            parent.addView(statusIndicator);
            
            // Update status asynchronously
            new CheckPatchStatusTask().execute(context);
            
            // Create reload button
            Button reloadBtn = new Button(context);
            reloadBtn.setText("🔧 Reload DMR Patch");
            reloadBtn.setBackgroundColor(Color.parseColor("#FF5722")); // Orange
            reloadBtn.setTextColor(Color.WHITE);
            reloadBtn.setAllCaps(false);
            reloadBtn.setPadding(20, 15, 20, 15);
            reloadBtn.setOnClickListener(v -> {
                XposedBridge.log(TAG + ": Reload button clicked");
                new ReloadPatchTask(context).execute();
            });
            
            parent.addView(reloadBtn);
            
            XposedBridge.log(TAG + ": Reload button injected successfully");
            
        } catch (Exception e) {
            XposedBridge.log(TAG + ": Failed to inject reload button: " + e.getMessage());
        }
    }
    
    /**
     * Update patch status indicator UI
     * 
     * @param loaded True if patch is loaded, false if lost
     */
    public static void updateStatusIndicator(boolean loaded) {
        if (statusIndicator != null) {
            if (loaded) {
                statusIndicator.setText("✓ Patch Status: Active");
                statusIndicator.setTextColor(Color.parseColor("#4CAF50")); // Green
            } else {
                statusIndicator.setText("⚠️ Patch Status: Lost - Reload Required");
                statusIndicator.setTextColor(Color.parseColor("#FF5722")); // Orange
            }
        }
    }
    
    /**
     * Check if patch is currently loaded by examining recent logs
     * 
     * Bug signature: txContact=1 or txContact=16777215 = patch lost
     * Expected with patch: txContact shows actual group IDs (e.g., 11904)
     * 
     * @return True if patch appears to be loaded
     */
    private static boolean isPatchLoaded() {
        try {
            // Read recent logcat for DigitalMessage entries
            Process process = Runtime.getRuntime().exec("logcat -d -t 50");
            BufferedReader reader = new BufferedReader(new InputStreamReader(process.getInputStream()));
            
            String line;
            int bugSignatureCount = 0;
            int validIdCount = 0;
            
            while ((line = reader.readLine()) != null) {
                if (line.contains("DigitalMessage") && line.contains("txContact=")) {
                    // Extract txContact value
                    int idx = line.indexOf("txContact=");
                    if (idx > 0) {
                        String substr = line.substring(idx + 10);
                        String valueStr = substr.split("[,\\s}]")[0];
                        
                        try {
                            int txContact = Integer.parseInt(valueStr);
                            
                            // Check for bug signatures
                            if (txContact == 1 || txContact == 16777215) {
                                bugSignatureCount++;
                            } else if (txContact > 1 && txContact < 16777215) {
                                validIdCount++;
                            }
                        } catch (NumberFormatException e) {
                            // Ignore parse errors
                        }
                    }
                }
            }
            
            reader.close();
            process.waitFor();
            
            XposedBridge.log(TAG + ": Patch check - Bug signatures: " + bugSignatureCount + 
                           ", Valid IDs: " + validIdCount);
            
            // If we see mostly bug signatures, patch is lost
            // If we see mostly valid IDs, patch is loaded
            if (bugSignatureCount > 0 && validIdCount == 0) {
                return false; // Definitely lost
            } else if (validIdCount > bugSignatureCount) {
                return true; // Probably loaded
            } else {
                return false; // Uncertain, assume lost to prompt reload
            }
            
        } catch (Exception e) {
            XposedBridge.log(TAG + ": Patch check failed: " + e.getMessage());
            return false; // Assume lost if we can't check
        }
    }
    
    /**
     * AsyncTask to check patch status in background
     */
    private static class CheckPatchStatusTask extends AsyncTask<Context, Void, Boolean> {
        @Override
        protected Boolean doInBackground(Context... contexts) {
            return isPatchLoaded();
        }
        
        @Override
        protected void onPostExecute(Boolean loaded) {
            updateStatusIndicator(loaded);
        }
    }
    
    /**
     * AsyncTask to reload patch firmware
     * 
     * Steps:
     * 1. Copy assets/PATCH14.bin → /sdcard/DMR/DMRDEBUG.bin (20%)
     * 2. Launch UpdateFirmwareActivity (40%)
     * 3. Monitor YModem completion (60-90%)
     * 4. Cleanup DMRDEBUG.bin (95%)
     * 5. Force-stop and restart app (100%)
     */
    private static class ReloadPatchTask extends AsyncTask<Void, Integer, String> {
        private Context context;
        private ProgressDialog progressDialog;
        
        public ReloadPatchTask(Context context) {
            this.context = context;
        }
        
        @Override
        protected void onPreExecute() {
            progressDialog = new ProgressDialog(context);
            progressDialog.setTitle("Reloading DMR Patch");
            progressDialog.setMessage("Copying firmware...");
            progressDialog.setProgressStyle(ProgressDialog.STYLE_HORIZONTAL);
            progressDialog.setMax(100);
            progressDialog.setCancelable(false);
            progressDialog.setIndeterminate(false);
            progressDialog.show();
            
            XposedBridge.log(TAG + ": Starting patch reload workflow");
        }
        
        @Override
        protected String doInBackground(Void... voids) {
            try {
                // Step 1: Copy firmware from backup location (0-20%)
                XposedBridge.log(TAG + ": Step 1/5: Copying firmware from backup");
                publishProgress(5, 1);
                
                // Check if source file exists
                File sourceFile = new File(SOURCE_PATH);
                if (!sourceFile.exists()) {
                    XposedBridge.log(TAG + ": ERROR: Source firmware not found at " + SOURCE_PATH);
                    return "Failed: Firmware file not found. Please run setup first.";
                }
                
                File destFile = new File(DEST_PATH);
                destFile.getParentFile().mkdirs();
                
                FileInputStream is = new FileInputStream(sourceFile);
                FileOutputStream os = new FileOutputStream(destFile);
                
                byte[] buffer = new byte[8192];
                int bytesRead;
                long totalBytes = 0;
                
                while ((bytesRead = is.read(buffer)) != -1) {
                    os.write(buffer, 0, bytesRead);
                    totalBytes += bytesRead;
                }
                
                is.close();
                os.close();
                
                XposedBridge.log(TAG + ": Copied " + totalBytes + " bytes to " + DEST_PATH);
                publishProgress(20, 1);
                
                // Step 2: Launch UpdateFirmwareActivity (20-40%)
                XposedBridge.log(TAG + ": Step 2/5: Launching firmware update activity");
                publishProgress(30, 2);
                
                Intent intent = new Intent();
                intent.setClassName(PACKAGE_NAME, UPDATE_ACTIVITY);
                intent.addFlags(Intent.FLAG_ACTIVITY_NEW_TASK);
                context.startActivity(intent);
                
                Thread.sleep(2000); // Wait for activity to start
                publishProgress(40, 2);
                
                // Step 3: Monitor YModem completion (40-90%)
                XposedBridge.log(TAG + ": Step 3/5: Monitoring YModem transfer (~2 min)");
                boolean completed = false;
                int maxWaitSeconds = 180; // 3 minutes max
                
                for (int i = 0; i < maxWaitSeconds; i++) {
                    Thread.sleep(1000);
                    int progress = 40 + (i * 50 / maxWaitSeconds);
                    publishProgress(progress, 3);
                    
                    // Check for completion markers in logcat
                    if (isYModemComplete()) {
                        XposedBridge.log(TAG + ": YModem transfer completed!");
                        completed = true;
                        break;
                    }
                }
                
                if (!completed) {
                    XposedBridge.log(TAG + ": ⚠️ Timeout waiting for YModem completion");
                    return "Timeout";
                }
                
                publishProgress(100, 3);
                
                // Note: Cleanup and restart are now handled automatically by UpdateFirmwareActivity hook
                // The hook detects completion (step 32), deletes DMRDEBUG.bin, closes activity, and restarts app
                XposedBridge.log(TAG + ": ✅ YModem completed - automatic cleanup will handle the rest");
                
                return "Success";
                
            } catch (Exception e) {
                XposedBridge.log(TAG + ": ❌ Reload failed: " + e.getMessage());
                e.printStackTrace();
                return "Failed: " + e.getMessage();
            }
        }
        
        @Override
        protected void onProgressUpdate(Integer... values) {
            int progress = values[0];
            int step = values[1];
            
            progressDialog.setProgress(progress);
            
            String[] stepMessages = {
                "Initializing...",
                "Copying firmware from backup...",
                "Launching update activity...",
                "Transferring firmware via YModem (~2 min)..."
                // Note: Cleanup and restart handled automatically by UpdateFirmwareActivity hook
            };
            
            if (step >= 0 && step < stepMessages.length) {
                progressDialog.setMessage(stepMessages[step]);
            }
        }
        
        @Override
        protected void onPostExecute(String result) {
            // Safely dismiss dialog (may have been destroyed if app restarted)
            try {
                if (progressDialog != null && progressDialog.isShowing()) {
                    progressDialog.dismiss();
                }
            } catch (Exception e) {
                // Dialog already dismissed or activity destroyed - this is expected if app restarted
                XposedBridge.log(TAG + ": Dialog dismiss skipped (app may have restarted): " + e.getMessage());
            }
            
            if (result.equals("Success")) {
                try {
                    Toast.makeText(context, "✓ YModem completed - app will restart automatically", 
                                 Toast.LENGTH_SHORT).show();
                    updateStatusIndicator(true);
                } catch (Exception e) {
                    // Context may be invalid if app restarted
                    XposedBridge.log(TAG + ": Toast skipped: " + e.getMessage());
                }
            } else if (result.equals("Timeout")) {
                try {
                    Toast.makeText(context, "⚠️ Reload timeout - check if still in progress", 
                                 Toast.LENGTH_LONG).show();
                } catch (Exception e) {
                    XposedBridge.log(TAG + ": Toast skipped: " + e.getMessage());
                }
            } else {
                Toast.makeText(context, "❌ Reload " + result, 
                             Toast.LENGTH_LONG).show();
            }
        }
    }
    
    /**
     * Check if YModem transfer has completed
     * 
     * Looks for completion markers in recent logcat:
     * - "sendEOT" (End of transmission)
     * - "onSuccess" (Transfer callback)
     * 
     * @return True if transfer completed
     */
    private static boolean isYModemComplete() {
        try {
            Process process = Runtime.getRuntime().exec("logcat -d -t 20");
            BufferedReader reader = new BufferedReader(new InputStreamReader(process.getInputStream()));
            
            String line;
            boolean foundEOT = false;
            boolean foundSuccess = false;
            
            while ((line = reader.readLine()) != null) {
                if (line.contains("YMODEM") && line.contains("sendEOT")) {
                    foundEOT = true;
                }
                if (line.contains("YModemManager") && line.contains("onSuccess")) {
                    foundSuccess = true;
                }
            }
            
            reader.close();
            process.waitFor();
            
            return foundEOT && foundSuccess;
            
        } catch (Exception e) {
            XposedBridge.log(TAG + ": YModem check failed: " + e.getMessage());
            return false;
        }
    }
}
