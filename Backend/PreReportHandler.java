
package src5;

import com.smartfoxserver.v2.entities.Room;
import com.smartfoxserver.v2.entities.User;
import com.smartfoxserver.v2.entities.Zone;
import com.smartfoxserver.v2.entities.data.*;
import java.util.List;

/**
 * Client sends "prereport" (and sometimes "ingamereport") when reporting a user's chat/behavior.
 * This handler stores the complaint and pushes it to SECURITY/KNIGHTS panel (complaintlist).
 */
public class PreReportHandler extends OsBaseHandler {

    @Override
    public void handleClientRequest(User sender, ISFSObject params) {
        ISFSObject data = data(params);
        int rid = extractRid(params);
        String command = resolveCommand(sender);

        String targetId = readStringAny(data, new String[]{"avatarID","avatarId","targetId","toId","id","uid"}, "");
        String targetName = readStringAny(data, new String[]{"avatarName","targetName","toName","name"}, "");
        String text = readStringAny(data, new String[]{"text","msg","message","chat","body"}, null);
        String reason = readStringAny(data, new String[]{"reason","type","category"}, null);

        Room room = sender.getLastJoinedRoom();
        String roomName = room != null ? room.getName() : readStringAny(data, new String[]{"room","roomName"}, "");

        InMemoryStore store = getStore();
        InMemoryStore.UserState st = store.getOrCreateUser(sender);

        String reporterId = HandlerUtils.normalizeAvatarId(sender.getName());
        String reporterName = st.getAvatarName() != null ? st.getAvatarName() : sender.getName();

        String normalizedTargetId = HandlerUtils.normalizeAvatarId(targetId);
        int banCount = store.getBanCount(normalizedTargetId);
        long complaintId = store.addComplaint(reporterId, reporterName, targetId, targetName, roomName, text, reason);
        store.addReport(reporterId, normalizedTargetId, text, reason, 0, banCount, 0);

        // ACK to reporter
        SFSObject res = new SFSObject();
        res.putBool("ok", true);
        res.putLong("id", complaintId);
        sendResponseWithRid(command, res, sender, rid);

        // Push updated complaint list to all security users (including current sender if they are security)
        pushComplaintListToSecurityUsers();
    }

    private String resolveCommand(User sender) {
        try {
            Object last = sender.getProperty("lastRequestId");
            if (last != null) {
                String cmd = last.toString();
                if ("ingamereport".equals(cmd) || "report".equals(cmd)) {
                    return cmd;
                }
            }
        } catch (Exception ignored) {}
        return "prereport";
    }

    private void pushComplaintListToSecurityUsers() {
        InMemoryStore store = getStore();
        SFSObject payload = ComplaintListHandler.buildComplaintPayload(store, "OPEN", 50);

        try {
            Zone z = getZone();
            if (z == null) return;
            for (User u : z.getUserList()) {
                if (u == null) continue;
                if (ComplaintListHandler.isSecurityUser(u, store)) {
                    sendValidated(u, "complaintlist", payload);
                }
            }
        } catch (Exception ignored) {}
    }

    private static String readStringAny(ISFSObject obj, String[] keys, String def) {
        if (obj == null) return def;
        for (String k : keys) {
            try {
                if (obj.containsKey(k)) {
                    String v = obj.getUtfString(k);
                    if (v != null && !v.trim().isEmpty()) return v;
                }
            } catch (Exception ignored) {}
        }
        return def;
    }
}
