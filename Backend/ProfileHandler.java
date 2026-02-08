package src5;

import com.smartfoxserver.v2.entities.User;
import com.smartfoxserver.v2.entities.data.ISFSObject;
import com.smartfoxserver.v2.entities.data.SFSArray;
import com.smartfoxserver.v2.entities.data.SFSObject;
import com.smartfoxserver.v2.entities.variables.UserVariable;
import java.util.Set;

public class ProfileHandler extends OsBaseHandler {

    @Override
    public void handleClientRequest(User user, ISFSObject params) {
        ISFSObject data = data(params);
        String avatarId = resolveAvatarId(data);
        InMemoryStore store = getStore();
        InMemoryStore.ProfileData profile = store.resolveProfile(avatarId, resolveAvatarName(user, avatarId));
        String avatarName = profile != null ? profile.getAvatarName() : resolveAvatarName(user, avatarId);
        InMemoryStore.UserState viewerState = store.getOrCreateUser(user);
        InMemoryStore.UserState targetState = store.findUserByName(avatarId);
        boolean isBuddy = store.areBuddies(user.getName(), avatarId);
        boolean isRequest = store.hasPendingRequest(user.getName(), avatarId) || store.hasPendingRequest(avatarId, user.getName());
        int likeCount = profile != null ? profile.getLikeCount() : 0;
        int dislikeCount = profile != null ? profile.getDislikeCount() : 0;
        int totalVotes = likeCount + dislikeCount;
        double averageRating = totalVotes > 0 ? 1.0 + (likeCount * 4.0 / totalVotes) : 0.0;

        int rid = extractRid(params);
        trace("### PROFILE_HANDLER_V2 HIT ### handler=ProfileHandler rid=" + rid + " user=" + user.getName());
        trace("[PROFILE] Request avatarID=" + avatarId + " user=" + user.getName());
        try {
            user.setProperty("lastProfileAvatarId", avatarId);
            user.setProperty("lastProfileAvatarName", avatarName);
        } catch (Exception ignored) {}

        SFSObject res = new SFSObject();
        res.putUtfString("avatarName", avatarName);  // <-- هنا التغيير: استخدم avatarName بدلاً من "اَلمُشاغب"
        res.putDouble("avarageRating", averageRating);
        res.putInt("totalBuddies", store.getBuddies(avatarId).size());
        res.putBool("isBuddy", isBuddy);
        res.putBool("isRequest", isRequest);
        res.putInt("banCount", profile != null ? profile.getBanCount() : 0);
        
        // كل البطاقات من اللوجات
        SFSArray cards = new SFSArray();
        String[] cardClips = {
            "CARD_GOLD",
            "CARD_ACTOR",
            "CARD_CAFE",
            "CARD_CAPTAIN",
            "CARD_DIAMOND",
            "CARD_DIAMOND_CLUB",
            "CARD_DIRECTOR",
            "CARD_GOLD",
            "CARD_GUARD",
            "CARD_GUIDE",
            "CARD_JOURNALIST", 
            "CARD_MODERATOR",
            "CARD_MUSIC",
            "CARD_PAINTER",
            "CARD_PHOTOGRAPHER",
            "CARD_SANALIKAX",
            "CARD_SILVER"
        };
        
        for (String clip : cardClips) {
            SFSObject card = new SFSObject();
            card.putUtfString("clip", clip);
            cards.addSFSObject(card);
        }
        res.putSFSArray("cards", cards);
        
        // كل الملصقات من اللوجات
        SFSArray stickers = new SFSArray();
        Object[][] stickerData = {
            {"contestSticker", 12},
            {"treeSticker", 1},
            {"halloweenSticker", 1},
            {"cafeSticker", 1},
            {"heartSticker", 10},
            {"CaptainSticker2", 10},
            {"NewYearSticker", 10},
            {"RamadanHolidaySticker", 4},
            {"SacrificeFeastSticker", 4},
            {"SummerSticker", 4},
            {"partysticker", 10},
            {"BFsticker", 10},
            {"WinterSticker", 10},
            {"RamadanSticker", 4},
            {"SpringSticker", 4},
            {"CampSticker", 4},
            {"PetSticker", 10},
            {"AutumnSticker", 10},
            {"christmasSticker", 10}
        };
        
        for (Object[] sticker : stickerData) {
            SFSObject stickerObj = new SFSObject();
            stickerObj.putUtfString("clip", (String) sticker[0]);
            stickerObj.putInt("q", (Integer) sticker[1]);
            stickers.addSFSObject(stickerObj);
        }
        res.putSFSArray("stickers", stickers);
        
        // كل الشارات من اللوجات
        SFSArray badges = new SFSArray();
        String[] badgeClips = {
            // من اللوج الأول
           
            
            // من اللوج الثاني  
            "iosTesterBadge", "christmas2026", "eventsWinnerBadge1", "styleBadge1",
            "shipBadge2", "christmas2025", "academyBadge", "shipAchieve1",
            "eventsMakerBadge1", "socialBadge1", "2stGenBadge",
            
            // من اللوج الثالث
            "valentineBadge", "campbadge", "summerBadge", "sanilBadge3",
            "shipBadge3", "spainbadge", "christmas2024", "FORMER_GUIDE",
            "halloweenBadge", "estateBadge3", "partyislandBadge3",
            "autumnBadge", "diamondBadge3", "farmBadge3", "springBadge",
            "shopmaniaBadge", "shipAchieve3", "blackFridayBadge23",
            "8stGenBadge", "ramadanBadge", "contestBadge3",
            
            // من اللوجات الجديدة
            "blackFridayBadge19", "blackFridayBadge", "EDITOR_GUIDE",
            "christmas2020", "socialBadge2", "diamondBadge2",
            "partyislandBadge1", "securityM3", "diamondBadge2"
        };
        
        for (String clip : badgeClips) {
            SFSObject badge = new SFSObject();
            badge.putUtfString("clip", clip);
            badge.putInt("quantity", 1);
            badges.addSFSObject(badge);
        }
        res.putSFSArray("badges", badges);
        
        // الشقق
        SFSArray flats = new SFSArray();
        Object[][] flatData = {
            {12866356L, "CAFE", "كافية " + avatarName, 3, ""},
            {12868373L, "CAFE", "ديسكو " + avatarName, 13, ""},
            {12836992L, "CAFE", "شاطئ " + avatarName, 74, "1547934811"},
            {12834327L, "LAND", "الجزيرة العربية :)", 7, "1736872165"},
            {12817286L, "CAFE", "مقهى " + avatarName, 1132, "1545947724"},
            {12836362L, "CAFE", "مكان " + avatarName, 6, "1545335344"},
            {12839289L, "HOUSE", "المطعم :) ", 0, "1545251344"},
            {12834328L, "HOUSE", "bungalow01 * اوتو", 4, "1546209939"},
            {12839288L, "HOUSE", "الاجتماع :) ", 1, "1545251214"},
            {12839167L, "HOUSE", "المزرعة :) ", 4, "1545251034"}
        };
        
        for (Object[] flat : flatData) {
            SFSObject flatObj = new SFSObject();
            flatObj.putLong("id", (Long) flat[0]);
            flatObj.putUtfString("type", (String) flat[1]);
            flatObj.putUtfString("title", (String) flat[2]);
            flatObj.putInt("favCount", (Integer) flat[3]);
            flatObj.putUtfString("imgPath", (String) flat[4]);
            flats.addSFSObject(flatObj);
        }
        res.putSFSArray("flats", flats);
        
        res.putInt("mood", targetState != null ? targetState.getMood() : 0);
        res.putInt("likeCount", likeCount);
        res.putInt("dislikeCount", dislikeCount);
        res.putUtfString("status", profile != null ? profile.getStatusMessage() : "");
        res.putUtfString("avatarCity", profile != null ? profile.getCity() : "");
        res.putUtfString("avatarAge", profile != null ? profile.getAge() : "");
        res.putInt("emailRegistered", 1);
        res.putInt("nextRequest", 500);
        res.putLong("duration", 27164244);
        
        // سكن البروفايل
        InMemoryStore.ProfileSkin profileSkin = profile != null ? profile.getSkin() : InMemoryStore.ProfileSkin.defaultSkin();
        res.putSFSObject("skin", profileSkin.toSFSObject());
        
        res.putUtfString("runWinTeam", "");
        res.putBool("isBlocked", viewerState.isBlocked(avatarId));
        res.putInt("userLikeStatus", profile != null ? profile.getUserLikeStatus(user.getName()) : 0);

        trace("[PROFILE] Response keys=" + keyCount(res) + " avatarID=" + avatarId + " avatarName=" + avatarName);
        trace("[PROFILE] PayloadTypes=" + payloadTypes(res));
        trace("RID_CHECK cmd=profile reqRid=" + rid + " resRid=" + rid + " avatarID=" + avatarId);
        sendResponseWithRid("profile", res, user, rid);
    }

    private String resolveAvatarId(ISFSObject data) {
        if (data != null && data.containsKey("avatarID")) {
            try {
                String value = data.getUtfString("avatarID");
                if (value != null && !value.trim().isEmpty()) {
                    String trimmed = value.trim();
                    if (trimmed.toLowerCase().startsWith("guest#")) {
                        InMemoryStore.UserState state = getStore().findUserByName(trimmed);
                        if (state != null && state.getAvatarName() != null && !state.getAvatarName().trim().isEmpty()) {
                            return state.getAvatarName();
                        }
                        return trimmed.substring("guest#".length());
                    }
                    return trimmed;
                }
            } catch (Exception ignored) {
            }
        }
        return "100466809";
    }

    private String resolveAvatarName(User user, String avatarId) {
        // هنا تحتاج لاسترجاع الاسم الحقيقي من قاعدة البيانات أو الـ cache
        // حاليًا سأعطي مثالاً كيف يمكن الحصول عليه
        
        // محاولة الحصول من User Variables
        UserVariable nameVar = user.getVariable("avatarName");
        if (nameVar != null && nameVar.getStringValue() != null) {
            String name = nameVar.getStringValue();
            if (!name.trim().isEmpty()) {
                return name;
            }
        }
        
        // إذا لم يوجد، جرب من الـ Zone Properties (مثل InitHandler)
        String userIP = user.getSession().getAddress();
        if (getParentExtension().getParentZone().containsProperty(userIP + "_name")) {
            Object nameObj = getParentExtension().getParentZone().getProperty(userIP + "_name");
            if (nameObj != null && nameObj instanceof String) {
                String name = (String) nameObj;
                if (!name.trim().isEmpty()) {
                    return name;
                }
            }
        }
        
        // إذا لم يوجد، راجع InitHandler أو قاعدة البيانات
        // (هنا تحتاج لتطبيق منطق استرجاع الاسم من مصدر البيانات الحقيقي)
        
        // كحل مؤقت: إذا كان الـ avatarId هو خاصية اللاعب نفسه
        if (user.getName().equals(avatarId) || user.getVariable("playerID") != null) {
            // محاولة الحصول من الـ state
            InMemoryStore store = getStore();
            InMemoryStore.UserState state = store.getOrCreateUser(user);
            if (state != null && state.getAvatarName() != null) {
                return state.getAvatarName();
            }
        }
        
        // كملجأ أخير، استخدم الاسم من الـ avatarId مع تعديل
        return "Player_" + avatarId.substring(0, Math.min(5, avatarId.length()));
    }

    private String payloadTypes(SFSObject res) {
        if (res == null) {
            return "{}";
        }
        StringBuilder builder = new StringBuilder();
        builder.append("{");
        Set<String> keys = res.getKeys();
        int index = 0;
        for (String key : keys) {
            Object value = res.get(key);
            if (index > 0) {
                builder.append(", ");
            }
            builder.append(key).append(":");
            builder.append(value == null ? "null" : value.getClass().getSimpleName());
            index++;
        }
        builder.append("}");
        return builder.toString();
    }
}
