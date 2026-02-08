package src5;

import java.util.ArrayList;
import java.util.HashSet;
import java.util.HashMap;
import java.util.List;
import java.util.Locale;
import java.util.Map;
import java.util.Set;

public final class RoomConfigRegistry {
    public static final String DEFAULT_THEME = "snow";
    public static final int DEFAULT_X_ORIGIN = 275;
    public static final int DEFAULT_Y_ORIGIN = 614;
    private static final String DEFAULT_BOT_PROPERTY = "SimpleBotMessageProperty";
    private static final String DEFAULT_DOOR_PROPERTY = "FlatExitProperty";

    private static final Map<String, RoomConfig> CONFIGS = new HashMap<>();
    private static final Map<String, String> ALIASES = new HashMap<>();
    private static final Map<String, String> DEFAULT_DOOR_MAPPING = new HashMap<>();

    static {
        registerAlias("1450281337501-10.5", "street02");
        registerAlias("st01.1", "street01");
        registerDefaultDoorMapping();
        register(buildStreet01());
        register(buildStreet05());
        register(buildStreet02());
        register(buildStreet03());
        register(buildStreet04());
        register(buildStreet07());
        register(buildStreet08());
        register(buildStreet09());
        register(buildStreet10());
        register(buildStreet11());
        register(buildStreet12());
        register(buildStreet13());
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
        bots.add(bot("baloncuBengu", "ديانا", 35, 24, 1, 1));
        bots.add(bot("guvenlik2", "حارس X", 24, 35, 1, 1));
        bots.add(bot("airportBillboardSmall", "airportBillboardSmall", 9, 22, 3, 2));
        bots.add(bot("tahsin", "الساعي تحسين", 24, 28, 1, 1));
        bots.add(bot("beggars", "فقير", 46, 22, 1, 1));
        bots.add(bot("giftStandNew", "ستاند الهدايا", 29, 2, 2, 6));
        bots.add(bot("sanalikaxKapiBot", "sanalikaxKapiBot", 22, 36, 3, 3));
        bots.add(bot("newspaperStand3", "newspaperStand3", 22, 23, 4, 2));

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
        bots.add(bot("street02Guide", "Guide", 14, 16, 1, 1));

        List<DoorSpawn> doors = makeNineDoors("street02", 10, 8, 2, true);

        return new RoomConfig("street02", DEFAULT_THEME, DEFAULT_X_ORIGIN, DEFAULT_Y_ORIGIN, furniture, bots, doors);
    }

    private static RoomConfig buildStreet05() {
        List<FurnitureSpawn> furniture = new ArrayList<>();
        List<BotSpawn> bots = new ArrayList<>();

        addStreet05Furniture(furniture);
        addStreet05Bots(bots);
        List<DoorSpawn> doors = makeNineDoors("street05", 12, 8, 0, false);

        return new RoomConfig("street05", DEFAULT_THEME, DEFAULT_X_ORIGIN, DEFAULT_Y_ORIGIN, furniture, bots, doors);
    }

    private static RoomConfig buildStreet03() {
        List<FurnitureSpawn> furniture = new ArrayList<>();
        List<BotSpawn> bots = new ArrayList<>();
        List<DoorSpawn> doors = makeNineDoors("street03", 14, 8, 0, false);
        return new RoomConfig("street03", DEFAULT_THEME, DEFAULT_X_ORIGIN, DEFAULT_Y_ORIGIN, furniture, bots, doors);
    }

    private static RoomConfig buildStreet04() {
        List<FurnitureSpawn> furniture = new ArrayList<>();
        List<BotSpawn> bots = new ArrayList<>();
        List<DoorSpawn> doors = makeNineDoors("street04", 16, 8, 0, false);
        return new RoomConfig("street04", DEFAULT_THEME, DEFAULT_X_ORIGIN, DEFAULT_Y_ORIGIN, furniture, bots, doors);
    }

    private static RoomConfig buildStreet07() {
        List<FurnitureSpawn> furniture = new ArrayList<>();
        List<BotSpawn> bots = new ArrayList<>();
        List<DoorSpawn> doors = makeNineDoors("street07", 18, 8, 0, false);
        return new RoomConfig("street07", DEFAULT_THEME, DEFAULT_X_ORIGIN, DEFAULT_Y_ORIGIN, furniture, bots, doors);
    }

    private static RoomConfig buildStreet08() {
        List<FurnitureSpawn> furniture = new ArrayList<>();
        List<BotSpawn> bots = new ArrayList<>();
        List<DoorSpawn> doors = makeNineDoors("street08", 20, 8, 0, false);
        return new RoomConfig("street08", DEFAULT_THEME, DEFAULT_X_ORIGIN, DEFAULT_Y_ORIGIN, furniture, bots, doors);
    }

    private static RoomConfig buildStreet09() {
        List<FurnitureSpawn> furniture = new ArrayList<>();
        List<BotSpawn> bots = new ArrayList<>();
        List<DoorSpawn> doors = makeNineDoors("street09", 22, 8, 0, false);
        return new RoomConfig("street09", DEFAULT_THEME, DEFAULT_X_ORIGIN, DEFAULT_Y_ORIGIN, furniture, bots, doors);
    }

    private static RoomConfig buildStreet10() {
        List<FurnitureSpawn> furniture = new ArrayList<>();
        List<BotSpawn> bots = new ArrayList<>();
        List<DoorSpawn> doors = makeNineDoors("street10", 24, 8, 0, false);
        return new RoomConfig("street10", DEFAULT_THEME, DEFAULT_X_ORIGIN, DEFAULT_Y_ORIGIN, furniture, bots, doors);
    }

    private static RoomConfig buildStreet11() {
        List<FurnitureSpawn> furniture = new ArrayList<>();
        List<BotSpawn> bots = new ArrayList<>();
        List<DoorSpawn> doors = makeNineDoors("street11", 26, 8, 0, false);
        return new RoomConfig("street11", DEFAULT_THEME, DEFAULT_X_ORIGIN, DEFAULT_Y_ORIGIN, furniture, bots, doors);
    }

    private static RoomConfig buildStreet12() {
        List<FurnitureSpawn> furniture = new ArrayList<>();
        List<BotSpawn> bots = new ArrayList<>();
        List<DoorSpawn> doors = makeNineDoors("street12", 28, 8, 0, false);
        return new RoomConfig("street12", DEFAULT_THEME, DEFAULT_X_ORIGIN, DEFAULT_Y_ORIGIN, furniture, bots, doors);
    }

    private static RoomConfig buildStreet13() {
        List<FurnitureSpawn> furniture = new ArrayList<>();
        List<BotSpawn> bots = new ArrayList<>();
        List<DoorSpawn> doors = makeNineDoors("street13", 30, 8, 0, false);
        return new RoomConfig("street13", DEFAULT_THEME, DEFAULT_X_ORIGIN, DEFAULT_Y_ORIGIN, furniture, bots, doors);
    }

    private static FurnitureSpawn furniture(String type, String def, int x, int y, int z) {
        return new FurnitureSpawn(type, def, x, y, z, 0);
    }

    private static BotSpawn bot(String key, String name, int x, int y, int width, int height) {
        return new BotSpawn(key, name, x, y, width, height, 1, DEFAULT_BOT_PROPERTY);
    }

    private static void registerDefaultDoorMapping() {
        DEFAULT_DOOR_MAPPING.put("d1", "street01");
        DEFAULT_DOOR_MAPPING.put("d2", "street02");
        DEFAULT_DOOR_MAPPING.put("d3", "street03");
        DEFAULT_DOOR_MAPPING.put("d4", "street04");
        DEFAULT_DOOR_MAPPING.put("d5", "street05");
        DEFAULT_DOOR_MAPPING.put("d6", "street07");
        DEFAULT_DOOR_MAPPING.put("d7", "street08");
        DEFAULT_DOOR_MAPPING.put("d8", "street09");
        DEFAULT_DOOR_MAPPING.put("d9", "street10");
    }

    private static List<DoorSpawn> makeNineDoors(String roomKey, int baseX, int baseY, int dir, boolean d5ToStreet01) {
        List<DoorSpawn> doors = new ArrayList<>();
        String[] keys = new String[] {"d1", "d2", "d3", "d4", "d5", "d6", "d7", "d8", "d9"};
        for (int i = 0; i < keys.length; i++) {
            String key = keys[i];
            String destination = DEFAULT_DOOR_MAPPING.getOrDefault(key, MapBuilder.DEFAULT_ROOM_KEY);
            if ("d5".equals(key) && d5ToStreet01) {
                destination = "street01";
            }
            int x = baseX + (i * 5);
            doors.add(new DoorSpawn(key, x, baseY, dir, DEFAULT_DOOR_PROPERTY, destination, "spawn_default"));
        }
        return doors;
    }

    private static void addStreet05Bots(List<BotSpawn> bots) {
        Set<String> seen = new HashSet<>();
        for (BotSpawn bot : bots) {
            if (bot != null && bot.getKey() != null) {
                seen.add(bot.getKey());
            }
        }
        addBotIfMissing(bots, seen, new BotSpawn("florist01", "florist01", 12, 12, 1, 1, 1, DEFAULT_BOT_PROPERTY));
        addBotIfMissing(bots, seen, new BotSpawn("ramadanSt1_5", "ramadanSt1_5", 14, 12, 1, 1, 1, DEFAULT_BOT_PROPERTY));
        addBotIfMissing(bots, seen, new BotSpawn("ramadanPurpleLamp", "ramadanPurpleLamp", 16, 12, 1, 1, 1, DEFAULT_BOT_PROPERTY));
        addBotIfMissing(bots, seen, new BotSpawn("ramadanPurpleLamp2", "ramadanPurpleLamp2", 18, 12, 1, 1, 1, DEFAULT_BOT_PROPERTY));
        addBotIfMissing(bots, seen, new BotSpawn("tribun", "tribun", 20, 12, 1, 1, 1, DEFAULT_BOT_PROPERTY));
        addBotIfMissing(bots, seen, new BotSpawn("eylul", "eylul", 22, 12, 1, 1, 1, DEFAULT_BOT_PROPERTY));
        addBotIfMissing(bots, seen, new BotSpawn("ramadanSt1_3", "ramadanSt1_3", 24, 12, 1, 1, 1, DEFAULT_BOT_PROPERTY));
        addBotIfMissing(bots, seen, new BotSpawn("ramadanStars_5", "ramadanStars_5", 26, 12, 1, 1, 1, DEFAULT_BOT_PROPERTY));
        addBotIfMissing(bots, seen, new BotSpawn("securityBot3", "securityBot3", 28, 12, 1, 1, 1, DEFAULT_BOT_PROPERTY));
        addBotIfMissing(bots, seen, new BotSpawn("ramadanPurpleLamp3", "ramadanPurpleLamp3", 30, 12, 1, 1, 1, DEFAULT_BOT_PROPERTY));
    }

    private static void addBotIfMissing(List<BotSpawn> bots, Set<String> seen, BotSpawn bot) {
        if (bot == null || bot.getKey() == null || seen.contains(bot.getKey())) {
            return;
        }
        bots.add(bot);
        seen.add(bot.getKey());
    }

    private static void addStreet05Furniture(List<FurnitureSpawn> furniture) {
        Set<String> seen = new HashSet<>();
        for (FurnitureSpawn item : furniture) {
            if (item != null && item.getDef() != null) {
                seen.add(item.getDef());
            }
        }
        String[] items = new String[] {
            "bayrak", "bayrak_yari", "cadde_agac_dilek", "cadde_agac1", "cadde_bank_3", "cadde_bank_5",
            "cadde_bank1_3", "cadde_bank1_5", "cadde_bank2_3", "cadde_bank2_5", "cadde_bebek_heykeli",
            "cadde_cim_kisa", "cadde_cim_kisa_5", "cadde_cim_uzun", "cadde_direk", "cadde_durak_tabela",
            "cadde_girilmez_tabela_5", "cadde_kahvehane_kose", "cadde_kisa_duvar_3", "cadde_kisa_duvar_5",
            "cadde_metro_tabela", "cadde_reklam_tabela", "cadde_uzun_duvar_3", "cadde_uzun_duvar_5",
            "cadde_yuvarlak_agac", "cafe_market_cicek", "cafe_market_cicek_yuvarlak01",
            "cafe_market_cicek_yuvarlak02", "Cd5Tabela1", "Cd5Tabela3", "Cd5Tabela4", "cit_park_3", "Clock",
            "koltuk_1", "koltuk_1_m", "koltuk_3", "koltuk_5", "koltuk_7", "koltuk_7_m", "masa_1", "masa_7",
            "SaatKulesi", "semsiye"
        };
        int startX = 6;
        int startY = 20;
        int z = 0;
        int columns = 6;
        int spacingX = 2;
        int spacingY = 2;
        int index = 0;
        for (String def : items) {
            if (def == null || def.isEmpty() || seen.contains(def)) {
                continue;
            }
            int x = startX + (index % columns) * spacingX;
            int y = startY + (index / columns) * spacingY;
            furniture.add(new FurnitureSpawn("box", def, x, y, z, 0));
            seen.add(def);
            index++;
        }
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
