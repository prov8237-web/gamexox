package org.oyunstudyosu.sanalika.panels.newspaper
{
   import com.oyunstudyosu.panel.PanelVO;
   import com.oyunstudyosu.sanalika.mock.IExtensionMock;
   import com.smartfoxserver.v2.SmartFox;
   import flash.ui.Keyboard;
   
   public class NewspaperPanelMock implements IExtensionMock
   {
       
      
      public function NewspaperPanelMock()
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
                  "id":32,
                  "assetUrl":"JOURNAL_7_2022773.png",
                  "description":"SANALİKA\'DA NEVAR? YENİDEN SİZLERLE!",
                  "title":"SANALİKA\'DA NEVAR? YENİDEN SİZLERLE!",
                  "avatarID":100510590,
                  "version":1,
                  "likes":0,
                  "dislikes":0,
                  "priority":1
               },{
                  "id":21,
                  "assetUrl":"JOURNAL_7_1999674.png",
                  "description":"OLİMPOS\'TAN GÜZEL BİR GÜN!",
                  "title":"OLİMPOS\'TAN GÜZEL BİR GÜN!",
                  "avatarID":100327412,
                  "version":1,
                  "likes":0,
                  "dislikes":0,
                  "priority":2
               },{
                  "id":22,
                  "assetUrl":"JOURNAL_7_1999695.png",
                  "description":"SANALİKA\'DA NEVAR? GERİ DÖNÜYOR!",
                  "title":"SANALİKA\'DA NEVAR? GERİ DÖNÜYOR!",
                  "avatarID":100325966,
                  "version":1,
                  "likes":0,
                  "dislikes":0,
                  "priority":3
               },{
                  "id":23,
                  "assetUrl":"JOURNAL_7_1999714.png",
                  "description":"YEPYENİ HAYVAN MASKELERİ!",
                  "title":"YEPYENİ HAYVAN MASKELERİ!",
                  "avatarID":100340849,
                  "version":1,
                  "likes":0,
                  "dislikes":0,
                  "priority":4
               },{
                  "id":24,
                  "assetUrl":"JOURNAL_7_1999738.png",
                  "description":"SANALİKA İŞLETMELERİ",
                  "title":"SANALİKA İŞLETMELERİ",
                  "avatarID":100737735,
                  "version":1,
                  "likes":0,
                  "dislikes":0,
                  "priority":5
               },{
                  "id":25,
                  "assetUrl":"JOURNAL_7_1999930.png",
                  "description":"SANALİKA YENİLİKLERİ",
                  "title":"SANALİKA YENİLİKLERİ",
                  "avatarID":100334570,
                  "version":1,
                  "likes":0,
                  "dislikes":0,
                  "priority":6
               },{
                  "id":27,
                  "assetUrl":"JOURNAL_7_2000010.png",
                  "description":"SANALİKA\'DA BİR İLK!",
                  "title":"SANALİKA\'DA BİR İLK!",
                  "avatarID":100514899,
                  "version":1,
                  "likes":0,
                  "dislikes":0,
                  "priority":7
               },{
                  "id":28,
                  "assetUrl":"JOURNAL_7_2000059.png",
                  "description":"SANALİKA\'DA NELER OLUYOR?",
                  "title":"SANALİKA\'DA NELER OLUYOR?",
                  "avatarID":100327155,
                  "version":1,
                  "likes":0,
                  "dislikes":0,
                  "priority":8
               },{
                  "id":29,
                  "assetUrl":"JOURNAL_7_2000077.png",
                  "description":"SANALİKA\'DA NELER OLUYOR?",
                  "title":"SANALİKA\'DA NELER OLUYOR?",
                  "avatarID":100327155,
                  "version":1,
                  "likes":0,
                  "dislikes":0,
                  "priority":9
               },{
                  "id":30,
                  "assetUrl":"JOURNAL_7_2003828.png",
                  "description":"HAYVAN MASKELERİ SANALİKA\'DA!",
                  "title":"HAYVAN MASKELERİ SANALİKA\'DA!",
                  "avatarID":100326537,
                  "version":1,
                  "likes":0,
                  "dislikes":0,
                  "priority":10
               },{
                  "id":31,
                  "assetUrl":"JOURNAL_7_2004989.png",
                  "description":"TATİL EĞLENCESİ Mİ DEDİN?",
                  "title":"TATİL EĞLENCESİ Mİ DEDİN?",
                  "avatarID":100347915,
                  "version":1,
                  "likes":0,
                  "dislikes":0,
                  "priority":11
               },{
                  "id":33,
                  "assetUrl":"JOURNAL_7_2068026.png",
                  "description":"",
                  "title":"SANALİKA\'DA NEVAR?",
                  "avatarID":100444377,
                  "version":1,
                  "likes":0,
                  "dislikes":0,
                  "priority":12
               },{
                  "id":34,
                  "assetUrl":"JOURNAL_7_2068067.png",
                  "description":"",
                  "title":"BİRİ EĞLENCE Mİ DEDİ?",
                  "avatarID":100326652,
                  "version":1,
                  "likes":0,
                  "dislikes":0,
                  "priority":13
               },{
                  "id":35,
                  "assetUrl":"JOURNAL_7_2068128.png",
                  "description":"",
                  "title":"SANALİKA\'DA EĞLENCE BİTMİYOR!",
                  "avatarID":101054267,
                  "version":1,
                  "likes":0,
                  "dislikes":0,
                  "priority":13
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
