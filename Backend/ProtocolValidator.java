package src5;

import com.smartfoxserver.v2.entities.data.ISFSObject;
import com.smartfoxserver.v2.extensions.BaseClientRequestHandler;
import java.util.Collections;
import java.util.HashMap;
import java.util.Map;

public final class ProtocolValidator {

    private static final Map<String, ResponseSchema> SCHEMAS = buildSchemas();

    private ProtocolValidator() {}

    public static void validateResponse(String command, ISFSObject payload, BaseClientRequestHandler handler) {
        if (!ProtocolConfig.strictProtocol()) {
            return;
        }

        if (command == null) {
            throw new IllegalStateException("Protocol validation failed: null command");
        }

        ResponseSchema schema = SCHEMAS.get(command);
        if (schema == null) {
            log("[STRICT_PROTOCOL] Missing schema for response: " + command);
            throw new IllegalStateException("Strict protocol: missing schema for command " + command);
        }

        schema.validate(command, payload);
    }

    // ✅ SAFE LOG (no SmartFox access issues)
    private static void log(String message) {
        System.out.println(message);
    }

    private static Map<String, ResponseSchema> buildSchemas() {
        Map<String, ResponseSchema> schemas = new HashMap<>();

        schemas.put("config", ResponseSchema.builder()
                .require("itemFile", FieldType.UTF_STRING)
                .require("versionFile", FieldType.UTF_STRING)
                .require("langFile", FieldType.UTF_STRING)
                .require("webServer", FieldType.UTF_STRING)
                .require("language", FieldType.UTF_STRING)
                .require("version", FieldType.INT)
                .require("fileServer", FieldType.SFS_ARRAY)
                .require("masterRoles", FieldType.SFS_ARRAY)
                .require("roomTheme", FieldType.SFS_ARRAY)
                .require("allRoomTheme", FieldType.SFS_ARRAY)
                .require("moods", FieldType.SFS_ARRAY)
                .require("chatBaloons", FieldType.SFS_ARRAY)
                .require("farmCleaningCost", FieldType.INT)
                .require("farmMaxPlantedItemSize", FieldType.INT)
                .require("diamondExchangeRate", FieldType.INT)
                .require("order", FieldType.SFS_OBJECT)
                .build());

        schemas.put("initQueue", ResponseSchema.builder()
                .require("p", FieldType.INT)
                .require("ts", FieldType.LONG)
                .build());

        schemas.put("roles", ResponseSchema.builder()
                .require("roles", FieldType.UTF_STRING)
                .build());

        schemas.put("questlistroom", ResponseSchema.builder()
                .require("quests", FieldType.SFS_ARRAY)
                .build());

        schemas.put("init", ResponseSchema.builder()
                .require("ts", FieldType.LONG)
                .require("playerID", FieldType.UTF_STRING)
                .require("selectedAvatarID", FieldType.UTF_STRING)
                .require("emailActive", FieldType.INT)
                .require("guest", FieldType.BOOL)
                .require("isBanned", FieldType.BOOL)
                .require("completedAchievementsCount", FieldType.INT)
                .require("tutorialStep", FieldType.INT)
                .require("dailySpinAvailable", FieldType.BOOL)
                .require("campaigns", FieldType.SFS_ARRAY)
                .require("bans", FieldType.SFS_ARRAY)
                .require("settings", FieldType.SFS_OBJECT)
                .require("gender", FieldType.UTF_STRING)
                .require("orderRequest", FieldType.SFS_ARRAY)
                .require("checkAvatar", FieldType.INT)
                .require("universe", FieldType.SFS_OBJECT)
                .require("wallet", FieldType.SFS_ARRAY)
                .require("room", FieldType.SFS_OBJECT)
                .require("clothes", FieldType.SFS_OBJECT)
                .require("extensionInfo", FieldType.SFS_ARRAY)
                .build());

        schemas.put("restartServer", ResponseSchema.builder()
                .require("isRestartWaiting", FieldType.BOOL)
                .build());

        schemas.put("privateChatUpdate", ResponseSchema.builder()
                .require("unreadMessages", FieldType.INT)
                .build());

        schemas.put("buddylist", ResponseSchema.builder()
                .require("buddies", FieldType.SFS_ARRAY)
                .require("requests", FieldType.SFS_ARRAY)
                .require("nextRequest", FieldType.INT)
                .build());

        schemas.put("baseclothes", ResponseSchema.builder()
                .require("f", FieldType.SFS_ARRAY)
                .require("m", FieldType.SFS_ARRAY)
                .require("nextRequest", FieldType.INT)
                .build());

        schemas.put("clothlist", ResponseSchema.builder()
                .require("items", FieldType.SFS_ARRAY)
                .require("nextRequest", FieldType.INT)
                .build());

        schemas.put("savebaseclothes", ResponseSchema.builder()
                .require("nextRequest", FieldType.INT)
                .build());
        schemas.put("sceneitems", ResponseSchema.builder()
                .require("items", FieldType.SFS_ARRAY)
                .build());
        schemas.put("savesceneitems", ResponseSchema.builder()
                .require("ok", FieldType.BOOL)
                .require("count", FieldType.INT)
                .build());

        schemas.put("roomjoincomplete", ResponseSchema.builder().build());
        schemas.put("recommendeduniverse", ResponseSchema.builder().build());
        schemas.put("changeclothes", ResponseSchema.builder().build());
        schemas.put("displayAd", ResponseSchema.builder().require("ads", FieldType.SFS_ARRAY).build());
        schemas.put("walkrequest", ResponseSchema.builder().require("delay", FieldType.INT).build());
        schemas.put("walkfinalrequest", ResponseSchema.builder().build());
        schemas.put("usechatballoon", ResponseSchema.builder().require("id", FieldType.INT).build());
        schemas.put("smileylist", ResponseSchema.builder()
                .require("smilies", FieldType.SFS_ARRAY)
                .require("nextRequest", FieldType.INT)
                .build());
        schemas.put("usesmiley", ResponseSchema.builder()
                .require("id", FieldType.INT)
                .require("clip", FieldType.UTF_STRING)
                .require("nextRequest", FieldType.INT)
                .build());
        schemas.put("adminannouncement", ResponseSchema.builder()
                .require("ok", FieldType.BOOL)
                .require("message", FieldType.UTF_STRING)
                .build());
        schemas.put("questaction", ResponseSchema.builder()
                .require("curVal", FieldType.INT)
                .require("reqVal", FieldType.INT)
                .require("id", FieldType.INT)
                .build());
        schemas.put("teleport", ResponseSchema.builder().require("room", FieldType.SFS_OBJECT).build());
        schemas.put("usedoor", ResponseSchema.builder().require("room", FieldType.SFS_OBJECT).build());
        schemas.put("usehousedoor", ResponseSchema.builder().require("room", FieldType.SFS_OBJECT).build());
        schemas.put("useobjectdoor", ResponseSchema.builder().require("room", FieldType.SFS_OBJECT).build());
        schemas.put("pong", ResponseSchema.builder().build());
        schemas.put("trace", ResponseSchema.builder().build());
        schemas.put("purchase", ResponseSchema.builder()
                .require("items", FieldType.SFS_ARRAY)
                .require("cost", FieldType.INT)
                .build());
        schemas.put("flatpurchase", ResponseSchema.builder()
                .require("items", FieldType.SFS_ARRAY)
                .require("cost", FieldType.INT)
                .build());
        schemas.put("randomwheel", ResponseSchema.builder().build());
        schemas.put("usehanditem", ResponseSchema.builder()
                .require("nextRequest", FieldType.INT)
                .build());
        schemas.put("transferresponse", ResponseSchema.builder().build());
        schemas.put("giftcheckexchange", ResponseSchema.builder()
                .require("id", FieldType.LONG)
                .require("ok", FieldType.BOOL)
                .require("exchangeable", FieldType.BOOL)
                .require("message", FieldType.UTF_STRING)
                .require("item", FieldType.SFS_OBJECT)
                .require("nextRequest", FieldType.INT)
                .build());
        schemas.put("transferrequest", ResponseSchema.builder().build());
        schemas.put("startroomvideo", ResponseSchema.builder().build());
        schemas.put("partyIsland.rollDice", ResponseSchema.builder().build());
        schemas.put("partyIsland.leave", ResponseSchema.builder().build());
        schemas.put("dropthrowaction", ResponseSchema.builder().build());
        schemas.put("buddyrespondinvitelocation", ResponseSchema.builder().build());
        schemas.put("buddyacceptinvitegame", ResponseSchema.builder().build());
        schemas.put("buddyinvitelocation", ResponseSchema.builder().build());
        schemas.put("buddylocate", ResponseSchema.builder()
                .require("universe", FieldType.UTF_STRING)
                .require("street", FieldType.UTF_STRING)
                .build());
        schemas.put("diamondtransferresponse", ResponseSchema.builder().build());
        schemas.put("diamondtransferrequest", ResponseSchema.builder().build());
        schemas.put("addbuddy", ResponseSchema.builder().build());
        schemas.put("changemood", ResponseSchema.builder().build());
        schemas.put("changestatusmessage", ResponseSchema.builder().build());
        schemas.put("changebuddyrating", ResponseSchema.builder().build());
        schemas.put("addbuddyresponse", ResponseSchema.builder().require("requests", FieldType.SFS_ARRAY).build());
        schemas.put("removebuddy", ResponseSchema.builder().build());
        schemas.put("barterresponse", ResponseSchema.builder().build());
        schemas.put("barterrequest", ResponseSchema.builder().build());
        schemas.put("bartercancel", ResponseSchema.builder().build());
        schemas.put("farmimplantation", ResponseSchema.builder().build());
        schemas.put("drop", ResponseSchema.builder().build());
        schemas.put("changeobjectlock", ResponseSchema.builder().build());
        schemas.put("changeobjectframe", ResponseSchema.builder().build());
        schemas.put("gatheritemsearch", ResponseSchema.builder().build());
        schemas.put("gatheritemcollect", ResponseSchema.builder().require("clip", FieldType.UTF_STRING).require("quantity", FieldType.INT).build());
        schemas.put("avatarsalescollect", ResponseSchema.builder().require("gains", FieldType.SFS_ARRAY).build());
        schemas.put("campaignquest", ResponseSchema.builder().build());
        schemas.put("farmclean", ResponseSchema.builder().build());
        schemas.put("farmgather", ResponseSchema.builder().build());
        schemas.put("matchmakingCancel", ResponseSchema.builder().build());
        schemas.put("removeavatarrestriction", ResponseSchema.builder().build());
        schemas.put("exchangediamond", ResponseSchema.builder().build());
        schemas.put("whisper", ResponseSchema.builder().build());
        schemas.put("privatechatlist", ResponseSchema.builder().require("groupList", FieldType.SFS_ARRAY).build());
        schemas.put("messagedetails", ResponseSchema.builder().require("groupID", FieldType.UTF_STRING).require("contents", FieldType.SFS_ARRAY).build());
        schemas.put("privatechatdeletegroup", ResponseSchema.builder().build());
        schemas.put("flatsettings", ResponseSchema.builder()
                .require("passwordSet", FieldType.BOOL)
                .require("vip", FieldType.BOOL)
                .require("plus18", FieldType.BOOL)
                .require("notVisitor", FieldType.BOOL)
                .build());
        schemas.put("flatpassword", ResponseSchema.builder().build());
        schemas.put("debugcommand", ResponseSchema.builder().build());
        schemas.put("roommessage", ResponseSchema.builder().build());
        schemas.put("questlist", ResponseSchema.builder()
                .require("quests", FieldType.SFS_ARRAY)
                .require("nextRequest", FieldType.INT)
                .build());
        schemas.put("orderlist", ResponseSchema.builder().require("orders", FieldType.SFS_ARRAY).build());
        schemas.put("profile", ResponseSchema.builder()
                .require("avatarName", FieldType.UTF_STRING)
                .require("avarageRating", FieldType.DOUBLE)
                .require("totalBuddies", FieldType.INT)
                .require("isBuddy", FieldType.BOOL)
                .require("isRequest", FieldType.BOOL)
                .require("banCount", FieldType.INT)
                .require("cards", FieldType.SFS_ARRAY)
                .require("stickers", FieldType.SFS_ARRAY)
                .require("badges", FieldType.SFS_ARRAY)
                .require("flats", FieldType.SFS_ARRAY)
                .require("mood", FieldType.INT)
                .require("likeCount", FieldType.INT)
                .require("dislikeCount", FieldType.INT)
                .require("status", FieldType.UTF_STRING)
                .require("avatarCity", FieldType.UTF_STRING)
                .require("avatarAge", FieldType.UTF_STRING)
                .require("emailRegistered", FieldType.INT)
                .require("skin", FieldType.SFS_OBJECT)
                .require("runWinTeam", FieldType.UTF_STRING)
                .build());
        schemas.put("profilelike", ResponseSchema.builder()
                .require("likeCount", FieldType.INT)
                .require("dislikeCount", FieldType.INT)
                .build());
        schemas.put("profileimproper", ResponseSchema.builder().build());
        schemas.put("profileskinlist", ResponseSchema.builder()
                .require("items", FieldType.SFS_OBJECT)
                .require("pageSelected", FieldType.INT)
                .build());
        schemas.put("useprofileskinwithclip", ResponseSchema.builder().build());
        schemas.put("kickAvatarFromRoom", ResponseSchema.builder().build());
        schemas.put("changesettings", ResponseSchema.builder()
                .require("ok", FieldType.BOOL)
                .build());
        schemas.put("nickChange", ResponseSchema.builder()
                .require("ok", FieldType.BOOL)
                .build());


        // === Added (Guides / Knights / Reports) ===
        // Lists are pushed with varying payloads (sometimes {list}, sometimes {ok,error}),
        // so we keep them permissive to match the client/server mixed usage.
        schemas.put("guidelist", ResponseSchema.builder().build());
        schemas.put("complaintlist", ResponseSchema.builder().build());

        // Actions/acks always include ok (+ sometimes extra fields)
        schemas.put("guideaction", ResponseSchema.builder()
                .require("ok", FieldType.BOOL)
                .build());
        schemas.put("guiderequest", ResponseSchema.builder()
                .require("ok", FieldType.BOOL)
                .build());
        schemas.put("guidemessage", ResponseSchema.builder()
                .require("ok", FieldType.BOOL)
                .build());

        schemas.put("complaintaction", ResponseSchema.builder()
                .require("ok", FieldType.BOOL)
                .build());
        schemas.put("prereport", ResponseSchema.builder()
                .require("ok", FieldType.BOOL)
                .build());
        schemas.put("ingamereport", ResponseSchema.builder()
                .require("ok", FieldType.BOOL)
                .build());
        schemas.put("report", ResponseSchema.builder()
                .require("ok", FieldType.BOOL)
                .build());
        // === End added ===


        return Collections.unmodifiableMap(schemas);
    }

    public enum FieldType {
        INT, LONG, DOUBLE, BOOL, UTF_STRING, SFS_OBJECT, SFS_ARRAY
    }

    public static final class ResponseSchema {

        private final Map<String, FieldType> requiredFields;

        private ResponseSchema(Map<String, FieldType> requiredFields) {
            this.requiredFields = requiredFields;
        }

        public void validate(String command, ISFSObject payload) {
            if (payload == null) {
                log("[STRICT_PROTOCOL] Null payload for command: " + command);
                throw new IllegalStateException("Strict protocol: null payload for command " + command);
            }

            for (Map.Entry<String, FieldType> entry : requiredFields.entrySet()) {
                String key = entry.getKey();
                FieldType type = entry.getValue();

                if (!payload.containsKey(key)) {
                    log("[STRICT_PROTOCOL] Missing field: " + command + "." + key);
                    throw new IllegalStateException("Strict protocol: missing field " + command + "." + key);
                }

                assertFieldType(command, payload, key, type);
            }
        }

        private void assertFieldType(String command, ISFSObject payload, String key, FieldType type) {
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
                log("[STRICT_PROTOCOL] Type mismatch: " + command + "." + key + " expected " + type);
                throw new IllegalStateException("Strict protocol: type mismatch for " + command + "." + key, e);
            }
        }

        public static Builder builder() {
            return new Builder();
        }

        public static final class Builder {
            private final Map<String, FieldType> required = new HashMap<>();

            public Builder require(String key, FieldType type) {
                required.put(key, type);
                return this;
            }

            public ResponseSchema build() {
                return new ResponseSchema(Collections.unmodifiableMap(new HashMap<>(required)));
            }
        }
    }
}
