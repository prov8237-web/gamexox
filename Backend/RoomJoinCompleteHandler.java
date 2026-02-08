package src5;

import com.smartfoxserver.v2.entities.User;
import com.smartfoxserver.v2.entities.data.SFSArray;
import com.smartfoxserver.v2.entities.data.SFSObject;
import com.smartfoxserver.v2.entities.data.ISFSObject;

public class RoomJoinCompleteHandler extends OsBaseHandler {

    @Override
    public void handleClientRequest(User user, ISFSObject params) {
        trace("[ROOMJOINCOMPLETE] Request from: " + user.getName());
        // Official server returns empty params for roomjoincomplete
        SFSObject res = new SFSObject();
        reply(user, "roomjoincomplete", res);
        
        // After roomjoincomplete, official server sends displayAd
        sendDisplayAd(user);
        
        trace("[ROOMJOINCOMPLETE] ✅ Complete");
    }
    
    private void sendDisplayAd(User user) {
        SFSObject adRes = new SFSObject();
        SFSArray adsArray = new SFSArray();
        
        SFSObject ad = new SFSObject();
        ad.putInt("id", 32);
        ad.putInt("repeat", 0);
        ad.putInt("length", 0);
        ad.putInt("skipSecond", 0);
        ad.putUtfString("assetUrl", "sanalikaXBillboard_1.png");
        ad.putUtfString("impUrl", "");
        ad.putUtfString("type", "BILLBOARD");
        ad.putUtfString("clickUrl", "https://www.facebook.com/marhabcom");
        ad.putUtfString("alias", "sanalikaXBillboa");
        adsArray.addSFSObject(ad);
        
        adRes.putSFSArray("ads", adsArray);
        sendValidated(user, "displayAd", adRes);
        trace("[ROOMJOINCOMPLETE] Sent displayAd");
    }
    
}
