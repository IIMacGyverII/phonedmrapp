package com.dmrmod.hooks;

import android.content.Context;
import android.database.Cursor;
import android.database.sqlite.SQLiteDatabase;
import android.graphics.Canvas;
import android.graphics.Color;
import android.graphics.Paint;
import android.graphics.Typeface;
import android.graphics.pdf.PdfDocument;
import android.util.Log;

import java.io.File;
import java.io.FileOutputStream;
import java.text.SimpleDateFormat;
import java.util.Date;
import java.util.HashMap;
import java.util.Locale;

import com.dmrmod.hooks.ToneConverter;

/**
 * PDFExporter - Generate PDF summary of backup contents
 * 
 * Creates a comprehensive PDF report with:
 * - Channel listing with frequencies and settings
 * - Contact database summary
 * - OpenGD77 CPS usage instructions
 * - Download links and compatibility notes
 */
public class PDFExporter {
    
    private static final String TAG = "PDFExporter";
    
    // Page dimensions (A4 @ 72 DPI)
    private static final int PAGE_WIDTH = 595;
    private static final int PAGE_HEIGHT = 842;
    private static final int MARGIN = 40;
    private static final int USABLE_WIDTH = PAGE_WIDTH - (2 * MARGIN);
    
    // Text sizes
    private static final float TITLE_SIZE = 20f;
    private static final float HEADING_SIZE = 14f;
    private static final float SUBHEADING_SIZE = 12f;
    private static final float BODY_SIZE = 10f;
    private static final float SMALL_SIZE = 8f;
    
    /**
     * Export backup summary to PDF
     * 
     * @param context App context
     * @param backupFolder Folder containing CSV backups
     * @return true if PDF created successfully
     */
    public static boolean exportBackupSummary(Context context, File backupFolder) {
        PdfDocument document = new PdfDocument();
        int pageNumber = 1;
        
        try {
            Log.i(TAG, "Generating PDF summary for: " + backupFolder.getName());
            
            // Page 1: Title and Channel Summary
            pageNumber = addTitlePage(document, pageNumber, backupFolder.getName());
            pageNumber = addChannelSummary(document, pageNumber, context);
            
            // Page 2+: Contact Summary and Instructions
            pageNumber = addContactSummary(document, pageNumber, context);
            pageNumber = addInstructions(document, pageNumber);
            
            // Write PDF to file
            File pdfFile = new File(backupFolder, "Backup_Summary.pdf");
            document.writeTo(new FileOutputStream(pdfFile));
            document.close();
            
            Log.i(TAG, "✓ PDF summary created: " + pdfFile.getAbsolutePath());
            return true;
            
        } catch (Exception e) {
            Log.e(TAG, "Error creating PDF: " + e.getMessage());
            e.printStackTrace();
            document.close();
            return false;
        }
    }
    
    /**
     * Add title page with backup info
     */
    private static int addTitlePage(PdfDocument document, int pageNumber, String backupFolderName) {
        PdfDocument.PageInfo pageInfo = new PdfDocument.PageInfo.Builder(PAGE_WIDTH, PAGE_HEIGHT, pageNumber).create();
        PdfDocument.Page page = document.startPage(pageInfo);
        Canvas canvas = page.getCanvas();
        Paint paint = new Paint();
        
        int y = MARGIN + 60;
        
        // Main title
        paint.setTextSize(TITLE_SIZE);
        paint.setTypeface(Typeface.create(Typeface.DEFAULT, Typeface.BOLD));
        paint.setColor(Color.BLACK);
        canvas.drawText("DMR Channel Backup Summary", MARGIN, y, paint);
        y += 40;
        
        // Backup info
        paint.setTextSize(BODY_SIZE);
        paint.setTypeface(Typeface.create(Typeface.DEFAULT, Typeface.NORMAL));
        canvas.drawText("Backup Date: " + formatBackupDate(backupFolderName), MARGIN, y, paint);
        y += 20;
        canvas.drawText("Format: OpenGD77 CSV", MARGIN, y, paint);
        y += 20;
        canvas.drawText("Device: Ulefone PriInterPhone DMR Radio", MARGIN, y, paint);
        y += 40;
        
        // Horizontal line
        paint.setStrokeWidth(2);
        canvas.drawLine(MARGIN, y, PAGE_WIDTH - MARGIN, y, paint);
        
        document.finishPage(page);
        return pageNumber + 1;
    }
    
    /**
     * Add channel summary page
     */
    private static int addChannelSummary(PdfDocument document, int pageNumber, Context context) {
        SQLiteDatabase db = null;
        Cursor cursor = null;
        PdfDocument.Page page = null;
        
        try {
            File dbFile = context.getDatabasePath("database_channel_area_default_uhf.db");
            if (!dbFile.exists()) {
                return pageNumber;
            }
            
            db = SQLiteDatabase.openDatabase(dbFile.getAbsolutePath(), null, SQLiteDatabase.OPEN_READONLY);
            cursor = db.query("database_channel_area_default_uhf", null, null, null, null, null, "channel_number ASC");
            
            if (cursor == null || cursor.getCount() == 0) {
                return pageNumber;
            }
            
            // Build contact map before starting PDF page (to catch DB errors first)
            HashMap<Integer, String> contactMap = buildContactMapPDF(context);
            
            PdfDocument.PageInfo pageInfo = new PdfDocument.PageInfo.Builder(PAGE_WIDTH, PAGE_HEIGHT, pageNumber).create();
            page = document.startPage(pageInfo);
            Canvas canvas = page.getCanvas();
            Paint paint = new Paint();
            
            int y = MARGIN + 20;
            
            // Section title
            paint.setTextSize(HEADING_SIZE);
            paint.setTypeface(Typeface.create(Typeface.DEFAULT, Typeface.BOLD));
            paint.setColor(Color.BLACK);
            canvas.drawText("Channels (" + cursor.getCount() + " total)", MARGIN, y, paint);
            y += 30;
            
            // Column headers (compact layout for more info)
            paint.setTextSize(SMALL_SIZE);
            paint.setTypeface(Typeface.create(Typeface.DEFAULT, Typeface.BOLD));
            canvas.drawText("#", MARGIN, y, paint);
            canvas.drawText("Name", MARGIN + 20, y, paint);
            canvas.drawText("Type", MARGIN + 150, y, paint);
            canvas.drawText("RX→TX Freq", MARGIN + 190, y, paint);
            canvas.drawText("Contact/Tones", MARGIN + 310, y, paint);
            canvas.drawText("CC/TS", MARGIN + 450, y, paint);
            canvas.drawText("SQ", MARGIN + 490, y, paint);
            canvas.drawText("P", MARGIN + 515, y, paint);
            y += 15;
            
            // Channels list
            paint.setTypeface(Typeface.create(Typeface.DEFAULT, Typeface.NORMAL));
            int maxChannelsPerPage = 35;
            int channelCount = 0;
            
            while (cursor.moveToNext()) {
                if (channelCount >= maxChannelsPerPage) {
                    // Start new page
                    document.finishPage(page);
                    pageNumber++;
                    pageInfo = new PdfDocument.PageInfo.Builder(PAGE_WIDTH, PAGE_HEIGHT, pageNumber).create();
                    page = document.startPage(pageInfo);
                    canvas = page.getCanvas();
                    y = MARGIN + 20;
                    channelCount = 0;
                    
                    // Repeat headers
                    paint.setTypeface(Typeface.create(Typeface.DEFAULT, Typeface.BOLD));
                    canvas.drawText("#", MARGIN, y, paint);
                    canvas.drawText("Name", MARGIN + 20, y, paint);
                    canvas.drawText("Type", MARGIN + 150, y, paint);
                    canvas.drawText("RX→TX Freq", MARGIN + 190, y, paint);
                    canvas.drawText("Contact/Tones", MARGIN + 310, y, paint);
                    canvas.drawText("CC/TS", MARGIN + 450, y, paint);
                    canvas.drawText("SQ", MARGIN + 490, y, paint);
                    canvas.drawText("P", MARGIN + 515, y, paint);
                    y += 15;
                    paint.setTypeface(Typeface.create(Typeface.DEFAULT, Typeface.NORMAL));
                }
                
                // Read all channel fields
                int chNum = cursor.getInt(cursor.getColumnIndex("channel_number"));
                String name = cursor.getString(cursor.getColumnIndex("channel_name"));
                if (name.length() > 18) name = name.substring(0, 18);
                int type = cursor.getInt(cursor.getColumnIndex("channel_type"));
                int rxFreq = cursor.getInt(cursor.getColumnIndex("channel_rxFreq"));
                int txFreq = cursor.getInt(cursor.getColumnIndex("channel_txFreq"));
                int power = cursor.getInt(cursor.getColumnIndex("channel_power"));
                int squelch = cursor.getInt(cursor.getColumnIndex("channel_sq"));
                
                String typeStr = (type == 0) ? "DMR" : "FM";
                String freqStr = String.format(Locale.US, "%.4f→%.4f", rxFreq / 1000000.0, txFreq / 1000000.0);
                String pwrStr = (power == 0) ? "L" : "H";
                
                // Type-specific data
                String extraInfo = "";
                String ccTs = "";
                
                if (type == 0) {
                    // Digital channel - show contact name, color code, timeslot
                    int contactId = cursor.getInt(cursor.getColumnIndex("channel_txContact"));
                    String contactName = contactMap.getOrDefault(contactId, "None");
                    if (contactName.length() > 15) contactName = contactName.substring(0, 15);
                    extraInfo = contactName;
                    
                    int colorCode = cursor.getInt(cursor.getColumnIndex("channel_cc"));
                    int timeslot = cursor.getInt(cursor.getColumnIndex("channel_outBoundSlot"));
                    ccTs = colorCode + "/" + timeslot;
                } else {
                    // Analog channel - show CTCSS/DCS tones
                    int rxType = cursor.getInt(cursor.getColumnIndex("channel_rxType"));
                    int rxSubCode = cursor.getInt(cursor.getColumnIndex("channel_rxSubCode"));
                    int txType = cursor.getInt(cursor.getColumnIndex("channel_txType"));
                    int txSubCode = cursor.getInt(cursor.getColumnIndex("channel_txSubCode"));
                    
                    String rxTone = ToneConverter.toCSVFormat(rxType, rxSubCode);
                    String txTone = ToneConverter.toCSVFormat(txType, txSubCode);
                    
                    if (rxTone.equals("None") && txTone.equals("None")) {
                        extraInfo = "No tones";
                    } else if (rxTone.equals(txTone)) {
                        extraInfo = rxTone;
                    } else {
                        extraInfo = rxTone + "/" + txTone;
                        if (extraInfo.length() > 15) {
                            extraInfo = "R:" + rxTone.substring(0, 6);
                        }
                    }
                    ccTs = "-";
                }
                
                // Draw row
                canvas.drawText(String.valueOf(chNum), MARGIN, y, paint);
                canvas.drawText(name, MARGIN + 20, y, paint);
                canvas.drawText(typeStr, MARGIN + 150, y, paint);
                canvas.drawText(freqStr, MARGIN + 190, y, paint);
                canvas.drawText(extraInfo, MARGIN + 310, y, paint);
                canvas.drawText(ccTs, MARGIN + 450, y, paint);
                canvas.drawText(String.valueOf(squelch), MARGIN + 490, y, paint);
                canvas.drawText(pwrStr, MARGIN + 515, y, paint);
                
                y += 16;
                channelCount++;
            }
            
            document.finishPage(page);
            return pageNumber + 1;
            
        } catch (Exception e) {
            Log.e(TAG, "Error adding channel summary: " + e.getMessage());
            e.printStackTrace();
            // Finish the page if it was started before the error
            if (page != null) {
                try {
                    document.finishPage(page);
                } catch (Exception ex) {
                    Log.e(TAG, "Error finishing page in exception handler: " + ex.getMessage());
                }
            }
            return pageNumber;
        } finally {
            if (cursor != null) cursor.close();
            if (db != null) db.close();
        }
    }
    
    /**
     * Add contact summary page
     */
    private static int addContactSummary(PdfDocument document, int pageNumber, Context context) {
        SQLiteDatabase db = null;
        Cursor cursor = null;
        PdfDocument.Page page = null;
        
        try {
            File dbFile = context.getDatabasePath("contact_database.db");
            if (!dbFile.exists()) {
                return pageNumber;
            }
            
            db = SQLiteDatabase.openDatabase(dbFile.getAbsolutePath(), null, SQLiteDatabase.OPEN_READONLY);
            cursor = db.query("contact_database", null, null, null, null, null, "contact_name ASC");
            
            if (cursor == null || cursor.getCount() == 0) {
                return pageNumber;
            }
            
            PdfDocument.PageInfo pageInfo = new PdfDocument.PageInfo.Builder(PAGE_WIDTH, PAGE_HEIGHT, pageNumber).create();
            page = document.startPage(pageInfo);
            Canvas canvas = page.getCanvas();
            Paint paint = new Paint();
            
            int y = MARGIN + 20;
            
            // Section title
            paint.setTextSize(HEADING_SIZE);
            paint.setTypeface(Typeface.create(Typeface.DEFAULT, Typeface.BOLD));
            paint.setColor(Color.BLACK);
            canvas.drawText("Contacts (" + cursor.getCount() + " total)", MARGIN, y, paint);
            y += 30;
            
            // Column headers
            paint.setTextSize(SMALL_SIZE);
            canvas.drawText("Name", MARGIN, y, paint);
            canvas.drawText("DMR ID", MARGIN + 300, y, paint);
            canvas.drawText("Type", MARGIN + 400, y, paint);
            y += 15;
            
            // Contacts list
            paint.setTypeface(Typeface.create(Typeface.DEFAULT, Typeface.NORMAL));
            
            while (cursor.moveToNext()) {
                String name = cursor.getString(cursor.getColumnIndex("contact_name"));
                int dmrId = cursor.getInt(cursor.getColumnIndex("contact_number"));
                int type = cursor.getInt(cursor.getColumnIndex("contact_type"));
                
                String typeStr = (type == 0) ? "Group" : "Private";
                
                canvas.drawText(name, MARGIN, y, paint);
                canvas.drawText(String.valueOf(dmrId), MARGIN + 300, y, paint);
                canvas.drawText(typeStr, MARGIN + 400, y, paint);
                
                y += 14;
                
                if (y > PAGE_HEIGHT - MARGIN - 20) {
                    // Start new page
                    document.finishPage(page);
                    pageNumber++;
                    pageInfo = new PdfDocument.PageInfo.Builder(PAGE_WIDTH, PAGE_HEIGHT, pageNumber).create();
                    page = document.startPage(pageInfo);
                    canvas = page.getCanvas();
                    y = MARGIN + 20;
                }
            }
            
            document.finishPage(page);
            return pageNumber + 1;
            
        } catch (Exception e) {
            Log.e(TAG, "Error adding contact summary: " + e.getMessage());
            e.printStackTrace();
            if (page != null) {
                try {
                    document.finishPage(page);
                } catch (Exception ex) {
                    Log.e(TAG, "Error finishing page in exception handler: " + ex.getMessage());
                }
            }
            return pageNumber;
        } finally {
            if (cursor != null) cursor.close();
            if (db != null) db.close();
        }
    }
    
    /**
     * Add OpenGD77 instructions page
     */
    private static int addInstructions(PdfDocument document, int pageNumber) {
        PdfDocument.Page page = null;
        
        try {
            PdfDocument.PageInfo pageInfo = new PdfDocument.PageInfo.Builder(PAGE_WIDTH, PAGE_HEIGHT, pageNumber).create();
            page = document.startPage(pageInfo);
        Canvas canvas = page.getCanvas();
        Paint paint = new Paint();
        
        int y = MARGIN + 20;
        
        // Section title
        paint.setTextSize(HEADING_SIZE);
        paint.setTypeface(Typeface.create(Typeface.DEFAULT, Typeface.BOLD));
        paint.setColor(Color.BLACK);
        canvas.drawText("OpenGD77 CPS Usage Instructions", MARGIN, y, paint);
        y += 35;
        
        // Instructions
        paint.setTextSize(BODY_SIZE);
        paint.setTypeface(Typeface.create(Typeface.DEFAULT, Typeface.NORMAL));
        
        y = drawWrappedText(canvas, paint, "This backup contains CSV files compatible with the OpenGD77 Community Programming Software (CPS). You can edit your channel programming on a computer and re-import to your radio.", MARGIN, y, USABLE_WIDTH);
        y += 20;
        
        paint.setTypeface(Typeface.create(Typeface.DEFAULT, Typeface.BOLD));
        canvas.drawText("Backup Contents:", MARGIN, y, paint);
        y += 18;
        
        paint.setTypeface(Typeface.create(Typeface.DEFAULT, Typeface.NORMAL));
        y = drawWrappedText(canvas, paint, "• DMR_Backup_[timestamp].zip - Complete backup archive (recommended for transfer)", MARGIN + 10, y, USABLE_WIDTH - 10);
        y = drawWrappedText(canvas, paint, "• Individual CSV files (Channels, Contacts, TG_Lists, Zones, DTMF)", MARGIN + 10, y, USABLE_WIDTH - 10);
        y = drawWrappedText(canvas, paint, "• This PDF summary document", MARGIN + 10, y, USABLE_WIDTH - 10);
        y += 25;
        
        // Download section
        paint.setTypeface(Typeface.create(Typeface.DEFAULT, Typeface.BOLD));
        canvas.drawText("Download OpenGD77 CPS:", MARGIN, y, paint);
        y += 18;
        
        paint.setTypeface(Typeface.create(Typeface.DEFAULT, Typeface.NORMAL));
        paint.setColor(Color.BLUE);
        canvas.drawText("https://github.com/LibreDMR/OpenGD77/releases", MARGIN, y, paint);
        y += 20;
        
        paint.setColor(Color.BLACK);
        y = drawWrappedText(canvas, paint, "Download the latest OpenGD77 CPS release for Windows, macOS, or Linux from the GitHub releases page.", MARGIN, y, USABLE_WIDTH);
        y += 25;
        
        // Import instructions
        paint.setTypeface(Typeface.create(Typeface.DEFAULT, Typeface.BOLD));
        canvas.drawText("How to Import Your Backup:", MARGIN, y, paint);
        y += 20;
        
        paint.setTypeface(Typeface.create(Typeface.DEFAULT, Typeface.NORMAL));
        y = drawBulletPoint(canvas, paint, "1. Transfer the backup zip file or folder from your phone to your computer", MARGIN, y, USABLE_WIDTH);
        y = drawBulletPoint(canvas, paint, "2. Extract the zip file if needed, then open OpenGD77 CPS", MARGIN, y, USABLE_WIDTH);
        y = drawBulletPoint(canvas, paint, "3. Go to Menu > Import > Import CSV Files", MARGIN, y, USABLE_WIDTH);
        y = drawBulletPoint(canvas, paint, "4. Select the Channels.csv and Contacts.csv files from this backup", MARGIN, y, USABLE_WIDTH);
        y = drawBulletPoint(canvas, paint, "5. Edit channels, contacts, zones, and settings as needed", MARGIN, y, USABLE_WIDTH);
        y = drawBulletPoint(canvas, paint, "6. Export the modified CSV files", MARGIN, y, USABLE_WIDTH);
        y = drawBulletPoint(canvas, paint, "7. Transfer back to your phone and import using the DMR app", MARGIN, y, USABLE_WIDTH);
        y += 25;
        
        // Export instructions
        paint.setTypeface(Typeface.create(Typeface.DEFAULT, Typeface.BOLD));
        canvas.drawText("How to Re-Import to Your Phone:", MARGIN, y, paint);
        y += 20;
        
        paint.setTypeface(Typeface.create(Typeface.DEFAULT, Typeface.NORMAL));
        y = drawBulletPoint(canvas, paint, "1. Create a new folder in Download/DMR_Backups/ with timestamp format", MARGIN, y, USABLE_WIDTH);
        y = drawBulletPoint(canvas, paint, "2. Copy your edited CSV files to this folder", MARGIN, y, USABLE_WIDTH);
        y = drawBulletPoint(canvas, paint, "3. Open PriInterPhone app > LOCAL tab", MARGIN, y, USABLE_WIDTH);
        y = drawBulletPoint(canvas, paint, "4. Tap 'Import Channels' and select your backup folder", MARGIN, y, USABLE_WIDTH);
        y = drawBulletPoint(canvas, paint, "5. Confirm import - channels will be updated automatically", MARGIN, y, USABLE_WIDTH);
        y += 25;
        
        // Notes
        paint.setTypeface(Typeface.create(Typeface.DEFAULT, Typeface.BOLD));
        canvas.drawText("Important Notes:", MARGIN, y, paint);
        y += 18;
        
        paint.setTypeface(Typeface.create(Typeface.DEFAULT, Typeface.NORMAL));
        y = drawWrappedText(canvas, paint, "• Use the zip file for easy transfer via USB, email, or cloud storage", MARGIN + 10, y, USABLE_WIDTH - 10);
        y = drawWrappedText(canvas, paint, "• Importing will replace ALL existing channels in the app", MARGIN + 10, y, USABLE_WIDTH - 10);
        y = drawWrappedText(canvas, paint, "• Contacts are preserved during channel import", MARGIN + 10, y, USABLE_WIDTH - 10);
        y = drawWrappedText(canvas, paint, "• Backup your current settings before importing new ones", MARGIN + 10, y, USABLE_WIDTH - 10);
        y = drawWrappedText(canvas, paint, "• CTCSS and DCS tone settings are fully supported", MARGIN + 10, y, USABLE_WIDTH - 10);
        y += 25;
        
        // Footer
        paint.setTextSize(SMALL_SIZE);
        paint.setColor(Color.GRAY);
        canvas.drawText("Generated by DMRModHooks v0.9.36 - LSPosed Module for Ulefone PriInterPhone", MARGIN, PAGE_HEIGHT - 30, paint);
        
        document.finishPage(page);
        return pageNumber + 1;
        
        } catch (Exception e) {
            Log.e(TAG, "Error adding instructions: " + e.getMessage());
            e.printStackTrace();
            if (page != null) {
                try {
                    document.finishPage(page);
                } catch (Exception ex) {
                    Log.e(TAG, "Error finishing page in exception handler: " + ex.getMessage());
                }
            }
            return pageNumber;
        }
    }
    
    /**
     * Draw wrapped text with automatic line breaks
     */
    private static int drawWrappedText(Canvas canvas, Paint paint, String text, int x, int y, int maxWidth) {
        String[] words = text.split(" ");
        StringBuilder line = new StringBuilder();
        
        for (String word : words) {
            String testLine = line.length() == 0 ? word : line + " " + word;
            if (paint.measureText(testLine) > maxWidth) {
                canvas.drawText(line.toString(), x, y, paint);
                y += 16;
                line = new StringBuilder(word);
            } else {
                line = new StringBuilder(testLine);
            }
        }
        
        if (line.length() > 0) {
            canvas.drawText(line.toString(), x, y, paint);
            y += 16;
        }
        
        return y;
    }
    
    /**
     * Draw bullet point text
     */
    private static int drawBulletPoint(Canvas canvas, Paint paint, String text, int x, int y, int maxWidth) {
        return drawWrappedText(canvas, paint, text, x, y, maxWidth);
    }
    
    /**
     * Format backup folder name to readable date
     */
    private static String formatBackupDate(String folderName) {
        try {
            // Folder format: YYYYMMDD_HHMMSS
            String dateStr = folderName.substring(0, 8);
            String timeStr = folderName.substring(9, 15);
            
            String year = dateStr.substring(0, 4);
            String month = dateStr.substring(4, 6);
            String day = dateStr.substring(6, 8);
            String hour = timeStr.substring(0, 2);
            String min = timeStr.substring(2, 4);
            String sec = timeStr.substring(4, 6);
            
            return String.format(Locale.US, "%s/%s/%s %s:%s:%s", month, day, year, hour, min, sec);
        } catch (Exception e) {
            return folderName;
        }
    }
    
    /**
     * Build contact ID to name mapping for PDF display
     */
    private static HashMap<Integer, String> buildContactMapPDF(Context context) {
        HashMap<Integer, String> contactMap = new HashMap<>();
        SQLiteDatabase db = null;
        Cursor cursor = null;
        
        try {
            File dbFile = context.getDatabasePath("contact_database.db");
            if (!dbFile.exists()) {
                return contactMap;
            }
            
            db = SQLiteDatabase.openDatabase(dbFile.getAbsolutePath(), null, SQLiteDatabase.OPEN_READONLY);
            cursor = db.query("contact_database", 
                new String[]{"_id", "contact_name"}, 
                null, null, null, null, null);
            
            while (cursor != null && cursor.moveToNext()) {
                int id = cursor.getInt(0);
                String name = cursor.getString(1);
                contactMap.put(id, name);
            }
            
        } catch (Exception e) {
            Log.e(TAG, "Error building contact map for PDF: " + e.getMessage());
        } finally {
            if (cursor != null) cursor.close();
            if (db != null) db.close();
        }
        
        return contactMap;
    }
}
