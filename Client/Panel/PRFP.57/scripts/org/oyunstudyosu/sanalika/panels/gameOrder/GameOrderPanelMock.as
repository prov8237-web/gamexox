package org.oyunstudyosu.sanalika.panels.gameOrder
{
   import com.oyunstudyosu.sanalika.mock.IExtensionMock;
   
   public class GameOrderPanelMock implements IExtensionMock
   {
       
      
      public function GameOrderPanelMock()
      {
         super();
      }
      
      public function requestData(param1:String, param2:Object) : Object
      {
         switch(param1)
         {
            case "orderlist":
               return {"data":{"orders":[{
                  "id":29,
                  "avatarID":1101,
                  "avatarName":"fdsfsdfsdffds",
                  "flatInventoryID":6,
                  "clip":"col1",
                  "expireTime":1465478285,
                  "orderExpireTime":1465475010,
                  "status":"PREPARING"
               }]}};
            case "report":
               return {"data":{}};
            default:
               return null;
         }
      }
      
      public function getInitData() : Object
      {
         return null;
      }
      
      public function dispatchExtension(param1:uint) : Object
      {
         return null;
      }
   }
}
