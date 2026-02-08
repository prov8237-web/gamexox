package src5;

import com.smartfoxserver.v2.entities.User;
import com.smartfoxserver.v2.entities.data.ISFSArray;
import com.smartfoxserver.v2.entities.data.ISFSObject;
import com.smartfoxserver.v2.entities.data.SFSArray;
import com.smartfoxserver.v2.entities.data.SFSObject;
import com.smartfoxserver.v2.entities.variables.UserVariable;

public final class HandlerUtils {
    private HandlerUtils() {}

    public static ISFSObject dataOrSelf(ISFSObject params) {
        if (params == null) {
            return new SFSObject();
        }
        if (params.containsKey("data")) {
            ISFSObject data = params.getSFSObject("data");
            if (data != null) {
                return data;
            }
        }
        return params;
    }

    public static ISFSArray safeArray(ISFSArray array) {
        return array == null ? new SFSArray() : array;
    }

    public static SFSObject emptyResponse() {
        return new SFSObject();
    }

    public static String defaultRoomMapBase64() {
        return MapBuilder.buildMapBase64();
    }

    public static String normalizeAvatarId(String rawId) {
        if (rawId == null) {
            return "unknown";
        }
        String trimmed = rawId.trim();
        if (trimmed.isEmpty()) {
            return "unknown";
        }
        String lower = trimmed.toLowerCase();
        if (lower.startsWith("guest#")) {
            return "guest#" + lower.substring("guest#".length()).trim();
        }
        return trimmed;
    }

    public static String readUserVarAsString(User user, String... keys) {
        if (user == null || keys == null) {
            return null;
        }
        for (String key : keys) {
            if (key == null) continue;
            try {
                UserVariable var = user.getVariable(key);
                if (var == null) continue;
                String v = var.getStringValue();
                if (v != null && !v.trim().isEmpty()) {
                    return v;
                }
            } catch (Exception ignored) {}
        }
        return null;
    }

    public static String readStringAny(ISFSObject obj, String... keys) {
        if (obj == null || keys == null) {
            return "";
        }
        for (String key : keys) {
            if (key == null) continue;
            try {
                if (!obj.containsKey(key)) continue;
                String v = obj.getUtfString(key);
                if (v != null) return v;
            } catch (Exception ignored) {}
            try {
                if (!obj.containsKey(key)) continue;
                return String.valueOf(obj.getInt(key));
            } catch (Exception ignored) {}
            try {
                if (!obj.containsKey(key)) continue;
                return String.valueOf(obj.getLong(key));
            } catch (Exception ignored) {}
            try {
                if (!obj.containsKey(key)) continue;
                Double d = obj.getDouble(key);
                if (d != null) return String.valueOf(d.intValue());
            } catch (Exception ignored) {}
        }
        return "";
    }

    public static SFSObject buildBannedPayload(String type, InMemoryStore.BanRecord record, long nowEpochSec, String traceId) {
        SFSObject payload = new SFSObject();
        payload.putUtfString("type", type == null ? "CHAT" : type);
        int timeLeft = record == null ? -1 : record.timeLeftSec(nowEpochSec);
        payload.putInt("timeLeft", timeLeft);
        String startDate = record == null ? null : record.startDate;
        String endDate = record == null ? null : record.endDate;
        if (startDate != null) {
            payload.putUtfString("startDate", startDate);
        }
        if (endDate != null) {
            payload.putUtfString("endDate", endDate);
        }
        payload.putUtfString("trace", traceId == null ? "" : traceId);
        return payload;
    }
}
