package src5;

import com.smartfoxserver.v2.entities.data.ISFSArray;
import com.smartfoxserver.v2.entities.data.SFSArray;
import com.smartfoxserver.v2.entities.data.SFSObject;
import java.io.File;
import java.io.IOException;
import java.nio.charset.StandardCharsets;
import java.nio.file.Files;
import java.util.ArrayList;
import java.util.Arrays;
import java.util.Base64;
import java.util.Collections;
import java.util.HashMap;
import java.util.List;
import java.util.Locale;
import java.util.Map;

public final class DefaultClothesBuilder {
    private DefaultClothesBuilder() {}

    private static final Map<Integer, String> PLACEBIT_TO_SUBTYPE = buildPlaceBitMap();
    private static final Map<String, List<String>> DEFAULT_CLIP_PREFERENCES = buildDefaultClipPreferences();
    private static final Object LOCK = new Object();
    private static Map<String, ClothDefinition> definitionsByClip;

    public static DefaultOutfit buildDefaultOutfit(String gender) {
        Map<String, ClothDefinition> definitions = getDefinitions();
        Map<String, ClothDefinition> selection = new HashMap<>();
        for (String subtype : requiredSubtypes()) {
            ClothDefinition preferred = selectDefaultForSubtype(definitions, subtype, gender);
            if (preferred != null) {
                selection.put(subtype, preferred);
            }
        }
        SFSArray items = new SFSArray();
        for (String subtype : requiredSubtypes()) {
            ClothDefinition def = selection.get(subtype);
            if (def != null) {
                int color = pickDefaultColor(def);
                items.addSFSObject(buildItem(def, color));
            } else {
                ClothDefinition fallback = fallbackDefinition(subtype);
                if (fallback != null) {
                    items.addSFSObject(buildItem(fallback, pickDefaultColor(fallback)));
                }
            }
        }
        return new DefaultOutfit(items, selection);
    }

    public static ISFSArray buildDefaultItems(String gender) {
        return buildDefaultOutfit(gender).getItems();
    }

    /**
     * ✅ FIXED: Changed from putInt("type", CLOTH) to putUtfString("type", "CLOTH")
     * This matches InitHandler.java and ClothListHandler.java behavior
     */
    public static SFSObject buildClothesObject(ISFSArray items) {
        SFSObject clothesObj = new SFSObject();
        clothesObj.putUtfString("type", "CLOTH");  // ✅ FIXED: String instead of Int
        clothesObj.putSFSArray("items", items == null ? new SFSArray() : items);
        return clothesObj;
    }

    public static ClothDefinition findDefinition(String clip) {
        if (clip == null) {
            return null;
        }
        return getDefinitions().get(clip);
    }

    public static List<ClothDefinition> getAllDefinitions() {
        return new ArrayList<>(getDefinitions().values());
    }

    public static String getSubTypeByClip(String clip) {
        ClothDefinition def = findDefinition(clip);
        if (def == null) {
            return "BODY";
        }
        String subtype = PLACEBIT_TO_SUBTYPE.get(def.placeBit);
        return subtype == null ? "BODY" : subtype;
    }

    public static boolean isSupportedPlaceBit(int placeBit) {
        return PLACEBIT_TO_SUBTYPE.containsKey(placeBit);
    }

    public static int resolveColorForClip(String clip, int requestedColor) {
        ClothDefinition def = findDefinition(clip);
        if (def == null || def.colors.isEmpty()) {
            return requestedColor;
        }
        if (def.colors.contains(requestedColor)) {
            return requestedColor;
        }
        return def.colors.get(0);
    }

    public static int getProductIDByClip(String clip) {
        ClothDefinition def = findDefinition(clip);
        return def == null ? 0 : def.productId;
    }

    public static SFSObject buildItem(ClothDefinition def, int color) {
        SFSObject item = new SFSObject();
        int productID = def == null ? 0 : def.productId;
        String subType = def == null ? "BODY" : getSubTypeByClip(def.clip);
        String clip = def == null ? "" : def.clip;

        item.putInt("quantity", 1);
        item.putInt("color", color);
        item.putUtfString("createdAt", String.valueOf(System.currentTimeMillis()));
        item.putUtfString("roles", "AA==");
        item.putInt("active", 1);
        item.putUtfString("source", "FREE");
        item.putInt("expire", 0);
        item.putBool("transferrable", false);
        item.putInt("base", 1);
        item.putInt("productID", productID);
        item.putInt("id", 0);
        item.putUtfString("subType", subType);
        item.putInt("lifeTime", 0);
        item.putUtfString("clip", clip + "_" + color);
        item.putInt("timeLeft", 0);

        return item;
    }

    private static Map<Integer, String> buildPlaceBitMap() {
        Map<Integer, String> map = new HashMap<>();
        map.put(4, "BODY");
        map.put(2, "FACE");
        map.put(1, "HEAD");
        map.put(512, "SHIRT");
        map.put(64, "PANTS");
        map.put(16, "SHOES");
        map.put(131072, "HAIR");
        return map;
    }

    private static Map<String, List<String>> buildDefaultClipPreferences() {
        Map<String, List<String>> map = new HashMap<>();
        map.put("BODY", Arrays.asList("A", "ya"));
        map.put("FACE", Arrays.asList("B", "yb"));
        map.put("HEAD", Arrays.asList("C", "yc"));
        map.put("SHIRT", Arrays.asList("4", "5"));
        map.put("PANTS", Arrays.asList("1", "2"));
        map.put("SHOES", Arrays.asList("7", "6"));
        map.put("HAIR", Arrays.asList("6", "8", "9", "10", "11", "12", "13"));
        return map;
    }

    private static List<String> requiredSubtypes() {
        return Arrays.asList("BODY", "FACE", "HEAD", "SHIRT", "PANTS", "SHOES", "HAIR");
    }

    public static List<String> getRequiredSubtypes() {
        return new ArrayList<>(requiredSubtypes());
    }

    private static ClothDefinition selectDefaultForSubtype(Map<String, ClothDefinition> definitions,
                                                           String subtype,
                                                           String gender) {
        List<String> preferredClips = DEFAULT_CLIP_PREFERENCES.getOrDefault(subtype, Collections.emptyList());
        for (String clip : preferredClips) {
            ClothDefinition def = definitions.get(clip);
            if (def != null && subtype.equals(PLACEBIT_TO_SUBTYPE.get(def.placeBit))
                && matchesGender(def, gender)) {
                return def;
            }
        }
        for (ClothDefinition def : definitions.values()) {
            if (subtype.equals(PLACEBIT_TO_SUBTYPE.get(def.placeBit)) && matchesGender(def, gender)) {
                return def;
            }
        }
        return null;
    }

    private static ClothDefinition fallbackDefinition(String subtype) {
        List<String> preferredClips = DEFAULT_CLIP_PREFERENCES.getOrDefault(subtype, Collections.emptyList());
        if (preferredClips.isEmpty()) {
            return null;
        }
        String clip = preferredClips.get(0);
        int placeBit = 0;
        for (Map.Entry<Integer, String> entry : PLACEBIT_TO_SUBTYPE.entrySet()) {
            if (subtype.equals(entry.getValue())) {
                placeBit = entry.getKey();
                break;
            }
        }
        return new ClothDefinition(clip, Collections.singletonList(1), placeBit, 0, 0, 0, 0);
    }

    private static boolean matchesGender(ClothDefinition def, String gender) {
        if (def == null) {
            return false;
        }
        if (gender == null) {
            return true;
        }
        String normalized = gender.toLowerCase(Locale.ROOT);
        if (def.gender == 0) {
            return true;
        }
        if ("f".equals(normalized)) {
            return def.gender == 1;
        }
        if ("m".equals(normalized)) {
            return def.gender == 2 || def.gender == 0;
        }
        return true;
    }

    private static int pickDefaultColor(ClothDefinition def) {
        if (def == null || def.colors.isEmpty()) {
            return 1;
        }
        return def.colors.get(0);
    }

    private static Map<String, ClothDefinition> getDefinitions() {
        Map<String, ClothDefinition> current = definitionsByClip;
        if (current != null) {
            return current;
        }
        synchronized (LOCK) {
            if (definitionsByClip == null) {
                definitionsByClip = loadDefinitions();
            }
            return definitionsByClip;
        }
    }

    private static Map<String, ClothDefinition> loadDefinitions() {
        File file = findIfile();
        if (file == null) {
            return Collections.emptyMap();
        }
        try {
            byte[] encoded = Files.readAllBytes(file.toPath());
            byte[] decoded = Base64.getDecoder().decode(encoded);
            String text = new String(decoded, StandardCharsets.UTF_8);
            Map<String, ClothDefinition> map = new HashMap<>();
            for (String line : text.split("\\r?\\n")) {
                if (line.trim().isEmpty()) {
                    continue;
                }
                String[] parts = line.split("\\|");
                if (parts.length != 7) {
                    continue;
                }
                String clip = parts[0];
                if (clip == null || clip.trim().isEmpty()) {
                    continue;
                }
                List<Integer> colors = parseColors(parts[1]);
                int placeBit = parseInt(parts[2]);
                int productId = parseInt(parts[3]);
                int offsetX = parseInt(parts[4]);
                int offsetY = parseInt(parts[5]);
                int gender = parseInt(parts[6]);
                map.put(clip, new ClothDefinition(clip, colors, placeBit, productId, offsetX, offsetY, gender));
            }
            return map;
        } catch (IOException | IllegalArgumentException e) {
            return Collections.emptyMap();
        }
    }

    private static File findIfile() {
        File cwd = new File(".");
        File[] files = cwd.listFiles();
        if (files == null) {
            return null;
        }
        for (File file : files) {
            if (!file.isFile()) {
                continue;
            }
            String name = file.getName();
            if (name.startsWith("ifile.") || name.startsWith("ifile")) {
                return file;
            }
        }
        return null;
    }

    private static List<Integer> parseColors(String value) {
        if (value == null || value.trim().isEmpty()) {
            return Collections.singletonList(1);
        }
        List<Integer> colors = new ArrayList<>();
        for (String part : value.split(",")) {
            int color = parseInt(part);
            if (color > 0) {
                colors.add(color);
            }
        }
        if (colors.isEmpty()) {
            colors.add(1);
        }
        return colors;
    }

    private static int parseInt(String value) {
        try {
            return Integer.parseInt(value.trim());
        } catch (Exception e) {
            return 0;
        }
    }

    public static final class ClothDefinition {
        private final String clip;
        private final List<Integer> colors;
        private final int placeBit;
        private final int productId;
        private final int offsetX;
        private final int offsetY;
        private final int gender;

        private ClothDefinition(String clip,
                                List<Integer> colors,
                                int placeBit,
                                int productId,
                                int offsetX,
                                int offsetY,
                                int gender) {
            this.clip = clip;
            this.colors = colors == null ? Collections.emptyList() : colors;
            this.placeBit = placeBit;
            this.productId = productId;
            this.offsetX = offsetX;
            this.offsetY = offsetY;
            this.gender = gender;
        }

        public String getClip() {
            return clip;
        }

        public List<Integer> getColors() {
            return colors;
        }

        public int getPlaceBit() {
            return placeBit;
        }

        public int getProductId() {
            return productId;
        }

        public int getOffsetX() {
            return offsetX;
        }

        public int getOffsetY() {
            return offsetY;
        }

        public int getGender() {
            return gender;
        }
    }

    public static final class DefaultOutfit {
        private final ISFSArray items;
        private final Map<String, ClothDefinition> selection;

        private DefaultOutfit(ISFSArray items, Map<String, ClothDefinition> selection) {
            this.items = items;
            this.selection = selection;
        }

        public ISFSArray getItems() {
            return items;
        }

        public Map<String, ClothDefinition> getSelection() {
            return selection;
        }
    }
}