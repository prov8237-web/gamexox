package src5;

import com.smartfoxserver.v2.entities.data.ISFSArray;
import com.smartfoxserver.v2.entities.data.ISFSObject;
import com.smartfoxserver.v2.entities.data.SFSArray;
import com.smartfoxserver.v2.entities.data.SFSObject;

public final class HandlerUtils {
    private HandlerUtils() {}

    public static ISFSObject dataOrSelf(ISFSObject params) {
        if (params == null) {
            return new SFSObject();
        }
        if (params.containsKey("data")) {
            ISFSObject data = params.getSFSObject("data");
            if (data != null) {
                return data;
            }
        }
        return params;
    }

    public static ISFSArray safeArray(ISFSArray array) {
        return array == null ? new SFSArray() : array;
    }

    public static SFSObject emptyResponse() {
        return new SFSObject();
    }

    public static String defaultRoomMapBase64() {
        return MapBuilder.buildMapBase64();
    }
}
