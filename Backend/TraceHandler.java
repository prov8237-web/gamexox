package src5;

import com.smartfoxserver.v2.entities.User;
import com.smartfoxserver.v2.entities.data.*;

public class TraceHandler extends OsBaseHandler {
    
    @Override
    public void handleClientRequest(User user, ISFSObject params) {
        if (params.containsKey("msg")) {
            trace("[CLIENT-TRACE] " + params.getUtfString("msg"));
        }
        // No response needed for trace
    }
}
