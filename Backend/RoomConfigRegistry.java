package src5;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Locale;
import java.util.Map;

public final class RoomConfigRegistry {
    public static final String DEFAULT_THEME = "snow";
    public static final int DEFAULT_X_ORIGIN = 275;
    public static final int DEFAULT_Y_ORIGIN = 614;
    private static final String DEFAULT_BOT_PROPERTY = "SimpleBotMessageProperty";
    private static final String DEFAULT_DOOR_PROPERTY = "FlatExitProperty";
    private static final String PANEL_BOT_PROPERTY = "PanelProperty";
    private static final String SPEECH_BOT_PROPERTY = "SpeechProperty";

    private static final Map<String, RoomConfig> CONFIGS = new HashMap<>();
    private static final Map<String, String> ALIASES = new HashMap<>();

    static {
        registerAlias("1450281337501-10.5", "street02");
        registerAlias("st01.1", "street01");
        register(buildStreet01());
        register(buildStreet05());
        register(buildStreet02());
    }

    private RoomConfigRegistry() {}

    public static Resolution resolve(String roomKey) {
        String requested = roomKey == null ? "" : roomKey.trim();
        String normalized = normalizeRoomKey(requested);
        boolean found = normalized != null && CONFIGS.containsKey(normalized);
        System.out.println("[ROOM_CONFIG_RESOLVE] requestedKey=" + requested
            + " normalizedKey=" + normalized
            + " found=" + found
            + " source=" + (found ? "config" : "fallback"));
        if (found) {
            return new Resolution(CONFIGS.get(normalized), "config");
        }
        String fallbackKey = normalized == null ? MapBuilder.DEFAULT_ROOM_KEY : normalized;
        return new Resolution(RoomConfig.empty(fallbackKey, DEFAULT_THEME, DEFAULT_X_ORIGIN, DEFAULT_Y_ORIGIN), "fallback");
    }

    public static boolean roomHasBot(String roomKey, String botKey) {
        if (botKey == null || botKey.trim().isEmpty()) {
            return false;
        }
        String normalized = normalizeRoomKey(roomKey);
        RoomConfig config = normalized == null ? null : CONFIGS.get(normalized);
        if (config == null) {
            return false;
        }
        for (BotSpawn bot : config.getBots()) {
            if (botKey.equalsIgnoreCase(bot.getKey())) {
                return true;
            }
        }
        return false;
    }

    public static List<String> getBotKeys(String roomKey) {
        String normalized = normalizeRoomKey(roomKey);
        RoomConfig config = normalized == null ? null : CONFIGS.get(normalized);
        if (config == null || config.getBots().isEmpty()) {
            return java.util.Collections.emptyList();
        }
        List<String> keys = new ArrayList<>();
        for (BotSpawn bot : config.getBots()) {
            if (bot.getKey() != null && !bot.getKey().trim().isEmpty()) {
                keys.add(bot.getKey());
            }
        }
        return keys;
    }

    public static String normalizeRoomKey(String rawRoomName) {
        if (rawRoomName == null) {
            return MapBuilder.DEFAULT_ROOM_KEY;
        }
        String trimmed = rawRoomName.trim();
        if (trimmed.isEmpty()) {
            return MapBuilder.DEFAULT_ROOM_KEY;
        }
        String alias = ALIASES.get(trimmed);
        if (alias != null) {
            System.out.println("[ROOM_CONFIG_ALIAS] requestedKey=" + trimmed + " aliasTo=" + alias);
            trimmed = alias;
        }
        String normalized = trimmed.toLowerCase(Locale.ROOT);
        int hashIndex = normalized.indexOf('#');
        if (hashIndex > 0) {
            normalized = normalized.substring(0, hashIndex);
        }
        normalized = normalized.replaceAll("([_-])\\d+$", "");
        return normalized;
    }

    private static void register(RoomConfig config) {
        if (config == null || config.getRoomKey() == null) {
            return;
        }
        CONFIGS.put(config.getRoomKey().toLowerCase(Locale.ROOT), config);
    }

    private static void registerAlias(String rawKey, String canonicalKey) {
        if (rawKey == null || canonicalKey == null) {
            return;
        }
        ALIASES.put(rawKey, canonicalKey);
    }

    private static RoomConfig buildStreet01() {
        List<FurnitureSpawn> furniture = new ArrayList<>();
        furniture.add(furniture("floor", "kugu", 6, 6, 0));
        furniture.add(furniture("floor", "dalga", 8, 6, 0));
        furniture.add(furniture("floor", "iskele", 10, 6, 0));

        furniture.add(furniture("box", "bank_05_a", 12, 10, 0));
        furniture.add(furniture("box", "bank_05_b", 14, 10, 0));
        furniture.add(furniture("box", "cadde_bank1_5", 16, 10, 0));
        furniture.add(furniture("box", "cadde_bank_5", 18, 10, 0));
        furniture.add(furniture("box", "cadde_bank_5", 20, 10, 0));
        furniture.add(furniture("box", "cadde_bank2_5", 22, 10, 0));
        furniture.add(furniture("box", "cadde_bank1_5", 16, 14, 0));
        furniture.add(furniture("box", "cadde_bank_5", 18, 14, 0));
        furniture.add(furniture("box", "cadde_bank_5", 20, 14, 0));
        furniture.add(furniture("box", "cadde_bank2_5", 22, 14, 0));
        furniture.add(furniture("box", "cadde_bank1_5", 16, 18, 0));
        furniture.add(furniture("box", "cadde_bank_5", 18, 18, 0));
        furniture.add(furniture("box", "cadde_bank_5", 20, 18, 0));
        furniture.add(furniture("box", "cadde_bank2_5", 22, 18, 0));
        furniture.add(furniture("box", "cadde_bank1_5", 16, 22, 0));
        furniture.add(furniture("box", "cadde_bank_5", 18, 22, 0));
        furniture.add(furniture("box", "cadde_bank_5", 20, 22, 0));
        furniture.add(furniture("box", "cadde_bank2_5", 22, 22, 0));
        furniture.add(furniture("box", "cadde_bank1_5", 16, 26, 0));
        furniture.add(furniture("box", "cadde_bank_5", 18, 26, 0));
        furniture.add(furniture("box", "cadde_bank_5", 20, 26, 0));
        furniture.add(furniture("box", "cadde_bank2_5", 22, 26, 0));

        furniture.add(furniture("box", "cadde_sezlong_01", 28, 10, 0));
        furniture.add(furniture("box", "cadde_sezlong_02", 30, 10, 0));
        furniture.add(furniture("box", "cadde_sezlong_03", 32, 10, 0));
        furniture.add(furniture("box", "cadde_sezlong_01", 28, 14, 0));
        furniture.add(furniture("box", "cadde_sezlong_02", 30, 14, 0));
        furniture.add(furniture("box", "cadde_sezlong_03", 32, 14, 0));
        furniture.add(furniture("box", "cadde_sezlong_01", 28, 18, 0));
        furniture.add(furniture("box", "cadde_sezlong_02", 30, 18, 0));
        furniture.add(furniture("box", "cadde_sezlong_03", 32, 18, 0));
        furniture.add(furniture("box", "cadde_sezlong_01", 28, 22, 0));
        furniture.add(furniture("box", "cadde_sezlong_02", 30, 22, 0));
        furniture.add(furniture("box", "cadde_sezlong_03", 32, 22, 0));
        furniture.add(furniture("box", "cadde_sezlong_01", 28, 26, 0));
        furniture.add(furniture("box", "cadde_sezlong_02", 30, 26, 0));
        furniture.add(furniture("box", "cadde_sezlong_03", 32, 26, 0));
        furniture.add(furniture("box", "cadde_sezlong_01", 28, 30, 0));
        furniture.add(furniture("box", "cadde_sezlong_02", 30, 30, 0));
        furniture.add(furniture("box", "cadde_sezlong_03", 32, 30, 0));
        furniture.add(furniture("box", "cadde_sezlong", 34, 30, 0));

        furniture.add(furniture("box", "cadde_semsiye", 36, 12, 0));
        furniture.add(furniture("box", "cadde_semsiye", 36, 20, 0));
        furniture.add(furniture("box", "CdTabela2", 40, 18, 0));

        furniture.add(furniture("box", "bitki_duvar_1", 8, 24, 0));
        furniture.add(furniture("box", "bitki_duvar_3", 10, 34, 0));
        furniture.add(furniture("box", "bitki_duvar_2", 20, 34, 20));
        furniture.add(furniture("box", "bitki_duvar_4", 18, 34, 0));

        List<BotSpawn> bots = new ArrayList<>();
        bots.add(botWithPanelAndSpeech("baloncuBengu", "ديانا", 35, 24, 1, 1, "ShopPanel"));
        bots.add(botWithPanelAndSpeech("guvenlik2", "حارس X", 24, 35, 1, 1, "VipCardPanel"));
        bots.add(botWithPanelAndSpeech("airportBillboardSmall", "airportBillboardSmall", 9, 22, 3, 2, "GameBrowserPanel"));
        bots.add(botWithPanelAndSpeech("tahsin", "الساعي تحسين", 24, 28, 1, 1, "NewspaperPanel"));
        bots.add(botWithPanelAndSpeech("beggars", "فقير", 46, 22, 1, 1, "ReportPanel"));
        bots.add(botWithPanelAndSpeech("giftStandNew", "ستاند الهدايا", 29, 2, 2, 6, "ShopPanel"));
        bots.add(botWithPanelAndSpeech("sanalikaxKapiBot", "sanalikaxKapiBot", 22, 36, 3, 3, "RoomShopPanel"));
        bots.add(botWithPanelAndSpeech("newspaperStand3", "newspaperStand3", 22, 23, 4, 2, "NewspaperPanel"));

        List<DoorSpawn> doors = new ArrayList<>();
        doors.add(new DoorSpawn("d1", 10, 5, 0, DEFAULT_DOOR_PROPERTY, "street02", "spawn_default"));
        doors.add(new DoorSpawn("d2", 15, 5, 0, DEFAULT_DOOR_PROPERTY, "street03", "spawn_default"));
        doors.add(new DoorSpawn("d3", 20, 5, 0, DEFAULT_DOOR_PROPERTY, "street04", "spawn_default"));
        doors.add(new DoorSpawn("d4", 25, 5, 0, DEFAULT_DOOR_PROPERTY, "street05", "spawn_default"));
        doors.add(new DoorSpawn("d5", 5, 5, 0, DEFAULT_DOOR_PROPERTY, "street06", "spawn_default"));
        doors.add(new DoorSpawn("d6", 30, 5, 0, DEFAULT_DOOR_PROPERTY, "street07", "spawn_default"));
        doors.add(new DoorSpawn("d7", 35, 5, 0, DEFAULT_DOOR_PROPERTY, "street08", "spawn_default"));
        doors.add(new DoorSpawn("d8", 40, 5, 0, DEFAULT_DOOR_PROPERTY, "street09", "spawn_default"));
        doors.add(new DoorSpawn("d9", 45, 5, 0, DEFAULT_DOOR_PROPERTY, "street10", "spawn_default"));

        return new RoomConfig("street01", DEFAULT_THEME, DEFAULT_X_ORIGIN, DEFAULT_Y_ORIGIN, furniture, bots, doors);
    }

    private static RoomConfig buildStreet02() {
        List<FurnitureSpawn> furniture = new ArrayList<>();
        furniture.add(furniture("floor", "kugu", 6, 8, 0));
        furniture.add(furniture("box", "cadde_sezlong_02", 18, 12, 0));
        furniture.add(furniture("box", "cadde_semsiye", 22, 18, 0));

        List<BotSpawn> bots = new ArrayList<>();
        bots.add(botWithPanel("street02Guide", "Guide", 14, 16, 1, 1, "QuestPanel"));

        List<DoorSpawn> doors = new ArrayList<>();
        doors.add(new DoorSpawn("d5", 10, 8, 2, DEFAULT_DOOR_PROPERTY,
            "street01", "spawn_default"));

        return new RoomConfig("street02", DEFAULT_THEME, DEFAULT_X_ORIGIN, DEFAULT_Y_ORIGIN, furniture, bots, doors);
    }

    private static RoomConfig buildStreet05() {
        List<FurnitureSpawn> furniture = new ArrayList<>();
        List<BotSpawn> bots = new ArrayList<>();

        List<DoorSpawn> doors = new ArrayList<>();
        doors.add(new DoorSpawn("d1", 12, 8, 0, DEFAULT_DOOR_PROPERTY, "street01", "spawn_default"));
        doors.add(new DoorSpawn("d2", 18, 8, 0, DEFAULT_DOOR_PROPERTY, "street02", "spawn_default"));
        doors.add(new DoorSpawn("d3", 24, 8, 0, DEFAULT_DOOR_PROPERTY, "street03", "spawn_default"));
        doors.add(new DoorSpawn("d4", 30, 8, 0, DEFAULT_DOOR_PROPERTY, "street04", "spawn_default"));
        doors.add(new DoorSpawn("d5", 36, 8, 0, DEFAULT_DOOR_PROPERTY, "street06", "spawn_default"));
        doors.add(new DoorSpawn("d6", 42, 8, 0, DEFAULT_DOOR_PROPERTY, "street07", "spawn_default"));
        doors.add(new DoorSpawn("d7", 48, 8, 0, DEFAULT_DOOR_PROPERTY, "street08", "spawn_default"));
        doors.add(new DoorSpawn("d8", 54, 8, 0, DEFAULT_DOOR_PROPERTY, "street09", "spawn_default"));
        doors.add(new DoorSpawn("d9", 60, 8, 0, DEFAULT_DOOR_PROPERTY, "street10", "spawn_default"));

        return new RoomConfig("street05", DEFAULT_THEME, DEFAULT_X_ORIGIN, DEFAULT_Y_ORIGIN, furniture, bots, doors);
    }

    private static FurnitureSpawn furniture(String type, String def, int x, int y, int z) {
        return new FurnitureSpawn(type, def, x, y, z, 0);
    }

    private static BotSpawn bot(String key, String name, int x, int y, int width, int height) {
        return new BotSpawn(key, name, x, y, width, height, 1, DEFAULT_BOT_PROPERTY, null, null, null);
    }

    private static BotSpawn botWithPanel(String key, String name, int x, int y, int width, int height, String panelKey) {
        Map<String, Object> data = new HashMap<>();
        data.put("panelKey", panelKey);
        return new BotSpawn(key, name, x, y, width, height, 1, PANEL_BOT_PROPERTY, data, null, null);
    }

    private static BotSpawn botWithPanelAndSpeech(String key, String name, int x, int y, int width, int height,
                                                  String panelKey) {
        Map<String, Object> panelData = new HashMap<>();
        panelData.put("panelKey", panelKey);
        Map<String, Object> speechData = new HashMap<>();
        List<Map<String, Object>> list = new ArrayList<>();
        list.add(speechEntry("casual", "ياهلا!"));
        list.add(speechEntry("casual", "انا هنا لو احتجت حاجة."));
        list.add(speechEntry("casual", "تابع اخر الاخبار من الجريدة."));
        list.add(speechEntry("casual", "استمتع بوقتك!"));
        speechData.put("list", list);
        return new BotSpawn(key, name, x, y, width, height, 1, PANEL_BOT_PROPERTY, panelData,
            SPEECH_BOT_PROPERTY, speechData);
    }

    private static Map<String, Object> speechEntry(String event, String message) {
        Map<String, Object> entry = new HashMap<>();
        entry.put("event", event);
        entry.put("message", message);
        return entry;
    }

    public static final class Resolution {
        private final RoomConfig config;
        private final String source;

        public Resolution(RoomConfig config, String source) {
            this.config = config;
            this.source = source;
        }

        public RoomConfig getConfig() {
            return config;
        }

        public String getSource() {
            return source;
        }
    }
}
