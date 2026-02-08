package src5;

import com.smartfoxserver.v2.extensions.BaseClientRequestHandler;
import com.smartfoxserver.v2.entities.User;
import com.smartfoxserver.v2.entities.Room;
import com.smartfoxserver.v2.entities.data.ISFSObject;
import com.smartfoxserver.v2.entities.data.SFSObject;
import com.smartfoxserver.v2.entities.data.SFSArray;
import java.util.List;

public class BotMessageHandler extends BaseClientRequestHandler {
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
            
            String botKey = parts[0].trim();
            String message = parts[1].trim();
            
            trace("🔑 Bot key extracted: " + botKey);
            trace("📝 Message extracted: " + message);
            
            // Check if bot key is allowed
            BotMessageCatalog.BotDefinition definition = BotMessageCatalog.resolve(botKey);
            if (definition == null) {
                trace("❌ ERROR: Bot key not allowed: " + botKey);
                trace("✅ Allowed keys are: " + BotMessageCatalog.allowedKeys());
                sendError(user, "KEY_NOT_ALLOWED", 
                    "Allowed keys: " + BotMessageCatalog.allowedKeysMessage());
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
            SFSObject botData = prepareBotData(definition, message);
            
            // Get all users in room
            List<User> usersInRoom = currentRoom.getUserList();
            trace("👥 Users in room: " + usersInRoom.size());
            
            // Send bot message to everyone in room
            int sentCount = 0;
            for (User recipient : usersInRoom) {
                send("botMessage", botData, recipient);
                sentCount++;
                trace("   → Sent to: " + recipient.getName());
            }
            
            trace("✅ SUCCESS: Bot message sent to " + sentCount + " users");
            
            // Send success response to sender
            SFSObject response = new SFSObject();
            response.putUtfString("status", "success");
            response.putInt("recipients", sentCount);
            response.putUtfString("botKey", definition.getKey());
            response.putUtfString("message", "Message sent successfully!");
            
            send("botmessage", response, user);
            
            // Also broadcast to room chat
            broadcastToChat(currentRoom, definition.getKey(), message, user.getName());
            
        } catch (Exception e) {
            trace("❌ CRITICAL ERROR: " + e.getMessage());
            e.printStackTrace();
            sendError(user, "SERVER_ERROR", "Internal error: " + e.getMessage());
        }
    }
    
    private SFSObject prepareBotData(BotMessageCatalog.BotDefinition definition, String message) {
        SFSObject botData = new SFSObject();
        botData.putUtfString("botKey", definition.getKey());
        botData.putUtfString("message", message);
        botData.putInt("duration", 20); // Show for 20 seconds
        botData.putInt("version", 1);
        SFSArray colors = definition.buildColors();
        botData.putSFSArray("colors", colors);
        
        // Property (required by client)
        SFSObject property = new SFSObject();
        property.putUtfString("cn", "SimpleBotMessageProperty");
        botData.putSFSObject("property", property);
        
        trace("🎨 Colors set for " + definition.getKey() + ": " + colors.toJson());
        
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
