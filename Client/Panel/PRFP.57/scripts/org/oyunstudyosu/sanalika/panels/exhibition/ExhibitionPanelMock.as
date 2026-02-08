package org.oyunstudyosu.sanalika.panels.exhibition
{
   import com.oyunstudyosu.panel.PanelVO;
   import com.oyunstudyosu.sanalika.mock.IExtensionMock;
   import com.smartfoxserver.v2.SmartFox;
   import flash.ui.Keyboard;
   
   public class ExhibitionPanelMock implements IExtensionMock
   {
       
      
      public function ExhibitionPanelMock()
      {
         super();
      }
      
      public function requestData(param1:String, param2:Object) : Object
      {
         if(param1 == "pubContentList")
         {
            return {"data":{
               "id":7,
               "title":"Sayı 1",
               "metaType":"JOURNAL",
               "details":[{
                  "id":117,
                  "assetUrl":"EXHIBITION_11_4344604.png",
                  "description":"Sanalika sanatçılarından ll_Monter_ll\'ın cadde tasarımı...",
                  "title":"Sanalika Cadde Çizimi",
                  "avatarID":0,
                  "version":1,
                  "likeCount":10,
                  "dislikeCount":2,
                  "priority":1
               },{
                  "id":118,
                  "assetUrl":"EXHIBITION_11_4344612.png",
                  "description":"Sanalika sanatçılarından __dreamy__\'a ait Sanalika temalı çalışma..",
                  "title":"Sanalika",
                  "avatarID":0,
                  "version":1,
                  "likeCount":11,
                  "dislikeCount":1,
                  "priority":2
               },{
                  "id":119,
                  "assetUrl":"EXHIBITION_11_4344980.png",
                  "description":"Sanalika sanatçılarından tracooo\'ya ait \"Sanalika Eğlenceye Katıl!\" Sloganlı serbest temalı çalışma...",
                  "title":"Sanalika Eğlenceye Katıl",
                  "avatarID":0,
                  "version":1,
                  "likeCount":12,
                  "dislikeCount":0,
                  "priority":3
               },{
                  "id":120,
                  "assetUrl":"EXHIBITION_11_4345211.png",
                  "description":"Sanalika sanatçılarından illuzyonist\'in haz��rladığı Profesör Nikel çizimi!",
                  "title":"Profesör Nikel Çizimi",
                  "avatarID":0,
                  "version":1,
                  "likeCount":13,
                  "dislikeCount":1,
                  "priority":4
               }]
            }};
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
