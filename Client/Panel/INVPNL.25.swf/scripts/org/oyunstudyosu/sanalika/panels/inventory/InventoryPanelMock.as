package org.oyunstudyosu.sanalika.panels.inventory
{
   import com.oyunstudyosu.sanalika.mock.IExtensionMock;
   import com.smartfoxserver.v2.SmartFox;
   
   public class InventoryPanelMock implements IExtensionMock
   {
       
      
      public function InventoryPanelMock()
      {
         super();
      }
      
      public function requestData(param1:String, param2:Object) : Object
      {
         if(param1 == "handitemlist")
         {
            return {"data":{"list":[{
               "productID":"1dsa",
               "ids":[1,2,3,4,5],
               "clip":"bp",
               "lifeTime":600
            },{
               "productID":2,
               "ids":[5],
               "timeLeft":180,
               "clip":"1008",
               "lifeTime":200
            }]}};
         }
         return null;
      }
      
      public function getInitData() : Object
      {
         return {"name":"InventoryPanel"};
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
