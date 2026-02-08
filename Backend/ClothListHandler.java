package src5;

import com.smartfoxserver.v2.entities.User;
import com.smartfoxserver.v2.entities.data.*;
import java.util.Base64;

public class ClothListHandler extends OsBaseHandler {
    
    @Override
    public void handleClientRequest(User user, ISFSObject params) {
        String username = user.getName();
        String ip = user.getSession().getAddress();
        int userId = user.getId();

        trace("[CLOTHLIST] 📦 Request from: " + username + " (ID: " + userId + ") IP: " + ip);

        // ═══════════════════════════════════════════════════════════
        // ✅ بناء الرد بالضبط زي اللوج
        // ═══════════════════════════════════════════════════════════
        SFSObject res = new SFSObject();
        res.putUtfString("type", "CLOTH");
        res.putSFSArray("items", buildAllClothesFromLog());
        res.putInt("nextRequest", 1000);
        
        // ═══════════════════════════════════════════════════════════
        // ✅ إرسال الرد مباشرة
        // ═══════════════════════════════════════════════════════════
        reply(user, "clothlist", res);

        // طباعة تفاصيل للتتبع
        trace("[CLOTHLIST] =========================================");
        trace("[CLOTHLIST] ✅ SENT EXACTLY LIKE LOG");
        trace("[CLOTHLIST] Items Count: " + res.getSFSArray("items").size());
        trace("[CLOTHLIST] =========================================");
    }

    /**
     * ✅ بناء كل الملابس من اللوج بالضبط - 132 قطعة
     */
    private ISFSArray buildAllClothesFromLog() {
        SFSArray items = new SFSArray();
        
        // ═══════════════════════════════════════════════════════════
        // ✅ كل الملابس من اللوج بالضبط
        // ═══════════════════════════════════════════════════════════
        
        // 1. الملابس الأساسية (base=1) - 7 قطع
        items.addSFSObject(createItem(131853564, "7_1", "SHOES", 1, 31, 0, "FREE", 1, 0, false, "AA==", "2018-07-04 20:09:34.0", 0, 0));
        items.addSFSObject(createItem(131853567, "9_1", "HAIR", 1, 33, 0, "FREE", 1, 0, false, "AA==", "2018-07-04 20:09:34.0", 0, 0));
        items.addSFSObject(createItem(131853565, "2_2", "PANTS", 2, 136, 0, "FREE", 1, 0, false, "", "2018-07-04 20:09:34.0", 0, 0));
        items.addSFSObject(createItem(131853566, "4_1", "SHIRT", 1, 149, 0, "FREE", 1, 0, false, "AA==", "2018-07-04 20:09:34.0", 0, 0));
        items.addSFSObject(createItem(131853563, "A_12", "BODY", 12, 1344, 0, "FREE", 1, 0, true, "AA==", "2018-07-04 20:09:34.0", 0, 0));
        items.addSFSObject(createItem(131853562, "B_12", "BODY", 12, 1348, 0, "FREE", 1, 0, true, "AA==", "2018-07-04 20:09:34.0", 0, 0));
        items.addSFSObject(createItem(131853561, "C_12", "BODY", 12, 1349, 0, "FREE", 1, 0, true, "AA==", "2018-07-04 20:09:34.0", 0, 0));

        // 2. قمصان (SHIRT) - 36 قطعة
        items.addSFSObject(createItem(119397882, "a8_8", "SHIRT", 8, 163, 2592000, "SHOPPING_BUY", 0, 2592000, false, "", "2018-02-25 19:18:47.0", 0, 1));
        items.addSFSObject(createItem(119397883, "a8_5", "SHIRT", 5, 163, 2592000, "SHOPPING_BUY", 0, 2592000, false, "", "2018-02-25 19:18:47.0", 0, 1));
        items.addSFSObject(createItem(119397887, "28_9", "SHIRT", 9, 721, 2592000, "SHOPPING_BUY", 0, 2592000, false, "", "2018-02-25 19:18:47.0", 0, 1));
        items.addSFSObject(createItem(180559480, "f8_9", "SHIRT", 9, 1512, 2592000, "SHOPPING_BUY", 0, 2592000, false, "", "2021-01-12 10:50:40.0", 0, 1));
        items.addSFSObject(createItem(108311674, "d8_7", "SHIRT", 7, 1575, 2592000, "SHOPPING_BUY", 0, 2592000, false, "AA==", "2017-11-08 18:06:29.0", 0, 1));
        items.addSFSObject(createItem(113548542, "d11_10", "SHIRT", 10, 1584, 2592000, "SHOPPING_BUY", 0, 2592000, false, "", "2017-12-28 14:09:55.0", 0, 1));
        items.addSFSObject(createItem(113628145, "d11_7", "SHIRT", 7, 1584, 2592000, "SHOPPING_BUY", 0, 2592000, false, "", "2017-12-29 09:04:43.0", 0, 1));
        items.addSFSObject(createItem(119397890, "gt_9", "SHIRT", 9, 1611, 2592000, "SHOPPING_BUY", 0, 2592000, false, "", "2018-02-25 19:18:47.0", 0, 1));
        items.addSFSObject(createItem(106683336, "r6_3", "SHIRT", 3, 2007, 2592000, "SHOPPING_BUY", 0, 2592000, false, "", "2017-10-20 23:07:52.0", 0, 1));
        items.addSFSObject(createItem(119397980, "rq_3", "SHIRT", 3, 2018, 2592000, "SHOPPING_BUY", 0, 2592000, false, "", "2018-02-25 19:19:31.0", 0, 1));
        items.addSFSObject(createItem(119397769, "ss_9", "SHIRT", 9, 2053, 2592000, "SHOPPING_BUY", 0, 2592000, false, "AA==", "2018-02-25 19:18:07.0", 0, 1));
        items.addSFSObject(createItem(119864536, "sc_3", "SHIRT", 3, 2055, 2592000, "SHOPPING_BUY", 0, 2592000, false, "AA==", "2018-03-03 15:26:40.0", 0, 1));
        items.addSFSObject(createItem(119269685, "nf_9", "SHIRT", 9, 2132, 2592000, "SHOPPING_BUY", 0, 2592000, false, "ACA=", "2018-02-24 05:22:14.0", 0, 1));
        items.addSFSObject(createItem(116742402, "nq_9", "SHIRT", 9, 2160, 2592000, "SHOPPING_BUY", 0, 2592000, false, "ACA=", "2018-01-26 16:21:03.0", 0, 2));
        items.addSFSObject(createItem(116742401, "ny_9", "SHIRT", 9, 2166, 2592000, "SHOPPING_BUY", 0, 2592000, false, "ACA=", "2018-01-26 16:21:03.0", 0, 1));
        items.addSFSObject(createItem(119398276, "sw1_7", "SHIRT", 7, 2224, 2592000, "SHOPPING_BUY", 0, 2592000, false, "", "2018-02-25 19:22:49.0", 0, 1));
        items.addSFSObject(createItem(119818413, "sw1_5", "SHIRT", 5, 2224, 2592000, "SHOPPING_BUY", 0, 2592000, false, "", "2018-03-03 02:37:43.0", 0, 1));
        items.addSFSObject(createItem(119269801, "0303_6", "SHIRT", 6, 2580, 2592000, "SHOPPING_BUY", 0, 2592000, false, "ACA=", "2018-02-24 05:23:42.0", 0, 1));
        items.addSFSObject(createItem(119269800, "0306_1", "SHIRT", 1, 2583, 2592000, "SHOPPING_BUY", 0, 2592000, false, "ACA=", "2018-02-24 05:23:42.0", 0, 1));
        items.addSFSObject(createItem(84715558, "0507_11", "SHIRT", 11, 2855, 2592000, "SHOPPING_BUY", 0, 2592000, false, "ACA=", "2017-02-03 20:16:00.0", 0, 1));
        items.addSFSObject(createItem(119269872, "0507_12", "SHIRT", 12, 2855, 2592000, "SHOPPING_BUY", 0, 2592000, false, "ACA=", "2018-02-24 05:24:17.0", 0, 1));
        items.addSFSObject(createItem(119818540, "0484_7", "SHIRT", 7, 2858, 2592000, "SHOPPING_BUY", 0, 2592000, false, "AA==", "2018-03-03 02:39:34.0", 0, 1));
        items.addSFSObject(createItem(119818552, "0484_3", "SHIRT", 3, 2858, 2592000, "SHOPPING_BUY", 0, 2592000, false, "AA==", "2018-03-03 02:39:46.0", 0, 1));
        items.addSFSObject(createItem(111825955, "0510_7", "SHIRT", 7, 2861, 2592000, "SHOPPING_BUY", 0, 2592000, false, "AA==", "2017-12-12 00:08:54.0", 0, 1));
        items.addSFSObject(createItem(111825954, "0513_7", "SHIRT", 7, 2947, 2592000, "SHOPPING_BUY", 0, 2592000, false, "", "2017-12-12 00:08:54.0", 0, 1));
        items.addSFSObject(createItem(109898407, "0627_4", "SHIRT", 4, 3140, 2592000, "SHOPPING_BUY", 0, 2592000, false, "ACA=", "2017-11-25 17:22:53.0", 0, 2));
        items.addSFSObject(createItem(109898408, "0627_7", "SHIRT", 7, 3140, 2317128, "SHOPPING_BUY", 0, 2592000, true, "ACA=", "2017-11-25 17:22:53.0", 1772516056, 1));
        items.addSFSObject(createItem(119269509, "0627_7", "SHIRT", 7, 3140, 2592000, "SHOPPING_BUY", 0, 2592000, false, "ACA=", "2018-02-24 05:18:41.0", 0, 1));
        items.addSFSObject(createItem(119269510, "0627_13", "SHIRT", 13, 3140, 2592000, "SHOPPING_BUY", 0, 2592000, false, "ACA=", "2018-02-24 05:18:41.0", 0, 1));
        items.addSFSObject(createItem(84246031, "0790_7", "SHIRT", 7, 3266, 1296000, "PACKAGE", 0, 1296000, false, "AA==", "2017-01-28 03:26:56.0", 0, 1));
        items.addSFSObject(createItem(180559460, "1023_9", "SHIRT", 9, 3557, 2592000, "SHOPPING_BUY", 0, 2592000, false, "", "2021-01-12 10:49:35.0", 0, 2));
        items.addSFSObject(createItem(180559461, "1023_3", "SHIRT", 3, 3557, 2592000, "SHOPPING_BUY", 0, 2592000, false, "", "2021-01-12 10:49:35.0", 0, 2));
        items.addSFSObject(createItem(180559463, "1023_10", "SHIRT", 10, 3557, 2592000, "SHOPPING_BUY", 0, 2592000, false, "", "2021-01-12 10:49:35.0", 0, 1));
        items.addSFSObject(createItem(113548469, "1026_9", "SHIRT", 9, 3561, 2592000, "SHOPPING_BUY", 0, 2592000, false, "", "2017-12-28 14:09:00.0", 0, 1));
        items.addSFSObject(createItem(113548470, "1026_6", "SHIRT", 6, 3561, 2592000, "SHOPPING_BUY", 0, 2592000, false, "", "2017-12-28 14:09:00.0", 0, 1));
        items.addSFSObject(createItem(113548471, "1026_3", "SHIRT", 3, 3561, 2592000, "SHOPPING_BUY", 0, 2592000, false, "", "2017-12-28 14:09:00.0", 0, 3));
        items.addSFSObject(createItem(113548472, "1026_2", "SHIRT", 2, 3561, 2592000, "SHOPPING_BUY", 0, 2592000, false, "", "2017-12-28 14:09:00.0", 0, 1));
        items.addSFSObject(createItem(117916953, "1026_5", "SHIRT", 5, 3561, 2592000, "SHOPPING_BUY", 0, 2592000, false, "", "2018-02-05 17:15:28.0", 0, 2));
        items.addSFSObject(createItem(119397656, "1026_4", "SHIRT", 4, 3561, 2592000, "SHOPPING_BUY", 0, 2592000, false, "", "2018-02-25 19:17:31.0", 0, 1));
        items.addSFSObject(createItem(119397657, "1026_1", "SHIRT", 1, 3561, 2592000, "SHOPPING_BUY", 0, 2592000, false, "", "2018-02-25 19:17:31.0", 0, 1));
        items.addSFSObject(createItem(119397661, "1026_7", "SHIRT", 7, 3561, 2592000, "SHOPPING_BUY", 0, 2592000, false, "", "2018-02-25 19:17:31.0", 0, 1));
        items.addSFSObject(createItem(118259893, "1422_7", "SHIRT", 7, 7118, 2592000, "SHOPPING_BUY", 0, 2592000, false, "ACA=", "2018-02-10 16:54:50.0", 0, 1));
        items.addSFSObject(createItem(116687459, "bngx7Ja6_13", "SHIRT", 13, 7701, 2592000, "SHOPPING_BUY", 0, 2592000, false, "AA==", "2018-01-26 05:27:56.0", 0, 1));
        items.addSFSObject(createItem(83487674, "mbDp52d5_9", "SHIRT", 9, 8011, 2592000, "SHOPPING_BUY", 0, 2592000, false, "ACA=", "2017-01-21 00:45:27.0", 0, 1));
        items.addSFSObject(createItem(117916747, "mfghkSp7_11", "SHIRT", 11, 8017, 2592000, "SHOPPING_BUY", 0, 2592000, false, "AA==", "2018-02-05 17:14:00.0", 0, 2));
        items.addSFSObject(createItem(117916746, "mig6tYkc_13", "SHIRT", 13, 8023, 2592000, "SHOPPING_BUY", 0, 2592000, false, "", "2018-02-05 17:14:00.0", 0, 1));
        items.addSFSObject(createItem(119397885, "mj178GHD_4", "SHIRT", 4, 8024, 2592000, "SHOPPING_BUY", 0, 2592000, false, "AA==", "2018-02-25 19:18:47.0", 0, 1));
        items.addSFSObject(createItem(109805779, "mnBgjzm7_9", "SHIRT", 9, 8031, 2592000, "SHOPPING_BUY", 0, 2592000, false, "AA==", "2017-11-24 21:33:13.0", 0, 1));
        items.addSFSObject(createItem(119397891, "mnBgjzm7_1", "SHIRT", 1, 8031, 2592000, "SHOPPING_BUY", 0, 2592000, false, "AA==", "2018-02-25 19:18:47.0", 0, 1));
        items.addSFSObject(createItem(119397892, "mnBgjzm7_3", "SHIRT", 3, 8031, 2592000, "SHOPPING_BUY", 0, 2592000, false, "AA==", "2018-02-25 19:18:47.0", 0, 1));
        items.addSFSObject(createItem(119397893, "mnBgjzm7_7", "SHIRT", 7, 8031, 2592000, "SHOPPING_BUY", 0, 2592000, false, "AA==", "2018-02-25 19:18:47.0", 0, 1));
        items.addSFSObject(createItem(89960004, "mprPgXgN_7", "SHIRT", 7, 8034, 2592000, "SHOPPING_BUY", 0, 2592000, false, "AA==", "2017-05-05 20:51:08.0", 0, 1));
        items.addSFSObject(createItem(101819881, "HmQW0UHY_1", "SHIRT", 1, 9073, 2592000, "SHOPPING_BUY", 0, 2592000, false, "ACA=", "2017-09-01 15:30:13.0", 0, 1));
        items.addSFSObject(createItem(116742865, "HmQW0UHY_13", "SHIRT", 13, 9073, 2592000, "SHOPPING_BUY", 0, 2592000, false, "ACA=", "2018-01-26 16:22:27.0", 0, 2));
        items.addSFSObject(createItem(109805780, "KnDejIBD_9", "SHIRT", 9, 9099, 2592000, "SHOPPING_BUY", 0, 2592000, false, "AA==", "2017-11-24 21:33:13.0", 0, 1));
        items.addSFSObject(createItem(83487673, "ndhj65k_9", "SHIRT", 9, 9290, 2592000, "SHOPPING_BUY", 0, 2592000, false, "ACA=", "2017-01-21 00:45:27.0", 0, 1));
        items.addSFSObject(createItem(117916869, "roRTN78_4", "SHIRT", 4, 9296, 2592000, "SHOPPING_BUY", 0, 2592000, false, "AA==", "2018-02-05 17:14:51.0", 0, 1));
        items.addSFSObject(createItem(119465886, "onBjCBxu_13", "SHIRT", 13, 9301, 2592000, "SHOPPING_BUY", 0, 2592000, false, "AA==", "2018-02-26 17:50:11.0", 0, 1));
        items.addSFSObject(createItem(119476278, "onBjCBxu_10", "SHIRT", 10, 9301, 2592000, "SHOPPING_BUY", 0, 2592000, false, "AA==", "2018-02-26 20:34:58.0", 0, 1));
        items.addSFSObject(createItem(119818414, "onBjCBxu_1", "SHIRT", 1, 9301, 2592000, "SHOPPING_BUY", 0, 2592000, false, "AA==", "2018-03-03 02:37:43.0", 0, 1));
        items.addSFSObject(createItem(119818415, "onBjCBxu_3", "SHIRT", 3, 9301, 2592000, "SHOPPING_BUY", 0, 2592000, false, "AA==", "2018-03-03 02:37:43.0", 0, 1));
        items.addSFSObject(createItem(119818416, "onBjCBxu_7", "SHIRT", 7, 9301, 2592000, "SHOPPING_BUY", 0, 2592000, false, "AA==", "2018-03-03 02:37:43.0", 0, 1));
        items.addSFSObject(createItem(119397976, "bXFHMWHm_6", "SHIRT", 6, 9311, 2592000, "SHOPPING_BUY", 0, 2592000, false, "AA==", "2018-02-25 19:19:31.0", 0, 1));
        items.addSFSObject(createItem(119397977, "bXFHMWHm_7", "SHIRT", 7, 9311, 2592000, "SHOPPING_BUY", 0, 2592000, false, "AA==", "2018-02-25 19:19:31.0", 0, 1));
        items.addSFSObject(createItem(119397978, "bXFHMWHm_1", "SHIRT", 1, 9311, 2592000, "SHOPPING_BUY", 0, 2592000, false, "AA==", "2018-02-25 19:19:31.0", 0, 1));
        items.addSFSObject(createItem(109805774, "csfv84tn_9", "SHIRT", 9, 10239, 2592000, "SHOPPING_BUY", 0, 2592000, false, "AA==", "2017-11-24 21:33:13.0", 0, 1));
        items.addSFSObject(createItem(180437597, "j43gfakt_3", "SHIRT", 3, 11568, 2592000, "SHOPPING_BUY", 0, 2592000, false, "AA==", "2021-01-08 19:16:03.0", 0, 1));
        items.addSFSObject(createItem(180437599, "hy68f595_7", "SHIRT", 7, 11569, 2592000, "SHOPPING_BUY", 0, 2592000, false, "AA==", "2021-01-08 19:16:03.0", 0, 1));
        items.addSFSObject(createItem(176234707, "tcJLfTPC_9", "SHIRT", 9, 12238, 2592000, "SHOPPING_BUY", 0, 2592000, false, "AA==", "2020-09-18 12:52:10.0", 0, 1));
        items.addSFSObject(createItem(174057543, "xz2yj7h6_4", "SHIRT", 4, 12372, 2592000, "SHOPPING_BUY", 0, 2592000, false, "AA==", "2020-07-27 23:16:53.0", 0, 2));
        items.addSFSObject(createItem(174140108, "t5btvtpe_7", "SHIRT", 7, 11145, 2592000, "SHOPPING_BUY", 0, 2592000, false, "AA==", "2020-07-29 15:27:22.0", 0, 1));

        // 3. بنطلونات (PANTS) - 13 قطعة
        items.addSFSObject(createItem(108311675, "d9_7", "PANTS", 7, 1576, 2592000, "SHOPPING_BUY", 0, 2592000, false, "AA==", "2017-11-08 18:06:29.0", 0, 1));
        items.addSFSObject(createItem(113628157, "d15_7", "PANTS", 7, 1585, 2592000, "SHOPPING_BUY", 0, 2592000, false, "", "2017-12-29 09:04:51.0", 0, 1));
        items.addSFSObject(createItem(113628179, "d15_8", "PANTS", 8, 1585, 2592000, "SHOPPING_BUY", 0, 2592000, false, "", "2017-12-29 09:05:08.0", 0, 1));
        items.addSFSObject(createItem(148509818, "d7_3", "PANTS", 3, 1613, 2592000, "SHOPPING_BUY", 0, 2592000, false, "AA==", "2019-03-09 00:17:32.0", 0, 1));
        items.addSFSObject(createItem(118259951, "ng_9", "PANTS", 9, 2134, 2592000, "SHOPPING_BUY", 0, 2592000, false, "ACA=", "2018-02-10 16:56:06.0", 0, 1));
        items.addSFSObject(createItem(101819880, "sw5_12", "PANTS", 12, 2311, 2592000, "SHOPPING_BUY", 0, 2592000, false, "ACA=", "2017-09-01 15:30:13.0", 0, 1));
        items.addSFSObject(createItem(119266844, "0509_13", "PANTS", 13, 3143, 2317128, "SHOPPING_BUY", 0, 2592000, true, "ACA=", "2018-02-24 03:38:02.0", 1772516056, 1));
        items.addSFSObject(createItem(119872820, "nl54TyO_9", "PANTS", 9, 9292, 2592000, "SHOPPING_BUY", 0, 2592000, false, "AA==", "2018-03-03 17:12:38.0", 0, 1));
        items.addSFSObject(createItem(109805777, "sv44m4hq_4", "PANTS", 4, 10257, 2592000, "SHOPPING_BUY", 0, 2592000, false, "AA==", "2017-11-24 21:33:13.0", 0, 1));
        items.addSFSObject(createItem(109805778, "sv44m4hq_7", "PANTS", 7, 10257, 2592000, "SHOPPING_BUY", 0, 2592000, false, "AA==", "2017-11-24 21:33:13.0", 0, 1));
        items.addSFSObject(createItem(180437598, "c6bd27xg_3", "PANTS", 3, 11570, 2592000, "SHOPPING_BUY", 0, 2592000, false, "AA==", "2021-01-08 19:16:03.0", 0, 1));
        items.addSFSObject(createItem(180437600, "cguy2rerg_7", "PANTS", 7, 11571, 2592000, "SHOPPING_BUY", 0, 2592000, false, "AA==", "2021-01-08 19:16:03.0", 0, 1));
        items.addSFSObject(createItem(172704632, "ul_9", "PANTS", 9, 2362, 86400, "SHOPPING_BUY", 0, 86400, false, "AA==", "2020-07-03 21:23:32.0", 0, 6));

        // 4. أحذية وأكسسوارات - 6 قطع
        items.addSFSObject(createItem(157598965, "cs_1", "GLASSES", 1, 1702, 2592000, "SHOPPING_BUY", 0, 2592000, false, "", "2019-08-11 01:05:31.0", 0, 1));
        items.addSFSObject(createItem(157598966, "cs_8", "GLASSES", 8, 1702, 2592000, "SHOPPING_BUY", 0, 2592000, false, "", "2019-08-11 01:05:31.0", 0, 1));
        items.addSFSObject(createItem(226180864, "j65xuczf_7", "SHOES", 7, 13913, 2317128, "SHOPPING_BUY", 0, 2592000, true, "AA==", "2025-01-31 03:12:49.0", 1772516056, 1));
        items.addSFSObject(createItem(180437603, "qKWsnMuk_3", "SHOES", 3, 14598, 2592000, "SHOPPING_BUY", 0, 2592000, false, "AA==", "2021-01-08 19:16:03.0", 0, 1));
        items.addSFSObject(createItem(25477818, "68_9", "GLASSES", 9, 1193, 604800, "PACKAGE", 0, 604800, false, "", "2016-02-26 18:32:14.0", 0, 1));

        // 5. قبعات (HAT) - 16 قطعة
        items.addSFSObject(createItem(120298303, "e5_9", "HAT", 9, 1292, 2592000, "SHOPPING_BUY", 0, 2592000, false, "", "2018-03-09 01:09:59.0", 0, 1));
        items.addSFSObject(createItem(144845235, "e6_9", "HAT", 9, 1293, 2592000, "SHOPPING_BUY", 0, 2592000, false, "", "2018-12-29 19:54:19.0", 0, 1));
        items.addSFSObject(createItem(120298305, "e8_9", "HAT", 9, 1295, 2592000, "SHOPPING_BUY", 0, 2592000, false, "", "2018-03-09 01:10:03.0", 0, 1));
        items.addSFSObject(createItem(144845274, "gl_9", "HAT", 9, 1504, 2592000, "SHOPPING_BUY", 0, 2592000, false, "AA==", "2018-12-29 19:56:09.0", 0, 1));
        items.addSFSObject(createItem(121460585, "er_2", "HAT", 2, 1885, 604800, "SHOPPING_BUY", 0, 604800, false, "", "2018-03-22 18:53:15.0", 0, 1));
        items.addSFSObject(createItem(180399353, "1372_12", "HAT", 12, 7104, 2317128, "PACKAGE", 0, 2592000, true, "", "2021-01-07 18:55:38.0", 1772516056, 1));
        items.addSFSObject(createItem(182558176, "1372_4", "HAT", 4, 7104, 2592000, "PACKAGE", 0, 2592000, false, "", "2021-03-24 21:40:43.0", 0, 3));
        items.addSFSObject(createItem(81997393, "1406_8", "HAT", 8, 7109, 2592000, "SHOPPING_BUY", 0, 2592000, false, "ACA=", "2017-01-05 21:42:09.0", 0, 1));
        items.addSFSObject(createItem(144438043, "k4Zsh2y7_9", "HAT", 9, 7931, 2592000, "SHOPPING_BUY", 0, 2592000, false, "AA==", "2018-12-18 16:48:00.0", 0, 1));
        items.addSFSObject(createItem(119767791, "pALzHsIg_9", "HAT", 9, 9602, 2592000, "SHOPPING_BUY", 0, 2592000, false, "AA==", "2018-03-02 13:40:43.0", 0, 1));
        items.addSFSObject(createItem(118705239, "EALu6YyH_9", "HAT", 9, 9615, 2592000, "SHOPPING_BUY", 0, 2592000, false, "AA==", "2018-02-16 23:28:11.0", 0, 1));
        items.addSFSObject(createItem(120267033, "ONHbIHWuS_3", "HAT", 3, 10160, 2592000, "SHOPPING_BUY", 0, 2592000, false, "AA==", "2018-03-08 17:44:09.0", 0, 1));
        items.addSFSObject(createItem(125184223, "azyhuawg_9", "HAT", 9, 10680, 2592000, "PACKAGE", 0, 2592000, false, "AAAAgA==", "2018-05-04 21:33:03.0", 0, 1));
        items.addSFSObject(createItem(174057140, "vh6u7ph3_5", "HAT", 5, 11456, 2592000, "SHOPPING_BUY", 0, 2592000, false, "AAAAgA==", "2020-07-27 23:05:42.0", 0, 1));
        items.addSFSObject(createItem(179336271, "zDUKb4o3_9", "HAT", 9, 14519, 0, "PACKAGE", 0, 0, false, "AAAAgA==", "2020-12-06 15:51:29.0", 0, 1));

        // 6. أكسسوارات (ACCESSORY) - 4 قطع
        items.addSFSObject(createItem(140537374, "0995_3", "ACCESSORY", 3, 3461, 6508, "SHOPPING_BUY", 0, 86400, true, "AA==", "2018-10-12 09:13:56.0", 1770205436, 1));
        items.addSFSObject(createItem(140537375, "0995_3", "ACCESSORY", 3, 3461, 86400, "SHOPPING_BUY", 0, 86400, false, "AA==", "2018-10-12 09:13:56.0", 0, 1));
        items.addSFSObject(createItem(174056703, "1094_9", "ACCESSORY", 9, 3686, 2592000, "PACKAGE", 0, 2592000, false, "AA==", "2020-07-27 22:54:16.0", 0, 1));
        items.addSFSObject(createItem(175959058, "oyyvqf5o_6", "BAG", 6, 10050, 2592000, "PACKAGE", 0, 2592000, false, "AA==", "2020-09-10 14:28:47.0", 0, 1));

        // 7. ملابس كاملة (COSTUME) - 16 قطعة
        items.addSFSObject(createItem(175966563, "cv_13", "COSTUME", 13, 1705, 1266010, "SHOPPING_BUY", 0, 2592000, false, "AA==", "2020-09-10 18:07:16.0", 1771464938, 1));
        items.addSFSObject(createItem(109806250, "p7_7", "COSTUME", 7, 1864, 604800, "SHOPPING_BUY", 0, 604800, false, "", "2017-11-24 21:41:13.0", 0, 1));
        items.addSFSObject(createItem(109806163, "nj_4", "COSTUME", 4, 2107, 2592000, "SHOPPING_BUY", 0, 2592000, false, "", "2017-11-24 21:39:15.0", 0, 1));
        items.addSFSObject(createItem(140537379, "0018_7", "COSTUME", 7, 2336, 86400, "SHOPPING_BUY", 0, 86400, false, "", "2018-10-12 09:13:56.0", 0, 1));
        items.addSFSObject(createItem(180399352, "0560_9", "COSTUME", 9, 3013, 604800, "PACKAGE", 0, 604800, false, "AA==", "2021-01-07 18:55:38.0", 0, 1));
        items.addSFSObject(createItem(182558173, "0560_9", "COSTUME", 9, 3013, 2592000, "PACKAGE", 0, 2592000, false, "AA==", "2021-03-24 21:40:43.0", 0, 2));
        items.addSFSObject(createItem(107735202, "1164_3", "COSTUME", 3, 3793, 604800, "SHOPPING_BUY", 0, 604800, false, "AA==", "2017-11-02 00:42:48.0", 0, 1));
        items.addSFSObject(createItem(82260699, "1498_4", "COSTUME", 4, 7199, 1296000, "PACKAGE", 0, 1296000, false, "ACA=", "2017-01-08 21:44:53.0", 0, 1));
        items.addSFSObject(createItem(118214347, "4t9fcyc9_7", "COSTUME", 7, 10424, 0, "PACKAGE", 0, 0, false, "AAAAgA==", "2018-02-09 23:15:44.0", 0, 1));
        items.addSFSObject(createItem(122837353, "K7dhX9sJ_11", "COSTUME", 11, 10425, 0, "PACKAGE", 0, 0, false, "AAAAgA==", "2018-04-06 18:47:17.0", 0, 1));
        items.addSFSObject(createItem(120297267, "06h36hb2_7", "COSTUME", 7, 10428, 0, "PACKAGE", 0, 0, false, "AAAAgA==", "2018-03-09 00:46:21.0", 0, 1));
        items.addSFSObject(createItem(120297266, "yzsx37uv_9", "COSTUME", 9, 10532, 0, "PACKAGE", 0, 0, false, "AAAAgA==", "2018-03-09 00:46:21.0", 0, 1));
        items.addSFSObject(createItem(226203698, "z7r7qctx_7", "COSTUME", 7, 11112, 2592000, "SHOPPING_BUY", 0, 2592000, false, "AA==", "2025-01-31 20:31:03.0", 0, 1));
        items.addSFSObject(createItem(119083043, "A0Ukj1zA_9", "COSTUME", 9, 9418, 604800, "SHOPPING_BUY", 0, 604800, false, "AA==", "2018-02-21 20:39:23.0", 0, 1));
        items.addSFSObject(createItem(119106937, "5T0LHj8c_9", "COSTUME", 9, 9422, 604800, "SHOPPING_BUY", 0, 604800, false, "AA==", "2018-02-22 04:36:25.0", 0, 1));
        items.addSFSObject(createItem(119075679, "ZTlvrZ2P_9", "COSTUME", 9, 9427, 604800, "SHOPPING_BUY", 0, 604800, false, "AA==", "2018-02-21 18:46:28.0", 0, 1));

        // 8. أقنعة (MASK) - 3 قطع
        items.addSFSObject(createItem(119106958, "3Za9vBK8_9", "MASK", 9, 7507, 2592000, "SHOPPING_BUY", 0, 2592000, false, "AA==", "2018-02-22 04:37:23.0", 0, 1));
        items.addSFSObject(createItem(119106981, "xOWOAPpM_9", "MASK", 9, 8648, 2592000, "SHOPPING_BUY", 0, 2592000, false, "AA==", "2018-02-22 04:38:41.0", 0, 1));
        items.addSFSObject(createItem(176777506, "XrvfyBJs_9", "MASK", 9, 14291, 0, "PACKAGE", 0, 0, false, "AAAAgA==", "2020-10-03 10:00:21.0", 0, 1));

        // 9. شعر (HAIR) - 1 قطعة
        items.addSFSObject(createItem(234965117, "HxvxM1pG_12", "HAIR", 12, 13424, 2512062, "SHOPPING_BUY", 0, 2592000, true, "ACA=", "2026-02-03 14:43:11.0", 1772710990, 1));

        // 10. إفكت (EFFECT) - 2 قطعة
        items.addSFSObject(createItem(157310174, "pV21xxs2_9", "EFFECT", 9, 12366, 86400, "PACKAGE", 0, 86400, false, "AAAAgA==", "2019-08-06 06:02:59.0", 0, 1));
        items.addSFSObject(createItem(191957515, "w8v3itry_3", "EFFECT", 3, 16452, 0, "PACKAGE", 0, 0, false, "AAAAgA==", "2022-02-12 21:10:48.0", 0, 1));

        trace("[CLOTHLIST] ✅ Built " + items.size() + " items from log");
        return items;
    }

    /**
     * ✅ إنشاء عنصر ملابس بالضبط كما في اللوج
     */
    private ISFSObject createItem(int id, String clip, String subType, int color, int productID,
                                  int timeLeft, String source, int base, int lifeTime,
                                  boolean active, String roles, String createdAt,
                                  int expire, int quantity) {
        ISFSObject item = new SFSObject();
        
        // ✅ كل الحقول بالضبط كما في اللوج
        item.putBool("transferrable", false);
        item.putInt("color", color);
        item.putInt("expire", expire);
        item.putInt("quantity", quantity);
        item.putInt("productID", productID);
        item.putInt("lifeTime", lifeTime);
        item.putUtfString("source", source);
        item.putUtfString("subType", subType);
        item.putInt("timeLeft", timeLeft);
        item.putUtfString("createdAt", createdAt);
        item.putUtfString("roles", roles);
        item.putInt("base", base);
        item.putUtfString("clip", clip);
        item.putInt("id", id);
        item.putInt("active", active ? 1 : 0);
        
        return item;
    }
}