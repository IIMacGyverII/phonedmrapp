# Phase 2 Research Instructions for Grok

**Mission**: Extract FCC internal photos, identify DMR module chips, and find firmware updates or Prize Telecom contact information.

**Context**: Phase 1 found XDA thread and Ulefone contact but failed to identify chips or retrieve FCC photos. We need hardware details for firmware extraction/patching.

---

## 🎯 PRIORITY TASKS (Complete These First)

### Task 1: FCC Internal Photo Extraction (CRITICAL)
**Objective**: Download high-resolution internal device photos showing chip markings

**Step-by-Step Instructions**:

1. **Go to https://fccid.io/**

2. **Try these exact searches** (in order):
   - Search box: `2AOWK-ARMOR26`
   - Search box: `2AOWK-A26`
   - Search box: `2AOWK ARMOR 26`
   - Search box: `Ulefone Armor 26 Ultra`
   - Click "Grantee Search" → Enter: `2AOWK`
   - Click "Grantee Search" → Enter: `Shenzhen Ulefone`

3. **For each result found**:
   - Click the FCC ID link
   - Look for "Internal Photos" document (usually PDF)
   - Download and examine for chip markings on PCB
   - Specifically look for DMR module section

4. **If nothing found above, try**:
   - Browse ALL devices by grantee 2AOWK
   - Look for similar Ulefone devices (Armor 25, Armor 20WT)
   - Check if they use same/similar DMR module

5. **Document findings**:
   - FCC ID number (if found)
   - List of documents available
   - Any chip markings visible in internal photos
   - Screenshot or transcribe chip labels you see

**Alternative FCC Databases**:
- Try https://apps.fcc.gov/oetcf/eas/reports/GenericSearch.cfm
- Search for: "Ulefone" under Equipment Authorization Search

**IC Canada Database** (parallel search):
- Go to https://ised-isde.canada.ca/site/spectrum-management-telecommunications/en/equipment-certification/search-certifications
- Search: "Ulefone Armor 26"
- Download any internal photos or technical briefs

**Questions to Answer**:
- ❓ What is the exact FCC ID for Ulefone Armor 26 Ultra?
- ❓ Are internal photos available in the FCC filing?
- ❓ What chip markings are visible on the DMR module PCB?
- ❓ Can you identify: Main MCU chip? RF transceiver chip? Flash memory chip?
- ❓ Does the FCC block diagram show component details?

---

### Task 2: XDA Thread Deep Dive
**Objective**: Read ENTIRE XDA thread for chip IDs, teardown photos, or firmware updates

**URL**: https://xdaforums.com/t/ulefone-armor-26-ultra-walkie-talkie-info-guides-development.4677740/

**Instructions**:

1. **Read ALL pages** (start from page 1, not just page 11)
   - Use search function (Ctrl+F) for keywords:
     - "chip"
     - "MCU"
     - "teardown"
     - "disassembly"
     - "V023" or "V024" (newer firmware)
     - "Prize"
     - "DMR003"
     - "JTAG"
     - "SWD"
     - "programmer"
     - "flash"

2. **Look for user-posted photos**:
   - Any images of DMR module PCB
   - Internal device photos showing chips
   - Firmware update screens showing version numbers

3. **Check for file attachments**:
   - Firmware dumps
   - UART logs
   - Technical documents
   - APK mods with newer firmware

4. **Identify expert users**:
   - Who has deep technical knowledge?
   - Who has posted about firmware or hardware?
   - Would any user be good to directly message asking about chip IDs?

**Questions to Answer**:
- ❓ Has anyone posted teardown photos showing chip markings?
- ❓ Have any users identified the MCU or RF chip model?
- ❓ Are there firmware versions beyond V022 mentioned?
- ❓ Has anyone successfully extracted/dumped the firmware?
- ❓ Are there any hardware modders in the thread?
- ❓ Should we post a request for chip identification help?

---

### Task 3: AliExpress/Taobao Module Search
**Objective**: Find Chinese sellers offering DMR003 or Prize modules with product photos/specs

**AliExpress Instructions**:

1. **Go to https://www.aliexpress.com/**

2. **Try these searches** (exact phrases):
   - `DMR003 module`
   - `Prize DMR module`
   - `普睿 DMR模块` (Prize DMR module in Chinese)
   - `DMR对讲模块` (DMR intercom module)
   - `数字对讲机模块` (digital walkie-talkie module)
   - `车载DMR模块` (vehicle DMR module)
   - `DMR radio module STM32` (might find compatible modules)

3. **For each listing found**:
   - Check product photos for PCB/chip close-ups
   - Read product description for specifications
   - Look at customer reviews (sometimes include photos)
   - Check Q&A section for technical questions
   - Note seller name/store for potential contact

4. **Contact promising sellers** (use AliExpress message):
   ```
   Hello, I am interested in your DMR module. Can you provide:
   1. What MCU chip does this module use? (STM32? GD32? Other?)
   2. Do you have a technical datasheet or specification sheet?
   3. Is this module compatible with JTAG or SWD programmers?
   4. Can you provide more detailed photos of the PCB?
   Thank you!
   ```

**Taobao Instructions**:

1. **Go to https://world.taobao.com/**

2. **Try these Chinese searches**:
   - `普睿通讯` (Prize Telecom)
   - `普睿DMR` (Prize DMR)
   - `DMR003模块` (DMR003 module)
   - `DMR003.UV4T`
   - `数字对讲模块芯片` (digital intercom module chip)
   - `DMR模块开发板` (DMR module development board)

3. **Examine product listings**:
   - Look for OEM/wholesale sellers (more likely to show modules)
   - Check for development kits (would list chip compatibility)
   - Screenshot any chip specifications mentioned
   - Note if any sellers mention "STM32" or other chip families

**Questions to Answer**:
- ❓ Did you find any DMR003 or Prize modules for sale?
- ❓ Do product photos show PCB/chip details?
- ❓ Do any sellers list the MCU chip model in specifications?
- ❓ Are there similar DMR modules listed with chip specs that might match?
- ❓ Did any sellers respond to messages about chip details?

---

## 📧 COMMUNICATION TASKS

### Task 4: Draft Ulefone Support Email
**Objective**: Prepare professional email to Ulefone support requesting firmware update and Prize contact

**To**: support@ulefone.com  
**Subject**: Bug Report: DMR Module Group Call Filtering (DMR003.UV4T.V022)

**Draft Email** (you can refine/send):

```
Dear Ulefone Support Team,

I am writing regarding a firmware bug in the DMR module (model: DMR003.UV4T, 
firmware version: V022) integrated into the Ulefone Armor 26 Ultra smartphone.

ISSUE SUMMARY:
The DMR module fails to honor the contactType=2 (RECEIVE_ALL) setting for 
group calls. While private calls correctly use the RECEIVE_ALL configuration, 
group calls are filtered at the hardware level even when contactType is set 
to allow all calls.

TECHNICAL DETAILS:
- Firmware Version: DMR003.UV4T.V022 (extracted from APK assets)
- Affected Command: SET_RX_GROUP_LIST (CMD 0x22)
- UART logs confirm correct configuration is sent and acknowledged
- Private calls work as expected with contactType=2
- Group calls are filtered despite correct configuration
- Testing performed: 247 UART commands tested; no workaround found

IMPACT:
This prevents the "Monitoring Mode" feature from working correctly, as users 
cannot receive all group calls regardless of ID configuration. This is critical 
for emergency services, fleet management, and hobbyist applications.

REQUESTS:
1. Is there a firmware update (V023 or later) that addresses this bug?
2. Can you provide contact information for Prize Telecom (the module manufacturer) 
   so I can report this bug directly to their engineering team?
3. Can you provide technical documentation for the DMR003.UV4T module, including:
   - MCU chip model (for potential community patching)
   - Programming interface type (JTAG/SWD)
   - Hardware interface specifications

AVAILABLE DOCUMENTATION:
I have complete UART communication logs, firmware binary analysis, and detailed 
bug reproduction steps. I can provide these to your engineering team if helpful.

Thank you for your assistance in resolving this issue. I believe a simple 
firmware patch could address this problem.

Best regards,
[Your name/contact]
```

**Question**:
- ❓ Should I send this email now, or do you want to review/modify it first?
- ❓ Would it help to attach any specific documentation with the email?

---

## 🔍 SECONDARY TASKS (If Time Permits)

### Task 5: YouTube Video Frame Analysis
**URL**: https://www.youtube.com/watch?v=eHKtYTjekRE

**Instructions**:
1. Watch video at 0.25x speed
2. Pause on any frames showing device interior or PCB
3. Screenshot any chip markings visible
4. Check video timeline for sections labeled "teardown" or "inside"
5. Read video description for specifications
6. Check comments for technical discussions

**Additional YouTube searches**:
- "Ulefone Armor 26 Ultra teardown"
- "Ulefone Armor 26 disassembly"
- "Ulefone Armor 26 repair"

**Question**:
- ❓ Does the video show any internal shots with chip details?

---

### Task 6: Chinese Technical Forums
**Objective**: Search Chinese radio/electronics communities for DMR003 discussion

**Baidu Tieba** (Chinese Reddit-like forum):
1. Go to https://tieba.baidu.com/
2. Search: `DMR003` or `普睿通讯` or `DMR模块`
3. Look for posts about Ulefone Armor 26 or Prize modules
4. Use Google Translate on any promising threads

**CQ.net.cn** (Chinese amateur radio forum):
1. Search site for DMR-related posts
2. Look for discussions of commercial DMR modules
3. Check if anyone has teardown experience

**Question**:
- ❓ Did you find any Chinese forum discussions about DMR003 or Prize modules?

---

### Task 7: Patent Search
**Google Patents**: https://patents.google.com/

Search terms:
- "Prize Telecom"
- "普睿通讯"
- "DMR module" + author:"China"
- "digital mobile radio" + "transceiver module"

**Question**:
- ❓ Did you find any patents by Prize Telecom or related to DMR003?

---

### Task 8: Check iFixit for Repair Guide
**URL**: https://www.ifixit.com/

- Search: "Ulefone Armor 26"
- Check if teardown guide exists
- Look for component identification

**Question**:
- ❓ Does iFixit have a teardown guide with internal photos?

---

## 📊 DELIVERABLE FORMAT

For the main tasks (1-4), please report back using this format:

```markdown
## PHASE 2 RESEARCH RESULTS

### Task 1: FCC Internal Photos
**Status**: ✅ Success / ⏸️ Partial / ❌ Failed

**FCC ID Found**: [e.g., 2AOWK-ARMOR26 or "Not found"]

**Documents Available**:
- [ ] Internal Photos (PDF)
- [ ] Test Reports
- [ ] Block Diagram
- [ ] User Manual

**Chip Identifications from Photos**:
- Main MCU: [chip model if visible, e.g., "STM32F407" or "Not visible"]
- RF Transceiver: [chip model if visible, e.g., "Si4463" or "Not visible"]
- Other Notable Chips: [list any other visible chips]

**Screenshots/Evidence**: [describe what you saw or provide image descriptions]

---

### Task 2: XDA Thread Analysis
**Status**: ✅ Success / ⏸️ Partial / ❌ Failed

**Pages Read**: [e.g., "Pages 1-15 of 20"]

**Key Findings**:
- Chip IDs mentioned: [Yes/No - if yes, list them]
- Teardown photos posted: [Yes/No - if yes, describe]
- Firmware versions mentioned: [list all versions seen]
- Expert users identified: [usernames of technically knowledgeable members]

**Relevant Posts/Quotes**: [any important technical discussions]

---

### Task 3: AliExpress/Taobao Search
**Status**: ✅ Success / ⏸️ Partial / ❌ Failed

**Products Found**:
- DMR003 modules: [Yes/No - if yes, provide links]
- Similar DMR modules with specs: [Yes/No - if yes, describe]
- Sellers with PCB photos: [Yes/No - if yes, describe]

**Chip Specifications Listed**:
- [e.g., "One seller lists 'STM32F MCU' in description"]
- [or "No chip specifications found"]

**Seller Responses**: [if you contacted any sellers, summarize responses]

---

### Task 4: Ulefone Support Email
**Status**: ⏸️ Draft Ready for Review / ✅ Sent / ❌ Not Sent

**Email Draft**: [paste the final version if modified]

**Send Decision**: Should this be sent now?

---

### Summary & Next Steps
**Critical Findings**:
1. [Most important discovery]
2. [Second most important discovery]
3. [Third most important discovery]

**Recommended Next Actions**:
- [ ] [Action 1 based on findings]
- [ ] [Action 2 based on findings]
- [ ] [Action 3 based on findings]
```

---

## ⏱️ TIME ALLOCATION SUGGESTION

- **Task 1 (FCC)**: 20 minutes - Most critical
- **Task 2 (XDA)**: 25 minutes - High value
- **Task 3 (AliExpress/Taobao)**: 15 minutes - Good potential
- **Task 4 (Email draft)**: 10 minutes - Quick but important
- **Tasks 5-8 (Secondary)**: 10 minutes - If time allows

**Total**: ~80 minutes for thorough Phase 2 research

---

## 🎯 SUCCESS CRITERIA

**Minimum Success** (Need 1):
- [ ] FCC internal photos retrieved showing chip markings
- [ ] MCU chip model identified from any source
- [ ] Ulefone support email sent

**Good Success** (Need 2):
- [ ] MCU and RF chips both identified
- [ ] Firmware V023+ discovered or confirmed not to exist
- [ ] Prize Telecom contact info or pathway identified

**Excellent Success** (Need 3+):
- [ ] Complete chip list with programming interface confirmed
- [ ] Hardware documentation or schematic found
- [ ] Direct contact with Prize Telecom or Ulefone engineer established
- [ ] Community member with teardown photos/expertise identified

---

**START WITH TASK 1 (FCC)**. This is the most likely path to chip identification. If that fails, proceed to Tasks 2 and 3. Good luck! 🔍
