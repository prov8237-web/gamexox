package src5;

import com.smartfoxserver.v2.entities.data.SFSArray;
import java.util.Collections;
import java.util.LinkedHashMap;
import java.util.Map;
import java.util.Set;
import java.util.stream.Collectors;

public final class BotMessageCatalog {
    public static final class BotDefinition {
        private final String key;
        private final String[] colors;

        private BotDefinition(String key, String[] colors) {
            this.key = key;
            this.colors = colors;
        }

        public String getKey() {
            return key;
        }

        public SFSArray buildColors() {
            SFSArray colorsArray = new SFSArray();
            for (String color : colors) {
                colorsArray.addUtfString(color);
            }
            return colorsArray;
        }
    }

    private static final Map<String, BotDefinition> DEFINITIONS;

    static {
        Map<String, BotDefinition> defs = new LinkedHashMap<>();
        register(defs, "musa", new String[] {"FF5722", "FFFFFF", "D84315", "E64A19"});
        register(defs, "egyptmod", new String[] {"1E88E5", "FFFFFF", "0D47A1", "1565C0"});
        register(defs, "botMarhab", new String[] {"43A047", "FFFFFF", "1B5E20", "2E7D32"});
        register(defs, "fahman", new String[] {"8E24AA", "FFFFFF", "4A148C", "6A1B9A"});
        register(defs, "cenkay", new String[] {"1a629b", "ffffff", "3394e0", "227abf"});
        register(defs, "ulubilge", new String[] {"E53935", "FFFFFF", "B71C1C", "C62828"});
        register(defs, "batuhandiamond", new String[] {"00ACC1", "FFFFFF", "006064", "00838F"});
        register(defs, "canca_bot", new String[] {"FF9800", "FFFFFF", "F57C00", "EF6C00"});
        register(defs, "countryBot3", new String[] {"4CAF50", "FFFFFF", "2E7D32", "388E3C"});
        register(defs, "countryBot5", new String[] {"2196F3", "FFFFFF", "0D47A1", "1565C0"});
        register(defs, "bigboss", new String[] {"9C27B0", "FFFFFF", "6A1B9A", "7B1FA2"});
        register(defs, "batuhan", new String[] {"00BCD4", "FFFFFF", "00838F", "0097A7"});
        register(defs, "jaberBot", new String[] {"FF5722", "FFFFFF", "BF360C", "D84315"});
        register(defs, "janja_bot", new String[] {"E91E63", "FFFFFF", "AD1457", "C2185B"});
        register(defs, "kion_bot", new String[] {"673AB7", "FFFFFF", "4527A0", "512DA8"});
        register(defs, "kozalak_bot", new String[] {"795548", "FFFFFF", "4E342E", "5D4037"});
        register(defs, "moroccoBot", new String[] {"C62828", "FFFFFF", "B71C1C", "D32F2F"});
        register(defs, "musicBot", new String[] {"9C27B0", "FFFFFF", "6A1B9A", "7B1FA2"});
        register(defs, "musicStoreBot", new String[] {"FF9800", "FFFFFF", "F57C00", "EF6C00"});
        register(defs, "pierbeachbot3", new String[] {"00ACC1", "FFFFFF", "00838F", "0097A7"});
        register(defs, "botAlgeria", new String[] {"008000", "FFFFFF", "006400", "228B22"});
        DEFINITIONS = Collections.unmodifiableMap(defs);
    }

    private BotMessageCatalog() {}

    private static void register(Map<String, BotDefinition> defs, String key, String[] colors) {
        defs.put(key.toLowerCase(), new BotDefinition(key, colors));
    }

    public static BotDefinition resolve(String rawKey) {
        if (rawKey == null) {
            return null;
        }
        return DEFINITIONS.get(rawKey.trim().toLowerCase());
    }

    public static Set<String> allowedKeys() {
        return DEFINITIONS.values().stream()
                .map(BotDefinition::getKey)
                .collect(Collectors.toSet());
    }

    public static String allowedKeysMessage() {
        return DEFINITIONS.values().stream()
                .map(BotDefinition::getKey)
                .collect(Collectors.joining(", "));
    }
}
