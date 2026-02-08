package src5;

import com.smartfoxserver.v2.entities.Room;
import com.smartfoxserver.v2.entities.User;
import com.smartfoxserver.v2.entities.Zone;
import com.smartfoxserver.v2.entities.data.ISFSObject;
import com.smartfoxserver.v2.entities.data.SFSObject;
import java.util.List;

public class WhisperHandler extends OsBaseHandler {

    @Override
    public void handleClientRequest(User user, ISFSObject params) {
        ISFSObject data = data(params);
        String message = data != null && data.containsKey("message") ? data.getUtfString("message") : "";
        String receiver = data != null && data.containsKey("receiver") ? data.getUtfString("receiver") : "";

        if (!ProtocolConfig.chatEnabled()) {
            trace("[WHISPER] from=" + user.getName() + " to=" + receiver + " msg=" + message);
            reply(user, "whisper", new SFSObject());
            return;
        }

        trace("[CHAT_IN] type=whisper senderId=" + user.getId()
                + " avatarId=" + user.getName()
                + " keys=[message,receiver] messageLen=" + message.length());

        if (receiver.isEmpty() || message.isEmpty()) {
            SFSObject error = new SFSObject();
            error.putUtfString("errorCode", "MISSING_ITEM");
            reply(user, "whisper", error);
            return;
        }

        Zone zone = getParentExtension() != null ? getParentExtension().getParentZone() : null;
        User target = zone != null ? zone.getUserByName(receiver) : null;
        if (target == null) {
            SFSObject error = new SFSObject();
            error.putUtfString("errorCode", "MISSING_ITEM");
            reply(user, "whisper", error);
            return;
        }

        SFSObject payload = new SFSObject();
        payload.putUtfString("message", message);
        payload.putUtfString("sender", user.getName());
        payload.putUtfString("receiver", receiver);

        sendValidated(user, "whisper", payload);
        sendValidated(target, "whisper", payload);

        trace("[CHAT_OUT] type=whisper scope=direct recipients=" + user.getName() + "," + target.getName()
                + " keys=[message,sender,receiver] messageLen=" + message.length());

        Room room = user.getLastJoinedRoom();
        if (room != null) {
            SFSObject notify = new SFSObject();
            notify.putUtfString("sender", user.getName());
            notify.putUtfString("receiver", receiver);
            List<User> recipients = room.getUserList();
            send("whispernotify", notify, recipients);
            trace("[CHAT_OUT] type=whispernotify scope=room room=" + room.getName()
                    + " keys=[sender,receiver]");
        }
    }
}
