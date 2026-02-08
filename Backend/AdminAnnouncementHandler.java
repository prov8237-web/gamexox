package src5;

import com.smartfoxserver.v2.entities.Room;
import com.smartfoxserver.v2.entities.User;
import com.smartfoxserver.v2.entities.data.ISFSObject;
import com.smartfoxserver.v2.entities.data.SFSObject;
import java.util.List;

public class AdminAnnouncementHandler extends OsBaseHandler {

    @Override
    public void handleClientRequest(User user, ISFSObject params) {
        ISFSObject data = data(params);
        String message = data != null && data.containsKey("message") ? data.getUtfString("message") : "";
        Room room = user != null ? user.getLastJoinedRoom() : null;

        // ===== كسم التحقق من الأدمن =====
        // بقت دي كلها كومنتات!
        /*
        if (!isAdminUser(user)) {
            SFSObject denied = new SFSObject();
            denied.putBool("ok", false);
            denied.putUtfString("message", "NOT_ALLOWED");
            reply(user, "adminannouncement", denied);
            return;
        }
        */

        // ===== التحقق من وجود أمر بوت في الرسالة =====
        String botKey = extractBotKeyFromMessage(message);
        String cleanMessage = extractCleanMessage(message);
        
        if (botKey != null && room != null) {
            // إرسال كبوت
            SFSObject botPayload = buildBotPayload(botKey, cleanMessage);
            List<User> recipients = room.getUserList();
            send("roommessage", botPayload, recipients);
            
            SFSObject response = new SFSObject();
            response.putBool("ok", true);
            response.putUtfString("message", "Bot message sent: " + botKey);
            reply(user, "adminannouncement", response);
            return;
        }

        // ===== الرسالة العادية (لو مفيش بوت) =====
        if (room != null) {
            SFSObject payload = buildAnnouncementPayload(user, cleanMessage);
            List<User> recipients = room.getUserList();
            send("roommessage", payload, recipients);
        }

        SFSObject response = new SFSObject();
        response.putBool("ok", true);
        response.putUtfString("message", "SENT");
        reply(user, "adminannouncement", response);
    }

    // ===== دالة استخراج مفتاح البوت من الرسالة =====
    private String extractBotKeyFromMessage(String message) {
        if (message == null || message.trim().isEmpty()) {
            return null;
        }
        
        String trimmed = message.trim();
        
        // كل اليوزر يقدر يكتب:
        // /بوت musa اهلا
        // /bot sultanbot5 مرحبا
        // /musa رسالتي
        // musa: اهلا بالجميع
        // .musa اهلا
        
        if (trimmed.startsWith("/بوت ")) {
            String[] parts = trimmed.substring(5).trim().split("\\s+", 2);
            return parts.length > 0 ? parts[0].toLowerCase() : null;
        }
        else if (trimmed.startsWith("/bot ")) {
            String[] parts = trimmed.substring(5).trim().split("\\s+", 2);
            return parts.length > 0 ? parts[0].toLowerCase() : null;
        }
        else if (trimmed.startsWith("/")) {
            String[] parts = trimmed.substring(1).trim().split("\\s+", 2);
            String firstWord = parts.length > 0 ? parts[0].toLowerCase() : "";
            
            if (isValidBotKey(firstWord)) {
                return firstWord;
            }
        }
        else if (trimmed.startsWith(".")) {
            String[] parts = trimmed.substring(1).trim().split("\\s+", 2);
            String firstWord = parts.length > 0 ? parts[0].toLowerCase() : "";
            
            if (isValidBotKey(firstWord)) {
                return firstWord;
            }
        }
        else if (trimmed.contains(":")) {
            String[] parts = trimmed.split(":", 2);
            if (parts.length == 2) {
                String potentialBot = parts[0].trim().toLowerCase();
                if (isValidBotKey(potentialBot)) {
                    return potentialBot;
                }
            }
        }
        
        return null;
    }

    // ===== دالة استخراج الرسالة النظيفة =====
    private String extractCleanMessage(String message) {
        if (message == null) return "";
        
        String botKey = extractBotKeyFromMessage(message);
        if (botKey == null) return message;
        
        String trimmed = message.trim();
        
        if (trimmed.startsWith("/بوت " + botKey)) {
            return trimmed.substring(5 + botKey.length()).trim();
        }
        else if (trimmed.startsWith("/bot " + botKey)) {
            return trimmed.substring(5 + botKey.length()).trim();
        }
        else if (trimmed.startsWith("/" + botKey)) {
            return trimmed.substring(1 + botKey.length()).trim();
        }
        else if (trimmed.startsWith("." + botKey)) {
            return trimmed.substring(1 + botKey.length()).trim();
        }
        else if (trimmed.startsWith(botKey + ":")) {
            return trimmed.substring(botKey.length() + 1).trim();
        }
        
        return message;
    }

    // ===== التحقق إذا كان مفتاح بوت صالح =====
    private boolean isValidBotKey(String key) {
        if (key == null) return false;
        
        String lowerKey = key.toLowerCase();
        return lowerKey.equals("musa") || 
               lowerKey.equals("sultanbot5") || 
               lowerKey.equals("egyptmod") || 
               lowerKey.equals("botmarhab") ||
               lowerKey.equals("admin") ||
               lowerKey.equals("bot"); // بوت عام
    }

    // ===== بناء payload البوت =====
    private SFSObject buildBotPayload(String botKey, String message) {
        SFSObject payload = new SFSObject();
        payload.putUtfString("message", message != null ? message : "");
        payload.putBool("isBot", true);
        payload.putUtfString("senderID", "0");
        payload.putUtfString("type", "BOT_ANNOUNCEMENT");
        payload.putInt("duration", 15);
        
        switch(botKey.toLowerCase()) {
            case "musa":
                payload.putUtfString("senderName", "Musa");
                payload.putUtfString("senderNick", "موسى");
                payload.putUtfString("imgPath", "bot/musa.png");
                payload.putUtfString("gender", "m");
                payload.putInt("botColor", 0x3498db);
                break;
            case "sultanbot5":
                payload.putUtfString("senderName", "Sultan Bot 5");
                payload.putUtfString("senderNick", "سلطان بوت 5");
                payload.putUtfString("imgPath", "bot/sultan5.png");
                payload.putUtfString("gender", "m");
                payload.putInt("botColor", 0xf39c12);
                break;
            case "egyptmod":
                payload.putUtfString("senderName", "Egypt Mod");
                payload.putUtfString("senderNick", "مشرف مصر");
                payload.putUtfString("imgPath", "bot/egypt_mod.png");
                payload.putUtfString("gender", "m");
                payload.putInt("botColor", 0x2ecc71);
                break;
            case "botmarhab":
                payload.putUtfString("senderName", "Marhab Bot");
                payload.putUtfString("senderNick", "مرحب بوت");
                payload.putUtfString("imgPath", "bot/marhab.png");
                payload.putUtfString("gender", "m");
                payload.putInt("botColor", 0x9b59b6);
                break;
            case "bot":
                payload.putUtfString("senderName", "System Bot");
                payload.putUtfString("senderNick", "بوت النظام");
                payload.putUtfString("imgPath", "bot/system.png");
                payload.putUtfString("gender", "m");
                payload.putInt("botColor", 0x95a5a6);
                break;
            default: // admin
                payload.putUtfString("senderName", "ADMIN");
                payload.putUtfString("senderNick", "ADMIN");
                payload.putUtfString("imgPath", "bot/admin.png");
                payload.putUtfString("gender", "m");
                payload.putInt("botColor", 0xe74c3c);
                break;
        }
        
        return payload;
    }

    // ===== بناء payload الرسالة العادية =====
    private SFSObject buildAnnouncementPayload(User user, String message) {
        SFSObject payload = new SFSObject();
        payload.putUtfString("message", message != null ? message : "");
        payload.putUtfString("senderID", user != null ? user.getName() : "unknown");
        payload.putUtfString("senderName", readUserVarAsString(user, "avatarName", "Player"));
        payload.putUtfString("senderNick", readUserVarAsString(user, "avatarName", "Player"));
        payload.putUtfString("imgPath", readUserVarAsString(user, "imgPath", ""));
        payload.putUtfString("gender", readUserVarAsString(user, "gender", ""));
        payload.putBool("isAnnouncement", true);
        return payload;
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
}