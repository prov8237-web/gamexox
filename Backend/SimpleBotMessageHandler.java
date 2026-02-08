package src5;

import com.smartfoxserver.v2.extensions.BaseClientRequestHandler;
import com.smartfoxserver.v2.entities.User;
import com.smartfoxserver.v2.entities.Room;
import com.smartfoxserver.v2.entities.data.ISFSObject;
import com.smartfoxserver.v2.entities.data.SFSObject;
import java.util.List;

public class SimpleBotMessageHandler extends BaseClientRequestHandler {
    
    @Override
    public void handleClientRequest(User user, ISFSObject params) {
        try {
            trace("🤖 SIMPLE BOT MESSAGE REQUEST");
            
            String key = params.containsKey("key") ? params.getUtfString("key") : "botmarhab";
            String msg = params.containsKey("msg") ? params.getUtfString("msg") : "Hello from server!";
            
            Room room = user.getLastJoinedRoom();
            if (room == null) {
                trace("❌ User not in room");
                return;
            }
            
            BotMessageCatalog.BotDefinition definition = BotMessageCatalog.resolve(key);
            if (definition == null) {
                trace("❌ Unknown bot key: " + key);
                return;
            }

            SFSObject botData = new SFSObject();
            botData.putUtfString("botKey", definition.getKey());
            botData.putUtfString("message", msg);
            botData.putInt("duration", 15);
            botData.putInt("version", 1);
            botData.putSFSArray("colors", definition.buildColors());
            
            SFSObject property = new SFSObject();
            property.putUtfString("cn", "SimpleBotMessageProperty");
            botData.putSFSObject("property", property);
            
            getParentExtension().send("botMessage", botData, room.getUserList());
            
            trace("✅ Simple bot message sent: " + key + " - " + msg);
            
        } catch (Exception e) {
            trace("❌ Error in SimpleBotMessageHandler: " + e.getMessage());
        }
    }
}
