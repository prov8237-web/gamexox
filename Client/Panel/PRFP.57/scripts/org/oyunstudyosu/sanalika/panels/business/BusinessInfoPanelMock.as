package org.oyunstudyosu.sanalika.panels.business
{
   import com.oyunstudyosu.enums.RequestDataKey;
   import com.oyunstudyosu.panel.PanelVO;
   import com.oyunstudyosu.sanalika.mock.IExtensionMock;
   import com.smartfoxserver.v2.SmartFox;
   
   public class BusinessInfoPanelMock implements IExtensionMock
   {
       
      
      public function BusinessInfoPanelMock()
      {
         super();
      }
      
      public function requestData(param1:String, param2:Object) : Object
      {
         switch(param1)
         {
            case RequestDataKey.FLAT_INFO:
               return {"data":{
                  "id":21146160,
                  "avatarID":1024,
                  "title":"hilary_duff1234_1",
                  "favorites":0,
                  "description":"Ouv yeah mother fucka !",
                  "onlineCount":1,
                  "isLocked":false,
                  "accessKey":"fad20f0b566bd85529316a18c6edeae3",
                  "isInFavorites":false
               }};
            default:
               return null;
         }
      }
      
      public function getInitData() : Object
      {
         return new PanelVO();
      }
      
      public function getExtensionResponse(param1:uint, param2:SmartFox) : void
      {
      }
      
      public function dispatchExtension(param1:uint) : Object
      {
         return null;
      }
   }
}
