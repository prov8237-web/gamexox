package src5;

import com.smartfoxserver.v2.entities.User;
import com.smartfoxserver.v2.entities.data.*;
import com.smartfoxserver.v2.entities.variables.SFSUserVariable;
import java.util.*;

public class ChangeClothesHandler extends OsBaseHandler {
    
    private static final Map<Integer, String> CLOTH_MAP = new HashMap<>();
    
    static {
        // تهيئة الخريطة بكل IDs
        initializeClothMap();
        
        System.out.println("[CHANGECLOTHES] ✅ Initialized cloth map with " + CLOTH_MAP.size() + " items");
    }
    
    @Override
    public void handleClientRequest(User user, ISFSObject params) {
        String username = user.getName();
        trace("[CHANGECLOTHES] 🎽 Request from: " + username);
        
        try {
            // 1. استخراج بيانات الملابس
            ISFSObject data = params.getSFSObject("data");
            if (data == null) {
                trace("[CHANGECLOTHES] ❌ No data object");
                sendSimpleResponse(user);
                return;
            }
            
            ISFSArray clothesArray = data.getSFSArray("clothes");
            if (clothesArray == null || clothesArray.size() == 0) {
                trace("[CHANGECLOTHES] ❌ No clothes array");
                sendSimpleResponse(user);
                return;
            }
            
            // 2. تحويل IDs إلى Clips
            List<String> clips = convertClothIdsToClips(clothesArray);
            
            // 3. تحديث UserVariable للملابس
            updateUserClothes(user, clips);
            
            // 4. إرسال الرد
            SFSObject response = new SFSObject();
            response.putInt("nextRequest", 4000);
            
            reply(user, "changeclothes", response);
            trace("[CHANGECLOTHES] ✅ Changed " + clips.size() + " clothes for " + username);
            
        } catch (Exception e) {
            trace("[CHANGECLOTHES] ❌ Error: " + e.getMessage());
            e.printStackTrace();
            sendSimpleResponse(user);
        }
    }
    
    /**
     * تحويل IDs إلى Clips
     */
    private List<String> convertClothIdsToClips(ISFSArray clothesArray) {
        List<String> clips = new ArrayList<>();
        
        for (int i = 0; i < clothesArray.size(); i++) {
            int clothId = clothesArray.getInt(i);
            String clip = null;
            
            // إذا كان ID = 0، استخدم الملابس الأساسية الافتراضية حسب الموضع
            if (clothId == 0) {
                clip = getDefaultClothByPosition(i);
                if (clip != null) {
                    clips.add(clip);
                    trace("[CHANGECLOTHES] ID 0 at position " + i + " -> " + clip + " (default)");
                    continue;
                }
            }
            
            // البحث في خريطة الملابس
            clip = CLOTH_MAP.get(clothId);
            
            if (clip != null) {
                clips.add(clip);
                trace("[CHANGECLOTHES] ID " + clothId + " -> " + clip);
            } else {
                trace("[CHANGECLOTHES] ⚠️ Unknown cloth ID: " + clothId);
                clips.add("unknown_" + clothId);
            }
        }
        
        return clips;
    }
    
    /**
     * الحصول على الملابس الافتراضية حسب الموضع
     */
    private String getDefaultClothByPosition(int position) {
        // بناءً على اللوج الثاني: ["C_12","B_12","A_12","7_1","2_2","4_1","9_1"]
        switch (position) {
            case 0: return "C_12";   // BODY
            case 1: return "B_12";   // BODY
            case 2: return "A_12";   // BODY
            case 3: return "7_1";    // SHOES
            case 4: return "2_2";    // PANTS
            case 5: return "4_1";    // SHIRT
            case 6: return "9_1";    // HAIR
            default: return "";
        }
    }
    
    /**
     * تحديث متغير الملابس للمستخدم
     */
    private void updateUserClothes(User user, List<String> clips) {
        if (clips.isEmpty()) {
            trace("[CHANGECLOTHES] ⚠️ No clips to update");
            return;
        }
        
        // بناء JSON كما في اللوج
        StringBuilder json = new StringBuilder("[");
        for (int i = 0; i < clips.size(); i++) {
            if (i > 0) json.append(",");
            json.append("\"").append(clips.get(i)).append("\"");
        }
        json.append("]");
        
        String clothesJson = json.toString();
        
        trace("[CHANGECLOTHES] Updating clothes to: " + clothesJson);
        
        // تحديث UserVariable
        SFSUserVariable clothesVar = new SFSUserVariable("clothes", clothesJson);
        
        // تحديث optimizedAssetKey (توقيت عشوائي)
        int optimizedAssetKey = (int) System.currentTimeMillis() % Integer.MAX_VALUE;
        SFSUserVariable optimizedVar = new SFSUserVariable("optimizedAssetKey", optimizedAssetKey);
        
        // تحديث speed
        SFSUserVariable speedVar = new SFSUserVariable("speed", 1.0);
        
        // إزالة hand item
        SFSUserVariable handVar = new SFSUserVariable("hand", null);
        
        getApi().setUserVariables(user, Arrays.asList(clothesVar, optimizedVar, speedVar, handVar));
        
        trace("[CHANGECLOTHES] ✅ Updated clothes variable for " + user.getName());
    }
    
    /**
     * إرسال رد بسيط
     */
    private void sendSimpleResponse(User user) {
        SFSObject response = new SFSObject();
        response.putInt("nextRequest", 4000);
        send("changeclothes", response, user);
    }
    
    /**
     * تهيئة خريطة الملابس بكل IDs
     */
    private static void initializeClothMap() {
        // الملابس الأساسية الافتراضية (من BaseClothesHandler)
        CLOTH_MAP.put(131853563, "C_12");
        CLOTH_MAP.put(131853562, "B_12");
        CLOTH_MAP.put(131853561, "A_12");
        CLOTH_MAP.put(131853564, "7_1");
        CLOTH_MAP.put(131853565, "2_2");
        CLOTH_MAP.put(131853566, "4_1");
        CLOTH_MAP.put(131853567, "9_1");
        
        // من اللوج الأول
        CLOTH_MAP.put(140537374, "0995_3");
        CLOTH_MAP.put(109898408, "0627_7");
        CLOTH_MAP.put(119266844, "0509_13");
        CLOTH_MAP.put(226180864, "j65xuczf_7");
        
        // إضافة كل الملابس الأخرى من ClothListHandler
        addAllClothListItems();
    }
    
    /**
     * إضافة كل عناصر ClothListHandler إلى الخريطة
     */
    private static void addAllClothListItems() {
        // قمصان (SHIRT)
        CLOTH_MAP.put(119397882, "a8_8");
        CLOTH_MAP.put(119397883, "a8_5");
        CLOTH_MAP.put(119397887, "28_9");
        CLOTH_MAP.put(180559480, "f8_9");
        CLOTH_MAP.put(108311674, "d8_7");
        CLOTH_MAP.put(113548542, "d11_10");
        CLOTH_MAP.put(113628145, "d11_7");
        CLOTH_MAP.put(119397890, "gt_9");
        CLOTH_MAP.put(106683336, "r6_3");
        CLOTH_MAP.put(119397980, "rq_3");
        CLOTH_MAP.put(119397769, "ss_9");
        CLOTH_MAP.put(119864536, "sc_3");
        CLOTH_MAP.put(119269685, "nf_9");
        CLOTH_MAP.put(116742402, "nq_9");
        CLOTH_MAP.put(116742401, "ny_9");
        CLOTH_MAP.put(119398276, "sw1_7");
        CLOTH_MAP.put(119818413, "sw1_5");
        CLOTH_MAP.put(119269801, "0303_6");
        CLOTH_MAP.put(119269800, "0306_1");
        CLOTH_MAP.put(84715558, "0507_11");
        CLOTH_MAP.put(119269872, "0507_12");
        CLOTH_MAP.put(119818540, "0484_7");
        CLOTH_MAP.put(119818552, "0484_3");
        CLOTH_MAP.put(111825955, "0510_7");
        CLOTH_MAP.put(111825954, "0513_7");
        CLOTH_MAP.put(109898407, "0627_4");
        CLOTH_MAP.put(119269509, "0627_7");
        CLOTH_MAP.put(119269510, "0627_13");
        CLOTH_MAP.put(84246031, "0790_7");
        CLOTH_MAP.put(180559460, "1023_9");
        CLOTH_MAP.put(180559461, "1023_3");
        CLOTH_MAP.put(180559463, "1023_10");
        CLOTH_MAP.put(113548469, "1026_9");
        CLOTH_MAP.put(113548470, "1026_6");
        CLOTH_MAP.put(113548471, "1026_3");
        CLOTH_MAP.put(113548472, "1026_2");
        CLOTH_MAP.put(117916953, "1026_5");
        CLOTH_MAP.put(119397656, "1026_4");
        CLOTH_MAP.put(119397657, "1026_1");
        CLOTH_MAP.put(119397661, "1026_7");
        CLOTH_MAP.put(118259893, "1422_7");
        CLOTH_MAP.put(116687459, "bngx7Ja6_13");
        CLOTH_MAP.put(83487674, "mbDp52d5_9");
        CLOTH_MAP.put(117916747, "mfghkSp7_11");
        CLOTH_MAP.put(117916746, "mig6tYkc_13");
        CLOTH_MAP.put(119397885, "mj178GHD_4");
        CLOTH_MAP.put(109805779, "mnBgjzm7_9");
        CLOTH_MAP.put(119397891, "mnBgjzm7_1");
        CLOTH_MAP.put(119397892, "mnBgjzm7_3");
        CLOTH_MAP.put(119397893, "mnBgjzm7_7");
        CLOTH_MAP.put(89960004, "mprPgXgN_7");
        CLOTH_MAP.put(101819881, "HmQW0UHY_1");
        CLOTH_MAP.put(116742865, "HmQW0UHY_13");
        CLOTH_MAP.put(109805780, "KnDejIBD_9");
        CLOTH_MAP.put(83487673, "ndhj65k_9");
        CLOTH_MAP.put(117916869, "roRTN78_4");
        CLOTH_MAP.put(119465886, "onBjCBxu_13");
        CLOTH_MAP.put(119476278, "onBjCBxu_10");
        CLOTH_MAP.put(119818414, "onBjCBxu_1");
        CLOTH_MAP.put(119818415, "onBjCBxu_3");
        CLOTH_MAP.put(119818416, "onBjCBxu_7");
        CLOTH_MAP.put(119397976, "bXFHMWHm_6");
        CLOTH_MAP.put(119397977, "bXFHMWHm_7");
        CLOTH_MAP.put(119397978, "bXFHMWHm_1");
        CLOTH_MAP.put(109805774, "csfv84tn_9");
        CLOTH_MAP.put(180437597, "j43gfakt_3");
        CLOTH_MAP.put(180437599, "hy68f595_7");
        CLOTH_MAP.put(176234707, "tcJLfTPC_9");
        CLOTH_MAP.put(174057543, "xz2yj7h6_4");
        CLOTH_MAP.put(174140108, "t5btvtpe_7");
        
        // بنطلونات (PANTS)
        CLOTH_MAP.put(108311675, "d9_7");
        CLOTH_MAP.put(113628157, "d15_7");
        CLOTH_MAP.put(113628179, "d15_8");
        CLOTH_MAP.put(148509818, "d7_3");
        CLOTH_MAP.put(118259951, "ng_9");
        CLOTH_MAP.put(101819880, "sw5_12");
        CLOTH_MAP.put(119872820, "nl54TyO_9");
        CLOTH_MAP.put(109805777, "sv44m4hq_4");
        CLOTH_MAP.put(109805778, "sv44m4hq_7");
        CLOTH_MAP.put(180437598, "c6bd27xg_3");
        CLOTH_MAP.put(180437600, "cguy2rerg_7");
        CLOTH_MAP.put(172704632, "ul_9");
        
        // أحذية وأكسسوارات
        CLOTH_MAP.put(157598965, "cs_1");
        CLOTH_MAP.put(157598966, "cs_8");
        CLOTH_MAP.put(180437603, "qKWsnMuk_3");
        CLOTH_MAP.put(25477818, "68_9");
        
        // قبعات (HAT)
        CLOTH_MAP.put(120298303, "e5_9");
        CLOTH_MAP.put(144845235, "e6_9");
        CLOTH_MAP.put(120298305, "e8_9");
        CLOTH_MAP.put(144845274, "gl_9");
        CLOTH_MAP.put(121460585, "er_2");
        CLOTH_MAP.put(180399353, "1372_12");
        CLOTH_MAP.put(182558176, "1372_4");
        CLOTH_MAP.put(81997393, "1406_8");
        CLOTH_MAP.put(144438043, "k4Zsh2y7_9");
        CLOTH_MAP.put(119767791, "pALzHsIg_9");
        CLOTH_MAP.put(118705239, "EALu6YyH_9");
        CLOTH_MAP.put(120267033, "ONHbIHWuS_3");
        CLOTH_MAP.put(125184223, "azyhuawg_9");
        CLOTH_MAP.put(174057140, "vh6u7ph3_5");
        CLOTH_MAP.put(179336271, "zDUKb4o3_9");
        
        // أكسسوارات (ACCESSORY)
        CLOTH_MAP.put(140537375, "0995_3");
        CLOTH_MAP.put(174056703, "1094_9");
        CLOTH_MAP.put(175959058, "oyyvqf5o_6");
        
        // ملابس كاملة (COSTUME)
        CLOTH_MAP.put(175966563, "cv_13");
        CLOTH_MAP.put(109806250, "p7_7");
        CLOTH_MAP.put(109806163, "nj_4");
        CLOTH_MAP.put(140537379, "0018_7");
        CLOTH_MAP.put(180399352, "0560_9");
        CLOTH_MAP.put(182558173, "0560_9");
        CLOTH_MAP.put(107735202, "1164_3");
        CLOTH_MAP.put(82260699, "1498_4");
        CLOTH_MAP.put(118214347, "4t9fcyc9_7");
        CLOTH_MAP.put(122837353, "K7dhX9sJ_11");
        CLOTH_MAP.put(120297267, "06h36hb2_7");
        CLOTH_MAP.put(120297266, "yzsx37uv_9");
        CLOTH_MAP.put(226203698, "z7r7qctx_7");
        CLOTH_MAP.put(119083043, "A0Ukj1zA_9");
        CLOTH_MAP.put(119106937, "5T0LHj8c_9");
        CLOTH_MAP.put(119075679, "ZTlvrZ2P_9");
        
        // أقنعة (MASK)
        CLOTH_MAP.put(119106958, "3Za9vBK8_9");
        CLOTH_MAP.put(119106981, "xOWOAPpM_9");
        CLOTH_MAP.put(176777506, "XrvfyBJs_9");
        
        // شعر (HAIR)
        CLOTH_MAP.put(234965117, "HxvxM1pG_12");
        
        // إفكت (EFFECT)
        CLOTH_MAP.put(157310174, "pV21xxs2_9");
        CLOTH_MAP.put(191957515, "w8v3itry_3");
    }
}