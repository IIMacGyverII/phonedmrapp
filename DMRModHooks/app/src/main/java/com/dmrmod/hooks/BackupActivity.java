package com.dmrmod.hooks;

import android.Manifest;
import android.app.Activity;
import android.content.Intent;
import android.content.pm.PackageManager;
import android.os.Build;
import android.os.Bundle;
import android.os.Environment;
import android.view.View;
import android.widget.Button;
import android.widget.ScrollView;
import android.widget.TextView;
import android.widget.Toast;

import java.io.File;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Date;
import java.util.Locale;

/**
 * BackupActivity - OpenGD77 CSV Export/Import UI
 * 
 * Provides a standalone activity for backup/restore functionality.
 * 
 * NOTE: This activity is currently unused in favor of direct hooks in the LOCAL tab.
 * The DirectDatabaseExporter and DirectDatabaseImporter classes are used instead,
 * providing a more seamless integration with buttons directly in the app's UI.
 * 
 * This file is kept for reference and potential future standalone backup app.
 * 
 * FEATURES:
 * - Export/Import DMR channels and contacts
 * - OpenGD77 CPS-compatible CSV format
 * - Files stored in Download/DMR_Backups/
 * - No special permissions required (uses standard Download folder)
 */
public class BackupActivity extends Activity {
    
    private static final String TAG = "DMRModHooks_Backup";
    private static final int REQUEST_CODE_STORAGE = 1001;
    private static final int REQUEST_CODE_IMPORT = 1002;
    
    private static final String BACKUP_DIR = "DMR_Backups";
    private static final String CHANNELS_CSV = "Channels.csv";
    private static final String CONTACTS_CSV = "Contacts.csv";
    
    private TextView tvInstructions;
    private Button btnExport;
    private Button btnImport;
    private Button btnBrowse;
    private TextView tvStatus;
    private TextView tvLog;
    private ScrollView scrollLog;
    private Button btnClose;
    
    private File backupDirectory;
    private String targetPackage;
    private android.content.Context targetContext;
    
    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        
        // Get target package from intent
        targetPackage = getIntent().getStringExtra("target_package");
        if (targetPackage == null) {
            targetPackage = "com.pri.prizeinterphone";
        }
        
        // Create context for target app to access its databases
        try {
            targetContext = createPackageContext(targetPackage, CONTEXT_INCLUDE_CODE | CONTEXT_IGNORE_SECURITY);
            log("Created target app context: " + targetPackage);
        } catch (Exception e) {
            log("ERROR: Could not create target app context: " + e.getMessage());
            Toast.makeText(this, "Error: Could not access target app", Toast.LENGTH_LONG).show();
        }
        
        // Create UI programmatically (no XML layout needed for simplicity)
        createUI();
        
        // Initialize backup directory (no permissions needed!)
        initializeBackupDirectory();
        
        log("Backup Activity initialized");
        log("Target app: " + targetPackage);
        log("Using app-specific storage (no permissions required)");
    }
    
    /**
     * Create UI programmatically
     */
    private void createUI() {
        // Root layout
        android.widget.LinearLayout rootLayout = new android.widget.LinearLayout(this);
        rootLayout.setOrientation(android.widget.LinearLayout.VERTICAL);
        rootLayout.setPadding(30, 30, 30, 30);
        rootLayout.setBackgroundColor(0xFFF5F5F5);
        
        // Title
        TextView tvTitle = new TextView(this);
        tvTitle.setText("📦 DMR Backup & Restore");
        tvTitle.setTextSize(24);
        tvTitle.setTextColor(0xFF000000);
        tvTitle.setPadding(0, 0, 0, 20);
        tvTitle.setGravity(android.view.Gravity.CENTER);
        rootLayout.addView(tvTitle);
        
        // Instructions
        tvInstructions = new TextView(this);
        tvInstructions.setText(
            "OpenGD77 CPS Compatible Format\n\n" +
            "• Export: Creates Channels.csv and Contacts.csv\n" +
            "• Import: Loads CSV files into app database\n" +
            "• Files: Android/data/com.dmrmod.hooks/files/\n\n" +
            "Compatible with OpenGD77 CPS (opengd77.com)"
        );
        tvInstructions.setTextSize(14);
        tvInstructions.setTextColor(0xFF333333);
        tvInstructions.setPadding(20, 10, 20, 20);
        rootLayout.addView(tvInstructions);
        
        // Export button
        btnExport = new Button(this);
        btnExport.setText("📤 Export Channels & Contacts");
        btnExport.setTextSize(16);
        btnExport.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                exportToCSV();
            }
        });
        android.widget.LinearLayout.LayoutParams exportParams = new android.widget.LinearLayout.LayoutParams(
            android.widget.LinearLayout.LayoutParams.MATCH_PARENT,
            android.widget.LinearLayout.LayoutParams.WRAP_CONTENT
        );
        exportParams.setMargins(0, 10, 0, 10);
        btnExport.setLayoutParams(exportParams);
        rootLayout.addView(btnExport);
        
        // Import button
        btnImport = new Button(this);
        btnImport.setText("📥 Import Channels & Contacts");
        btnImport.setTextSize(16);
        btnImport.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                importFromCSV();
            }
        });
        android.widget.LinearLayout.LayoutParams importParams = new android.widget.LinearLayout.LayoutParams(
            android.widget.LinearLayout.LayoutParams.MATCH_PARENT,
            android.widget.LinearLayout.LayoutParams.WRAP_CONTENT
        );
        importParams.setMargins(0, 0, 0, 20);
        btnImport.setLayoutParams(importParams);
        rootLayout.addView(btnImport);
        
        // Status label
        tvStatus = new TextView(this);
        tvStatus.setText("Ready");
        tvStatus.setTextSize(16);
        tvStatus.setTextColor(0xFF007700);
        tvStatus.setPadding(20, 10, 20, 10);
        tvStatus.setGravity(android.view.Gravity.CENTER);
        rootLayout.addView(tvStatus);
        
        // Log label
        TextView tvLogLabel = new TextView(this);
        tvLogLabel.setText("Activity Log:");
        tvLogLabel.setTextSize(14);
        tvLogLabel.setTextColor(0xFF000000);
        tvLogLabel.setPadding(20, 20, 20, 5);
        rootLayout.addView(tvLogLabel);
        
        // Log text in scroll view
        tvLog = new TextView(this);
        tvLog.setText("");
        tvLog.setTextSize(12);
        tvLog.setTextColor(0xFF000000);
        tvLog.setPadding(20, 10, 20, 10);
        tvLog.setBackgroundColor(0xFFFFFFFF);
        
        scrollLog = new ScrollView(this);
        scrollLog.addView(tvLog);
        android.widget.LinearLayout.LayoutParams scrollParams = new android.widget.LinearLayout.LayoutParams(
            android.widget.LinearLayout.LayoutParams.MATCH_PARENT,
            0,
            1.0f  // Weight to take remaining space
        );
        scrollParams.setMargins(0, 0, 0, 20);
        scrollLog.setLayoutParams(scrollParams);
        rootLayout.addView(scrollLog);
        
        // Close button
        btnClose = new Button(this);
        btnClose.setText("Close");
        btnClose.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                finish();
            }
        });
        android.widget.LinearLayout.LayoutParams closeParams = new android.widget.LinearLayout.LayoutParams(
            android.widget.LinearLayout.LayoutParams.MATCH_PARENT,
            android.widget.LinearLayout.LayoutParams.WRAP_CONTENT
        );
        btnClose.setLayoutParams(closeParams);
        rootLayout.addView(btnClose);
        
        setContentView(rootLayout);
    }
    
    /**
     * Initialize backup directory
     * Uses app-specific external storage (no permissions required on any Android version)
     */
    private void initializeBackupDirectory() {
        try {
            // Use Download/DMR_Backups for easy user access
            File downloadDir = Environment.getExternalStoragePublicDirectory(Environment.DIRECTORY_DOWNLOADS);
            if (downloadDir == null) {
                log("ERROR: External storage not available");
                return;
            }
            
            backupDirectory = new File(downloadDir, BACKUP_DIR);
            
            if (!backupDirectory.exists()) {
                boolean created = backupDirectory.mkdirs();
                if (created) {
                    log("Created backup directory: " + backupDirectory.getAbsolutePath());
                } else {
                    log("WARNING: Could not create backup directory");
                }
            } else {
                log("Backup directory ready: " + backupDirectory.getAbsolutePath());
            }
            
            log("Access files via file manager: Download/" + BACKUP_DIR);
        } catch (Exception e) {
            log("ERROR initializing backup directory: " + e.getMessage());
            e.printStackTrace();
        }
    }
    
    /**
     * Export channels and contacts to CSV
     */
    private void exportToCSV() {
        setStatus("Exporting...", 0xFF0077FF);
        log("=== EXPORT STARTED ===");
        
        new Thread(new Runnable() {
            @Override
            public void run() {
                try {
                    // No permission checks needed with app-specific storage!
                    
                    if (targetContext == null) {
                        runOnUiThread(new Runnable() {
                            @Override
                            public void run() {
                                setStatus("ERROR: Target app context not available", 0xFFFF0000);
                                log("ERROR: Cannot export without target app context");
                            }
                        });
                        return;
                    }
                    
                    // DIAGNOSTIC: Dump sample channels to logcat
                    log("Running diagnostic database dump...");
                    DiagnosticDatabaseDump.dumpMultipleChannels(targetContext);
                    
                    // Create timestamp for backup
                    String timestamp = new SimpleDateFormat("yyyy-MM-dd_HH-mm-ss", Locale.US).format(new Date());
                    
                    // Export channels
                    File channelsFile = new File(backupDirectory, CHANNELS_CSV);
                    log("Exporting to: " + channelsFile.getAbsolutePath());
                    
                    boolean channelsSuccess = CSVExporter.exportChannels(
                        BackupActivity.this,  // Use module context for cache access
                        targetPackage,
                        channelsFile
                    );
                    
                    // Export contacts
                    File contactsFile = new File(backupDirectory, CONTACTS_CSV);
                    log("Exporting to: " + contactsFile.getAbsolutePath());
                    
                    boolean contactsSuccess = CSVExporter.exportContacts(
                        BackupActivity.this,  // Use module context for cache access
                        targetPackage,
                        contactsFile
                    );
                    
                    final boolean success = channelsSuccess && contactsSuccess;
                    
                    runOnUiThread(new Runnable() {
                        @Override
                        public void run() {
                            if (success) {
                                setStatus("✓ Export complete!", 0xFF007700);
                                log("=== EXPORT COMPLETE ===");
                                Toast.makeText(BackupActivity.this, 
                                    "CSV files created successfully!", Toast.LENGTH_LONG).show();
                            } else {
                                setStatus("Export failed", 0xFFFF0000);
                                log("=== EXPORT FAILED ===");
                                Toast.makeText(BackupActivity.this, 
                                    "Export failed - check logs", Toast.LENGTH_SHORT).show();
                            }
                        }
                    });
                    
                } catch (final Exception e) {
                    runOnUiThread(new Runnable() {
                        @Override
                        public void run() {
                            setStatus("ERROR: " + e.getMessage(), 0xFFFF0000);
                            log("ERROR during export: " + e.getMessage());
                            e.printStackTrace();
                            Toast.makeText(BackupActivity.this, 
                                "Export error: " + e.getMessage(), Toast.LENGTH_SHORT).show();
                        }
                    });
                }
            }
        }).start();
    }
    
    /**
     * Import channels and contacts from CSV
     */
    private void importFromCSV() {
        setStatus("Importing...", 0xFF0077FF);
        log("=== IMPORT STARTED ===");
        
        new Thread(new Runnable() {
            @Override
            public void run() {
                try {
                    File channelsFile = new File(backupDirectory, CHANNELS_CSV);
                    File contactsFile = new File(backupDirectory, CONTACTS_CSV);
                    
                    if (!channelsFile.exists() || !contactsFile.exists()) {
                        runOnUiThread(new Runnable() {
                            @Override
                            public void run() {
                                setStatus("ERROR: CSV files not found", 0xFFFF0000);
                                log("ERROR: CSV files not found in backup directory");
                                Toast.makeText(BackupActivity.this, 
                                    "CSV files not found. Run export first.", Toast.LENGTH_LONG).show();
                            }
                        });
                        return;
                    }
                    
                    if (targetContext == null) {
                        runOnUiThread(new Runnable() {
                            @Override
                            public void run() {
                                setStatus("ERROR: Target app context not available", 0xFFFF0000);
                                log("ERROR: Cannot import without target app context");
                            }
                        });
                        return;
                    }
                    
                    log("Importing from: " + channelsFile.getAbsolutePath());
                    log("Importing from: " + contactsFile.getAbsolutePath());
                    
                    boolean contactsSuccess = CSVImporter.importContacts(
                        BackupActivity.this,  // Use module context for cache access
                        targetPackage,
                        contactsFile
                    );
                    
                    boolean channelsSuccess = CSVImporter.importChannels(
                        BackupActivity.this,  // Use module context for cache access
                        targetPackage,
                        channelsFile
                    );
                    
                    final boolean success = channelsSuccess && contactsSuccess;
                    
                    runOnUiThread(new Runnable() {
                        @Override
                        public void run() {
                            if (success) {
                                setStatus("✓ Import complete!", 0xFF007700);
                                log("=== IMPORT COMPLETE ===");
                                Toast.makeText(BackupActivity.this, 
                                    "Import successful! Restart app to see changes.", Toast.LENGTH_LONG).show();
                            } else {
                                setStatus("Import failed", 0xFFFF0000);
                                log("=== IMPORT FAILED ===");
                                Toast.makeText(BackupActivity.this, 
                                    "Import failed - check logs", Toast.LENGTH_SHORT).show();
                            }
                        }
                    });
                    
                } catch (final Exception e) {
                    runOnUiThread(new Runnable() {
                        @Override
                        public void run() {
                            setStatus("ERROR: " + e.getMessage(), 0xFFFF0000);
                            log("ERROR during import: " + e.getMessage());
                            e.printStackTrace();
                            Toast.makeText(BackupActivity.this, 
                                "Import error: " + e.getMessage(), Toast.LENGTH_SHORT).show();
                        }
                    });
                }
            }
        }).start();
    }
    
    /**
     * Set status message
     */
    private void setStatus(String message, int color) {
        if (tvStatus != null) {
            tvStatus.setText(message);
            tvStatus.setTextColor(color);
        }
    }
    
    /**
     * Append log message
     */
    private void log(final String message) {
        // Also log to Android log
        android.util.Log.i(TAG, message);
        
        runOnUiThread(new Runnable() {
            @Override
            public void run() {
                // Check if UI has been created yet
                if (tvLog == null || scrollLog == null) {
                    return;
                }
                
                String timestamp = new SimpleDateFormat("HH:mm:ss", Locale.US).format(new Date());
                String current = tvLog.getText().toString();
                tvLog.setText(current + "\n[" + timestamp + "] " + message);
                
                // Auto-scroll to bottom
                scrollLog.post(new Runnable() {
                    @Override
                    public void run() {
                        scrollLog.fullScroll(ScrollView.FOCUS_DOWN);
                    }
                });
            }
        });
    }
}
