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

    private static final Map<String, RoomConfig> CONFIGS = new HashMap<>();

    static {
        register(buildStreet01());
        register(buildStreet02());
    }

    private RoomConfigRegistry() {}

    public static Resolution resolve(String roomKey) {
        String resolved = roomKey == null ? "" : roomKey.trim();
        if (resolved.isEmpty()) {
            resolved = MapBuilder.DEFAULT_ROOM_KEY;
        }
        RoomConfig config = CONFIGS.get(resolved.toLowerCase(Locale.ROOT));
        if (config != null) {
            return new Resolution(config, "config");
        }
        return new Resolution(RoomConfig.empty(resolved, DEFAULT_THEME, DEFAULT_X_ORIGIN, DEFAULT_Y_ORIGIN), "fallback");
    }

    private static void register(RoomConfig config) {
        if (config == null || config.getRoomKey() == null) {
            return;
        }
        CONFIGS.put(config.getRoomKey().toLowerCase(Locale.ROOT), config);
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
        doors.add(new DoorSpawn(MapBuilder.DEFAULT_DOOR_KEY, 5, 5, 0, DEFAULT_DOOR_PROPERTY,
            "street02", MapBuilder.DEFAULT_DOOR_KEY));

        return new RoomConfig("street01", DEFAULT_THEME, DEFAULT_X_ORIGIN, DEFAULT_Y_ORIGIN, furniture, bots, doors);
    }

    private static RoomConfig buildStreet02() {
        List<FurnitureSpawn> furniture = new ArrayList<>();
        furniture.add(furniture("floor", "kugu", 6, 8, 0));
        furniture.add(furniture("box", "cadde_sezlong_02", 18, 12, 0));
        furniture.add(furniture("box", "cadde_semsiye", 22, 18, 0));

        List<BotSpawn> bots = new ArrayList<>();
        bots.add(bot("street02Guide", "Guide", 14, 16, 1, 1));

        List<DoorSpawn> doors = new ArrayList<>();
        doors.add(new DoorSpawn(MapBuilder.DEFAULT_DOOR_KEY, 10, 8, 2, DEFAULT_DOOR_PROPERTY,
            "street01", MapBuilder.DEFAULT_DOOR_KEY));

        return new RoomConfig("street02", DEFAULT_THEME, DEFAULT_X_ORIGIN, DEFAULT_Y_ORIGIN, furniture, bots, doors);
    }

    private static FurnitureSpawn furniture(String type, String def, int x, int y, int z) {
        return new FurnitureSpawn(type, def, x, y, z, 0);
    }

    private static BotSpawn bot(String key, String name, int x, int y, int width, int height) {
        return new BotSpawn(key, name, x, y, width, height, 1, DEFAULT_BOT_PROPERTY);
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
