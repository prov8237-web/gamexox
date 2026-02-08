package org.oyunstudyosu.sanalika.panels.smiley
{
   import com.oyunstudyosu.panel.PanelVO;
   import com.oyunstudyosu.sanalika.mock.IExtensionMock;
   import com.smartfoxserver.v2.SmartFox;
   import flash.ui.Keyboard;
   
   public class SmileyPanelMock implements IExtensionMock
   {
       
      
      public function SmileyPanelMock()
      {
         super();
      }
      
      public function requestData(param1:String, param2:Object) : Object
      {
         if(param1 == "smileylist")
         {
            return {"data":{"smilies":[{
               "id":17,
               "metaKey":"gumus-yildiz",
               "requirements":"gA==",
               "sorting":22
            },{
               "id":23,
               "metaKey":"kagit",
               "requirements":"AA==",
               "sorting":81
            },{
               "id":33,
               "metaKey":"melek",
               "requirements":"AA==",
               "sorting":35
            },{
               "id":104,
               "metaKey":"nota",
               "requirements":"AA==",
               "sorting":80
            },{
               "id":4,
               "metaKey":"alayci",
               "requirements":"AA==",
               "sorting":5
            },{
               "id":11,
               "metaKey":"canak-anten",
               "requirements":"AA==",
               "sorting":34
            },{
               "id":18,
               "metaKey":"gunes",
               "requirements":"AA==",
               "sorting":39
            },{
               "id":114,
               "metaKey":"zaa",
               "requirements":"AA==",
               "sorting":50
            },{
               "id":27,
               "metaKey":"kirik-kalp",
               "requirements":"AA==",
               "sorting":30
            },{
               "id":34,
               "metaKey":"mutsuz",
               "requirements":"AA==",
               "sorting":11
            },{
               "id":32,
               "metaKey":"makas",
               "requirements":"AA==",
               "sorting":82
            },{
               "id":2,
               "metaKey":"aglayan",
               "requirements":"AA==",
               "sorting":10
            },{
               "id":48,
               "metaKey":"vip",
               "requirements":"CA==",
               "sorting":24
            },{
               "id":38,
               "metaKey":"peri",
               "requirements":"AA==",
               "sorting":41
            },{
               "id":21,
               "metaKey":"huzurlu",
               "requirements":"AA==",
               "sorting":6
            },{
               "id":95,
               "metaKey":"darbuka",
               "requirements":"AA==",
               "sorting":80
            },{
               "id":103,
               "metaKey":"gitar",
               "requirements":"AA==",
               "sorting":80
            },{
               "id":14,
               "metaKey":"flirty",
               "requirements":"AA==",
               "sorting":8
            },{
               "id":7,
               "metaKey":"balik",
               "requirements":"AA==",
               "sorting":32
            },{
               "id":87,
               "metaKey":"diamond",
               "requirements":"QA==",
               "sorting":23
            },{
               "id":61,
               "metaKey":"empty",
               "requirements":"AA==",
               "sorting":0
            },{
               "id":39,
               "metaKey":"sabit",
               "requirements":"AA==",
               "sorting":15
            },{
               "id":52,
               "metaKey":"yonca",
               "requirements":"AA==",
               "sorting":16
            },{
               "id":41,
               "metaKey":"sapka",
               "requirements":"AA==",
               "sorting":38
            },{
               "id":111,
               "metaKey":"ressamlik",
               "requirements":"AABA",
               "sorting":25
            },{
               "id":36,
               "metaKey":"olu",
               "requirements":"AA==",
               "sorting":12
            },{
               "id":19,
               "metaKey":"hasta",
               "requirements":"AA==",
               "sorting":13
            },{
               "id":117,
               "metaKey":"lol",
               "requirements":"AA==",
               "sorting":5
            },{
               "id":42,
               "metaKey":"saskin",
               "requirements":"AA==",
               "sorting":13
            },{
               "id":12,
               "metaKey":"cool",
               "requirements":"AA==",
               "sorting":9
            },{
               "id":37,
               "metaKey":"on-milyon",
               "requirements":"AA==",
               "sorting":65
            },{
               "id":26,
               "metaKey":"kalp",
               "requirements":"AA==",
               "sorting":29
            },{
               "id":13,
               "metaKey":"firtina",
               "requirements":"AA==",
               "sorting":37
            },{
               "id":31,
               "metaKey":"kurukafa",
               "requirements":"CA==",
               "sorting":31
            },{
               "id":40,
               "metaKey":"sanil",
               "requirements":"CA==",
               "sorting":24
            },{
               "id":16,
               "metaKey":"gergin",
               "requirements":"AA==",
               "sorting":7
            },{
               "id":24,
               "metaKey":"kahraman",
               "requirements":"AA==",
               "sorting":13
            },{
               "id":91,
               "metaKey":"diamond1",
               "requirements":"ACA=",
               "sorting":24
            },{
               "id":25,
               "metaKey":"kahve",
               "requirements":"AA==",
               "sorting":25
            },{
               "id":116,
               "metaKey":"mutlu",
               "requirements":"AA==",
               "sorting":5
            },{
               "id":53,
               "metaKey":"yonetmen",
               "requirements":"AAAE",
               "sorting":27
            },{
               "id":46,
               "metaKey":"titanica",
               "requirements":"AA==",
               "sorting":66
            },{
               "id":5,
               "metaKey":"altin-yildiz",
               "requirements":"EA==",
               "sorting":21
            },{
               "id":49,
               "metaKey":"yarasa",
               "requirements":"AA==",
               "sorting":40
            },{
               "id":20,
               "metaKey":"hediye-paketi",
               "requirements":"AA==",
               "sorting":33
            },{
               "id":44,
               "metaKey":"tas",
               "requirements":"AA==",
               "sorting":83
            },{
               "id":47,
               "metaKey":"uyku",
               "requirements":"AA==",
               "sorting":28
            },{
               "id":15,
               "metaKey":"gazete",
               "requirements":"AAAC",
               "sorting":26
            }]}};
         }
         if(param1 == "change.smiley")
         {
            if(param2.key == "")
            {
               return null;
            }
            if(param2.key == "mutlu")
            {
               return {"data":{"errorKey":"mustBeVip"}};
            }
            return {"data":{}};
         }
         return null;
      }
      
      public function getInitData() : Object
      {
         return new PanelVO();
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
               _loc2_.key = "test";
               _loc2_.params.test = 1;
               return _loc2_;
            default:
               return null;
         }
      }
   }
}
