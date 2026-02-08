package src5;

import com.smartfoxserver.v2.entities.User;
import com.smartfoxserver.v2.entities.data.ISFSArray;
import com.smartfoxserver.v2.entities.data.ISFSObject;
import com.smartfoxserver.v2.entities.variables.UserVariable;
import java.util.ArrayList;
import java.util.LinkedHashMap;
import java.util.List;
import java.util.Map;

public final class RenderGateAudit {
    private RenderGateAudit() {}

    public static List<String> audit(User user, InMemoryStore.UserState state, String stage) {
        List<String> lines = new ArrayList<>();
        Map<String, String> expected = new LinkedHashMap<>();
        expected.put("avatarName", "String");
        expected.put("gender", "String");
        expected.put("playerID", "Number");
        expected.put("imgPath", "String");
        expected.put("optimizedAssetKey", "String");
        expected.put("avatarSize", "Number");
        expected.put("speed", "Number");
        expected.put("mood", "Number");
        expected.put("platform", "String");
        expected.put("statusMessage", "String");
        expected.put("universeKey", "String");
        expected.put("position", "String");
        expected.put("direction", "Number");
        expected.put("clothes", "String");

        List<String> missing = new ArrayList<>();
        List<String> wrongTypes = new ArrayList<>();
        StringBuilder keysSummary = new StringBuilder();

        for (Map.Entry<String, String> entry : expected.entrySet()) {
            String key = entry.getKey();
            String expectedType = entry.getValue();
            UserVariable var = user.getVariable(key);
            Object value = var != null ? var.getValue() : null;
            if (var == null || value == null) {
                missing.add(key);
                appendKeySummary(keysSummary, key, "missing");
                continue;
            }
            boolean typeOk = isTypeMatch(value, expectedType);
            appendKeySummary(keysSummary, key, value.getClass().getSimpleName());
            if (!typeOk) {
                wrongTypes.add(key + " expected=" + expectedType + " got=" + value.getClass().getSimpleName());
            }
        }

        ISFSArray clothesItems = state != null ? state.getClothesItems() : null;
        int clothesLen = clothesItems == null ? 0 : clothesItems.size();
        String firstClip = "-";
        String firstSubType = "-";
        String firstProduct = "-";
        String firstColor = "-";
        List<String> clothesFailures = new ArrayList<>();

        if (clothesLen > 0) {
            ISFSObject first = clothesItems.getSFSObject(0);
            if (first != null) {
                firstClip = readStringField(first, "clip", "firstItem", clothesFailures);
                firstSubType = readStringField(first, "subType", "firstItem", clothesFailures);
                firstProduct = readIntField(first, "productID", "firstItem", clothesFailures);
                firstColor = readIntField(first, "color", "firstItem", clothesFailures);
            } else {
                clothesFailures.add("firstItem_null");
            }
        } else {
            clothesFailures.add("clothes_items_empty");
        }

        ClothesUserVarAudit clothesUserVarAudit = auditClothesUserVar(user);

        String summary = "[RENDER_AUDIT] stage=" + stage
                + " keys={" + keysSummary + "}"
                + " clothesLen=" + clothesLen
                + " firstItem={clip:" + firstClip
                + " subType:" + firstSubType
                + " productID:" + firstProduct
                + " color:" + firstColor + "}"
                + " clothesKeysLen=" + clothesUserVarAudit.keysLen
                + " clothesFirstKey=" + clothesUserVarAudit.firstKey;
        lines.add(summary);

        if (!missing.isEmpty() || !wrongTypes.isEmpty() || !clothesFailures.isEmpty() || !clothesUserVarAudit.failures.isEmpty()) {
            String failure = "[RENDER_AUDIT_FAIL] stage=" + stage
                    + " missing=" + missing
                    + " wrongTypes=" + wrongTypes
                    + " clothesIssues=" + clothesFailures
                    + " clothesUserVarIssues=" + clothesUserVarAudit.failures;
            lines.add(failure);
        }

        return lines;
    }

    private static void appendKeySummary(StringBuilder builder, String key, String type) {
        if (builder.length() > 0) {
            builder.append(",");
        }
        builder.append(key).append(":").append(type);
    }

    private static boolean isTypeMatch(Object value, String expectedType) {
        if ("String".equals(expectedType)) {
            return value instanceof String;
        }
        if ("Number".equals(expectedType)) {
            return value instanceof Number;
        }
        return true;
    }

    private static String readStringField(ISFSObject obj, String key, String prefix, List<String> errors) {
        if (!obj.containsKey(key)) {
            errors.add(prefix + "_missing_" + key);
            return "-";
        }
        try {
            return String.valueOf(obj.getUtfString(key));
        } catch (Exception e) {
            errors.add(prefix + "_wrongType_" + key + "_expected_String");
            return "-";
        }
    }

    private static String readIntField(ISFSObject obj, String key, String prefix, List<String> errors) {
        if (!obj.containsKey(key)) {
            errors.add(prefix + "_missing_" + key);
            return "-";
        }
        try {
            return String.valueOf(obj.getInt(key));
        } catch (Exception e) {
            errors.add(prefix + "_wrongType_" + key + "_expected_Int");
            return "-";
        }
    }

    private static ClothesUserVarAudit auditClothesUserVar(User user) {
        ClothesUserVarAudit audit = new ClothesUserVarAudit();
        if (user == null) {
            audit.failures.add("user_null");
            return audit;
        }
        UserVariable clothesVar = user.getVariable("clothes");
        Object value = clothesVar != null ? clothesVar.getValue() : null;
        if (!(value instanceof String)) {
            audit.failures.add("clothes_user_var_not_string");
            return audit;
        }
        String raw = (String) value;
        List<String> parsed = parseJsonStringArray(raw, audit.failures);
        audit.keysLen = parsed.size();
        if (!parsed.isEmpty()) {
            audit.firstKey = parsed.get(0);
        }
        return audit;
    }

    private static List<String> parseJsonStringArray(String raw, List<String> failures) {
        List<String> values = new ArrayList<>();
        if (raw == null) {
            failures.add("clothes_user_var_null");
            return values;
        }
        String trimmed = raw.trim();
        if (trimmed.isEmpty()) {
            failures.add("clothes_user_var_empty");
            return values;
        }
        if (!trimmed.startsWith("[") || !trimmed.endsWith("]")) {
            failures.add("clothes_user_var_not_array");
            return values;
        }
        String body = trimmed.substring(1, trimmed.length() - 1).trim();
        if (body.isEmpty()) {
            return values;
        }
        int i = 0;
        boolean expectingValue = true;
        while (i < body.length()) {
            char c = body.charAt(i);
            if (Character.isWhitespace(c)) {
                i++;
                continue;
            }
            if (expectingValue) {
                if (c != '"') {
                    failures.add("clothes_user_var_non_string_token_at_" + i);
                    break;
                }
                i++;
                StringBuilder current = new StringBuilder();
                boolean closed = false;
                boolean escaped = false;
                while (i < body.length()) {
                    char ch = body.charAt(i);
                    if (escaped) {
                        current.append(ch);
                        escaped = false;
                        i++;
                        continue;
                    }
                    if (ch == '\\') {
                        escaped = true;
                        i++;
                        continue;
                    }
                    if (ch == '"') {
                        closed = true;
                        i++;
                        break;
                    }
                    current.append(ch);
                    i++;
                }
                if (!closed) {
                    failures.add("clothes_user_var_unterminated_string");
                    break;
                }
                values.add(current.toString());
                expectingValue = false;
            } else {
                if (c == ',') {
                    expectingValue = true;
                    i++;
                } else {
                    failures.add("clothes_user_var_missing_comma_at_" + i);
                    break;
                }
            }
        }
        if (expectingValue && failures.isEmpty()) {
            failures.add("clothes_user_var_trailing_comma");
        }
        return values;
    }

    private static final class ClothesUserVarAudit {
        private int keysLen = 0;
        private String firstKey = "-";
        private final List<String> failures = new ArrayList<>();
    }
}
