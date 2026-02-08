package src5;

import com.smartfoxserver.v2.entities.User;
import com.smartfoxserver.v2.entities.data.*;
import com.smartfoxserver.v2.entities.variables.*;
import java.util.*;

public class SaveBaseClothesHandler extends OsBaseHandler {
    
    @Override
    public void handleClientRequest(User user, ISFSObject params) {
        String ip = user.getSession().getAddress();
        InMemoryStore.UserState state = getStore().getOrCreateUser(user);
        
        trace("[SAVEBASECLOTHES] ═══════════════════════════════════════════");
        trace("[SAVEBASECLOTHES] Request from: " + user.getName() + " IP: " + ip);
        
        // Get PlayerID
        String persistentID = (String) getParentExtension().getParentZone().getProperty(ip + "_id");
        if (persistentID == null) {
            persistentID = String.valueOf(System.currentTimeMillis());
            getParentExtension().getParentZone().setProperty(ip + "_id", persistentID);
        }
        trace("[SAVEBASECLOTHES] Using ID: " + persistentID);
        
        // ═══════════════════════════════════════════════════════════
        // FIX: البيانات موجودة جوه "data" object مش في params مباشرة!
        // ═══════════════════════════════════════════════════════════
        ISFSObject data = params;
        if (params.containsKey("data")) {
            data = params.getSFSObject("data");
            trace("[SAVEBASECLOTHES] Found data object, using it");
        }
        
        // Extract data
        String avatarName = data.containsKey("avatarName") ? data.getUtfString("avatarName") : "Guest";
        String gender = data.containsKey("gender") ? data.getUtfString("gender") : "m";
        state.setAvatarName(avatarName);
        state.setGender(gender);
        
        trace("[SAVEBASECLOTHES] Avatar: " + avatarName + ", Gender: " + gender);
        
        // Build clothes object for storage
        SFSObject clothesObj = new SFSObject();
        clothesObj.putUtfString("type", "CLOTH");
        SFSArray items = new SFSArray();

        if (data.containsKey("clothes")) {
            ISFSArray chosen = data.getSFSArray("clothes");
            trace("[SAVEBASECLOTHES] Processing " + chosen.size() + " items...");
            
            for (int i = 0; i < chosen.size(); i++) {
                ISFSObject row = chosen.getSFSObject(i);
                SFSObject item = new SFSObject();
                
                String clip = row.getUtfString("clip");
                String colorStr = row.getUtfString("color");
                int color = Integer.parseInt(colorStr);
                int productID = getProductIDByClip(clip);
                String subType = getSubTypeByClip(clip);
                
                trace("[SAVEBASECLOTHES] Item " + i + ": clip=" + clip + ", color=" + colorStr + 
                      ", productID=" + productID + ", subType=" + subType);
                
                // Matching official response structure exactly
                item.putInt("quantity", 1);
                item.putInt("color", color);
                java.text.SimpleDateFormat sdf = new java.text.SimpleDateFormat("yyyy-MM-dd HH:mm:ss.S", java.util.Locale.US);
                item.putUtfString("createdAt", sdf.format(new java.util.Date()));
                item.putUtfString("roles", "AA==");
                item.putInt("active", 1);
                item.putUtfString("source", "FREE");
                item.putInt("expire", 0);
                item.putBool("transferrable", false);
                item.putInt("base", 1);
                item.putInt("productID", productID);
                item.putInt("id", i + 100000);
                item.putUtfString("subType", subType);
                item.putInt("lifeTime", 0);
                item.putUtfString("clip", clip + "_" + colorStr);
                item.putInt("timeLeft", 0);
                
                items.addSFSObject(item);
            }
        } else {
            trace("[SAVEBASECLOTHES] WARNING: No 'clothes' key in data!");
        }
        
        clothesObj.putSFSArray("items", items);
        trace("[SAVEBASECLOTHES] Total items to save: " + items.size());
        state.setClothesItems(items);

        // Save to Zone Properties
        getParentExtension().getParentZone().setProperty(ip + "_active", Boolean.TRUE);
        getParentExtension().getParentZone().setProperty(ip + "_clothes", clothesObj);
        getParentExtension().getParentZone().setProperty(ip + "_name", avatarName);
        getParentExtension().getParentZone().setProperty(ip + "_gender", gender);
        
        List<UserVariable> vars = new ArrayList<>();
        vars.add(new SFSUserVariable("avatarName", avatarName));
        vars.add(new SFSUserVariable("gender", gender));
        vars.add(new SFSUserVariable("clothes", state.getClothesJson()));
        getApi().setUserVariables(user, vars);
        
        // Verify save
        trace("[SAVEBASECLOTHES] Verifying save...");
        Object savedClothes = getParentExtension().getParentZone().getProperty(ip + "_clothes");
        if (savedClothes != null && savedClothes instanceof ISFSObject) {
            ISFSObject sc = (ISFSObject) savedClothes;
            if (sc.containsKey("items")) {
                trace("[SAVEBASECLOTHES] ✅ Verified: " + sc.getSFSArray("items").size() + " items saved");
            }
        }
        
        // Send response
        SFSObject res = new SFSObject();
        res.putInt("nextRequest", 1000);
        reply(user, "savebaseclothes", res);

        SFSObject changeRes = new SFSObject();
        sendValidated(user, "changeclothes", changeRes);
        
        trace("[SAVEBASECLOTHES] ✅ Complete");
        trace("[SAVEBASECLOTHES] ═══════════════════════════════════════════");
    }

    /**
     * ✅ FIXED: Correct productID mapping based on BaseClothesHandler.java
     */
    private int getProductIDByClip(String clip) {
        if (clip == null) return 0;
        
        switch (clip.toUpperCase()) {
            // BODY / FACE / HEAD (placeBit 4, 2, 1)
            case "A": return 1344;  // BODY
            case "B": return 1348;  // FACE
            case "C": return 1349;  // HEAD
            
            // PANTS (placeBit 64)
            case "1": return 2;
            case "2": return 136;
            case "3": return 20;
            
            // SHIRT (placeBit 512)
            case "4": return 149;
            case "5": return 28;    // ✅ FIXED: was 21, correct is 28
            case "13": return 6;
            
            // SHOES (placeBit 16)
            case "7": return 31;
            
            // HAIR (placeBit 131072)
            case "6": return 30;    // Note: 6 is HAIR, not SHOES!
            case "8": return 32;
            case "9": return 33;
            case "10": return 3;
            case "11": return 4;
            case "12": return 5;
            
            // Special items
            case "U9OENJCZ": return 10231;
            
            default: 
                trace("[SAVEBASECLOTHES] ⚠️ Unknown clip: " + clip);
                return 0;
        }
    }

    /**
     * ✅ FIXED: Correct subType mapping based on placeBit values
     * 
     * PlaceBit mapping:
     * - 4 = BODY
     * - 2 = FACE
     * - 1 = HEAD
     * - 512 = SHIRT
     * - 64 = PANTS
     * - 16 = SHOES
     * - 131072 = HAIR
     */
    private String getSubTypeByClip(String clip) {
        if (clip == null) return "BODY";
        
        String c = clip.toUpperCase();
        
        // BODY / FACE / HEAD
        if (c.equals("A")) return "BODY";
        if (c.equals("B")) return "FACE";
        if (c.equals("C")) return "HEAD";
        
        // HAIR (placeBit 131072) - clips: 6, 8, 9, 10, 11, 12, 13* 
        // Note: clip "6" has placeBit 131072 (HAIR) not 16 (SHOES)!
        if (c.equals("6") || c.equals("8") || c.equals("9") || 
            c.equals("10") || c.equals("11") || c.equals("12")) {
            return "HAIR";
        }
        
        // SHOES (placeBit 16) - clip: 7
        if (c.equals("7")) {
            return "SHOES";
        }
        
        // PANTS (placeBit 64) - clips: 1, 2, 3
        if (c.equals("1") || c.equals("2") || c.equals("3")) {
            return "PANTS";
        }
        
        // SHIRT (placeBit 512) - clips: 4, 5, 13
        if (c.equals("4") || c.equals("5") || c.equals("13") || c.equals("U9OENJCZ")) {
            return "SHIRT";
        }
        
        // Default
        trace("[SAVEBASECLOTHES] ⚠️ Unknown clip for subType: " + clip + ", defaulting to BODY");
        return "BODY";
    }
}