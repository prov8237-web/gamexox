package src5;

import com.smartfoxserver.v2.entities.User;
import com.smartfoxserver.v2.entities.data.*;
import com.smartfoxserver.v2.entities.variables.*;
import java.util.*;

public class InitHandler extends OsBaseHandler {

    @Override
    public void handleClientRequest(User user, ISFSObject params) {
        try {
            System.out.println("★★★ INIT HANDLER STARTED ★★★");
            processInit(user, params);
            System.out.println("★★★ INIT HANDLER COMPLETED ★★★");
        } catch (Exception e) {
            System.out.println("★★★ INIT ERROR: " + e.getMessage());
            e.printStackTrace();
        }
    }
    
    private void processInit(User user, ISFSObject params) {
        String userIP = user.getSession().getAddress();
        System.out.println("★ STEP 1: Got IP = " + userIP);
        
        InMemoryStore store = getStore();
        System.out.println("★ STEP 2: Got store");
        
        InMemoryStore.UserState state = store.getOrCreateUser(user);
        System.out.println("★ STEP 3: Got user state");
        
        trace("[INIT] ═══════════════════════════════════════════════════");
        trace("[INIT] Request from IP: " + userIP);

        // Get or create PlayerID
        String customID;
        System.out.println("★ STEP 3.5: Checking zone property...");
        if (getParentExtension().getParentZone().containsProperty(userIP + "_id")) {
            customID = (String) getParentExtension().getParentZone().getProperty(userIP + "_id");
            trace("[INIT] Found existing ID: " + customID);
        } else {
            long generatedId = 100000000L + user.getId();
            customID = String.valueOf(generatedId);
            getParentExtension().getParentZone().setProperty(userIP + "_id", customID);
            trace("[INIT] Created new ID: " + customID);
        }
        System.out.println("★ STEP 3.6: customID = " + customID);
        
        long ts = System.currentTimeMillis() / 1000;
        double playerIDDouble = Double.parseDouble(customID);
        
        // Check if user has saved data
        boolean hasSavedData = getParentExtension().getParentZone().containsProperty(userIP + "_active");
        System.out.println("★ STEP 4: hasSavedData = " + hasSavedData);
        trace("[INIT] Has saved data: " + hasSavedData);
        
        // ═══════════════════════════════════════════════════════════
        // تعيين صلاحيات المستخدم إلى MODERATOR (ID: 2)
        // ═══════════════════════════════════════════════════════════
        user.setPrivilegeId((short)2); // (short)2 = MODERATOR في SFS2X
        trace("[INIT] Set user privilege to MODERATOR (ID: 2)");
        
        // ═══════════════════════════════════════════════════════════
        // إضافة صلاحية MODERATOR في الـ roles
        // صلاحية MODERATOR = 20 حسب ملف AvatarPermission.as
        // نحتاج لتحويلها إلى Base64 مثل "AA=="
        // ═══════════════════════════════════════════════════════════
        // Roles must match client Permission.as encoding.
        // Compute from owned cards + privilege implied permissions.
        String computedRoles = store.recomputeRoles(user.getId(), user.getPrivilegeId());
        state.setRoles(computedRoles);
        trace("[INIT] Updated roles to: " + computedRoles);
        
        // ═══════════════════════════════════════════════════════════
        // STEP 1: Send initQueue first (matching official)
        // ═══════════════════════════════════════════════════════════
        SFSObject initQueueRes = new SFSObject();
        initQueueRes.putInt("p", 1);
        initQueueRes.putLong("ts", ts);
        sendValidated(user, "initQueue", initQueueRes);
        System.out.println("★ STEP 5: Sent initQueue");
        trace("[INIT] Sent initQueue");
        
        // ═══════════════════════════════════════════════════════════
        // STEP 2: Set User Variables (matching official order)
        // ═══════════════════════════════════════════════════════════
        String savedGender = state.getGender();
        String savedName = state.getAvatarName();
        
        if (hasSavedData) {
            Object genderObj = getParentExtension().getParentZone().getProperty(userIP + "_gender");
            Object nameObj = getParentExtension().getParentZone().getProperty(userIP + "_name");
            if (genderObj != null) savedGender = (String) genderObj;
            if (nameObj != null) savedName = (String) nameObj;
            trace("[INIT] Loaded saved gender: " + savedGender + ", name: " + savedName);
        }
        boolean isGuest = !hasSavedData;
        if (isGuest) {
            savedName = "Guest#" + customID;
        }
        state.setGender(savedGender);
        state.setAvatarName(savedName);
        System.out.println("★ STEP 6: Gender = " + savedGender + ", Name = " + savedName);
        
        // ═══════════════════════════════════════════════════════════
        // Build clothes - ALWAYS have valid clothes data
        // ═══════════════════════════════════════════════════════════
        String clothesJson = "[]";
        ISFSArray savedItemsArray = null;
        
        if (hasSavedData) {
            Object clothesObj = getParentExtension().getParentZone().getProperty(userIP + "_clothes");
            trace("[INIT] Clothes object type: " + (clothesObj != null ? clothesObj.getClass().getName() : "null"));
            
            if (clothesObj != null && clothesObj instanceof ISFSObject) {
                ISFSObject savedClothes = (ISFSObject) clothesObj;
                trace("[INIT] Clothes object keys: " + savedClothes.getKeys());
                
                if (savedClothes.containsKey("items")) {
                    savedItemsArray = savedClothes.getSFSArray("items");
                    clothesJson = savedItemsArray.toJson();
                    trace("[INIT] Found " + savedItemsArray.size() + " clothing items");
                }
            }
        }
        
        // If no saved clothes, build default clothes
        if (savedItemsArray == null || savedItemsArray.size() == 0) {
            System.out.println("★ STEP 7: Building default clothes...");
            trace("[INIT] Building default clothes for gender: " + savedGender);
            savedItemsArray = buildDefaultClothesItems(savedGender);
            clothesJson = savedItemsArray.toJson();
            System.out.println("★ STEP 8: Built clothes, count = " + savedItemsArray.size());
            trace("[INIT] Built " + savedItemsArray.size() + " default clothing items");
        }

        List<String> clothesErrors = new ArrayList<>();
        if (!validateClothesItems(savedItemsArray, clothesErrors)) {
            trace("[INIT] ⚠️ Invalid clothes payload detected: " + String.join("; ", clothesErrors));
            savedItemsArray = buildDefaultClothesItems(savedGender);
            clothesJson = savedItemsArray.toJson();
            trace("[INIT] Rebuilt clothes payload with defaults. Count=" + savedItemsArray.size());
        }

        state.setClothesJson(clothesJson);
        state.setClothesItems(savedItemsArray);

        SFSArray clothesKeysArray = buildClothesKeysArray(savedItemsArray);
        String clothesKeysJson = clothesKeysArray.toJson();
        int clothesKeysLen = clothesKeysArray.size();
        String firstClothesKey = clothesKeysLen > 0 ? clothesKeysArray.getUtfString(0) : "-";
        
        // ═══════════════════════════════════════════════════════════
        // DEBUG: Print clothes JSON for analysis
        // ═══════════════════════════════════════════════════════════
        System.out.println("★★★ CLOTHES DEBUG START ★★★");
        System.out.println("clothesJson: " + clothesJson);
        System.out.println("★★★ CLOTHES DEBUG END ★★★");
        
        List<UserVariable> userVars = new ArrayList<>();
        userVars.add(new SFSUserVariable("gender", savedGender));
        userVars.add(new SFSUserVariable("playerID", playerIDDouble));
        userVars.add(new SFSUserVariable("avatarName", savedName));
        userVars.add(new SFSUserVariable("universeKey", "w8"));
        userVars.add(new SFSUserVariable("imgPath", ""));
        userVars.add(new SFSUserVariable("mood", 0));
        userVars.add(new SFSUserVariable("platform", "web"));
        userVars.add(new SFSUserVariable("statusMessage", ""));
        userVars.add(new SFSUserVariable("hand", "0"));
        userVars.add(new SFSUserVariable("speed", 1.0));
        userVars.add(new SFSUserVariable("smiley", state.getSmiley()));
        userVars.add(new SFSUserVariable("avatarSize", 1.0));
        if (ProtocolConfig.chatEnabled()) {
            userVars.add(new SFSUserVariable("chatBalloon", state.getChatBalloon()));
        }
        userVars.add(new SFSUserVariable("clothes", clothesKeysJson));
        userVars.add(new SFSUserVariable("optimizedAssetKey", state.getOptimizedAssetKey()));
        getApi().setUserVariables(user, userVars);
        trace("[INIT] Set initial user variables");
        trace("[USER_VARS_SET] stage=INIT count=" + userVars.size() + " user=" + user.getName());
        trace("[INIT] clothes userVar keys len=" + clothesKeysLen + " firstKey=" + firstClothesKey);
        
        // Set roles variable separately - إرسال الـ roles المعدلة
        List<UserVariable> rolesVar = new ArrayList<>();
        rolesVar.add(new SFSUserVariable("roles", computedRoles));
        getApi().setUserVariables(user, rolesVar);
        trace("[USER_VARS_SET] stage=INIT roles user=" + user.getName() + " roles=" + computedRoles);
        
        // ═══════════════════════════════════════════════════════════
        // STEP 3: Send roles response (matching official)
        // ═══════════════════════════════════════════════════════════
        SFSObject rolesRes = new SFSObject();
        rolesRes.putUtfString("roles", computedRoles);
        sendValidated(user, "roles", rolesRes);
        trace("[INIT] Sent roles response: " + computedRoles);
        
        // ═══════════════════════════════════════════════════════════
        // STEP 4: Set position variables - FIXED: Grid coordinates!
        // ═══════════════════════════════════════════════════════════
        List<UserVariable> posVars = new ArrayList<>();
        posVars.add(new SFSUserVariable("target", ""));
        getApi().setUserVariables(user, posVars);
        trace("[USER_VARS_SET] stage=INIT target user=" + user.getName());
        
        List<UserVariable> statusVars = new ArrayList<>();
        statusVars.add(new SFSUserVariable("status", "idle"));
        statusVars.add(new SFSUserVariable("position", "20,30"));
        statusVars.add(new SFSUserVariable("direction", 0));
        getApi().setUserVariables(user, statusVars);
        trace("[USER_VARS_SET] stage=INIT status user=" + user.getName());
        state.setPosition("20,30");
        state.setDirection(0);
        
        List<UserVariable> speedVars = new ArrayList<>();
        speedVars.add(new SFSUserVariable("speed", 1.0));
        getApi().setUserVariables(user, speedVars);
        trace("[USER_VARS_SET] stage=INIT speed user=" + user.getName());

        for (String line : RenderGateAudit.audit(user, state, "INIT")) {
            trace(line);
        }
        
        // ═══════════════════════════════════════════════════════════
        // STEP 6: Send questlistroom (matching official)
        // ═══════════════════════════════════════════════════════════
        SFSObject questRes = new SFSObject();
        SFSArray questsArray = new SFSArray();
        
        SFSObject quest = new SFSObject();
        quest.putInt("rewardMultiplier", 1);
        quest.putUtfString("metaKey", "paperDelivery");
        quest.putInt("id", -154132);
        quest.putUtfString("status", "NEW");
        quest.putInt("currentStep", 1);
        quest.putInt("totalStep", 7);
        quest.putUtfString("roomKey", "street01");
        
        SFSObject step = new SFSObject();
        step.putUtfString("cn", "BotQuestProperty");
        step.putUtfString("botKey", "tahsin");
        step.putInt("reqVal", 1);
        step.putInt("curVal", 0);
        
        SFSArray questItems = new SFSArray();
        SFSObject questItem = new SFSObject();
        questItem.putInt("quantity", 5);
        questItem.putUtfString("countDownType", "NOW");
        questItem.putInt("lifeTime", 17159);
        questItem.putUtfString("clip", "dt678TPO");
        questItems.addSFSObject(questItem);
        step.putSFSArray("items", questItems);
        quest.putSFSObject("step", step);
        
        SFSArray rewards = new SFSArray();
        SFSObject reward = new SFSObject();
        reward.putUtfString("type", "SANIL");
        SFSObject rewardData = new SFSObject();
        rewardData.putInt("amount", 260);
        reward.putSFSObject("data", rewardData);
        rewards.addSFSObject(reward);
        quest.putSFSArray("rewards", rewards);
        
        questsArray.addSFSObject(quest);
        questRes.putSFSArray("quests", questsArray);
        sendValidated(user, "questlistroom", questRes);
        trace("[INIT] Sent questlistroom");
        
        // Update universeKey variable
        List<UserVariable> universeVars = new ArrayList<>();
        universeVars.add(new SFSUserVariable("universeKey", "w8"));
        getApi().setUserVariables(user, universeVars);
        
        // ═══════════════════════════════════════════════════════════
        // STEP 7: Send main init response (matching official structure)
        // ═══════════════════════════════════════════════════════════
        SFSObject res = new SFSObject();
        res.putLong("ts", ts);
        res.putUtfString("playerID", customID);
        String avatarKey = ProtocolConfig.chatEnabled() ? user.getName() : customID;
        res.putUtfString("selectedAvatarID", avatarKey);
        res.putInt("emailActive", 1);
        res.putBool("guest", isGuest);
        state.setGuest(isGuest);
        trace("[GUEST_CREATED] user=" + user.getName() + " guest=" + isGuest + " playerID=" + customID);
        res.putBool("isBanned", false);
        res.putInt("completedAchievementsCount", 0);
        res.putInt("tutorialStep", 0);
        res.putBool("dailySpinAvailable", false);
        res.putSFSArray("campaigns", new SFSArray());
        res.putSFSArray("bans", store.getActiveBansSFS(userIP));
        res.putSFSObject("settings", new SFSObject());
        res.putUtfString("gender", savedGender);
        res.putSFSArray("orderRequest", new SFSArray());
        
        res.putInt("checkAvatar", hasSavedData ? 1 : 0);
        trace("[INIT] checkAvatar = " + (hasSavedData ? 1 : 0));
        
        // Universe
        SFSObject universe = new SFSObject();
        universe.putUtfString("key", "w8");
        universe.putUtfString("name", "جزيرة 8");
        universe.putInt("fullness", 10);
        universe.putInt("roomFullness", 0);
        universe.putBool("roomAvailable", true);
        universe.putBool("recommended", false);
        universe.putUtfString("roles", "AAACAA==");
        res.putSFSObject("universe", universe);

        // Wallet
        SFSArray walletArray = new SFSArray();
        
        SFSObject sanilWallet = new SFSObject();
        sanilWallet.putUtfString("currency", "SANIL");
        sanilWallet.putInt("balance", 999999);
        sanilWallet.putDouble("avatarID", playerIDDouble);
        walletArray.addSFSObject(sanilWallet);
        
        SFSObject diamondWallet = new SFSObject();
        diamondWallet.putUtfString("currency", "DIAMOND");
        diamondWallet.putInt("balance", 999999);
        diamondWallet.putDouble("avatarID", playerIDDouble);
        walletArray.addSFSObject(diamondWallet);
        
        res.putSFSArray("wallet", walletArray);
        state.setWallet(walletArray);
        
        // Room data
        SFSObject roomObj = new SFSObject();
        roomObj.putUtfString("key", "street01");
        roomObj.putUtfString("doorKey", MapBuilder.DEFAULT_DOOR_KEY);
        roomObj.putInt("pv", 0);
        roomObj.putInt("dv", 0);
        roomObj.putUtfString("map", MapBuilder.buildMapBase64());
        res.putSFSObject("room", roomObj);

        // Clothes in init response
        SFSObject clothesObjResponse = new SFSObject();
        clothesObjResponse.putUtfString("type", "CLOTH");
        
        ISFSArray renderItems = state.getClothesItems();
        clothesObjResponse.putSFSArray("items", renderItems);
        res.putSFSObject("clothes", clothesObjResponse);
        
        System.out.println("★★★ INIT RESPONSE CLOTHES ★★★");
        System.out.println("clothesObjResponse: " + clothesObjResponse.toJson());
        System.out.println("★★★ END ★★★");

        // Extension info
        SFSArray extInfo = new SFSArray();
        
        SFSObject cursorExt = new SFSObject();
        cursorExt.putUtfString("name", "CursorExtension");
        SFSObject cursorProp = new SFSObject();
        cursorProp.putUtfString("cn", "EmptyProperty");
        cursorExt.putSFSObject("property", cursorProp);
        extInfo.addSFSObject(cursorExt);
        
        SFSObject soundExt = new SFSObject();
        soundExt.putUtfString("name", "SoundExtension");
        SFSObject soundProp = new SFSObject();
        soundProp.putUtfString("cn", "EmptyProperty");
        soundExt.putSFSObject("property", soundProp);
        extInfo.addSFSObject(soundExt);
        
        SFSObject snowExt = new SFSObject();
        snowExt.putUtfString("name", "SnowExtension");
        SFSObject snowProp = new SFSObject();
        snowProp.putUtfString("cn", "SnowExtensionProperty");
        snowProp.putUtfString("type", "outdoor");
        snowProp.putInt("speed", 1);
        snowExt.putSFSObject("property", snowProp);
        extInfo.addSFSObject(snowExt);
        
        res.putSFSArray("extensionInfo", extInfo);

        sendValidated(user, "init", res);
        trace("[INIT] Sent main init response");

        // Join room
        try {
            com.smartfoxserver.v2.entities.Room targetRoom = getParentExtension().getParentZone().getRoomByName("street01");
            if (targetRoom != null) {
                InMemoryStore.RoomState roomState = store.getOrCreateRoom(targetRoom);
                ensureMandatoryRoomVars(targetRoom, roomState, "INIT");
                if (user.getLastJoinedRoom() == null) {
                    trace("[JOIN_ROOM] stage=INIT user=" + user.getName() + " room=" + targetRoom.getName());
                    getApi().joinRoom(user, targetRoom);
                    trace("[INIT] Joined room: street01");
                    state.setCurrentRoom("street01");
                }
            }
        } catch (Exception e) {
            trace("[INIT] Room join error: " + e.getMessage());
        }
        
        // Send restartServer
        SFSObject restartRes = new SFSObject();
        restartRes.putBool("isRestartWaiting", false);
        sendValidated(user, "restartServer", restartRes);
        
        // Send privateChatUpdate
        SFSObject chatUpdateRes = new SFSObject();
        chatUpdateRes.putInt("unreadMessages", 0);
        sendValidated(user, "privateChatUpdate", chatUpdateRes);
        
        trace("[INIT] ✅ Complete for: " + user.getName());
        trace("[INIT] ═══════════════════════════════════════════════════");
    }

    private ISFSArray buildDefaultClothesItems(String gender) {
        SFSArray items = new SFSArray();
        java.text.SimpleDateFormat sdf = new java.text.SimpleDateFormat("yyyy-MM-dd HH:mm:ss.S", java.util.Locale.US);
        String createdAt = sdf.format(new java.util.Date());
        
        if ("f".equalsIgnoreCase(gender)) {
            items.addSFSObject(buildClothItem(100000, "C", 2, 1349, "HEAD", createdAt));
            items.addSFSObject(buildClothItem(100001, "B", 2, 1348, "FACE", createdAt));
            items.addSFSObject(buildClothItem(100002, "A", 2, 1344, "BODY", createdAt));
            items.addSFSObject(buildClothItem(100003, "7", 10, 31, "SHOES", createdAt));
            items.addSFSObject(buildClothItem(100004, "1", 9, 2, "PANTS", createdAt));
            items.addSFSObject(buildClothItem(100005, "5", 9, 28, "SHIRT", createdAt));
            items.addSFSObject(buildClothItem(100006, "10", 9, 32, "HAIR", createdAt));
        } else {
            items.addSFSObject(buildClothItem(100000, "C", 2, 1349, "HEAD", createdAt));
            items.addSFSObject(buildClothItem(100001, "B", 2, 1348, "FACE", createdAt));
            items.addSFSObject(buildClothItem(100002, "A", 2, 1344, "BODY", createdAt));
            items.addSFSObject(buildClothItem(100003, "7", 10, 31, "SHOES", createdAt));
            items.addSFSObject(buildClothItem(100004, "1", 9, 2, "PANTS", createdAt));
            items.addSFSObject(buildClothItem(100005, "4", 9, 149, "SHIRT", createdAt));
            items.addSFSObject(buildClothItem(100006, "8", 9, 32, "HAIR", createdAt));
        }
        
        return items;
    }
    
    private SFSObject buildClothItem(int id, String clipBase, int color, int productID, String subType, String createdAt) {
        SFSObject item = new SFSObject();
        
        String clipValue = clipBase + "_" + String.valueOf(color);
        
        item.putInt("id", id);
        item.putUtfString("clip", clipValue);
        item.putInt("color", color);
        item.putInt("productID", productID);
        item.putUtfString("subType", subType);
        item.putInt("quantity", 1);
        item.putUtfString("createdAt", createdAt);
        item.putUtfString("roles", "AA==");
        item.putUtfString("source", "FREE");
        item.putBool("transferrable", false);
        item.putInt("expire", 0);
        item.putInt("base", 1);
        item.putInt("lifeTime", 0);
        item.putInt("timeLeft", 0);
        item.putInt("active", 1);
        
        return item;
    }

    private boolean validateClothesItems(ISFSArray items, List<String> errors) {
        if (items == null || items.size() == 0) {
            errors.add("items_empty");
            return false;
        }
        boolean ok = true;
        for (int i = 0; i < items.size(); i++) {
            ISFSObject item = items.getSFSObject(i);
            if (item == null) {
                errors.add("item_" + i + "_null");
                ok = false;
                continue;
            }
            ok &= validateClothesField(item, i, "clip", "String", errors);
            ok &= validateClothesField(item, i, "subType", "String", errors);
            ok &= validateClothesField(item, i, "productID", "Int", errors);
            ok &= validateClothesField(item, i, "color", "Int", errors);
            ok &= validateClothesField(item, i, "quantity", "Int", errors);
            ok &= validateClothesField(item, i, "roles", "String", errors);
            ok &= validateClothesField(item, i, "source", "String", errors);
            ok &= validateClothesField(item, i, "expire", "Int", errors);
            ok &= validateClothesField(item, i, "transferrable", "Bool", errors);
            ok &= validateClothesField(item, i, "id", "Int", errors);
            ok &= validateClothesField(item, i, "lifeTime", "Int", errors);
            ok &= validateClothesField(item, i, "timeLeft", "Int", errors);
            ok &= validateClothesField(item, i, "createdAt", "String", errors);
        }
        return ok;
    }

    private boolean validateClothesField(ISFSObject item, int index, String key, String expectedType, List<String> errors) {
        if (!item.containsKey(key)) {
            errors.add("item_" + index + "_missing_" + key);
            return false;
        }
        try {
            switch (expectedType) {
                case "String":
                    item.getUtfString(key);
                    break;
                case "Int":
                    item.getInt(key);
                    break;
                case "Bool":
                    item.getBool(key);
                    break;
                default:
                    break;
            }
        } catch (Exception e) {
            errors.add("item_" + index + "_wrongType_" + key + "_expected_" + expectedType);
            return false;
        }
        return true;
    }

    private SFSArray buildClothesKeysArray(ISFSArray items) {
        SFSArray keys = new SFSArray();
        if (items == null) {
            return keys;
        }
        for (int i = 0; i < items.size(); i++) {
            ISFSObject item = items.getSFSObject(i);
            if (item == null || !item.containsKey("clip")) {
                continue;
            }
            try {
                String clip = item.getUtfString("clip");
                if (clip != null && !clip.isEmpty()) {
                    keys.addUtfString(clip);
                }
            } catch (Exception e) {
                // ignore invalid clip entries
            }
        }
        return keys;
    }
}
