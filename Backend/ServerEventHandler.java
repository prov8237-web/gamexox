package src5;

import com.smartfoxserver.v2.core.ISFSEvent;
import com.smartfoxserver.v2.core.SFSEventParam;
import com.smartfoxserver.v2.core.SFSEventType;
import com.smartfoxserver.v2.entities.Room;
import com.smartfoxserver.v2.entities.User;
import com.smartfoxserver.v2.entities.data.ISFSObject;
import com.smartfoxserver.v2.entities.data.SFSObject;
import com.smartfoxserver.v2.entities.variables.RoomVariable;
import com.smartfoxserver.v2.entities.variables.SFSRoomVariable;
import com.smartfoxserver.v2.entities.variables.UserVariable;
import com.smartfoxserver.v2.extensions.BaseServerEventHandler;
import java.util.ArrayList;
import java.util.List;
import java.util.Arrays;
import java.util.HashSet;
import java.util.Set;

public class ServerEventHandler extends BaseServerEventHandler {

    private static final Set<String> ALLOWED_BOT_KEYS = new HashSet<>(Arrays.asList(
        "jaberBot",
        "musa",
        "egyptmod", 
        "botmarhab",
        "fahman",
        "cenkay",
        "ulubilge",
        "batuhandiamond"
    ));

    @Override
    public void handleServerEvent(ISFSEvent event) {
        SFSEventType type = (SFSEventType) event.getType();
        MainExtension ext = (MainExtension) getParentExtension();
        if (ext == null) {
            return;
        }
        switch (type) {
            case USER_LOGIN:
                onUserLogin(event, ext);
                break;
            case USER_JOIN_ROOM:
                onUserJoinRoom(event, ext);
                break;
            case USER_LEAVE_ROOM:
                onUserLeaveRoom(event, ext);
                break;
            case USER_DISCONNECT:
                onUserDisconnect(event, ext);
                break;
            case PUBLIC_MESSAGE:
                onPublicMessage(event, ext); // ✅ إضافة ext
                break;
            default:
                break;
        }
    }

    private void onUserLogin(ISFSEvent event, MainExtension ext) {
        User user = (User) event.getParameter(SFSEventParam.USER);
        if (user == null) {
            return;
        }
        InMemoryStore store = ext.getStore();
        InMemoryStore.UserState state = store.getOrCreateUser(user);
        String displayName = store.ensureUniqueDisplayName(state.getAvatarName(), user.getId());
        state.setAvatarName(displayName);

        // Moderation: LOGIN ban check (client expects extension 'banned' with type=LOGIN)
        try {
            String ip = user.getSession().getAddress();
            if (store.isIpBanned(ip, "LOGIN")) {
                // send banned event
                SFSObject banned = new SFSObject();
                InMemoryStore.BanRecord match = null;
                long now = System.currentTimeMillis() / 1000;
                for (InMemoryStore.BanRecord br : store.getActiveBansForIp(ip)) {
                    if ("LOGIN".equalsIgnoreCase(br.type)) {
                        match = br;
                        break;
                    }
                }
                String traceId = "enforce-login-" + user.getName() + "-" + System.currentTimeMillis();
                if (match != null) {
                    long startMs = match.startEpochSec * 1000L;
                    long endMs = match.endEpochSec < 0 ? -1 : match.endEpochSec * 1000L;
                    int timeLeft = match.timeLeftSec(now);
                    banned.putUtfString("type", "LOGIN");
                    banned.putLong("startDate", startMs);
                    banned.putLong("endDate", endMs);
                    banned.putInt("timeLeft", timeLeft);
                }
                banned.putUtfString("trace", traceId);
                ext.send("banned", banned, user);
                // disconnect
                getApi().disconnectUser(user);
                trace("[MOD_BAN_ENFORCE] trace=" + traceId + " user=" + user.getName() + " type=LOGIN");
                return;
            }
        } catch (Exception e) {
            // ignore
        }

        // Moderation: CHAT ban check (enforce by disconnecting on login)
        try {
            String ip = user.getSession().getAddress();
            if (store.isIpBanned(ip, "CHAT")) {
                SFSObject banned = new SFSObject();
                InMemoryStore.BanRecord match = null;
                long now = System.currentTimeMillis() / 1000;
                for (InMemoryStore.BanRecord br : store.getActiveBansForIp(ip)) {
                    if ("CHAT".equalsIgnoreCase(br.type)) {
                        match = br;
                        break;
                    }
                }
                String traceId = "enforce-chat-" + user.getName() + "-" + System.currentTimeMillis();
                if (match != null) {
                    long startMs = match.startEpochSec * 1000L;
                    long endMs = match.endEpochSec < 0 ? -1 : match.endEpochSec * 1000L;
                    int timeLeft = match.timeLeftSec(now);
                    banned.putUtfString("type", "CHAT");
                    banned.putLong("startDate", startMs);
                    banned.putLong("endDate", endMs);
                    banned.putInt("timeLeft", timeLeft);
                }
                banned.putUtfString("trace", traceId);
                ext.send("banned", banned, user);
                getApi().disconnectUser(user);
                trace("[MOD_BAN_ENFORCE] trace=" + traceId + " user=" + user.getName() + " type=CHAT");
                return;
            }
        } catch (Exception e) {
            // ignore
        }

        trace("[SERVER_EVENT] USER_LOGIN init vars for " + user.getName());
    }

    private void onUserJoinRoom(ISFSEvent event, MainExtension ext) {
        Room room = (Room) event.getParameter(SFSEventParam.ROOM);
        User user = (User) event.getParameter(SFSEventParam.USER);
        if (room == null || user == null) {
            return;
        }
        
        trace("════════════════════════════════════════════════════");
        trace("🚀 PLAYER JOINING ROOM: " + user.getName());
        trace("Room: " + room.getName());
        trace("════════════════════════════════════════════════════");
        
        InMemoryStore store = ext.getStore();
        InMemoryStore.UserState userState = store.getOrCreateUser(user);
        userState.setCurrentRoom(room.getName());
        InMemoryStore.RoomState roomState = store.getOrCreateRoom(room);

        List<RoomVariable> roomVars = new ArrayList<>();
        roomVars.add(new SFSRoomVariable("doors", roomState.getDoorsJson()));
        roomVars.add(new SFSRoomVariable("bots", roomState.getBotsJson()));
        roomVars.add(new SFSRoomVariable("grid", roomState.getGridBase64()));
        roomVars.add(new SFSRoomVariable("isInteractiveRoom", true));
        roomVars.add(new SFSRoomVariable("isGameStarted", false));
        roomVars.add(new SFSRoomVariable("isGameEnded", false));
        getApi().setRoomVariables(null, room, roomVars, false, false, false);
        
        trace("[ROOM_VARS_BROADCAST] stage=USER_JOIN_ROOM room=" + room.getName() + " vars=doors,bots,grid,isInteractiveRoom,isGameStarted,isGameEnded");
        trace("[SERVER_EVENT] USER_JOIN_ROOM room vars for " + room.getName());

        // ═══════════════════════════════════════════════════════════
        // ✅ الجديد: إرسال بيانات اللاعب الجديد للآخرين
        // ═══════════════════════════════════════════════════════════
        
        // 1. إرسال للاعب الجديد: بيانات كل اللاعبين الموجودين في الغرفة
        trace("[BROADCAST] Sending existing players to new player: " + user.getName());
        List<User> existingPlayers = new ArrayList<>(room.getUserList());
        existingPlayers.remove(user); // إزالة اللاعب نفسه
        
        for (User existingPlayer : existingPlayers) {
            // لكل لاعب موجود، أرسل بياناته للاعب الجديد
            InMemoryStore.UserState existingState = store.getOrCreateUser(existingPlayer);
            
            SFSObject playerData = new SFSObject();
            playerData.putUtfString("type", "PLAYER_JOINED");
            playerData.putUtfString("avatarID", existingPlayer.getName());
            playerData.putUtfString("avatarName", existingState.getAvatarName());
            playerData.putUtfString("gender", existingState.getGender());
            playerData.putUtfString("clothes", existingState.getClothesJson());
            playerData.putUtfString("position", existingState.getPosition());
            playerData.putInt("direction", existingState.getDirection());
            playerData.putDouble("avatarSize", existingState.getAvatarSize());
            playerData.putUtfString("roles", existingState.getRoles());
            playerData.putUtfString("status", "idle");
            
            trace("   → Sending player " + existingPlayer.getName() + " to " + user.getName());
            ext.send("roommessage", playerData, user); // ✅ استخدام ext.send()
        }
        
        // 2. إرسال للاعبين الموجودين: بيانات اللاعب الجديد
        if (!existingPlayers.isEmpty()) {
            SFSObject newPlayerData = new SFSObject();
            newPlayerData.putUtfString("type", "PLAYER_JOINED");
            newPlayerData.putUtfString("avatarID", user.getName());
            newPlayerData.putUtfString("avatarName", userState.getAvatarName());
            newPlayerData.putUtfString("gender", userState.getGender());
            newPlayerData.putUtfString("clothes", userState.getClothesJson());
            newPlayerData.putUtfString("position", userState.getPosition());
            newPlayerData.putInt("direction", userState.getDirection());
            newPlayerData.putDouble("avatarSize", userState.getAvatarSize());
            newPlayerData.putUtfString("roles", userState.getRoles());
            newPlayerData.putUtfString("status", "idle");
            
            trace("[BROADCAST] Sending new player " + user.getName() + " to " + existingPlayers.size() + " existing players");
            ext.send("roommessage", newPlayerData, existingPlayers); // ✅ استخدام ext.send()
        }

        for (String line : RenderGateAudit.audit(user, userState, "ROOM_JOIN")) {
            trace(line);
        }
        
        trace("════════════════════════════════════════════════════");
        trace("✅ PLAYER JOIN COMPLETE: " + user.getName());
        trace("════════════════════════════════════════════════════");
    }

    private void onUserLeaveRoom(ISFSEvent event, MainExtension ext) {
        User user = (User) event.getParameter(SFSEventParam.USER);
        Room room = (Room) event.getParameter(SFSEventParam.ROOM);
        if (user == null || room == null) {
            return;
        }
        
        trace("════════════════════════════════════════════════════");
        trace("👋 PLAYER LEAVING ROOM: " + user.getName());
        trace("Room: " + room.getName());
        trace("════════════════════════════════════════════════════");
        
        InMemoryStore store = ext.getStore();
        InMemoryStore.UserState state = store.getOrCreateUser(user);
        state.setCurrentRoom("");
        
        // ═══════════════════════════════════════════════════════════
        // ✅ الجديد: إعلام اللاعبين الباقيين أن اللاعب غادر
        // ═══════════════════════════════════════════════════════════
        List<User> remainingPlayers = new ArrayList<>(room.getUserList());
        remainingPlayers.remove(user);
        
        if (!remainingPlayers.isEmpty()) {
            SFSObject leaveData = new SFSObject();
            leaveData.putUtfString("type", "PLAYER_LEFT");
            leaveData.putUtfString("avatarID", user.getName());
            leaveData.putUtfString("avatarName", state.getAvatarName());
            
            trace("[BROADCAST] Notifying " + remainingPlayers.size() + " players that " + user.getName() + " left");
            ext.send("roommessage", leaveData, remainingPlayers); // ✅ استخدام ext.send()
        }
        
        trace("[SERVER_EVENT] USER_LEAVE_ROOM cleared room for " + user.getName());
        trace("════════════════════════════════════════════════════");
        trace("✅ PLAYER LEAVE COMPLETE: " + user.getName());
        trace("════════════════════════════════════════════════════");
    }

    private void onUserDisconnect(ISFSEvent event, MainExtension ext) {
        User user = (User) event.getParameter(SFSEventParam.USER);
        if (user == null) {
            return;
        }
        
        trace("🔌 PLAYER DISCONNECTED: " + user.getName());
        
        InMemoryStore store = ext.getStore();
        InMemoryStore.UserState state = store.getOrCreateUser(user);
        store.releaseDisplayName(state.getAvatarName());
        
        // ═══════════════════════════════════════════════════════════
        // ✅ الجديد: إذا كان اللاعب في غرفة، نعلم الآخرين
        // ═══════════════════════════════════════════════════════════
        Room currentRoom = user.getLastJoinedRoom();
        if (currentRoom != null) {
            List<User> roomPlayers = new ArrayList<>(currentRoom.getUserList());
            roomPlayers.remove(user);
            
            if (!roomPlayers.isEmpty()) {
                SFSObject disconnectData = new SFSObject();
                disconnectData.putUtfString("type", "PLAYER_DISCONNECTED");
                disconnectData.putUtfString("avatarID", user.getName());
                disconnectData.putUtfString("avatarName", state.getAvatarName());
                
                trace("[BROADCAST] Notifying room about disconnect");
                ext.send("roommessage", disconnectData, roomPlayers); // ✅ استخدام ext.send()
            }
        }
    }

    private void onPublicMessage(ISFSEvent event, MainExtension ext) { // ✅ إضافة ext كباراميتر
        if (!ProtocolConfig.chatEnabled()) {
            return;
        }
        User user = (User) event.getParameter(SFSEventParam.USER);
        Room room = (Room) event.getParameter(SFSEventParam.ROOM);
        String message = (String) event.getParameter(SFSEventParam.MESSAGE);
        ISFSObject data = (ISFSObject) event.getParameter(SFSEventParam.OBJECT);
        if (data == null) {
            Object raw = event.getParameter(SFSEventParam.OBJECT);
            if (raw instanceof ISFSObject) {
                data = (ISFSObject) raw;
            }
        }
        String keys = data != null ? data.getKeys().toString() : "[]";
        int messageLen = message != null ? message.length() : 0;

        String trimmed = message != null ? message.trim() : "";

        // Moderation: CHAT ban check (block chat + notify client)
        try {
            if (user != null) {
                InMemoryStore store = ext.getStore();
                String ip = user.getSession().getAddress();
                if (store != null && store.isIpBanned(ip, "CHAT")) {
                    SFSObject banned = new SFSObject();
                    long now = System.currentTimeMillis() / 1000;
                    for (InMemoryStore.BanRecord br : store.getActiveBansForIp(ip)) {
                        if ("CHAT".equalsIgnoreCase(br.type)) {
                            banned = br.toSFSObject(now);
                            break;
                        }
                    }
                    ext.send("banned", banned, user);
                    trace("🚫 Blocked public chat message due to CHAT ban: " + user.getName());
                    return;
                }
            }
        } catch (Exception e) {
            // ignore
        }

        // ✅ CHECK FOR BOT MESSAGE FORMAT: "botkey:message"
        if (user != null && room != null && isBotMessageFormat(trimmed)) {
            trace("🤖 BOT MESSAGE DETECTED in public chat!");
            handleBotMessageFromChat(user, room, trimmed, ext); // ✅ إضافة ext
            return; // Don't send as normal chat message
        }
        
        // Check for admin announcement
        if (user != null && room != null && isAdminAnnouncementCommand(trimmed) && isAdminUser(user)) {
            String announcement = stripAnnouncementPrefix(trimmed);
            sendAdminAnnouncement(user, room, announcement, ext); // ✅ إضافة ext
            return;
        }

        // Normal chat message
        if (user != null) {
            trace("[CHAT_PUBLIC_IN] senderId=" + user.getId()
                    + " senderName=" + user.getName()
                    + " room=" + (room != null ? room.getName() : "unknown")
                    + " messageLen=" + messageLen);
            trace("[CHAT_SYS_IN] type=public senderId=" + user.getId()
                    + " roomId=" + (room != null ? room.getId() : -1)
                    + " messageLen=" + messageLen);
            trace("[CHAT_RESOLVE_HINT] senderVars=" + collectUserVarKeys(user));
            String spawnKey = user.getName();
            trace("[CHAT_RESOLVE_KEY] senderName=" + user.getName() + " spawnKey=" + spawnKey);
            trace("[CHAT_RESOLVE_OK] match=" + user.getName().equals(spawnKey));
            trace("[CHAT_IN] type=public senderId=" + user.getId()
                    + " avatarId=" + user.getName()
                    + " keys=" + keys + " messageLen=" + messageLen);
            trace("[CHAT_OUT] type=public scope=room room=" + (room != null ? room.getName() : "unknown")
                    + " senderId=" + user.getId()
                    + " avatarId=" + user.getName()
                    + " keys=" + keys + " messageLen=" + messageLen);
            if (room != null) {
                SFSObject payload = new SFSObject();
                payload.putUtfString("type", "CHAT_MESSAGE");
                payload.putUtfString("message", message != null ? message : "");
                payload.putUtfString("senderID", user.getName());
                payload.putUtfString("senderName", readUserVarAsString(user, "avatarName", user.getName()));
                payload.putUtfString("senderNick", readUserVarAsString(user, "avatarName", user.getName()));
                payload.putUtfString("imgPath", readUserVarAsString(user, "imgPath", ""));
                payload.putUtfString("gender", readUserVarAsString(user, "gender", ""));
                ext.send("roommessage", payload, room.getUserList()); // ✅ استخدام ext.send()
                trace("[CHAT_EXT_OUT] event=roommessage keys=" + payload.getKeys());
            }
        }
    }

    // ✅ NEW METHOD: Check if message is bot format
    private boolean isBotMessageFormat(String message) {
        if (message == null || message.isEmpty()) {
            return false;
        }
        
        // Check if message contains ":"
        if (!message.contains(":")) {
            return false;
        }
        
        String[] parts = message.split(":", 2);
        if (parts.length < 2) {
            return false;
        }
        
        String botKey = parts[0].trim().toLowerCase();
        
        // Check if the key is in allowed bot keys
        return ALLOWED_BOT_KEYS.contains(botKey);
    }

    // ✅ NEW METHOD: Handle bot message from chat
    private void handleBotMessageFromChat(User user, Room room, String message, MainExtension ext) { // ✅ إضافة ext
        try {
            String[] parts = message.split(":", 2);
            String botKey = parts[0].trim().toLowerCase();
            String botMessage = parts.length > 1 ? parts[1].trim() : "";
            
            trace("🔑 Bot Key: " + botKey);
            trace("💬 Bot Message: " + botMessage);
            
            if (botMessage.isEmpty()) {
                trace("❌ Empty bot message, ignoring");
                return;
            }
            
            // Prepare bot data
            SFSObject botData = prepareBotData(botKey, botMessage);
            
            // Send to all users in room
            List<User> usersInRoom = room.getUserList();
            for (User recipient : usersInRoom) {
                ext.send("botMessage", botData, recipient); // ✅ استخدام ext.send()
            }
            
            trace("✅ Bot message sent to " + usersInRoom.size() + " users");
            
        } catch (Exception e) {
            trace("❌ Error handling bot message: " + e.getMessage());
            e.printStackTrace();
        }
    }

    // ✅ NEW METHOD: Prepare bot data with colors (matching original game format)
    private SFSObject prepareBotData(String botKey, String message) {
        SFSObject botData = new SFSObject();
        botData.putUtfString("botKey", botKey);
        botData.putUtfString("message", message);
        botData.putInt("duration", 20);
        botData.putInt("version", 1);
        
        // Build colors array as STRING (matching original format)
        String colorsJson = "";
        
        switch(botKey) {
            case "musa":
                colorsJson = "[\"FF5722\",\"FFFFFF\",\"D84315\",\"E64A19\"]";
                break;
            case "egyptmod":
                colorsJson = "[\"1E88E5\",\"FFFFFF\",\"0D47A1\",\"1565C0\"]";
                break;
            case "botMarhab":
                colorsJson = "[\"43A047\",\"FFFFFF\",\"1B5E20\",\"2E7D32\"]";
                break;
            case "fahman":
                colorsJson = "[\"8E24AA\",\"FFFFFF\",\"4A148C\",\"6A1B9A\"]";
                break;
            case "cenkay":
                colorsJson = "[\"1a629b\",\"ffffff\",\"3394e0\",\"227abf\"]";
                break;
            case "ulubilge":
                colorsJson = "[\"E53935\",\"FFFFFF\",\"B71C1C\",\"C62828\"]";
                break;
            case "batuhandiamond":
                colorsJson = "[\"00ACC1\",\"FFFFFF\",\"006064\",\"00838F\"]";
                break;
            case "canca_bot":
                colorsJson = "[\"FF9800\",\"FFFFFF\",\"F57C00\",\"EF6C00\"]";
                break;
            case "countryBot3":
                colorsJson = "[\"4CAF50\",\"FFFFFF\",\"2E7D32\",\"388E3C\"]";
                break;
            case "countryBot5":
                colorsJson = "[\"2196F3\",\"FFFFFF\",\"0D47A1\",\"1565C0\"]";
                break;
            case "bigboss":
                colorsJson = "[\"9C27B0\",\"FFFFFF\",\"6A1B9A\",\"7B1FA2\"]";
                break;
            case "batuhan":
                colorsJson = "[\"00BCD4\",\"FFFFFF\",\"00838F\",\"0097A7\"]";
                break;
            case "jaberBot":
                colorsJson = "[\"FF5722\",\"FFFFFF\",\"BF360C\",\"D84315\"]";
                break;
            case "janja_bot":
                colorsJson = "[\"E91E63\",\"FFFFFF\",\"AD1457\",\"C2185B\"]";
                break;
            case "kion_bot":
                colorsJson = "[\"673AB7\",\"FFFFFF\",\"4527A0\",\"512DA8\"]";
                break;
            case "kozalak_bot":
                colorsJson = "[\"795548\",\"FFFFFF\",\"4E342E\",\"5D4037\"]";
                break;
            case "moroccoBot":
                colorsJson = "[\"C62828\",\"FFFFFF\",\"B71C1C\",\"D32F2F\"]";
                break;
            case "musicBot":
                colorsJson = "[\"9C27B0\",\"FFFFFF\",\"6A1B9A\",\"7B1FA2\"]";
                break;
            case "musicStoreBot":
                colorsJson = "[\"FF9800\",\"FFFFFF\",\"F57C00\",\"EF6C00\"]";
                break;
            case "pierbeachbot3":
                colorsJson = "[\"00ACC1\",\"FFFFFF\",\"00838F\",\"0097A7\"]";
                break;
            case "botAlgeria":
                colorsJson = "[\"008000\",\"FFFFFF\",\"006400\",\"228B22\"]";
                break;
            default:
                colorsJson = "[\"607D8B\",\"FFFFFF\",\"37474F\",\"455A64\"]";
        }
        
        // Put as STRING, not SFSArray (matching original game)
        botData.putUtfString("colors", colorsJson);
        
        // Property as STRING JSON (matching original game)
        botData.putUtfString("property", "{\"cn\":\"SimpleBotMessageProperty\"}");
        
        // Additional fields from original game
        botData.putUtfString("filters", "[]");
        botData.putUtfString("title", "");
        botData.putUtfString("roomToSend", "");
        botData.putUtfString("date", new java.text.SimpleDateFormat("yyyy-MM-dd HH:mm:ss.S").format(new java.util.Date()));
        botData.putLong("ts", System.currentTimeMillis() / 1000);
        
        trace("🎨 Bot data prepared for: " + botKey);
        
        return botData;
    }

    private boolean isAdminAnnouncementCommand(String message) {
        if (message == null) {
            return false;
        }
        String normalized = message.toLowerCase();
        return normalized.startsWith("/admin ") || normalized.startsWith("/announce ");
    }

    private String stripAnnouncementPrefix(String message) {
        if (message == null) {
            return "";
        }
        String trimmed = message.trim();
        if (trimmed.toLowerCase().startsWith("/admin ")) {
            return trimmed.substring(7).trim();
        }
        if (trimmed.toLowerCase().startsWith("/announce ")) {
            return trimmed.substring(10).trim();
        }
        return trimmed;
    }

    private boolean isAdminUser(User user) {
        if (user == null) {
            return false;
        }
        String name = user.getName() != null ? user.getName().toLowerCase() : "";
        if (name.equals("admin") || name.startsWith("admin")) {
            return true;
        }
        if (user.containsVariable("roles")) {
            String roles = user.getVariable("roles").getStringValue();
            return roles != null && roles.toLowerCase().contains("admin");
        }
        return user.containsVariable("isAdmin") && Boolean.TRUE.equals(user.getVariable("isAdmin").getBoolValue());
    }

    private void sendAdminAnnouncement(User user, Room room, String message, MainExtension ext) { // ✅ إضافة ext
        if (room == null) {
            return;
        }
        SFSObject payload = new SFSObject();
        payload.putUtfString("message", message != null ? message : "");
        payload.putUtfString("senderID", "admin");
        payload.putUtfString("senderName", readUserVarAsString(user, "avatarName", "ADMIN"));
        payload.putUtfString("senderNick", readUserVarAsString(user, "avatarName", "ADMIN"));
        payload.putUtfString("imgPath", readUserVarAsString(user, "imgPath", ""));
        payload.putUtfString("gender", readUserVarAsString(user, "gender", ""));
        payload.putBool("isAdmin", true);
        payload.putBool("isAnnouncement", true);
        payload.putUtfString("type", "ADMIN_ANNOUNCEMENT");
        ext.send("roommessage", payload, room.getUserList()); // ✅ استخدام ext.send()
        trace("[CHAT_ADMIN_ANNOUNCE] room=" + room.getName() + " messageLen=" + (message != null ? message.length() : 0));
    }

    private String readUserVarAsString(User user, String key, String fallback) {
        if (user == null || !user.containsVariable(key)) {
            return fallback;
        }
        try {
            return user.getVariable(key).getStringValue();
        } catch (Exception ignored) {
            return fallback;
        }
    }

    private String collectUserVarKeys(User user) {
        if (user == null) {
            return "[]";
        }
        List<String> keys = new ArrayList<>();
        try {
            for (UserVariable var : user.getVariables()) {
                if (var != null) {
                    keys.add(var.getName());
                }
            }
        } catch (Exception ignored) {
            return "[]";
        }
        return keys.toString();
    }
}
