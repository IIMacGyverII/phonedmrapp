package com.dmrmod.hooks;

import android.app.Activity;
import android.content.Context;

import com.dmrmod.hooks.RepeaterModels.Repeater;
import com.dmrmod.hooks.RepeaterPlanner.ChannelSpec;
import com.dmrmod.hooks.RepeaterPlanner.Plan;

import java.util.ArrayList;
import java.util.LinkedHashMap;
import java.util.List;
import java.util.Map;
import java.util.Set;

import de.robv.android.xposed.XposedHelpers;
import de.robv.android.xposed.XposedBridge;

/**
 * Device-side applier for the Nearby Repeaters feature (chapter 16 §4.2, §10; Phase 1).
 *
 * <p>Takes a {@link Plan} from {@link RepeaterPlanner} and writes it through the OEM create path:
 * contacts (reused if present), one TG list per slot, one {@code ChannelData} per spec via
 * {@code DmrManager.createChannel}, then the zone, location and the {@link RepeaterInstallStore}
 * row that makes {@link #undo} exact. New channels stay {@code active=0}: nothing is live until the
 * user taps one. OEM classes are reached only by reflection (the module can't import them).
 */
public final class RepeaterProgrammer {

    private static final String TAG = "DMRModHooks";
    private static final String CH = "com.pri.prizeinterphone.serial.data.ChannelData";
    private static final String CONTACT = "com.pri.prizeinterphone.serial.data.ContactData";
    private static final String MGR = "com.pri.prizeinterphone.manager.DmrManager";

    private RepeaterProgrammer() { }

    public static final class Result {
        public boolean ok;
        public String message;
        public long runId;
        public int channelsCreated;
        public int listenCreated;
        public int talkCreated;
        public int contactsCreated;
    }

    /** Preview text without writing anything: how many of each object the plan will make. */
    public static String preview(Plan plan) {
        int listen = 0, talk = 0;
        for (ChannelSpec c : plan.channels) {
            if ("talk".equals(c.role)) talk++; else listen++;
        }
        StringBuilder sb = new StringBuilder();
        sb.append(plan.channels.size()).append(" channel").append(plan.channels.size() == 1 ? "" : "s");
        sb.append(" (").append(listen).append(" listen");
        if (talk > 0) sb.append(" + ").append(talk).append(" talk");
        sb.append("), ").append(plan.contactsNeeded.size()).append(" contacts, 1 zone");
        if (!plan.warnings.isEmpty()) sb.append("  ⚠ ").append(plan.warnings.get(0));
        return sb.toString();
    }

    /** Apply the plan to the radio. Runs on a background thread; never on the UI thread. */
    public static Result apply(Activity activity, ClassLoader cl, Repeater rep,
                               Set<Integer> talkTgs, Map<Integer, String> names) {
        Result res = new Result();
        try {
            final Context ctx = activity;
            final String areaKey = OemChannelTable.areaKey(ctx);
            Plan plan = RepeaterPlanner.plan(rep, talkTgs, names);
            if (plan.channels.isEmpty()) {
                res.message = plan.warnings.isEmpty() ? "Nothing to install" : plan.warnings.get(0);
                return res;
            }

            // P3.3: re-installing the same repeater into the same area replaces the earlier run,
            // so a second install updates rather than duplicating channels/zone/contacts.
            for (RepeaterInstallStore.Run prev : RepeaterInstallStore.load(ctx)) {
                if (areaKey.equals(prev.areaKey) && rep.key != null && rep.key.equals(prev.repeaterKey)) {
                    XposedBridge.log(TAG + ": Nearby: replacing prior install run " + prev.runId
                        + " for " + rep.callsign);
                    undo(activity, cl, prev.runId);
                    break;
                }
            }

            Object mgr = XposedHelpers.callStaticMethod(XposedHelpers.findClass(MGR, cl), "getInstance");

            RepeaterInstallStore.Run run = new RepeaterInstallStore.Run();
            run.runId = System.currentTimeMillis();
            run.areaKey = areaKey;
            run.repeaterKey = rep.key;
            run.callsign = rep.callsign;
            run.installedAt = run.runId;

            // 1. contacts (reuse existing by DMR-ID/number; create the rest)
            for (Map.Entry<Integer, String> e : plan.contactsNeeded.entrySet()) {
                int tg = e.getKey();
                Object existing = null;
                try { existing = XposedHelpers.callMethod(mgr, "getContact", 1, tg); } catch (Throwable ignore) { }
                if (existing != null) continue;
                // Track the TG number BEFORE saveContact. We only reach here when no such contact
                // existed, so (type=1, number=tg) identifies exactly what we create. saveContact does a
                // blank-insert then update then notifyContactAdded; that listener can throw on this
                // background thread AFTER the row is already persisted (seen on the first contact of a
                // run), which previously left an untracked, undeletable contact. Recording intent first
                // makes undo exact regardless.
                run.contactNumbersCreated.add(tg);
                res.contactsCreated++;
                try {
                    Object contact = XposedHelpers.newInstance(XposedHelpers.findClass(CONTACT, cl));
                    XposedHelpers.callMethod(contact, "setType", 1);
                    XposedHelpers.callMethod(contact, "setName", e.getValue());
                    XposedHelpers.callMethod(contact, "setNumber", String.valueOf(tg));
                    XposedHelpers.callMethod(contact, "setActive", 1);
                    XposedHelpers.callMethod(mgr, "saveContact", contact);
                    int cid = (Integer) XposedHelpers.callMethod(contact, "getId");
                    if (cid > 0) run.contactIdsCreated.add(cid);
                } catch (Throwable ct) {
                    XposedBridge.log(TAG + ": contact create (post-insert) note for TG " + tg + ": " + ct);
                }
            }

            // 2. one TG list per slot (for the editor's TG-List row); map slotIndex -> listId
            Map<Integer, Long> slotList = new LinkedHashMap<>();
            TGListDatabase tgDb = TGListDatabase.getInstance(ctx);
            for (ChannelSpec c : plan.channels) {
                if (slotList.containsKey(c.slotIndex)) continue;
                StringBuilder csv = new StringBuilder();
                for (int g : c.groups) { if (g > 0) { if (csv.length() > 0) csv.append(','); csv.append(g); } }
                String listName = RepeaterPlanner.trim("»" + rep.callsign + " S" + (c.slotIndex + 1), 48);
                long listId = tgDb.saveTGList(listName, csv.toString());
                if (listId > 0) { slotList.put(c.slotIndex, listId); run.tgListIdsCreated.add(listId); }
            }

            // 3. zone (reuse by name, else create)
            ZoneDatabase zoneDb = ZoneDatabase.getInstance(ctx);
            ZoneDatabase.Zone zone = zoneDb.getZoneByName(plan.zoneName);
            long zoneId;
            if (zone != null) {
                zoneId = zone.id;
                run.zoneCreated = false;
            } else {
                zoneId = zoneDb.saveZone(new ZoneDatabase.Zone(plan.zoneName, new ArrayList<Integer>()));
                run.zoneCreated = true;
            }
            run.zoneId = zoneId;

            // 4. channels
            LocationDatabase locDb = LocationDatabase.getInstance(ctx);
            for (ChannelSpec c : plan.channels) {
                Object cd = XposedHelpers.newInstance(XposedHelpers.findClass(CH, cl));
                XposedHelpers.callMethod(cd, "setName", c.name);
                XposedHelpers.callMethod(cd, "setType", 0);
                XposedHelpers.callMethod(cd, "setRxFreq", (int) c.rxHz);
                XposedHelpers.callMethod(cd, "setTxFreq", (int) c.txHz);
                XposedHelpers.callMethod(cd, "setPower", 1);
                XposedHelpers.callMethod(cd, "setCc", c.cc);
                XposedHelpers.callMethod(cd, "setInBoundSlot", c.slotIndex);
                XposedHelpers.callMethod(cd, "setOutBoundSlot", c.slotIndex);
                XposedHelpers.callMethod(cd, "setChannelMode", 4);     // double-slot, as the importer does
                XposedHelpers.callMethod(cd, "setContactType", 1);     // GROUP
                XposedHelpers.callMethod(cd, "setTxContact", c.txContact);
                XposedHelpers.callMethod(cd, "setEncryptSw", 2);       // off
                XposedHelpers.callMethod(cd, "setEncryptKey", "");
                XposedHelpers.callMethod(cd, "setRelay", 2);           // normal (never 0)
                XposedHelpers.callMethod(cd, "setInterrupt", 2);       // OFF
                XposedHelpers.callMethod(cd, "setBand", 1);
                XposedHelpers.callMethod(cd, "setSq", 2);
                XposedHelpers.callMethod(cd, "setGroups", c.groups);
                XposedHelpers.callMethod(cd, "setActive", 0);          // NOT live until the user taps it

                XposedHelpers.callMethod(mgr, "createChannel", areaKey, cd);
                int id = (Integer) XposedHelpers.callMethod(cd, "getId");
                if (id <= 0) { XposedBridge.log(TAG + ": createChannel returned no id for " + c.name); continue; }
                run.channelIds.add(id);
                res.channelsCreated++;
                if ("talk".equals(c.role)) res.talkCreated++; else res.listenCreated++;

                Long listId = slotList.get(c.slotIndex);
                if (listId != null) { try { tgDb.assignTGListToChannel(id, listId); } catch (Throwable ignore) { } }
                try { zoneDb.addChannelToZone(zoneId, id); } catch (Throwable ignore) { }
                if (rep.hasCoords) { try { locDb.saveLocation(id, rep.lat, rep.lon); } catch (Throwable ignore) { } }
            }

            RepeaterInstallStore.save(ctx, run);
            try { MainHook.refreshChannelListUi(); } catch (Throwable ignore) { }
            res.runId = run.runId;
            res.ok = res.channelsCreated > 0;
            res.message = "Added " + res.channelsCreated + " channel"
                + (res.channelsCreated == 1 ? "" : "s")
                + " (" + res.listenCreated + " listen"
                + (res.talkCreated > 0 ? " + " + res.talkCreated + " talk" : "") + ") to zone \""
                + plan.zoneName + "\", " + res.contactsCreated + " new contacts.\n\n"
                + "They are not live yet — open the channel list (or the new zone) and tap one.";
            XposedBridge.log(TAG + ": Repeater install run " + run.runId + ": " + res.message.replace('\n', ' '));
            return res;
        } catch (Throwable t) {
            XposedBridge.log(TAG + ": RepeaterProgrammer.apply failed: " + t);
            res.message = "Install failed: " + t.getMessage();
            return res;
        }
    }

    /** Undo one run: delete exactly what it created, leaving reused objects and other runs alone. */
    public static String undo(Activity activity, ClassLoader cl, long runId) {
        try {
            final Context ctx = activity;
            RepeaterInstallStore.Run run = null;
            for (RepeaterInstallStore.Run r : RepeaterInstallStore.load(ctx)) {
                if (r.runId == runId) { run = r; break; }
            }
            if (run == null) return "Nothing to undo";

            Object mgr = XposedHelpers.callStaticMethod(XposedHelpers.findClass(MGR, cl), "getInstance");
            TGListDatabase tgDb = TGListDatabase.getInstance(ctx);
            ZoneDatabase zoneDb = ZoneDatabase.getInstance(ctx);
            LocationDatabase locDb = LocationDatabase.getInstance(ctx);

            int removed = 0;
            for (int id : run.channelIds) {
                try {
                    Object cd = XposedHelpers.newInstance(XposedHelpers.findClass(CH, cl));
                    XposedHelpers.callMethod(cd, "setId", id);
                    XposedHelpers.callMethod(mgr, "deleteChannel", run.areaKey, cd);
                    removed++;
                } catch (Throwable ct) { XposedBridge.log(TAG + ": undo channel " + id + ": " + ct); }
                try { tgDb.removeAssignmentForChannel(id); } catch (Throwable ignore) { }
                try { locDb.deleteLocation(id); } catch (Throwable ignore) { }
            }
            for (long listId : run.tgListIdsCreated) { try { tgDb.deleteTGList(listId); } catch (Throwable ignore) { } }
            if (run.zoneCreated && run.zoneId > 0) { try { zoneDb.deleteZone(run.zoneId); } catch (Throwable ignore) { } }
            for (int num : run.contactNumbersCreated) {
                try {
                    Object contact = XposedHelpers.callMethod(mgr, "getContact", 1, num);
                    if (contact != null) XposedHelpers.callMethod(mgr, "deleteContact", contact);
                } catch (Throwable ignore) { }
            }
            // older runs tracked ids only; fall back to deleting those
            for (int cid : run.contactIdsCreated) {
                if (!run.contactNumbersCreated.isEmpty()) break;
                try {
                    Object contact = XposedHelpers.newInstance(XposedHelpers.findClass(CONTACT, cl));
                    XposedHelpers.callMethod(contact, "setId", cid);
                    XposedHelpers.callMethod(mgr, "deleteContact", contact);
                } catch (Throwable ignore) { }
            }
            try { XposedHelpers.callMethod(mgr, "updateChannelList"); } catch (Throwable ignore) { }
            RepeaterInstallStore.remove(ctx, runId);
            return "Removed " + removed + " channel" + (removed == 1 ? "" : "s") + " from \"" + run.callsign + "\".";
        } catch (Throwable t) {
            XposedBridge.log(TAG + ": RepeaterProgrammer.undo failed: " + t);
            return "Undo failed: " + t.getMessage();
        }
    }
}
