package org.oyunstudyosu.sanalika.panels.report
{
   import com.oyunstudyosu.panel.PanelVO;
   import com.oyunstudyosu.sanalika.mock.IExtensionMock;
   import com.smartfoxserver.v2.SmartFox;
   
   public class ReportPanelMock implements IExtensionMock
   {
       
      
      public function ReportPanelMock()
      {
         super();
      }
      
      public function requestData(param1:String, param2:Object) : Object
      {
         switch(param1)
         {
            case "preReport":
               return {"data":{
                  "res":"OK",
                  "rid":1234
               }};
            case "report":
               return {"data":{}};
            default:
               return null;
         }
      }
      
      public function getInitData() : Object
      {
         return new PanelVO("ReportPanel","",{
            "targetNick":"nick",
            "lastMessage":""
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
