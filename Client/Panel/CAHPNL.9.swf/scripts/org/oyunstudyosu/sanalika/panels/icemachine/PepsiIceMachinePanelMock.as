package org.oyunstudyosu.sanalika.panels.icemachine
{
   import com.oyunstudyosu.enums.RequestDataKey;
   import com.oyunstudyosu.sanalika.mock.IExtensionMock;
   import com.smartfoxserver.v2.SmartFox;
   
   public class PepsiIceMachinePanelMock implements IExtensionMock
   {
       
      
      public function PepsiIceMachinePanelMock()
      {
         super();
      }
      
      public function requestData(param1:String, param2:Object) : Object
      {
         switch(param1)
         {
            case RequestDataKey.FURTUNE_WHEEL:
               return {"data":{"list":[{
                  "id":3,
                  "gifts":[{
                     "type":"SANIL",
                     "quantity":10
                  },{
                     "type":"SANIL",
                     "quantity":20
                  },{
                     "type":"SANIL",
                     "quantity":30
                  },{
                     "type":"SANIL",
                     "quantity":40
                  }]
               },{
                  "id":4,
                  "gifts":[{
                     "type":"DIAMOND",
                     "quantity":10
                  },{
                     "type":"DIAMOND",
                     "quantity":20
                  },{
                     "type":"DIAMOND",
                     "quantity":30
                  },{
                     "type":"DIAMOND",
                     "quantity":40
                  }]
               }]}};
            default:
               return null;
         }
      }
      
      public function getInitData() : Object
      {
         return null;
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
