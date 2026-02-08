package src5;

import com.smartfoxserver.v2.entities.data.ISFSObject;
import java.util.Collections;
import java.util.HashMap;
import java.util.Map;

public final class RequestValidator {
    private static final Map<String, RequestSchema> SCHEMAS = buildSchemas();

    private RequestValidator() {}

    public static void validateRequest(String command, ISFSObject params) {
        RequestSchema schema = SCHEMAS.get(command);
        if (schema == null) {
            return;
        }
        schema.validate(command, params);
    }

    private static Map<String, RequestSchema> buildSchemas() {
        Map<String, RequestSchema> schemas = new HashMap<>();
        schemas.put("walkrequest", RequestSchema.builder().require("x", FieldType.INT).require("y", FieldType.INT).build());
        schemas.put("walkfinalrequest", RequestSchema.builder().build());
        schemas.put("usechatballoon", RequestSchema.builder().require("id", FieldType.INT).build());
        schemas.put("usehousedoor", RequestSchema.builder()
                .require("flatID", FieldType.UTF_STRING)
                .require("password", FieldType.UTF_STRING)
                .require("avatarID", FieldType.UTF_STRING)
                .build());
        schemas.put("usedoor", RequestSchema.builder().require("key", FieldType.UTF_STRING).require("type", FieldType.UTF_STRING).build());
        schemas.put("useobjectdoor", RequestSchema.builder().require("id", FieldType.INT).build());
        schemas.put("teleport", RequestSchema.builder().require("roomKey", FieldType.UTF_STRING).build());
        schemas.put("questlist", RequestSchema.builder().require("showDetail", FieldType.BOOL).build());
        schemas.put("questaction", RequestSchema.builder().require("id", FieldType.INT).build());
        schemas.put("purchase", RequestSchema.builder().require("shopID", FieldType.INT).require("objectID", FieldType.INT).require("items", FieldType.SFS_ARRAY).build());
        schemas.put("flatpurchase", RequestSchema.builder().require("shopID", FieldType.INT).require("objectID", FieldType.INT).require("items", FieldType.SFS_ARRAY).build());
        schemas.put("randomwheel", RequestSchema.builder().require("command", FieldType.UTF_STRING).require("id", FieldType.INT).build());
        schemas.put("transferrequest", RequestSchema.builder()
                .require("clip", FieldType.UTF_STRING)
                .require("id", FieldType.INT)
                .require("quantity", FieldType.INT)
                .require("avatarID", FieldType.UTF_STRING)
                .build());
        schemas.put("giftcheckexchange", RequestSchema.builder().require("id", FieldType.LONG).build());
        schemas.put("adminannouncement", RequestSchema.builder().require("message", FieldType.UTF_STRING).build());
        schemas.put("usehanditem", RequestSchema.builder().require("id", FieldType.INT).build());
        schemas.put("startroomvideo", RequestSchema.builder().require("videoUrl", FieldType.UTF_STRING).build());
        schemas.put("barterrequest", RequestSchema.builder().require("avatarID", FieldType.UTF_STRING).build());
        schemas.put("bartercancel", RequestSchema.builder().require("barterID", FieldType.INT).build());
        schemas.put("farmimplantation", RequestSchema.builder().require("id", FieldType.INT).require("itemID", FieldType.INT).build());
        schemas.put("farmclean", RequestSchema.builder().require("id", FieldType.INT).build());
        schemas.put("farmgather", RequestSchema.builder().require("id", FieldType.INT).build());
        schemas.put("drop", RequestSchema.builder().require("type", FieldType.UTF_STRING).build());
        schemas.put("changeobjectlock", RequestSchema.builder().require("id", FieldType.INT).build());
        schemas.put("changeobjectframe", RequestSchema.builder().require("id", FieldType.INT).build());
        schemas.put("gatheritemsearch", RequestSchema.builder().require("id", FieldType.INT).build());
        schemas.put("avatarsalescollect", RequestSchema.builder().require("id", FieldType.INT).build());
        schemas.put("exchangediamond", RequestSchema.builder().require("diamondQuantity", FieldType.INT).build());
        schemas.put("whisper", RequestSchema.builder().require("message", FieldType.UTF_STRING).require("receiver", FieldType.UTF_STRING).build());
        schemas.put("messagedetails", RequestSchema.builder().require("groupID", FieldType.UTF_STRING).build());
        schemas.put("privatechatdeletegroup", RequestSchema.builder().require("groupID", FieldType.UTF_STRING).build());
        schemas.put("flatpassword", RequestSchema.builder().require("password", FieldType.UTF_STRING).build());
        schemas.put("debugcommand", RequestSchema.builder().require("params", FieldType.UTF_STRING).build());
        schemas.put("roommessage", RequestSchema.builder().require("message", FieldType.UTF_STRING).build());
        schemas.put("matchmakingCancel", RequestSchema.builder().build());
        schemas.put("removeavatarrestriction", RequestSchema.builder().build());
        schemas.put("sceneitems", RequestSchema.builder().build());
        schemas.put("savesceneitems", RequestSchema.builder().require("items", FieldType.SFS_ARRAY).build());
        schemas.put("profile", RequestSchema.builder().require("avatarID", FieldType.UTF_STRING).build());
        schemas.put("profilelike", RequestSchema.builder()
                .require("avatarID", FieldType.UTF_STRING)
                .require("avatarLike", FieldType.INT)
                .build());
        schemas.put("profileimproper", RequestSchema.builder()
                .require("avatarID", FieldType.UTF_STRING)
                .require("action", FieldType.UTF_STRING)
                .build());
        schemas.put("profileskinlist", RequestSchema.builder()
                .require("search", FieldType.UTF_STRING)
                .require("page", FieldType.INT)
                .require("sort", FieldType.UTF_STRING)
                .build());
        schemas.put("useprofileskinwithclip", RequestSchema.builder()
                .require("clip", FieldType.UTF_STRING)
                .build());
        schemas.put("kickAvatarFromRoom", RequestSchema.builder()
                .require("avatarID", FieldType.UTF_STRING)
                .require("duration", FieldType.DOUBLE)
                .build());
        schemas.put("changesettings", RequestSchema.builder().build());
        schemas.put("nickChange", RequestSchema.builder().build());
        schemas.put("report", RequestSchema.builder().build());
        return Collections.unmodifiableMap(schemas);
    }

    public enum FieldType {
        INT, LONG, DOUBLE, BOOL, UTF_STRING, SFS_OBJECT, SFS_ARRAY
    }

    public static final class RequestSchema {
        private final Map<String, FieldType> requiredFields;

        private RequestSchema(Map<String, FieldType> requiredFields) {
            this.requiredFields = requiredFields;
        }

        public void validate(String command, ISFSObject params) {
            if (params == null) {
                return;
            }
            ISFSObject data = params.containsKey("data") ? params.getSFSObject("data") : params;
            if (data == null) {
                return;
            }
            for (Map.Entry<String, FieldType> entry : requiredFields.entrySet()) {
                String key = entry.getKey();
                FieldType type = entry.getValue();
                if (!data.containsKey(key)) {
                    System.out.println("[REQUEST_SCHEMA] Missing field: " + command + "." + key);
                    continue;
                }
                assertType(command, data, key, type);
            }
        }

        private void assertType(String command, ISFSObject payload, String key, FieldType type) {
            try {
                switch (type) {
                    case INT: payload.getInt(key); break;
                    case LONG: payload.getLong(key); break;
                    case DOUBLE: payload.getDouble(key); break;
                    case BOOL: payload.getBool(key); break;
                    case UTF_STRING: payload.getUtfString(key); break;
                    case SFS_OBJECT:
                        if (payload.getSFSObject(key) == null) throw new IllegalStateException();
                        break;
                    case SFS_ARRAY:
                        if (payload.getSFSArray(key) == null) throw new IllegalStateException();
                        break;
                }
            } catch (Exception e) {
                System.out.println("[REQUEST_SCHEMA] Type mismatch: " + command + "." + key + " expected " + type);
            }
        }

        public static Builder builder() {
            return new Builder();
        }

        public static final class Builder {
            private final Map<String, FieldType> requiredFields = new HashMap<>();

            public Builder require(String key, FieldType type) {
                requiredFields.put(key, type);
                return this;
            }

            public RequestSchema build() {
                return new RequestSchema(Collections.unmodifiableMap(requiredFields));
            }
        }
    }
}
