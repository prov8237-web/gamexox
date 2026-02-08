package org.oyunstudyosu.sanalika.panels.roomshop
{
   import com.oyunstudyosu.panel.PanelVO;
   import com.oyunstudyosu.sanalika.mock.IExtensionMock;
   import com.smartfoxserver.v2.SmartFox;
   
   public class RoomShopPanelMock implements IExtensionMock
   {
       
      
      public function RoomShopPanelMock()
      {
         super();
      }
      
      public function requestData(param1:String, param2:Object) : Object
      {
         switch(param1)
         {
            case "shopproductlist":
               return {"data":{"shopProductList":{
                  "CAFE":[{
                     "id":11437,
                     "productID":9816,
                     "price":750,
                     "discount":0,
                     "currency":"DIAMOND",
                     "lifetime":0,
                     "countDownType":"IMMORTAL",
                     "priority":0,
                     "clip":"36_flat_3",
                     "roles":"AA==",
                     "subType":"CAFE",
                     "type":"FLAT",
                     "publishDate":"04-08-2016",
                     "furnLocations":[2,4],
                     "furnLocation":0,
                     "property":""
                  },{
                     "id":6149,
                     "productID":8733,
                     "price":4000,
                     "discount":70,
                     "currency":"SANIL",
                     "lifetime":0,
                     "countDownType":"IMMORTAL",
                     "priority":100,
                     "clip":"6_flat_3",
                     "roles":"AA==",
                     "subType":"CAFE",
                     "type":"FLAT",
                     "publishDate":"11-06-2015",
                     "furnLocations":[2,4],
                     "furnLocation":0,
                     "property":""
                  },{
                     "id":6152,
                     "productID":8707,
                     "price":7000,
                     "discount":70,
                     "currency":"SANIL",
                     "lifetime":0,
                     "countDownType":"IMMORTAL",
                     "priority":100,
                     "clip":"20_flat_3",
                     "roles":"AA==",
                     "subType":"CAFE",
                     "type":"FLAT",
                     "publishDate":"11-06-2015",
                     "furnLocations":[2,4],
                     "furnLocation":0,
                     "property":""
                  },{
                     "id":6153,
                     "productID":8699,
                     "price":500,
                     "discount":70,
                     "currency":"DIAMOND",
                     "lifetime":0,
                     "countDownType":"IMMORTAL",
                     "priority":100,
                     "clip":"23_flat_11",
                     "roles":"",
                     "subType":"CAFE",
                     "type":"FLAT",
                     "publishDate":"11-06-2015",
                     "furnLocations":[1,4],
                     "furnLocation":0
                  },{
                     "id":6154,
                     "productID":8734,
                     "price":270,
                     "discount":70,
                     "currency":"DIAMOND",
                     "lifetime":0,
                     "countDownType":"IMMORTAL",
                     "priority":100,
                     "clip":"21_flat_3",
                     "roles":"AA==",
                     "subType":"CAFE",
                     "type":"FLAT",
                     "publishDate":"11-06-2015",
                     "furnLocations":[1,2,4],
                     "furnLocation":0,
                     "property":""
                  },{
                     "id":6155,
                     "productID":9251,
                     "price":500,
                     "discount":70,
                     "currency":"DIAMOND",
                     "lifetime":0,
                     "countDownType":"IMMORTAL",
                     "priority":100,
                     "clip":"25_flat_3",
                     "roles":"AA==",
                     "subType":"CAFE",
                     "type":"FLAT",
                     "publishDate":"11-06-2015",
                     "furnLocations":[64,4,128],
                     "furnLocation":0,
                     "property":""
                  },{
                     "id":6629,
                     "productID":8696,
                     "price":4000,
                     "discount":70,
                     "currency":"SANIL",
                     "lifetime":0,
                     "countDownType":"IMMORTAL",
                     "priority":100,
                     "clip":"3_flat_3",
                     "roles":"AA==",
                     "subType":"CAFE",
                     "type":"FLAT",
                     "publishDate":"25-06-2015",
                     "furnLocations":[2,4],
                     "furnLocation":0
                  }],
                  "LAND":[{
                     "id":11435,
                     "productID":9253,
                     "price":104,
                     "discount":0,
                     "currency":"DIAMOND",
                     "lifetime":0,
                     "countDownType":"IMMORTAL",
                     "priority":0,
                     "clip":"29_flat_14",
                     "roles":"AA==",
                     "subType":"LAND",
                     "type":"FLAT",
                     "publishDate":"29-06-2016",
                     "furnLocations":[1024,2],
                     "furnLocation":0,
                     "property":""
                  },{
                     "id":11436,
                     "productID":9254,
                     "price":100,
                     "discount":0,
                     "currency":"DIAMOND",
                     "lifetime":0,
                     "countDownType":"IMMORTAL",
                     "priority":0,
                     "clip":"30_flat_14",
                     "roles":"AA==",
                     "subType":"LAND",
                     "type":"FLAT",
                     "publishDate":"29-06-2016",
                     "furnLocations":[1024],
                     "furnLocation":0,
                     "property":""
                  }]
               }}};
            default:
               return null;
         }
      }
      
      public function getInitData() : Object
      {
         return new PanelVO("RoomShop","",{
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
