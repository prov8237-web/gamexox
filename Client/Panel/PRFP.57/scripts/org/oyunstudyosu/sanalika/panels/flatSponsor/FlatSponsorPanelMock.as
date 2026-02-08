package org.oyunstudyosu.sanalika.panels.flatSponsor
{
   import com.oyunstudyosu.enums.RequestDataKey;
   import com.oyunstudyosu.sanalika.mock.IExtensionMock;
   import com.smartfoxserver.v2.SmartFox;
   
   public class FlatSponsorPanelMock implements IExtensionMock
   {
       
      
      public function FlatSponsorPanelMock()
      {
         super();
      }
      
      public function requestData(param1:String, param2:Object) : Object
      {
         switch(param1)
         {
            case RequestDataKey.FLAT_SPONSOR:
               trace(param2.type);
               if(param2.type == "list")
               {
                  return {"data":{
                     "price":3,
                     "quantity":5,
                     "flatList":[{
                        "id":1,
                        "title":"title A"
                     },{
                        "id":2,
                        "title":"title B"
                     },{
                        "id":2,
                        "title":"title B"
                     },{
                        "id":2,
                        "title":"title B"
                     },{
                        "id":2,
                        "title":"title B"
                     },{
                        "id":2,
                        "title":"title B"
                     },{
                        "id":2,
                        "title":"title B"
                     },{
                        "id":2,
                        "title":"title B"
                     },{
                        "id":2,
                        "title":"title B"
                     },{
                        "id":2,
                        "title":"title B"
                     }]
                  }};
               }
               break;
         }
         return null;
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
