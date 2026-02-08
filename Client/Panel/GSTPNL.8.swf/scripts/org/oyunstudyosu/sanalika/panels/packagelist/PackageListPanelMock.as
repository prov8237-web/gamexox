package org.oyunstudyosu.sanalika.panels.packagelist
{
   import com.oyunstudyosu.enums.RequestDataKey;
   import com.oyunstudyosu.panel.PanelVO;
   import com.oyunstudyosu.sanalika.mock.IExtensionMock;
   
   public class PackageListPanelMock implements IExtensionMock
   {
       
      
      public function PackageListPanelMock()
      {
         super();
      }
      
      public function requestData(param1:String, param2:Object) : Object
      {
         if(param1 == RequestDataKey.OPEN_PACKAGE)
         {
            return {
               "result":"package opening succesful",
               "packagelist":[{
                  "color":3,
                  "clip":"1",
                  "productType":"CLOTH",
                  "quantity":3
               },{
                  "color":0,
                  "clip":"2",
                  "productType":"HAND",
                  "quantity":3
               },{
                  "color":0,
                  "clip":"3",
                  "productType":"OBJECT",
                  "quantity":2
               }]
            };
         }
         return null;
      }
      
      public function getInitData() : Object
      {
         return new PanelVO("BarterPanel","",{
            "command":"show",
            "packageData":{
               "result":"package opening succesful",
               "items":[{
                  "color":9,
                  "clip":"13",
                  "productType":"CLOTH",
                  "quantity":3
               },{
                  "color":0,
                  "clip":"0JJxWYIx",
                  "productType":"HAND",
                  "quantity":3
               },{
                  "color":0,
                  "clip":"c_2",
                  "productType":"OBJECT",
                  "quantity":2
               },{
                  "color":7,
                  "clip":"17",
                  "productType":"CLOTH",
                  "quantity":3
               },{
                  "color":0,
                  "clip":"1CdKVD5n",
                  "productType":"HAND",
                  "quantity":3
               },{
                  "color":0,
                  "clip":"cf_a5",
                  "productType":"OBJECT",
                  "quantity":2
               },{
                  "color":2,
                  "clip":"18",
                  "productType":"CLOTH",
                  "quantity":3
               },{
                  "color":0,
                  "clip":"1kRPu7Pn",
                  "productType":"HAND",
                  "quantity":3
               },{
                  "color":0,
                  "clip":"cf_a5",
                  "productType":"OBJECT",
                  "quantity":2
               },{
                  "color":2,
                  "clip":"18",
                  "productType":"CLOTH",
                  "quantity":3
               },{
                  "color":0,
                  "clip":"1kRPu7Pn",
                  "productType":"HAND",
                  "quantity":3
               }]
            }
         });
      }
      
      public function dispatchExtension(param1:uint) : Object
      {
         return null;
      }
   }
}
