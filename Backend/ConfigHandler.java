package src5;

import com.smartfoxserver.v2.entities.User;
import com.smartfoxserver.v2.entities.data.*;

public class ConfigHandler extends OsBaseHandler {

    @Override
    public void handleClientRequest(User user, ISFSObject params) {
        trace("[CONFIG] Request from: " + user.getName());
        
        SFSObject res = new SFSObject();

        // File paths - matching official
        res.putUtfString("itemFile", "data/ifile.1913");
        res.putUtfString("versionFile", "data/vf.467");
        res.putUtfString("langFile", "locale/ar_AR.702");
        res.putUtfString("webServer", "fs.sanalika.com");
        res.putUtfString("language", "ar");
        res.putInt("version", 92);
        
        // File servers
        SFSArray fileServerArray = new SFSArray();
        fileServerArray.addUtfString("fs.sanalika.com");
        res.putSFSArray("fileServer", fileServerArray);

        // Master Roles - 52 roles matching official (index 2-53)
        SFSArray masterRoles = new SFSArray();
        String[] rolesNames = {
            "TRANSFER", "BARTER", "VIP", "VIP_GOLD", "WHISPER", "VIP_DIAMOND", "VIP_SILVER",
            "AGE_18PLUS", "AGE_13MINUS", "VERIFIED_EMAIL", "VERIFIED_PHONE", "HOLIDAY_VISA_TURKEY",
            "DIAMOND_CLUB", "HOLIDAY_VISA_ABUDABI", "CARD_SECURITY", "HOLIDAY_VISA_SPAIN",
            "CARD_JOURNALIST", "CARD_DIRECTOR", "MODERATOR", "CARD_PHOTOGRAPHER", "EDITOR_SECURITY",
            "CARD_PAINTER", "PARTY", "SPACE_COSTUME", "KEY", "CARD_ACTOR", "CARD_GUARD",
            "CARD_GUIDE", "PLATO", "FORUM", "CARD_SANALIKAX", "KIDO", "AIRPASS", "RUNWIN",
            "SNOWBALL", "HOLIDAY_VISA_JAPON", "HOLIDAY_VISA_TR_JPN", "VISITOR", "SECURITY",
            "SWIM", "SKATE", "CARD_MUSIC", "BONUS_X2", "SHORTCUT", "SHIP_LICENSE",
            "CARD_CAPITAN", "EVENT", "NPC", "STAGE", "NOT_VISITOR", "GAME_ISLAND", "CARD_CAFE"
        };
        
        for (int i = 0; i < rolesNames.length; i++) {
            SFSObject r = new SFSObject();
            r.putInt("index", i + 2);
            r.putUtfString("name", rolesNames[i]);
            masterRoles.addSFSObject(r);
        }
        res.putSFSArray("masterRoles", masterRoles);

        // Room themes - matching official (2 items in roomTheme, 7 in allRoomTheme)
        SFSArray roomTheme = new SFSArray();
        roomTheme.addUtfString("snow");
        roomTheme.addUtfString("fest");
        res.putSFSArray("roomTheme", roomTheme);
        
        SFSArray allRoomTheme = new SFSArray();
        allRoomTheme.addUtfString("snow");
        allRoomTheme.addUtfString("fest");
        allRoomTheme.addUtfString("christmas");
        allRoomTheme.addUtfString("halloween");
        allRoomTheme.addUtfString("blackfriday");
        allRoomTheme.addUtfString("valentine");
        allRoomTheme.addUtfString("snowLand");
        res.putSFSArray("allRoomTheme", allRoomTheme);

        // Moods - 31 moods (0-30)
        SFSArray moods = new SFSArray();
        String[] moodLabels = {
            "Cheerful", "Peaceful", "Crazy", "Run Down", "Unhappy", "Nervous", "Broken Heart",
            "Pessimistic", "Pensive", "Energetic", "Romantical", "Sensitive", "Excited",
            "Curious", "Depressed", "Unstable", "Worried", "Thoughtful", "Mysterious",
            "Mixed", "Optimistic", "Confused", "Sucks", "Resents", "Desperate", "Regret",
            "Alone", "Questionable", "Lethargic", "Approachable", "Stressful"
        };
        
        for (int i = 0; i < moodLabels.length; i++) {
            SFSObject m = new SFSObject();
            m.putInt("id", i);
            m.putUtfString("label", moodLabels[i]);
            moods.addSFSObject(m);
        }
        res.putSFSArray("moods", moods);

        // Chat Balloons - matching official IDs
        SFSArray chatBaloons = new SFSArray();
        chatBaloons.addSFSObject(mkBaloon(1, "Default", "AA=="));
        chatBaloons.addSFSObject(mkBaloon(2, "Blue", "gA=="));
        chatBaloons.addSFSObject(mkBaloon(3, "Yellow", "EA=="));
        chatBaloons.addSFSObject(mkBaloon(4, "Grey", "QA=="));
        chatBaloons.addSFSObject(mkBaloon(23, "Black", "QA=="));
        chatBaloons.addSFSObject(mkBaloon(24, "Red", "EA=="));
        chatBaloons.addSFSObject(mkBaloon(25, "Pink", "EA=="));
        chatBaloons.addSFSObject(mkBaloon(26, "DiamondClub", "ACA="));
        chatBaloons.addSFSObject(mkBaloon(30, "SanalikaX", "AAAAgA=="));
        res.putSFSArray("chatBaloons", chatBaloons);

        // Farm settings - matching official
        res.putInt("farmCleaningCost", 10);
        res.putInt("farmMaxPlantedItemSize", 12);
        res.putInt("diamondExchangeRate", 30);
        
        // Order configuration - matching official
        SFSObject order = new SFSObject();
        order.putInt("orderLifeTime", 240);
        order.putInt("customerGainMin", 10);
        order.putInt("customerGainMax", 100);
        order.putInt("prepareLifeTime", 30);
        order.putInt("maxOrder", 10);
        order.putInt("avatarOrderLifeTime", 14400);
        res.putSFSObject("order", order);

        reply(user, "config", res);
        trace("[CONFIG] ✅ Response sent");
    }

    private ISFSObject mkBaloon(int id, String name, String req) {
        ISFSObject obj = new SFSObject();
        obj.putInt("id", id);
        obj.putUtfString("name", name);
        obj.putUtfString("requirements", req);
        return obj;
    }
}
