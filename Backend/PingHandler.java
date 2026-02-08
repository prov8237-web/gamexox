package src5;

import com.smartfoxserver.v2.entities.User;
import com.smartfoxserver.v2.entities.data.*;

public class PingHandler extends OsBaseHandler {
    
    @Override
    public void handleClientRequest(User user, ISFSObject params) {
        // Official server responds to "ping" with "pong" command
        SFSObject res = new SFSObject();
        sendValidated(user, "pong", res);
        trace("[PING] Sent pong to " + user.getName());
    }
}
