package src5;

import com.smartfoxserver.v2.extensions.BaseClientRequestHandler;
import com.smartfoxserver.v2.entities.User;
import com.smartfoxserver.v2.entities.Room;
import com.smartfoxserver.v2.entities.data.ISFSObject;
import com.smartfoxserver.v2.entities.data.SFSObject;
import com.smartfoxserver.v2.entities.data.SFSArray;
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
            
            SFSObject botData = new SFSObject();
            botData.putUtfString("botKey", key);
            botData.putUtfString("message", msg);
            botData.putInt("duration", 15);
            botData.putInt("version", 1);
            
            SFSArray colors = new SFSArray();
            colors.addUtfString("1E88E5");
            colors.addUtfString("FFFFFF");
            colors.addUtfString("0D47A1");
            colors.addUtfString("1565C0");
            botData.putSFSArray("colors", colors);
            
            SFSObject property = new SFSObject();
            property.putUtfString("cn", "SimpleBotMessageProperty");
            botData.putSFSObject("property", property);
            
            getParentExtension().send("botmessage", botData, room.getUserList());
            
            trace("✅ Simple bot message sent: " + key + " - " + msg);
            
        } catch (Exception e) {
            trace("❌ Error in SimpleBotMessageHandler: " + e.getMessage());
        }
    }
}