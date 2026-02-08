package com.oyunstudyosu.yandex
{
   import com.oyunstudyosu.data.IDataRequest;
   import flash.events.Event;
   import flash.net.URLLoader;
   import flash.net.URLRequest;
   
   public class Translator
   {
       
      
      public var request:IDataRequest;
      
      public function Translator(param1:IDataRequest)
      {
         super();
         this.request = param1;
         var _loc2_:URLLoader = new URLLoader();
         var _loc3_:String = "trnsl.1.1.20150630T082226Z.d2f5d2d64eb6b42a.b56014ec8d5c8e1c754b92e6ad4ae0f311e0e210";
         _loc2_.addEventListener(Event.COMPLETE,this.onLoaded);
         _loc2_.load(new URLRequest("https://translate.yandex.net/api/v1.5/tr.json/translate?key=" + _loc3_ + "&lang=" + param1.data.fromLanguage + "-" + param1.data.toLanguage + "&text=" + param1.data.myText));
      }
      
      protected function onLoaded(param1:Event) : void
      {
         var _loc2_:URLLoader = param1.target as URLLoader;
         var _loc3_:Object = JSON.parse(_loc2_.data);
         this.request.data.trText = _loc3_.text;
         if(this.request.loadedFunction != null)
         {
            this.request.loadedFunction(this.request);
         }
      }
   }
}
