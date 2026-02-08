package src5;

import java.io.ByteArrayOutputStream;
import java.io.DataOutputStream;
import java.io.IOException;
import java.nio.charset.StandardCharsets;
import java.util.Base64;
import com.smartfoxserver.v2.entities.data.ISFSArray;
import com.smartfoxserver.v2.entities.data.SFSArray;
import com.smartfoxserver.v2.entities.data.SFSObject;

public final class MapBuilder {
    public static final String DEFAULT_ROOM_KEY = "street01";
    public static final String DEFAULT_DOOR_KEY = "d5";
    public static final int DEFAULT_PV = 0;
    public static final int DEFAULT_DV = 0;
    public static final int GRID_WIDTH = 60;
    public static final int GRID_HEIGHT = 55;
    public static final int ROOM_WIDTH = 800;
    public static final int ROOM_HEIGHT = 500;
    private static final boolean USE_LEGACY_FALLBACK = false;

    private MapBuilder() {}

    public static RoomPayload buildRoomPayload(String roomKey, String doorKey) {
        String resolvedRoomKey = roomKey == null || roomKey.isEmpty() ? DEFAULT_ROOM_KEY : roomKey;
        String resolvedDoorKey = doorKey == null || doorKey.isEmpty() ? DEFAULT_DOOR_KEY : doorKey;
        return new RoomPayload(resolvedRoomKey, resolvedDoorKey, DEFAULT_PV, DEFAULT_DV, buildMapBase64(resolvedRoomKey));
    }

    public static String buildMapBase64() {
        return buildMapBase64(DEFAULT_ROOM_KEY);
    }

    public static String buildMapBase64(String roomKey) {
        return Base64.getEncoder().encodeToString(buildMapXml(roomKey).getBytes(StandardCharsets.UTF_8));
    }

    public static RoomBuildData buildRoomData(String roomKey) {
        String resolvedRoomKey = roomKey == null || roomKey.isEmpty() ? DEFAULT_ROOM_KEY : roomKey;
        RoomConfigRegistry.Resolution resolution = resolveRoomConfig(resolvedRoomKey);
        RoomConfig config = resolution.getConfig();
        if ("fallback".equals(resolution.getSource()) && USE_LEGACY_FALLBACK) {
            RoomBuildData legacy = new RoomBuildData(
                buildLegacyMapBase64(),
                buildLegacyDoorsJson(),
                buildLegacyBotsJson(),
                buildLegacySceneItems(),
                "legacy"
            );
            logRoomBuild(resolvedRoomKey, legacy.getFurnitureCount(), legacy.getBotsCount(), legacy.getDoorsCount(),
                legacy.getSource(), "legacy_fallback");
            return legacy;
        }

        RoomBuildData data = new RoomBuildData(
            buildMapBase64(resolvedRoomKey),
            buildDoorsJson(config),
            buildBotsJson(config),
            buildSceneItems(config),
            resolution.getSource()
        );
        String warning = "fallback".equals(resolution.getSource()) ? "missing_config" : null;
        logRoomBuild(resolvedRoomKey, data.getFurnitureCount(), data.getBotsCount(), data.getDoorsCount(),
            resolution.getSource(), warning);
        return data;
    }

    private static RoomConfigRegistry.Resolution resolveRoomConfig(String roomKey) {
        return RoomConfigRegistry.resolve(roomKey);
    }

    public static String buildMapXml(String roomKey) {
        RoomConfigRegistry.Resolution resolution = resolveRoomConfig(roomKey);
        if ("fallback".equals(resolution.getSource()) && USE_LEGACY_FALLBACK) {
            return buildLegacyMapXml();
        }
        return buildMapXml(resolution.getConfig());
    }

    private static String buildMapXml(RoomConfig config) {
        String theme = config.getTheme() == null ? RoomConfigRegistry.DEFAULT_THEME : config.getTheme();
        int xOrigin = config.getXOrigin();
        int yOrigin = config.getYOrigin();
        StringBuilder xml = new StringBuilder();
        xml.append("<map themes=\"").append(theme).append("\" xOrigin=\"").append(xOrigin)
            .append("\" yOrigin=\"").append(yOrigin).append("\">");
        for (FurnitureSpawn spawn : config.getFurniture()) {
            xml.append(baseEntry(spawn.getType(), spawn.getDef(), spawn.getX(), spawn.getY(), spawn.getZ()));
        }
        xml.append("</map>");
        return xml.toString();
    }

    public static ISFSArray buildSceneItems(String roomKey) {
        RoomConfigRegistry.Resolution resolution = resolveRoomConfig(roomKey);
        if ("fallback".equals(resolution.getSource()) && USE_LEGACY_FALLBACK) {
            return buildLegacySceneItems();
        }
        return buildSceneItems(resolution.getConfig());
    }

    private static ISFSArray buildSceneItems(RoomConfig config) {
        SFSArray items = new SFSArray();
        for (FurnitureSpawn spawn : config.getFurniture()) {
            addSceneItem(items, spawn);
        }
        return items;
    }

    public static String buildGridBase64() {
        ByteArrayOutputStream outputStream = new ByteArrayOutputStream();
        try (DataOutputStream dataStream = new DataOutputStream(outputStream)) {
            dataStream.writeInt(GRID_WIDTH);
            dataStream.writeInt(GRID_HEIGHT);
            for (int y = 0; y < GRID_HEIGHT; y++) {
                for (int x = 0; x < GRID_WIDTH; x++) {
                    dataStream.writeByte(0);
                }
            }
        } catch (IOException e) {
            throw new IllegalStateException("Failed to build grid payload", e);
        }
        return Base64.getEncoder().encodeToString(outputStream.toByteArray());
    }

    public static String buildDoorsJson(String roomKey) {
        RoomConfigRegistry.Resolution resolution = resolveRoomConfig(roomKey);
        if ("fallback".equals(resolution.getSource()) && USE_LEGACY_FALLBACK) {
            return buildLegacyDoorsJson();
        }
        return buildDoorsJson(resolution.getConfig());
    }

    private static String buildDoorsJson(RoomConfig config) {
        if (config.getDoors().isEmpty()) {
            return "[]";
        }
        StringBuilder json = new StringBuilder();
        json.append("[");
        for (int i = 0; i < config.getDoors().size(); i++) {
            DoorSpawn door = config.getDoors().get(i);
            if (i > 0) {
                json.append(",");
            }
            json.append("{\"key\":\"").append(door.getKey()).append("\",")
                .append("\"targetX\":").append(door.getTargetX()).append(",")
                .append("\"targetY\":").append(door.getTargetY()).append(",")
                .append("\"targetDir\":").append(door.getTargetDir()).append(",")
                .append("\"property\":{\"cn\":\"").append(door.getPropertyCn()).append("\"}}");
        }
        json.append("]");
        return json.toString();
    }

    public static String buildBotsJson(String roomKey) {
        RoomConfigRegistry.Resolution resolution = resolveRoomConfig(roomKey);
        if ("fallback".equals(resolution.getSource()) && USE_LEGACY_FALLBACK) {
            return buildLegacyBotsJson();
        }
        return buildBotsJson(resolution.getConfig());
    }

    private static String buildBotsJson(RoomConfig config) {
        if (config.getBots().isEmpty()) {
            return "[]";
        }
        StringBuilder json = new StringBuilder();
        json.append("[");
        for (int i = 0; i < config.getBots().size(); i++) {
            BotSpawn bot = config.getBots().get(i);
            if (i > 0) {
                json.append(",");
            }
            json.append(botJson(bot.getKey(), bot.getName(), bot.getX(), bot.getY(), bot.getWidth(), bot.getHeight(),
                bot.getLength(), bot.getPropertyCn()));
        }
        json.append("]");
        return json.toString();
    }

    private static String box(String def, int x, int y, int z) {
        return baseEntry("box", def, x, y, z);
    }

    private static String floor(String def, int x, int y, int z) {
        return baseEntry("floor", def, x, y, z);
    }

    private static String baseEntry(String type, String def, int x, int y, int z) {
        return "<" + type
            + " def=\"" + def + "\""
            + " x=\"" + x + "\""
            + " y=\"" + y + "\""
            + " z=\"" + z + "\""
            + " w=\"1\" h=\"1\" d=\"1\""
            + " f=\"0\" s=\"0\" fx=\"0\" lc=\"0\" st=\"0\" sv=\"0\"/>";
    }

    private static void addSceneItem(SFSArray items, FurnitureSpawn spawn) {
        SFSObject obj = new SFSObject();
        obj.putUtfString("id", spawn.getDef());
        obj.putUtfString("type", spawn.getType());
        obj.putInt("x", spawn.getX());
        obj.putInt("y", spawn.getY());
        obj.putInt("z", spawn.getZ());
        obj.putInt("w", 1);
        obj.putInt("h", 1);
        obj.putInt("d", 1);
        obj.putInt("dir", spawn.getRotation());
        obj.putInt("state", 0);
        items.addSFSObject(obj);
    }

    // دالة لإنشاء JSON البوتات بالهيكل الصحيح المطلوب من الكلاينت
    private static String botJson(String key, String name, int x, int y, int w, int h, int length, String propertyCn) {
        String property = propertyCn == null ? "SimpleBotMessageProperty" : propertyCn;
        int safeLength = length <= 0 ? 1 : length;
        return "{"
            + "\"key\":\"" + key + "\","           // مفتاح البوت (metaKey)
            + "\"posX\":" + x + ","                // موضع X (مهم: posX مش x)
            + "\"posY\":" + y + ","                // موضع Y (مهم: posY مش y)
            + "\"width\":" + w + ","               // العرض
            + "\"height\":" + h + ","              // الطول
            + "\"length\":" + safeLength + ","     // الارتفاع (length)
            + "\"ver\":1,"                         // الإصدار (version)
            + "\"property\":{"                     // خصائص البوت
            + "\"cn\":\"" + property + "\""        // نوع الـ Property
            + "},"
            + "\"speechProperty\":null"            // خصائص الكلام (يمكن تركها null)
            + "}";
    }

    private static String buildLegacyMapBase64() {
        return Base64.getEncoder().encodeToString(buildLegacyMapXml().getBytes(StandardCharsets.UTF_8));
    }

    private static String buildLegacyMapXml() {
        StringBuilder xml = new StringBuilder();
        xml.append("<map themes=\"snow\" xOrigin=\"275\" yOrigin=\"614\">");
        xml.append(floor("kugu", 6, 6, 0));
        xml.append(floor("dalga", 8, 6, 0));
        xml.append(floor("iskele", 10, 6, 0));

        xml.append(box("bank_05_a", 12, 10, 0));
        xml.append(box("bank_05_b", 14, 10, 0));
        xml.append(box("cadde_bank1_5", 16, 10, 0));
        xml.append(box("cadde_bank_5", 18, 10, 0));
        xml.append(box("cadde_bank_5", 20, 10, 0));
        xml.append(box("cadde_bank2_5", 22, 10, 0));
        xml.append(box("cadde_bank1_5", 16, 14, 0));
        xml.append(box("cadde_bank_5", 18, 14, 0));
        xml.append(box("cadde_bank_5", 20, 14, 0));
        xml.append(box("cadde_bank2_5", 22, 14, 0));
        xml.append(box("cadde_bank1_5", 16, 18, 0));
        xml.append(box("cadde_bank_5", 18, 18, 0));
        xml.append(box("cadde_bank_5", 20, 18, 0));
        xml.append(box("cadde_bank2_5", 22, 18, 0));
        xml.append(box("cadde_bank1_5", 16, 22, 0));
        xml.append(box("cadde_bank_5", 18, 22, 0));
        xml.append(box("cadde_bank_5", 20, 22, 0));
        xml.append(box("cadde_bank2_5", 22, 22, 0));
        xml.append(box("cadde_bank1_5", 16, 26, 0));
        xml.append(box("cadde_bank_5", 18, 26, 0));
        xml.append(box("cadde_bank_5", 20, 26, 0));
        xml.append(box("cadde_bank2_5", 22, 26, 0));

        xml.append(box("cadde_sezlong_01", 28, 10, 0));
        xml.append(box("cadde_sezlong_02", 30, 10, 0));
        xml.append(box("cadde_sezlong_03", 32, 10, 0));
        xml.append(box("cadde_sezlong_01", 28, 14, 0));
        xml.append(box("cadde_sezlong_02", 30, 14, 0));
        xml.append(box("cadde_sezlong_03", 32, 14, 0));
        xml.append(box("cadde_sezlong_01", 28, 18, 0));
        xml.append(box("cadde_sezlong_02", 30, 18, 0));
        xml.append(box("cadde_sezlong_03", 32, 18, 0));
        xml.append(box("cadde_sezlong_01", 28, 22, 0));
        xml.append(box("cadde_sezlong_02", 30, 22, 0));
        xml.append(box("cadde_sezlong_03", 32, 22, 0));
        xml.append(box("cadde_sezlong_01", 28, 26, 0));
        xml.append(box("cadde_sezlong_02", 30, 26, 0));
        xml.append(box("cadde_sezlong_03", 32, 26, 0));
        xml.append(box("cadde_sezlong_01", 28, 30, 0));
        xml.append(box("cadde_sezlong_02", 30, 30, 0));
        xml.append(box("cadde_sezlong_03", 32, 30, 0));
        xml.append(box("cadde_sezlong", 34, 30, 0));

        xml.append(box("cadde_semsiye", 36, 12, 0));
        xml.append(box("cadde_semsiye", 36, 20, 0));
        xml.append(box("CdTabela2", 40, 18, 0));

        xml.append(box("bitki_duvar_1", 8, 24, 0));
        xml.append(box("bitki_duvar_3", 10, 34, 0));
        xml.append(box("bitki_duvar_2", 20, 34, 20));
        xml.append(box("bitki_duvar_4", 18, 34, 0));

        xml.append("</map>");
        return xml.toString();
    }

    private static ISFSArray buildLegacySceneItems() {
        SFSArray items = new SFSArray();
        addSceneItem(items, new FurnitureSpawn("floor", "kugu", 6, 6, 0, 0));
        addSceneItem(items, new FurnitureSpawn("floor", "dalga", 8, 6, 0, 0));
        addSceneItem(items, new FurnitureSpawn("floor", "iskele", 10, 6, 0, 0));

        addSceneItem(items, new FurnitureSpawn("box", "bank_05_a", 12, 10, 0, 0));
        addSceneItem(items, new FurnitureSpawn("box", "bank_05_b", 14, 10, 0, 0));
        addSceneItem(items, new FurnitureSpawn("box", "cadde_bank1_5", 16, 10, 0, 0));
        addSceneItem(items, new FurnitureSpawn("box", "cadde_bank_5", 18, 10, 0, 0));
        addSceneItem(items, new FurnitureSpawn("box", "cadde_bank_5", 20, 10, 0, 0));
        addSceneItem(items, new FurnitureSpawn("box", "cadde_bank2_5", 22, 10, 0, 0));
        addSceneItem(items, new FurnitureSpawn("box", "cadde_bank1_5", 16, 14, 0, 0));
        addSceneItem(items, new FurnitureSpawn("box", "cadde_bank_5", 18, 14, 0, 0));
        addSceneItem(items, new FurnitureSpawn("box", "cadde_bank_5", 20, 14, 0, 0));
        addSceneItem(items, new FurnitureSpawn("box", "cadde_bank2_5", 22, 14, 0, 0));
        addSceneItem(items, new FurnitureSpawn("box", "cadde_bank1_5", 16, 18, 0, 0));
        addSceneItem(items, new FurnitureSpawn("box", "cadde_bank_5", 18, 18, 0, 0));
        addSceneItem(items, new FurnitureSpawn("box", "cadde_bank_5", 20, 18, 0, 0));
        addSceneItem(items, new FurnitureSpawn("box", "cadde_bank2_5", 22, 18, 0, 0));
        addSceneItem(items, new FurnitureSpawn("box", "cadde_bank1_5", 16, 22, 0, 0));
        addSceneItem(items, new FurnitureSpawn("box", "cadde_bank_5", 18, 22, 0, 0));
        addSceneItem(items, new FurnitureSpawn("box", "cadde_bank_5", 20, 22, 0, 0));
        addSceneItem(items, new FurnitureSpawn("box", "cadde_bank2_5", 22, 22, 0, 0));
        addSceneItem(items, new FurnitureSpawn("box", "cadde_bank1_5", 16, 26, 0, 0));
        addSceneItem(items, new FurnitureSpawn("box", "cadde_bank_5", 18, 26, 0, 0));
        addSceneItem(items, new FurnitureSpawn("box", "cadde_bank_5", 20, 26, 0, 0));
        addSceneItem(items, new FurnitureSpawn("box", "cadde_bank2_5", 22, 26, 0, 0));

        addSceneItem(items, new FurnitureSpawn("box", "cadde_sezlong_01", 28, 10, 0, 0));
        addSceneItem(items, new FurnitureSpawn("box", "cadde_sezlong_02", 30, 10, 0, 0));
        addSceneItem(items, new FurnitureSpawn("box", "cadde_sezlong_03", 32, 10, 0, 0));
        addSceneItem(items, new FurnitureSpawn("box", "cadde_sezlong_01", 28, 14, 0, 0));
        addSceneItem(items, new FurnitureSpawn("box", "cadde_sezlong_02", 30, 14, 0, 0));
        addSceneItem(items, new FurnitureSpawn("box", "cadde_sezlong_03", 32, 14, 0, 0));
        addSceneItem(items, new FurnitureSpawn("box", "cadde_sezlong_01", 28, 18, 0, 0));
        addSceneItem(items, new FurnitureSpawn("box", "cadde_sezlong_02", 30, 18, 0, 0));
        addSceneItem(items, new FurnitureSpawn("box", "cadde_sezlong_03", 32, 18, 0, 0));
        addSceneItem(items, new FurnitureSpawn("box", "cadde_sezlong_01", 28, 22, 0, 0));
        addSceneItem(items, new FurnitureSpawn("box", "cadde_sezlong_02", 30, 22, 0, 0));
        addSceneItem(items, new FurnitureSpawn("box", "cadde_sezlong_03", 32, 22, 0, 0));
        addSceneItem(items, new FurnitureSpawn("box", "cadde_sezlong_01", 28, 26, 0, 0));
        addSceneItem(items, new FurnitureSpawn("box", "cadde_sezlong_02", 30, 26, 0, 0));
        addSceneItem(items, new FurnitureSpawn("box", "cadde_sezlong_03", 32, 26, 0, 0));
        addSceneItem(items, new FurnitureSpawn("box", "cadde_sezlong_01", 28, 30, 0, 0));
        addSceneItem(items, new FurnitureSpawn("box", "cadde_sezlong_02", 30, 30, 0, 0));
        addSceneItem(items, new FurnitureSpawn("box", "cadde_sezlong_03", 32, 30, 0, 0));
        addSceneItem(items, new FurnitureSpawn("box", "cadde_sezlong", 34, 30, 0, 0));

        addSceneItem(items, new FurnitureSpawn("box", "cadde_semsiye", 36, 12, 0, 0));
        addSceneItem(items, new FurnitureSpawn("box", "cadde_semsiye", 36, 20, 0, 0));
        addSceneItem(items, new FurnitureSpawn("box", "CdTabela2", 40, 18, 0, 0));

        addSceneItem(items, new FurnitureSpawn("box", "bitki_duvar_1", 8, 24, 0, 0));
        addSceneItem(items, new FurnitureSpawn("box", "bitki_duvar_3", 10, 34, 0, 0));
        addSceneItem(items, new FurnitureSpawn("box", "bitki_duvar_2", 20, 34, 20, 0));
        addSceneItem(items, new FurnitureSpawn("box", "bitki_duvar_4", 18, 34, 0, 0));
        return items;
    }

    private static String buildLegacyDoorsJson() {
        return "[{\"key\":\"" + DEFAULT_DOOR_KEY + "\",\"targetX\":5,\"targetY\":5,\"targetDir\":0,"
            + "\"property\":{\"cn\":\"FlatExitProperty\"}}]";
    }

    private static String buildLegacyBotsJson() {
        return "["
            + botJson("baloncuBengu", "ديانا", 35, 24, 1, 1, 1, "SimpleBotMessageProperty") + ","
            + botJson("guvenlik2", "حارس X", 24, 35, 1, 1, 1, "SimpleBotMessageProperty") + ","
            + botJson("airportBillboardSmall", "airportBillboardSmall", 9, 22, 3, 2, 1, "SimpleBotMessageProperty") + ","
            + botJson("tahsin", "الساعي تحسين", 24, 28, 1, 1, 1, "SimpleBotMessageProperty") + ","
            + botJson("beggars", "فقير", 46, 22, 1, 1, 1, "SimpleBotMessageProperty") + ","
            + botJson("giftStandNew", "ستاند الهدايا", 29, 2, 2, 6, 1, "SimpleBotMessageProperty") + ","
            + botJson("sanalikaxKapiBot", "sanalikaxKapiBot", 22, 36, 3, 3, 1, "SimpleBotMessageProperty") + ","
            + botJson("newspaperStand3", "newspaperStand3", 22, 23, 4, 2, 1, "SimpleBotMessageProperty")
            + "]";
    }

    private static void logRoomBuild(String roomKey, int furnitureCount, int botsCount, int doorsCount,
                                     String source, String warning) {
        StringBuilder log = new StringBuilder();
        log.append("[ROOM_BUILD] roomKey=").append(roomKey)
            .append(" furniture=").append(furnitureCount)
            .append(" bots=").append(botsCount)
            .append(" doors=").append(doorsCount)
            .append(" source=").append(source);
        if (warning != null && !warning.isEmpty()) {
            log.append(" warning=").append(warning);
        }
        System.out.println(log);
    }

    public static final class RoomBuildData {
        private final String mapBase64;
        private final String doorsJson;
        private final String botsJson;
        private final ISFSArray sceneItems;
        private final String source;

        public RoomBuildData(String mapBase64, String doorsJson, String botsJson, ISFSArray sceneItems, String source) {
            this.mapBase64 = mapBase64 == null ? "" : mapBase64;
            this.doorsJson = doorsJson == null ? "[]" : doorsJson;
            this.botsJson = botsJson == null ? "[]" : botsJson;
            this.sceneItems = sceneItems == null ? new SFSArray() : sceneItems;
            this.source = source == null ? "config" : source;
        }

        public String getMapBase64() {
            return mapBase64;
        }

        public String getDoorsJson() {
            return doorsJson;
        }

        public String getBotsJson() {
            return botsJson;
        }

        public ISFSArray getSceneItems() {
            return sceneItems;
        }

        public String getSource() {
            return source;
        }

        public int getFurnitureCount() {
            return sceneItems == null ? 0 : sceneItems.size();
        }

        public int getBotsCount() {
            if (botsJson == null || botsJson.equals("[]")) {
                return 0;
            }
            return botsJson.split("\\{\"key\"").length - 1;
        }

        public int getDoorsCount() {
            if (doorsJson == null || doorsJson.equals("[]")) {
                return 0;
            }
            return doorsJson.split("\\{\"key\"").length - 1;
        }
    }
}
