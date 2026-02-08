package src5;

import com.smartfoxserver.v2.entities.User;
import com.smartfoxserver.v2.entities.data.ISFSArray;
import com.smartfoxserver.v2.entities.data.ISFSObject;
import com.smartfoxserver.v2.entities.data.SFSArray;
import com.smartfoxserver.v2.entities.data.SFSObject;

public final class DefaultResponseFactory {
    private DefaultResponseFactory() {}

    public static ISFSObject buildResponse(String command, User user, ISFSObject params, MainExtension extension) {
        if (command == null) {
            return new SFSObject();
        }

        switch (command) {
            case "clothlist":
                return buildClothList(user, extension);
            case "handitemlist":
                return buildArrayResponse("items");
            case "specialitemlist":
                return buildArrayResponse("items");
            case "smileylist":
                return buildArrayResponse("smilies");
            case "shopproductlist":
                return buildArrayResponse("products");
            case "universelist":
                return buildArrayResponse("universes");
            case "questlist":
                return buildArrayResponse("quests");
            case "achievementlist":
                return buildArrayResponse("achievements");
            case "newslist":
                return buildArrayResponse("news");
            case "pubContentList":
                return buildArrayResponse("list");
            case "banlist":
                return buildArrayResponse("list");
            case "flatlist":
                return buildArrayResponse("flats");
            case "flatsearch":
                return buildArrayResponse("flats");
            case "avatarlist":
                return buildArrayResponse("avatars");
            case "roommessage":
                return buildRoomMessageAck(params);
            default:
                return buildDefaultAck();
        }
    }

    private static ISFSObject buildClothList(User user, MainExtension extension) {
        SFSObject res = new SFSObject();
        ISFSArray items = new SFSArray();

        if (extension != null && user != null) {
            String ip = user.getSession().getAddress();
            Object savedClothes = extension.getParentZone().getProperty(ip + "_clothes");
            if (savedClothes instanceof ISFSObject) {
                ISFSObject clothesObj = (ISFSObject) savedClothes;
                if (clothesObj.containsKey("items")) {
                    items = clothesObj.getSFSArray("items");
                }
            }
        }

        res.putSFSArray("items", items);
        res.putInt("nextRequest", 1000);
        return res;
    }

    private static ISFSObject buildRoomMessageAck(ISFSObject params) {
        SFSObject res = new SFSObject();
        res.putBool("success", true);
        if (params != null && params.containsKey("data")) {
            ISFSObject data = params.getSFSObject("data");
            if (data.containsKey("message")) {
                res.putUtfString("message", data.getUtfString("message"));
            }
        }
        return res;
    }

    private static ISFSObject buildArrayResponse(String key) {
        SFSObject res = new SFSObject();
        res.putSFSArray(key, new SFSArray());
        res.putInt("nextRequest", 1000);
        return res;
    }

    private static ISFSObject buildDefaultAck() {
        SFSObject res = new SFSObject();
        res.putBool("ok", true);
        res.putInt("nextRequest", 1000);
        return res;
    }
}
