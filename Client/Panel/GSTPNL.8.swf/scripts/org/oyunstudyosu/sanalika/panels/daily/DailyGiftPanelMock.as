package org.oyunstudyosu.sanalika.panels.daily
{
   import com.oyunstudyosu.sanalika.mock.IExtensionMock;
   
   public class DailyGiftPanelMock implements IExtensionMock
   {
       
      
      public function DailyGiftPanelMock()
      {
         super();
      }
      
      public function requestData(param1:String, param2:Object) : Object
      {
         if(param1 == "dailyGiftList")
         {
            return {"data":{"campaigns":[{
               "id":1,
               "day":1,
               "gifts":[{
                  "quantity":1000,
                  "type":"SANIL",
                  "order":1
               },{
                  "quantity":1500,
                  "type":"SANIL",
                  "order":2
               },{
                  "quantity":2000,
                  "type":"SANIL",
                  "order":3
               },{
                  "quantity":500,
                  "type":"DIAMOND",
                  "order":4
               }]
            }]}};
         }
         return null;
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
