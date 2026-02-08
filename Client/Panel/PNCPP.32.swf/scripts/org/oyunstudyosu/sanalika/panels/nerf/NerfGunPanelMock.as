package org.oyunstudyosu.sanalika.panels.nerf
{
   import com.oyunstudyosu.panel.PanelVO;
   import com.oyunstudyosu.sanalika.mock.IExtensionMock;
   import com.smartfoxserver.v2.SmartFox;
   
   public class NerfGunPanelMock implements IExtensionMock
   {
       
      
      public function NerfGunPanelMock()
      {
         super();
      }
      
      public function requestData(param1:String, param2:Object) : Object
      {
         switch(param1)
         {
            case "products":
               return {"data":{"products":{
                  "types":["NERF"],
                  "NERF":[{
                     "clip":"DaDjx8Te",
                     "roles":"1",
                     "price":1000,
                     "has":true,
                     "productID":12,
                     "shopProductID":9534,
                     "currency":"SANIL",
                     "description":"3+1 bebek gibi ev daha ne istiyon lan!",
                     "property":{
                        "type":"RoomProductProperty",
                        "count":1
                     }
                  },{
                     "clip":"DZgzmHfu",
                     "roles":"1",
                     "has":false,
                     "price":1000,
                     "productID":12,
                     "shopProductID":9534,
                     "currency":"SANIL",
                     "description":"3+1 bebek gibi ev daha ne istiyon lan!",
                     "property":{
                        "type":"RoomProductProperty",
                        "count":1
                     }
                  }]
               }}};
            default:
               return null;
         }
      }
      
      public function getInitData() : Object
      {
         return new PanelVO("NerfGunPanel","",{
            "shopID":16,
            "botKey":"Barmen"
         });
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
