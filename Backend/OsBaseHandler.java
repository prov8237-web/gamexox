package src5;

import com.smartfoxserver.v2.entities.Room;
import com.smartfoxserver.v2.entities.User;
import com.smartfoxserver.v2.entities.Zone;
import com.smartfoxserver.v2.entities.data.ISFSObject;
import com.smartfoxserver.v2.entities.data.SFSObject;
import com.smartfoxserver.v2.entities.variables.RoomVariable;
import com.smartfoxserver.v2.entities.variables.SFSRoomVariable;
import com.smartfoxserver.v2.entities.variables.UserVariable;
import com.smartfoxserver.v2.extensions.BaseClientRequestHandler;
import java.util.ArrayList;
import java.util.List;

public abstract class OsBaseHandler extends BaseClientRequestHandler {
    
    protected void reply(User user, String cmd, ISFSObject res) {
        if (res == null) {
            res = new SFSObject();
        }

        ProtocolValidator.validateResponse(cmd, res, this);
        
        trace("📤 SENDING: " + cmd + " to " + user.getName());
        send(cmd, res, user);
        
        try {
            MainExtension mainExt = (MainExtension) getParentExtension();
            if (mainExt != null) {
                mainExt.markResponseSent(cmd, user);
            }
        } catch (Exception e) {
            // Silent
        }
    }

    protected void sendValidated(User user, String cmd, ISFSObject res) {
        if (res == null) {
            res = new SFSObject();
        }
        ProtocolValidator.validateResponse(cmd, res, this);
        send(cmd, res, user);
    }

    protected void replyToRequest(User user, String cmd, ISFSObject res, ISFSObject requestParams) {
        if (res == null) {
            res = new SFSObject();
        }
        ProtocolValidator.validateResponse(cmd, res, this);
        send(cmd, res, user);
        int clientRid = getClientRid(requestParams);
        trace("[MOVE_RESP] cmd=" + cmd + " type=RESPONSE clientRid=" + clientRid + " keys=" + res.getKeys());
        try {
            MainExtension mainExt = (MainExtension) getParentExtension();
            if (mainExt != null) {
                mainExt.markResponseSent(cmd, user);
            }
        } catch (Exception e) {
            // Silent
        }
    }

    protected int extractRid(ISFSObject params) {
        if (params == null) {
            return -1;
        }
        if (params.containsKey("rid")) {
            try {
                return params.getInt("rid");
            } catch (Exception ignored) {
            }
        }
        if (params.containsKey("data")) {
            try {
                ISFSObject data = params.getSFSObject("data");
                if (data != null && data.containsKey("rid")) {
                    return data.getInt("rid");
                }
            } catch (Exception ignored) {
            }
        }
        if (params.containsKey("clientRid")) {
            try {
                return params.getInt("clientRid");
            } catch (Exception ignored) {
            }
        }
        if (params.containsKey("data")) {
            try {
                ISFSObject data = params.getSFSObject("data");
                if (data != null && data.containsKey("clientRid")) {
                    return data.getInt("clientRid");
                }
            } catch (Exception ignored) {
            }
        }
        return -1;
    }

    protected void sendResponseWithRid(String cmd, ISFSObject res, User user, int rid) {
        if (res == null) {
            res = new SFSObject();
        }
        if (rid > 0) {
            res.putInt("rid", rid);
        }
        res.putUtfString("__cmd", cmd);
        ProtocolValidator.validateResponse(cmd, res, this);
        send(cmd, res, user);
        trace("[RESP_WITH_RID] cmd=" + cmd + " type=RESPONSE clientRid=" + rid + " keys=" + res.getKeys());
        try {
            MainExtension mainExt = (MainExtension) getParentExtension();
            if (mainExt != null) {
                mainExt.markResponseSent(cmd, user);
            }
        } catch (Exception e) {
            // Silent
        }
    }

    protected ISFSObject data(ISFSObject params) {
        return HandlerUtils.dataOrSelf(params);
    }

    protected int keyCount(ISFSObject obj) {
        return obj == null ? 0 : obj.getKeys().size();
    }

    protected InMemoryStore getStore() {
        MainExtension ext = (MainExtension) getParentExtension();
        return ext != null ? ext.getStore() : new InMemoryStore();
    }

    protected Zone getZone() {
        try {
            MainExtension ext = (MainExtension) getParentExtension();
            return ext != null ? ext.getParentZone() : null;
        } catch (Exception ignored) {
            return null;
        }
    }

    protected void ensureMandatoryRoomVars(Room room, InMemoryStore.RoomState roomState, String stage) {
        if (room == null) {
            return;
        }
        if (roomState == null) {
            roomState = getStore().getOrCreateRoom(room);
        }
        List<RoomVariable> vars = new ArrayList<>();

        if (!room.containsVariable("roomKey")) {
            vars.add(new SFSRoomVariable("roomKey", room.getName()));
        }
        if (!room.containsVariable("width")) {
            vars.add(new SFSRoomVariable("width", MapBuilder.ROOM_WIDTH));
        }
        if (!room.containsVariable("height")) {
            vars.add(new SFSRoomVariable("height", MapBuilder.ROOM_HEIGHT));
        }
        if (!room.containsVariable("type")) {
            vars.add(new SFSRoomVariable("type", "OUTDOOR"));
        }
        if (!room.containsVariable("roomTitle")) {
            vars.add(new SFSRoomVariable("roomTitle", room.getName()));
        }
        if (!room.containsVariable("isInteractiveRoom")) {
            vars.add(new SFSRoomVariable("isInteractiveRoom", true));
        }
        if (!room.containsVariable("doors")) {
            String doorsJson = roomState != null ? roomState.getDoorsJson() : "[]";
            vars.add(new SFSRoomVariable("doors", doorsJson));
        }
        if (!room.containsVariable("bots")) {
            String botsJson = roomState != null ? roomState.getBotsJson() : "[]";
            vars.add(new SFSRoomVariable("bots", botsJson));
        }
        if (!room.containsVariable("grid")) {
            String gridBase64 = roomState != null ? roomState.getGridBase64() : "";
            vars.add(new SFSRoomVariable("grid", gridBase64));
        }

        if (!vars.isEmpty()) {
            getApi().setRoomVariables(null, room, vars);
            trace("[ROOM_VARS_BROADCAST] stage=" + stage + " room=" + room.getName()
                + " vars=" + collectRoomVarNames(vars));
        }

        boolean hasInteractive = room.containsVariable("isInteractiveRoom") || containsRoomVar(vars, "isInteractiveRoom");
        boolean hasGrid = room.containsVariable("grid") || containsRoomVar(vars, "grid");
        boolean hasDoors = room.containsVariable("doors") || containsRoomVar(vars, "doors");
        boolean hasBots = room.containsVariable("bots") || containsRoomVar(vars, "bots");
        trace("[ROOM_VARS_GATE] stage=" + stage + " room=" + room.getName()
            + " has={isInteractiveRoom:" + hasInteractive
            + ",grid:" + hasGrid
            + ",doors:" + hasDoors
            + ",bots:" + hasBots + "}");
    }

    private boolean containsRoomVar(List<RoomVariable> vars, String key) {
        for (RoomVariable var : vars) {
            if (var != null && key.equals(var.getName())) {
                return true;
            }
        }
        return false;
    }

    protected int getClientRid(ISFSObject params) {
        if (params == null) {
            return -1;
        }
        Integer rid = readRidFromObject(params);
        if (rid != null) {
            return rid;
        }
        if (params.containsKey("data")) {
            ISFSObject data = params.getSFSObject("data");
            rid = readRidFromObject(data);
            if (rid != null) {
                return rid;
            }
        }
        return -1;
    }

    private Integer readRidFromObject(ISFSObject obj) {
        if (obj == null) {
            return null;
        }
        String[] keys = new String[] {"rid", "clientRid"};
        for (String key : keys) {
            if (!obj.containsKey(key)) {
                continue;
            }
            try {
                long value = obj.getLong(key);
                if (value > Integer.MAX_VALUE) {
                    return Integer.MAX_VALUE;
                }
                if (value < Integer.MIN_VALUE) {
                    return Integer.MIN_VALUE;
                }
                return (int) value;
            } catch (Exception e) {
                try {
                    return obj.getInt(key);
                } catch (Exception ignored) {
                    return null;
                }
            }
        }
        return null;
    }

    protected String readString(ISFSObject obj, String key) {
        if (obj == null || key == null || !obj.containsKey(key)) {
            return "missing";
        }
        try {
            return obj.getUtfString(key);
        } catch (Exception e) {
            try {
                Object value = obj.get(key);
                return value == null ? "null" : String.valueOf(value);
            } catch (Exception ignored) {
                return "invalid";
            }
        }
    }

    protected String readUserVarAsString(User user, String... keys) {
        if (user == null || keys == null) {
            return "null";
        }
        for (String key : keys) {
            if (key == null) {
                continue;
            }
            try {
                UserVariable var = user.getVariable(key);
                if (var == null || var.getValue() == null) {
                    continue;
                }
                Object value = var.getValue();
                return String.valueOf(value);
            } catch (Exception e) {
                return "invalid";
            }
        }
        return "null";
    }

    protected String buildVarSnapshot(User user, ISFSObject params) {
        String position = readUserVarAsString(user, "position");
        if ("null".equals(position) || "invalid".equals(position)) {
            position = readString(params, "position");
        }
        String clothes = readUserVarAsString(user, "clothes");
        if ("null".equals(clothes) || "invalid".equals(clothes)) {
            clothes = readString(params, "clothes");
        }
        String imgPath = readUserVarAsString(user, "imgPath");
        if ("null".equals(imgPath) || "invalid".equals(imgPath)) {
            imgPath = readString(params, "imgPath");
        }
        String optimizedAssetKey = readUserVarAsString(user, "optimizedAssetKey");
        if ("null".equals(optimizedAssetKey) || "invalid".equals(optimizedAssetKey)) {
            optimizedAssetKey = readString(params, "optimizedAssetKey");
        }
        return "{position=" + position + ",clothes=" + clothes + ",imgPath=" + imgPath
            + ",optimizedAssetKey=" + optimizedAssetKey + "}";
    }

    protected String valueType(ISFSObject obj, String key, String fallbackValue) {
        if (obj != null && key != null && obj.containsKey(key)) {
            try {
                Object value = obj.get(key);
                return value == null ? "null" : value.getClass().getSimpleName();
            } catch (Exception e) {
                return "invalid";
            }
        }
        if (fallbackValue == null) {
            return "null";
        }
        return "String";
    }

    private String collectRoomVarNames(List<RoomVariable> vars) {
        StringBuilder builder = new StringBuilder();
        for (RoomVariable var : vars) {
            if (var == null) {
                continue;
            }
            if (builder.length() > 0) {
                builder.append(",");
            }
            builder.append(var.getName());
        }
        return builder.toString();
    }
}
