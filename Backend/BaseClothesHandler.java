package src5;

import com.smartfoxserver.v2.entities.User;
import com.smartfoxserver.v2.entities.data.*;

public class BaseClothesHandler extends OsBaseHandler {
    
    @Override
    public void handleClientRequest(User user, ISFSObject params) {
        trace("[BASECLOTHES] Request from: " + user.getName());
        
        SFSObject res = new SFSObject();
        
        // Female clothes - matching official server exactly
        SFSArray femaleClothes = new SFSArray();
        femaleClothes.addSFSObject(mkItem(2, "1", 64, new String[]{"2", "3", "4", "5", "6", "7", "9"}));
        femaleClothes.addSFSObject(mkItem(3, "10", 131072, new String[]{"3", "4", "5", "6", "7", "8", "9"}));
        femaleClothes.addSFSObject(mkItem(4, "11", 131072, new String[]{"1", "2", "3", "4", "6", "7", "9"}));
        femaleClothes.addSFSObject(mkItem(5, "12", 131072, new String[]{"1", "3", "4", "5", "6", "7", "8", "9"}));
        femaleClothes.addSFSObject(mkItem(6, "13", 512, new String[]{"4", "5", "6", "7", "9"}));
        femaleClothes.addSFSObject(mkItem(20, "3", 64, new String[]{"2", "3", "4", "5", "7", "9"}));
        femaleClothes.addSFSObject(mkItem(28, "5", 512, new String[]{"1", "3", "4", "5", "6", "7", "9"}));
        femaleClothes.addSFSObject(mkItem(30, "8", 131072, new String[]{"2", "3", "4", "5", "6", "7", "8"}));
        femaleClothes.addSFSObject(mkItem(31, "7", 16, new String[]{"2", "3", "5", "7", "9", "10"}));
        femaleClothes.addSFSObject(mkItem(32, "8", 131072, new String[]{"2", "3", "4", "5", "6", "7", "8", "9"}));
        femaleClothes.addSFSObject(mkItem(33, "9", 131072, new String[]{"1", "2", "3", "5", "7", "9"}));
        femaleClothes.addSFSObject(mkItem(1344, "A", 4, new String[]{"1", "2", "8", "12"}));
        femaleClothes.addSFSObject(mkItem(1348, "B", 2, new String[]{"1", "2", "8", "12"}));
        femaleClothes.addSFSObject(mkItem(1349, "C", 1, new String[]{"1", "2", "8", "12"}));
        femaleClothes.addSFSObject(mkItem(10231, "U9oeNjcz", 512, new String[]{"9"}));

        // Male clothes - matching official server exactly
        SFSArray maleClothes = new SFSArray();
        maleClothes.addSFSObject(mkItem(2, "1", 64, new String[]{"3", "4", "5", "7", "8", "9"}));
        maleClothes.addSFSObject(mkItem(3, "10", 131072, new String[]{"2", "3", "4", "5", "7", "8", "9"}));
        maleClothes.addSFSObject(mkItem(4, "11", 131072, new String[]{"1", "2", "3", "4", "6", "7", "9", "10"}));
        maleClothes.addSFSObject(mkItem(5, "12", 131072, new String[]{"1", "2", "4", "7", "9"}));
        maleClothes.addSFSObject(mkItem(6, "13", 512, new String[]{"1", "3", "4", "5", "7", "8", "9"}));
        maleClothes.addSFSObject(mkItem(30, "8", 131072, new String[]{"1", "2", "3", "4", "5", "6", "7", "8"}));
        maleClothes.addSFSObject(mkItem(31, "7", 16, new String[]{"1", "3", "4", "5", "7", "9", "10"}));
        maleClothes.addSFSObject(mkItem(32, "8", 131072, new String[]{"1", "2", "3", "4", "7", "9"}));
        maleClothes.addSFSObject(mkItem(33, "9", 131072, new String[]{"1", "2", "3", "4", "5", "6", "7", "8", "9"}));
        maleClothes.addSFSObject(mkItem(136, "2", 64, new String[]{"2", "3", "4", "5", "7", "8", "9"}));
        maleClothes.addSFSObject(mkItem(149, "4", 512, new String[]{"1", "3", "4", "5", "6", "7", "8", "9"}));
        maleClothes.addSFSObject(mkItem(1344, "A", 4, new String[]{"1", "2", "8", "12"}));
        maleClothes.addSFSObject(mkItem(1348, "B", 2, new String[]{"1", "2", "8", "12"}));
        maleClothes.addSFSObject(mkItem(1349, "C", 1, new String[]{"1", "2", "8", "12"}));

        res.putSFSArray("f", femaleClothes);
        res.putSFSArray("m", maleClothes);
        res.putInt("nextRequest", 1000);

        reply(user, "baseclothes", res);
        trace("[BASECLOTHES] ✅ Sent " + maleClothes.size() + " male, " + femaleClothes.size() + " female items");
    }

    private ISFSObject mkItem(int id, String clip, int placeBit, String[] colorArray) {
        ISFSObject obj = new SFSObject();
        obj.putInt("id", id);
        obj.putUtfString("clip", clip);
        obj.putInt("placeBit", placeBit);
        
        SFSArray colors = new SFSArray();
        for (String color : colorArray) {
            colors.addUtfString(color);
        }
        obj.putSFSArray("colors", colors);
        
        return obj;
    }
}