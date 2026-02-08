package org.oyunstudyosu.sanalika.panels.barter
{
   import com.oyunstudyosu.enums.RequestDataKey;
   import com.oyunstudyosu.panel.PanelVO;
   import com.oyunstudyosu.sanalika.mock.IExtensionMock;
   import com.smartfoxserver.v2.SmartFox;
   import flash.ui.Keyboard;
   
   public class BarterPanelMock implements IExtensionMock
   {
       
      
      private var arr:Array;
      
      public function BarterPanelMock()
      {
         super();
      }
      
      public function requestData(param1:String, param2:Object) : Object
      {
         if(param1 == "barterlist")
         {
            return {"data":{"items":[{
               "clip":"bp",
               "ids":[635,634,633,632]
            },{
               "clip":"kf",
               "ids":[636]
            },{
               "clip":"k6",
               "ids":[639]
            },{
               "clip":"0010",
               "ids":[100]
            },{
               "clip":"0778",
               "ids":[101]
            },{
               "clip":"1038",
               "ids":[102]
            },{
               "clip":"0901",
               "ids":[103]
            },{
               "clip":"0915",
               "ids":[104,105]
            },{
               "clip":"0916",
               "ids":[106]
            },{
               "clip":"0902",
               "ids":[107]
            },{
               "clip":"0956",
               "ids":[108,5634,4534]
            },{
               "clip":"0957",
               "ids":[109]
            },{
               "clip":"0958",
               "ids":[110]
            },{
               "clip":"0959",
               "ids":[111,112,113,114,115,116]
            },{
               "clip":"0868",
               "ids":[108]
            }]}};
         }
         return null;
      }
      
      public function getInitData() : Object
      {
         return new PanelVO("BarterPanel","",{"avatarID":1043});
      }
      
      public function getExtensionResponse(param1:uint, param2:SmartFox) : void
      {
      }
      
      public function dispatchExtension(param1:uint) : Object
      {
         var _loc2_:Object = {};
         _loc2_.params = {};
         switch(param1)
         {
            case Keyboard.NUMBER_1:
               _loc2_.key = RequestDataKey.BARTER_UPDATED;
               this.arr = [{
                  "clip":"1038",
                  "quantity":2
               },{
                  "clip":"0915",
                  "quantity":1
               },{
                  "clip":"0901",
                  "quantity":3
               },{
                  "clip":"0010",
                  "quantity":3
               }];
               _loc2_.params.offerList = this.arr;
               return _loc2_;
            case Keyboard.NUMBER_2:
               _loc2_.key = RequestDataKey.BARTER_UPDATED;
               this.arr = [{
                  "clip":"1038",
                  "quantity":2
               },{
                  "clip":"0915",
                  "quantity":3
               }];
               _loc2_.params.offerList = this.arr;
               return _loc2_;
            default:
               return null;
         }
      }
   }
}
