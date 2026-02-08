package org.oyunstudyosu.sanalika.panels.saleProduct
{
   import com.oyunstudyosu.panel.PanelVO;
   import com.oyunstudyosu.sanalika.mock.IExtensionMock;
   
   public class SaleProductPanelMock implements IExtensionMock
   {
       
      
      public function SaleProductPanelMock()
      {
         super();
      }
      
      public function requestData(param1:String, param2:Object) : Object
      {
         switch(param1)
         {
            case "saleproductlist":
               return {"data":{
                  "msisdn":"54x-xxx-xx-80",
                  "booth":"VALENTINE",
                  "products":[{
                     "id":517,
                     "title":"50 Sanil",
                     "booth":"VALENTINE",
                     "description":"50 Diamond Paketi",
                     "type":"SANIL",
                     "baseCurrency":"SANIL",
                     "imgUrl":"50D",
                     "baseAmount":50,
                     "baseSalePrice":4.9,
                     "baseSaleCurrency":"TRY",
                     "giftAmount":0,
                     "method":{
                        "salePrice":4.9,
                        "keyword":"paybyme",
                        "amount":55,
                        "saleCurrency":"TRY"
                     }
                  },{
                     "id":753,
                     "title":"110 DİAMOND",
                     "booth":"DIAMOND",
                     "description":"10 Numara Bir Gün Özel Avantajlı Paket!",
                     "type":"DIAMOND",
                     "baseCurrency":"DIAMOND",
                     "imgUrl":"a93cee82-fb71-82c4-d7af-1204a896130c",
                     "baseAmount":110,
                     "baseSalePrice":8,
                     "baseSaleCurrency":"TRY",
                     "giftAmount":0,
                     "method":{
                        "salePrice":8,
                        "keyword":"paybyme",
                        "amount":110,
                        "saleCurrency":"TRY"
                     }
                  },{
                     "id":518,
                     "title":"200 Diamond",
                     "booth":"DIAMOND",
                     "description":"200 Diamond Paketi",
                     "type":"DIAMOND",
                     "baseCurrency":"DIAMOND",
                     "imgUrl":"200D",
                     "baseAmount":20,
                     "baseSalePrice":14.9,
                     "baseSaleCurrency":"TRY",
                     "giftAmount":0,
                     "method":{
                        "salePrice":14.9,
                        "keyword":"paybyme",
                        "amount":200,
                        "saleCurrency":"TRY"
                     }
                  },{
                     "id":767,
                     "title":"350 Diamond",
                     "booth":"DIAMOND",
                     "description":"Bayramlık 350 Diamond Sanalika oyun parası",
                     "type":"DIAMOND",
                     "baseCurrency":"DIAMOND",
                     "imgUrl":"d54f788e-6f2c-1113-3af5-b42f7a5f3735",
                     "baseAmount":350,
                     "baseSalePrice":23.9,
                     "baseSaleCurrency":"TRY",
                     "giftAmount":0,
                     "method":{
                        "salePrice":23.9,
                        "keyword":"paybyme",
                        "amount":350,
                        "saleCurrency":"TRY"
                     }
                  },{
                     "id":597,
                     "title":"500 Diamond",
                     "booth":"DIAMOND",
                     "description":"500 Diamond Paketi",
                     "type":"PRODUCT",
                     "baseCurrency":"DIAMOND",
                     "imgUrl":"500D",
                     "baseAmount":500,
                     "baseSalePrice":29.9,
                     "baseSaleCurrency":"TRY",
                     "giftAmount":0,
                     "method":{
                        "salePrice":29.9,
                        "keyword":"paybyme",
                        "amount":550,
                        "saleCurrency":"TRY"
                     }
                  },{
                     "id":768,
                     "title":"750 Diamond",
                     "booth":"DIAMOND",
                     "description":"Bayramlık 750 Diamond Sanalika oyun parası",
                     "type":"DIAMOND",
                     "baseCurrency":"DIAMOND",
                     "imgUrl":"e36d0351-b1c8-f7a1-08af-e2818d992545",
                     "baseAmount":750,
                     "baseSalePrice":39.9,
                     "baseSaleCurrency":"TRY",
                     "giftAmount":0,
                     "method":{
                        "salePrice":39.9,
                        "keyword":"paybyme",
                        "amount":750,
                        "saleCurrency":"TRY"
                     }
                  },{
                     "id":596,
                     "title":"1.000 Diamond",
                     "booth":"DIAMOND",
                     "description":"1000 Diamond Paketi",
                     "type":"DIAMOND",
                     "baseCurrency":"DIAMOND",
                     "imgUrl":"1000D",
                     "baseAmount":1000,
                     "baseSalePrice":49.9,
                     "baseSaleCurrency":"TRY",
                     "giftAmount":0,
                     "method":{
                        "salePrice":49.9,
                        "keyword":"paybyme",
                        "amount":1000,
                        "saleCurrency":"TRY"
                     }
                  },{
                     "id":769,
                     "title":"2.000 Diamond",
                     "booth":"DIAMOND",
                     "description":"Bayramlık 2.000 Diamond Sanalika oyun parası",
                     "type":"DIAMOND",
                     "baseCurrency":"DIAMOND",
                     "imgUrl":"7ed15603-2eb4-5a56-a166-3d13b2f54e7e",
                     "baseAmount":2000,
                     "baseSalePrice":84.9,
                     "baseSaleCurrency":"TRY",
                     "giftAmount":0,
                     "method":{
                        "salePrice":84.9,
                        "keyword":"paybyme",
                        "amount":2000,
                        "saleCurrency":"TRY"
                     }
                  }]
               }};
            case "report":
               return {"data":{}};
            default:
               return null;
         }
      }
      
      public function getInitData() : Object
      {
         return new PanelVO("SaleProductPanel","",{});
      }
      
      public function dispatchExtension(param1:uint) : Object
      {
         return null;
      }
   }
}
