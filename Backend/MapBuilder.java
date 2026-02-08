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

    private MapBuilder() {}

    public static RoomPayload buildRoomPayload(String roomKey, String doorKey) {
        String resolvedRoomKey = roomKey == null || roomKey.isEmpty() ? DEFAULT_ROOM_KEY : roomKey;
        String resolvedDoorKey = doorKey == null || doorKey.isEmpty() ? DEFAULT_DOOR_KEY : doorKey;
        return new RoomPayload(resolvedRoomKey, resolvedDoorKey, DEFAULT_PV, DEFAULT_DV, buildMapBase64());
    }

    public static String buildMapBase64() {
        return Base64.getEncoder().encodeToString(buildMapXml().getBytes(StandardCharsets.UTF_8));
    }

    public static String buildMapXml() {
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

    public static ISFSArray buildSceneItems() {
        SFSArray items = new SFSArray();
        addSceneItem(items, "kugu", "floor", 6, 6, 0);
        addSceneItem(items, "dalga", "floor", 8, 6, 0);
        addSceneItem(items, "iskele", "floor", 10, 6, 0);

        addSceneItem(items, "bank_05_a", "box", 12, 10, 0);
        addSceneItem(items, "bank_05_b", "box", 14, 10, 0);
        addSceneItem(items, "cadde_bank1_5", "box", 16, 10, 0);
        addSceneItem(items, "cadde_bank_5", "box", 18, 10, 0);
        addSceneItem(items, "cadde_bank_5", "box", 20, 10, 0);
        addSceneItem(items, "cadde_bank2_5", "box", 22, 10, 0);
        addSceneItem(items, "cadde_bank1_5", "box", 16, 14, 0);
        addSceneItem(items, "cadde_bank_5", "box", 18, 14, 0);
        addSceneItem(items, "cadde_bank_5", "box", 20, 14, 0);
        addSceneItem(items, "cadde_bank2_5", "box", 22, 14, 0);
        addSceneItem(items, "cadde_bank1_5", "box", 16, 18, 0);
        addSceneItem(items, "cadde_bank_5", "box", 18, 18, 0);
        addSceneItem(items, "cadde_bank_5", "box", 20, 18, 0);
        addSceneItem(items, "cadde_bank2_5", "box", 22, 18, 0);
        addSceneItem(items, "cadde_bank1_5", "box", 16, 22, 0);
        addSceneItem(items, "cadde_bank_5", "box", 18, 22, 0);
        addSceneItem(items, "cadde_bank_5", "box", 20, 22, 0);
        addSceneItem(items, "cadde_bank2_5", "box", 22, 22, 0);
        addSceneItem(items, "cadde_bank1_5", "box", 16, 26, 0);
        addSceneItem(items, "cadde_bank_5", "box", 18, 26, 0);
        addSceneItem(items, "cadde_bank_5", "box", 20, 26, 0);
        addSceneItem(items, "cadde_bank2_5", "box", 22, 26, 0);

        addSceneItem(items, "cadde_sezlong_01", "box", 28, 10, 0);
        addSceneItem(items, "cadde_sezlong_02", "box", 30, 10, 0);
        addSceneItem(items, "cadde_sezlong_03", "box", 32, 10, 0);
        addSceneItem(items, "cadde_sezlong_01", "box", 28, 14, 0);
        addSceneItem(items, "cadde_sezlong_02", "box", 30, 14, 0);
        addSceneItem(items, "cadde_sezlong_03", "box", 32, 14, 0);
        addSceneItem(items, "cadde_sezlong_01", "box", 28, 18, 0);
        addSceneItem(items, "cadde_sezlong_02", "box", 30, 18, 0);
        addSceneItem(items, "cadde_sezlong_03", "box", 32, 18, 0);
        addSceneItem(items, "cadde_sezlong_01", "box", 28, 22, 0);
        addSceneItem(items, "cadde_sezlong_02", "box", 30, 22, 0);
        addSceneItem(items, "cadde_sezlong_03", "box", 32, 22, 0);
        addSceneItem(items, "cadde_sezlong_01", "box", 28, 26, 0);
        addSceneItem(items, "cadde_sezlong_02", "box", 30, 26, 0);
        addSceneItem(items, "cadde_sezlong_03", "box", 32, 26, 0);
        addSceneItem(items, "cadde_sezlong_01", "box", 28, 30, 0);
        addSceneItem(items, "cadde_sezlong_02", "box", 30, 30, 0);
        addSceneItem(items, "cadde_sezlong_03", "box", 32, 30, 0);
        addSceneItem(items, "cadde_sezlong", "box", 34, 30, 0);

        addSceneItem(items, "cadde_semsiye", "box", 36, 12, 0);
        addSceneItem(items, "cadde_semsiye", "box", 36, 20, 0);
        addSceneItem(items, "CdTabela2", "box", 40, 18, 0);

        addSceneItem(items, "bitki_duvar_1", "box", 8, 24, 0);
        addSceneItem(items, "bitki_duvar_3", "box", 10, 34, 0);
        addSceneItem(items, "bitki_duvar_2", "box", 20, 34, 20);
        addSceneItem(items, "bitki_duvar_4", "box", 18, 34, 0);
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

    public static String buildDoorsJson() {
        return "[{\"key\":\"" + DEFAULT_DOOR_KEY + "\",\"targetX\":5,\"targetY\":5,\"targetDir\":0,"
            + "\"property\":{\"cn\":\"FlatExitProperty\"}}]";
    }

    public static String buildBotsJson() {
        return "["
            + botJson("baloncuBengu", "ديانا", 35, 24, 1, 1) + ","
            + botJson("guvenlik2", "حارس X", 24, 35, 1, 1) + ","
            + botJson("airportBillboardSmall", "airportBillboardSmall", 9, 22, 3, 2) + ","
            + botJson("tahsin", "الساعي تحسين", 24, 28, 1, 1) + ","
            + botJson("beggars", "فقير", 46, 22, 1, 1) + ","
            + botJson("giftStandNew", "ستاند الهدايا", 29, 2, 2, 6) + ","
            + botJson("sanalikaxKapiBot", "sanalikaxKapiBot", 22, 36, 3, 3) + ","
            + botJson("newspaperStand3", "newspaperStand3", 22, 23, 4, 2)
            + "]";
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

    private static void addSceneItem(SFSArray items, String id, String type, int x, int y, int z) {
        SFSObject obj = new SFSObject();
        obj.putUtfString("id", id);
        obj.putUtfString("type", type);
        obj.putInt("x", x);
        obj.putInt("y", y);
        obj.putInt("z", z);
        obj.putInt("w", 1);
        obj.putInt("h", 1);
        obj.putInt("d", 1);
        obj.putInt("dir", 0);
        obj.putInt("state", 0);
        items.addSFSObject(obj);
    }

    // دالة لإنشاء JSON البوتات بالهيكل الصحيح المطلوب من الكلاينت
    private static String botJson(String key, String name, int x, int y, int w, int h) {
        return "{"
            + "\"key\":\"" + key + "\","           // مفتاح البوت (metaKey)
            + "\"posX\":" + x + ","                // موضع X (مهم: posX مش x)
            + "\"posY\":" + y + ","                // موضع Y (مهم: posY مش y)
            + "\"width\":" + w + ","               // العرض
            + "\"height\":" + h + ","              // الطول
            + "\"length\":1,"                      // الارتفاع (length)
            + "\"ver\":1,"                         // الإصدار (version)
            + "\"property\":{"                     // خصائص البوت
            + "\"cn\":\"SimpleBotMessageProperty\"" // نوع الـ Property
            + "},"
            + "\"speechProperty\":null"            // خصائص الكلام (يمكن تركها null)
            + "}";
    }
}