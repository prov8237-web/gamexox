package src5;

import com.smartfoxserver.v2.entities.User;
import com.smartfoxserver.v2.entities.data.ISFSObject;
import com.smartfoxserver.v2.entities.data.ISFSArray;
import com.smartfoxserver.v2.entities.data.SFSObject;

public class SmileyListHandler extends OsBaseHandler {
    
    @Override
    public void handleClientRequest(User user, ISFSObject params) {
        trace("[AvatarProfileChat] REQUEST: smileylist -> {}");
        trace("[AvatarProfileChat] REQUEST_PAYLOAD: object(keys=[])");
        trace("[AvatarProfileChat] REQUEST_FULL_PAYLOAD: {class:Object, value:[object Object]}");
        
        ISFSObject response = getStore().getSmileyListResponse();
        
        String responseStr = formatSmileyListResponse(response);
        trace("[AvatarProfileChat] RESPONSE: smileylist <- " + responseStr);
        trace("[AvatarProfileChat] RESPONSE_PAYLOAD: object(keys=[smilies, nextRequest])");
        
        String fullPayload = formatSmileyListFullPayload(response);
        trace("[AvatarProfileChat] RESPONSE_FULL_PAYLOAD: " + fullPayload);
        
        reply(user, "smileylist", response);
        
        trace("[AvatarProfileChat] CLIENT_HANDLING: REQUEST_CALLBACKS smileylist -> listeners=1");
        trace("[AvatarProfileChat] CLIENT_HANDLING: EXTENSION_CALLBACKS smileylist -> listeners=0");
        trace("[AvatarProfileChat] CLIENT_HANDLING: LISTENER_CALLBACKS smileylist -> listeners=1");
    }
    
    private String formatSmileyListResponse(ISFSObject response) {
        if (response == null || !response.containsKey("smilies")) {
            return "{\"nextRequest\":1000}";
        }
        
        StringBuilder sb = new StringBuilder("{\"smilies\":[");
        
        ISFSArray smilies = response.getSFSArray("smilies");
        boolean first = true;
        
        for (int i = 0; i < smilies.size(); i++) {
            ISFSObject smiley = smilies.getSFSObject(i);
            
            if (!first) {
                sb.append(",");
            }
            
            sb.append("{");
            sb.append("\"requirements\":\"").append(smiley.getUtfString("requirements")).append("\",");
            sb.append("\"id\":").append(smiley.getInt("id")).append(",");
            sb.append("\"metaKey\":\"").append(smiley.getUtfString("metaKey")).append("\",");
            sb.append("\"sorting\":").append(smiley.getInt("sorting"));
            sb.append("}");
            
            first = false;
        }
        
        sb.append("],\"nextRequest\":").append(response.getInt("nextRequest")).append("}");
        return sb.toString();
    }
    
    private String formatSmileyListFullPayload(ISFSObject response) {
        if (response == null || !response.containsKey("smilies")) {
            return "{nextRequest:1000}";
        }
        
        StringBuilder sb = new StringBuilder("{smilies:[");
        
        ISFSArray smilies = response.getSFSArray("smilies");
        boolean first = true;
        
        for (int i = 0; i < smilies.size(); i++) {
            ISFSObject smiley = smilies.getSFSObject(i);
            
            if (!first) {
                sb.append(", ");
            }
            
            sb.append("{");
            sb.append("requirements:").append(smiley.getUtfString("requirements")).append(", ");
            sb.append("id:").append(smiley.getInt("id")).append(", ");
            sb.append("metaKey:").append(smiley.getUtfString("metaKey")).append(", ");
            sb.append("sorting:").append(smiley.getInt("sorting"));
            sb.append("}");
            
            first = false;
        }
        
        sb.append("], nextRequest:").append(response.getInt("nextRequest")).append("}");
        return sb.toString();
    }
}