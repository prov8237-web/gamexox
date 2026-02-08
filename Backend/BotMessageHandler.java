package src5;

import com.smartfoxserver.v2.extensions.BaseClientRequestHandler;
import com.smartfoxserver.v2.entities.User;
import com.smartfoxserver.v2.entities.Room;
import com.smartfoxserver.v2.entities.data.ISFSObject;
import com.smartfoxserver.v2.entities.data.SFSObject;
import com.smartfoxserver.v2.entities.data.SFSArray;
import java.util.List;
import java.util.Arrays;
import java.util.HashSet;
import java.util.Set;

public class BotMessageHandler extends BaseClientRequestHandler {
    
    private static final Set<String> ALLOWED_BOT_KEYS = new HashSet<>(Arrays.asList(
        "musa",
        "egyptmod", 
        "botmarhab",
        "fahman",
        "cenkay",
        "ulubilge",
"jaberBot",
        "batuhandiamond"
    ));
    
    @Override
    public void handleClientRequest(User user, ISFSObject params) {
        trace("🤖🤖🤖 BOT MESSAGE HANDLER STARTED 🤖🤖🤖");
        
        try {
            // Log all parameters
            if (params != null && params.size() > 0) {
                trace("📦 Full params: " + params.toJson());
            }
            
            // Check if keybot parameter exists
            if (!params.containsKey("keybot")) {
                trace("❌ ERROR: Missing 'keybot' parameter");
                sendError(user, "MISSING_PARAM", "Please use format: 'key: message'");
                return;
            }
            
            String fullMessage = params.getUtfString("keybot");
            trace("💬 Full message received: '" + fullMessage + "'");
            
            // Parse the message (format: "key: message")
            String[] parts = fullMessage.split(":", 2);
            if (parts.length < 2) {
                trace("❌ ERROR: Invalid format. Should be 'key: message'");
                sendError(user, "INVALID_FORMAT", "Format: botname: your message");
                return;
            }
            
            String botKey = parts[0].trim().toLowerCase();
            String message = parts[1].trim();
            
            trace("🔑 Bot key extracted: " + botKey);
            trace("📝 Message extracted: " + message);
            
            // Check if bot key is allowed
            if (!ALLOWED_BOT_KEYS.contains(botKey)) {
                trace("❌ ERROR: Bot key not allowed: " + botKey);
                trace("✅ Allowed keys are: " + ALLOWED_BOT_KEYS);
                sendError(user, "KEY_NOT_ALLOWED", 
                    "Allowed keys: musa, egyptmod, botMarhab, fahman, cenkay, ulubilge, batuhandiamond, canca_bot, countryBot3, countryBot5, bigboss, batuhan, jaberBot, janja_bot, kion_bot, kozalak_bot, moroccoBot, musicBot, musicStoreBot, pierbeachbot3, botAlgeria");
                return;
            }
            
            // Get current room
            Room currentRoom = user.getLastJoinedRoom();
            if (currentRoom == null) {
                trace("❌ ERROR: User not in any room");
                sendError(user, "NOT_IN_ROOM", "Join a room first to send bot messages");
                return;
            }
            
            trace("📍 User is in room: " + currentRoom.getName());
            
            // Prepare bot data for client
            SFSObject botData = prepareBotData(botKey, message);
            
            // Get all users in room
            List<User> usersInRoom = currentRoom.getUserList();
            trace("👥 Users in room: " + usersInRoom.size());
            
            // Send bot message to everyone in room
            int sentCount = 0;
            for (User recipient : usersInRoom) {
                send("botmessage", botData, recipient);
                sentCount++;
                trace("   → Sent to: " + recipient.getName());
            }
            
            trace("✅ SUCCESS: Bot message sent to " + sentCount + " users");
            
            // Send success response to sender
            SFSObject response = new SFSObject();
            response.putUtfString("status", "success");
            response.putInt("recipients", sentCount);
            response.putUtfString("botKey", botKey);
            response.putUtfString("message", "Message sent successfully!");
            
            send("botmessage", response, user);
            
            // Also broadcast to room chat
            broadcastToChat(currentRoom, botKey, message, user.getName());
            
        } catch (Exception e) {
            trace("❌ CRITICAL ERROR: " + e.getMessage());
            e.printStackTrace();
            sendError(user, "SERVER_ERROR", "Internal error: " + e.getMessage());
        }
    }
    
    private SFSObject prepareBotData(String botKey, String message) {
        SFSObject botData = new SFSObject();
        botData.putUtfString("botKey", botKey);
        botData.putUtfString("message", message);
        botData.putInt("duration", 20); // Show for 20 seconds
        botData.putInt("version", 1);
        
        // Colors array - مهم جداً للكلاينت
        SFSArray colors = new SFSArray();
        
        // Assign colors based on bot key
        switch(botKey) {
    case "musa":
        colors.addUtfString("FF5722"); // Orange
        colors.addUtfString("FFFFFF"); // White text
        colors.addUtfString("D84315"); // Dark Orange
        colors.addUtfString("E64A19"); // Orange border
        break;
    case "egyptmod":
        colors.addUtfString("1E88E5"); // Blue
        colors.addUtfString("FFFFFF"); // White
        colors.addUtfString("0D47A1"); // Dark Blue
        colors.addUtfString("1565C0"); // Blue border
        break;
    case "botmarhab":
        colors.addUtfString("43A047"); // Green
        colors.addUtfString("FFFFFF"); // White
        colors.addUtfString("1B5E20"); // Dark Green
        colors.addUtfString("2E7D32"); // Green border
        break;
    case "fahman":
        colors.addUtfString("8E24AA"); // Purple
        colors.addUtfString("FFFFFF"); // White
        colors.addUtfString("4A148C"); // Dark Purple
        colors.addUtfString("6A1B9A"); // Purple border
        break;
    case "cenkay":
        colors.addUtfString("FDD835"); // Yellow
        colors.addUtfString("000000"); // Black text
        colors.addUtfString("F57F17"); // Dark Yellow
        colors.addUtfString("F9A825"); // Yellow border
        break;
    case "ulubilge":
        colors.addUtfString("E53935"); // Red
        colors.addUtfString("FFFFFF"); // White
        colors.addUtfString("B71C1C"); // Dark Red
        colors.addUtfString("C62828"); // Red border
        break;
    case "batuhandiamond":
        colors.addUtfString("00ACC1"); // Cyan
        colors.addUtfString("FFFFFF"); // White
        colors.addUtfString("006064"); // Dark Cyan
        colors.addUtfString("00838F"); // Cyan border
        break;
    
    // البوتات الجديدة
    case "canca_bot":
        colors.addUtfString("FF9800"); // Orange
        colors.addUtfString("FFFFFF"); // White
        colors.addUtfString("F57C00"); // Dark Orange
        colors.addUtfString("EF6C00"); // Orange border
        break;
    case "countryBot3":
        colors.addUtfString("4CAF50"); // Green
        colors.addUtfString("FFFFFF"); // White
        colors.addUtfString("2E7D32"); // Dark Green
        colors.addUtfString("388E3C"); // Green border
        break;
    case "countryBot5":
        colors.addUtfString("2196F3"); // Blue
        colors.addUtfString("FFFFFF"); // White
        colors.addUtfString("0D47A1"); // Dark Blue
        colors.addUtfString("1565C0"); // Blue border
        break;
    case "bigboss":
        colors.addUtfString("9C27B0"); // Purple
        colors.addUtfString("FFFFFF"); // White
        colors.addUtfString("6A1B9A"); // Dark Purple
        colors.addUtfString("7B1FA2"); // Purple border
        break;
    case "batuhan":
        colors.addUtfString("00BCD4"); // Cyan
        colors.addUtfString("FFFFFF"); // White
        colors.addUtfString("00838F"); // Dark Cyan
        colors.addUtfString("0097A7"); // Cyan border
        break;
    case "jaberBot":
        colors.addUtfString("FF5722"); // Orange
        colors.addUtfString("FFFFFF"); // White
        colors.addUtfString("BF360C"); // Dark Orange
        colors.addUtfString("D84315"); // Orange border
        break;
    case "janja_bot":
        colors.addUtfString("E91E63"); // Pink
        colors.addUtfString("FFFFFF"); // White
        colors.addUtfString("AD1457"); // Dark Pink
        colors.addUtfString("C2185B"); // Pink border
        break;
    case "kion_bot":
        colors.addUtfString("673AB7"); // Deep Purple
        colors.addUtfString("FFFFFF"); // White
        colors.addUtfString("4527A0"); // Dark Purple
        colors.addUtfString("512DA8"); // Purple border
        break;
    case "kozalak_bot":
        colors.addUtfString("795548"); // Brown
        colors.addUtfString("FFFFFF"); // White
        colors.addUtfString("4E342E"); // Dark Brown
        colors.addUtfString("5D4037"); // Brown border
        break;
    case "moroccoBot":
        colors.addUtfString("C62828"); // Red
        colors.addUtfString("FFFFFF"); // White
        colors.addUtfString("B71C1C"); // Dark Red
        colors.addUtfString("D32F2F"); // Red border
        break;
    case "musicBot":
        colors.addUtfString("9C27B0"); // Purple
        colors.addUtfString("FFFFFF"); // White
        colors.addUtfString("6A1B9A"); // Dark Purple
        colors.addUtfString("7B1FA2"); // Purple border
        break;
    case "musicStoreBot":
        colors.addUtfString("FF9800"); // Orange
        colors.addUtfString("FFFFFF"); // White
        colors.addUtfString("F57C00"); // Dark Orange
        colors.addUtfString("EF6C00"); // Orange border
        break;
    case "pierbeachbot3":
        colors.addUtfString("00ACC1"); // Cyan
        colors.addUtfString("FFFFFF"); // White
        colors.addUtfString("00838F"); // Dark Cyan
        colors.addUtfString("0097A7"); // Cyan border
        break;
    case "botAlgeria":
        colors.addUtfString("008000"); // Green
        colors.addUtfString("FFFFFF"); // White
        colors.addUtfString("006400"); // Dark Green
        colors.addUtfString("228B22"); // Green border
        break;
    
    default:
        colors.addUtfString("607D8B"); // Default Grey
        colors.addUtfString("FFFFFF"); // White
        colors.addUtfString("37474F"); // Dark Grey
        colors.addUtfString("455A64"); // Grey border
}
        
        botData.putSFSArray("colors", colors);
        
        // Property (required by client)
        SFSObject property = new SFSObject();
        property.putUtfString("cn", "SimpleBotMessageProperty");
        botData.putSFSObject("property", property);
        
        trace("🎨 Colors set for " + botKey + ": " + colors.toJson());
        
        return botData;
    }
    
    private void broadcastToChat(Room room, String botKey, String message, String sender) {
        try {
            String chatMessage = "[🤖 " + botKey + "] " + message;
            
            SFSObject chatData = new SFSObject();
            chatData.putUtfString("sender", sender);
            chatData.putUtfString("message", chatMessage);
            chatData.putInt("type", 0); // Normal message
            
            // Send to room
            getParentExtension().send("roommessage", chatData, room.getUserList());
            
            trace("💬 Broadcasted to room chat: " + chatMessage);
        } catch (Exception e) {
            trace("⚠️ Could not broadcast to chat: " + e.getMessage());
        }
    }
    
    private void sendError(User user, String errorCode, String message) {
        SFSObject error = new SFSObject();
        error.putUtfString("errorCode", errorCode);
        error.putUtfString("message", message);
        send("botmessage", error, user);
    }
}