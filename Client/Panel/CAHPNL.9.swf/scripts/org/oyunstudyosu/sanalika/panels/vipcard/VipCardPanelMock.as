package org.oyunstudyosu.sanalika.panels.vipcard
{
   import com.oyunstudyosu.panel.PanelVO;
   import com.oyunstudyosu.sanalika.mock.IExtensionMock;
   import com.smartfoxserver.v2.SmartFox;
   
   public class VipCardPanelMock implements IExtensionMock
   {
       
      
      public function VipCardPanelMock()
      {
         super();
      }
      
      public function requestData(param1:String, param2:Object) : Object
      {
         switch(param1)
         {
            case "shopproductlist":
               return {"data":{"shopProductList":{"VIP":[{
                  "id":8364,
                  "productID":4323,
                  "price":200,
                  "discount":0,
                  "currency":"DIAMOND",
                  "lifetime":2592000,
                  "countDownType":"NOW",
                  "priority":100,
                  "clip":"CARD_GOLD",
                  "roles":"AA==",
                  "subType":"VIP",
                  "type":"CARD",
                  "publishDate":"06-09-2015",
                  "furnLocation":0,
                  "property":"{\"cn\":\"BenefitProperty\",\"list\":[{\"key\":\"ROLES\",\"value\":\"Pg==\"},{\"key\":\"DISCOUNT\",\"value\":\"10\"}]}"
               },{
                  "id":8206,
                  "productID":4324,
                  "price":400,
                  "discount":0,
                  "currency":"DIAMOND",
                  "lifetime":2592000,
                  "countDownType":"NOW",
                  "priority":100,
                  "clip":"CARD_DIAMOND",
                  "roles":"AA==",
                  "subType":"VIP",
                  "type":"CARD",
                  "publishDate":"02-08-2015",
                  "furnLocation":0,
                  "property":"{\"cn\":\"BenefitProperty\",\"list\":[{\"key\":\"ROLES\",\"value\":\"bg==\"},{\"key\":\"DISCOUNT\",\"value\":\"20\"}]}"
               },{
                  "id":8205,
                  "productID":4325,
                  "price":100,
                  "discount":0,
                  "currency":"DIAMOND",
                  "lifetime":2592000,
                  "countDownType":"NOW",
                  "priority":100,
                  "clip":"CARD_SILVER",
                  "roles":"AA==",
                  "subType":"VIP",
                  "type":"CARD",
                  "publishDate":"02-08-2015",
                  "furnLocation":0,
                  "property":"{\"cn\":\"BenefitProperty\",\"list\":[{\"key\":\"ROLES\",\"value\":\"rg==\"}]}"
               }]}}};
            default:
               return null;
         }
      }
      
      public function getInitData() : Object
      {
         return new PanelVO("VipCardPanel","",{"shopID":16});
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
