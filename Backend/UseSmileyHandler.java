package src5;

import com.smartfoxserver.v2.entities.User;
import com.smartfoxserver.v2.entities.data.ISFSObject;
import com.smartfoxserver.v2.entities.data.SFSObject;
import com.smartfoxserver.v2.entities.variables.SFSUserVariable;
import com.smartfoxserver.v2.entities.variables.UserVariable;
import java.util.ArrayList;
import java.util.List;

public class UseSmileyHandler extends OsBaseHandler {

    @Override
    public void handleClientRequest(User user, ISFSObject params) {
        trace("[AvatarProfileChat] REQUEST: changesmiley -> " + formatSFSObject(params));
        trace("[AvatarProfileChat] REQUEST_PAYLOAD: object(keys=" + getKeys(params) + ")");
        trace("[AvatarProfileChat] REQUEST_FULL_PAYLOAD: " + formatFullPayload(params));
        
        ISFSObject data = data(params);
        InMemoryStore store = getStore();
        InMemoryStore.UserState state = store.getOrCreateUser(user);

        String clip = "";
        int id = 0;
        
        if (data != null) {
            if (data.containsKey("clip")) {
                clip = data.getUtfString("clip");
            }
            if (data.containsKey("id")) {
                id = data.getInt("id");
            }
            if (data.containsKey("key")) {
                clip = data.getUtfString("key");
            }
        }

        if (InMemoryStore.isBlank(clip) && id > 0) {
            InMemoryStore.SmileyItem item = store.findSmileyById(id);
            if (item != null) {
                clip = item.clip;
            }
        } else if (!InMemoryStore.isBlank(clip) && id == 0) {
            InMemoryStore.SmileyItem item = store.findSmileyByClip(clip);
            if (item != null) {
                id = item.id;
            }
        }

        if (InMemoryStore.isBlank(clip) && id == 0) {
            clip = "";
        }

        state.setSmiley(clip);
        
        List<UserVariable> vars = new ArrayList<>();
        vars.add(new SFSUserVariable("smiley", clip));
        getApi().setUserVariables(user, vars);
        
        trace("[AvatarProfileChat] USER_VAR_UPDATE: smiley user=" + user.getId() + " -> {\"type\":\"String\",\"name\":\"smiley\",\"isPrivate\":false}");
        trace("[AvatarProfileChat] USER_VAR_PAYLOAD: smiley -> object(keys=[])");
        trace("[AvatarProfileChat] USER_VAR_FULL_PAYLOAD: smiley -> {class:com.smartfoxserver.v2.entities.variables::SFSUserVariable, value:[UserVar: smiley, type: String, value: " + clip + ", private: false]}");
        trace("[AvatarProfileChat] CLIENT_HANDLING: USER_VAR_LISTENERS smiley -> listeners=1");

        SFSObject response = new SFSObject();
        if (id > 0) {
            response.putInt("id", id);
        }
        if (!clip.isEmpty()) {
            response.putUtfString("clip", clip);
        }
        response.putInt("nextRequest", 1000);

        trace("[AvatarProfileChat] RESPONSE: changesmiley <- " + formatSFSObject(response));
        trace("[AvatarProfileChat] RESPONSE_PAYLOAD: object(keys=" + getKeys(response) + ")");
        trace("[AvatarProfileChat] RESPONSE_FULL_PAYLOAD: " + formatFullPayload(response));
        
        reply(user, "changesmiley", response);
        
        trace("[AvatarProfileChat] CLIENT_HANDLING: REQUEST_CALLBACKS changesmiley -> listeners=0");
        trace("[AvatarProfileChat] CLIENT_HANDLING: EXTENSION_CALLBACKS changesmiley -> listeners=0");
        trace("[AvatarProfileChat] CLIENT_HANDLING: LISTENER_CALLBACKS changesmiley -> listeners=0");
    }
    
    private String formatSFSObject(ISFSObject obj) {
        if (obj == null || obj.size() == 0) {
            return "{}";
        }
        
        StringBuilder sb = new StringBuilder("{");
        boolean first = true;
        
        for (String key : obj.getKeys()) {
            if (!first) {
                sb.append(",");
            }
            
            Object value = obj.get(key);
            if (value instanceof String) {
                sb.append("\"").append(key).append("\":\"").append(value).append("\"");
            } else {
                sb.append("\"").append(key).append("\":").append(value);
            }
            
            first = false;
        }
        
        sb.append("}");
        return sb.toString();
    }
    
    private String getKeys(ISFSObject obj) {
        if (obj == null || obj.size() == 0) {
            return "[]";
        }
        return obj.getKeys().toString();
    }
    
    private String formatFullPayload(ISFSObject obj) {
        if (obj == null || obj.size() == 0) {
            return "{class:Object, value:[object Object]}";
        }
        
        StringBuilder sb = new StringBuilder("{");
        boolean first = true;
        
        for (String key : obj.getKeys()) {
            if (!first) {
                sb.append(", ");
            }
            
            Object value = obj.get(key);
            sb.append(key).append(":").append(value);
            
            first = false;
        }
        
        sb.append("}");
        return sb.toString();
    }
}