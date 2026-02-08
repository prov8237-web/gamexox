package org.oyunstudyosu.sanalika.panels.cellphone.apps.funwin
{
   import com.greensock.TweenMax;
   import com.oyunstudyosu.events.Dispatcher;
   import com.oyunstudyosu.events.FunwinEvent;
   import com.oyunstudyosu.utils.STextField;
   import com.oyunstudyosu.utils.TextFieldManager;
   import flash.display.MovieClip;
   import flash.events.MouseEvent;
   import flash.text.TextField;
   
   [Embed(source="/_assets/assets.swf", symbol="org.oyunstudyosu.sanalika.panels.cellphone.apps.funwin.FunwinAnswer")]
   public class FunwinAnswer extends MovieClip
   {
       
      
      public var answerID:int;
      
      public var answer:String;
      
      public var questionID:int;
      
      public var bg:MovieClip;
      
      public var txt:TextField;
      
      public var sTxt:STextField;
      
      public var bar:MovieClip;
      
      public var selected:Boolean = false;
      
      public var txtCount:TextField;
      
      public var txtLetter:TextField;
      
      public function FunwinAnswer()
      {
         super();
      }
      
      public function init() : void
      {
         this.addEventListener(MouseEvent.CLICK,this.answerClicked);
         this.addEventListener(MouseEvent.MOUSE_OVER,this.overHandler);
         this.addEventListener(MouseEvent.MOUSE_OUT,this.outHandler);
         if(this.sTxt == null)
         {
            this.sTxt = TextFieldManager.convertAsArabicTextField(getChildByName("txt") as TextField,true,true);
         }
         this.buttonMode = true;
         this.sTxt.text = this.answer;
         this.sTxt.y = 2;
         this.bg.height = this.sTxt.height + 2;
         this.bar.visible = false;
      }
      
      private function overHandler(param1:MouseEvent) : void
      {
         TweenMax.to(this.bg,0.3,{"colorTransform":{
            "tint":15684432,
            "tintAmount":1
         }});
      }
      
      private function outHandler(param1:MouseEvent) : void
      {
         TweenMax.to(this.bg,0.5,{"colorTransform":{
            "tint":15684432,
            "tintAmount":0
         }});
      }
      
      public function answerClicked(param1:MouseEvent) : void
      {
         this.selected = true;
         TweenMax.to(this.bg,0.3,{"colorTransform":{
            "tint":2201331,
            "tintAmount":1
         }});
         var _loc2_:FunwinEvent = new FunwinEvent(FunwinEvent.ANSWER);
         _loc2_.id = this.questionID;
         _loc2_.a = this.answerID;
         Dispatcher.dispatchEvent(_loc2_);
      }
      
      public function savedAnswer() : void
      {
         TweenMax.to(this.bg,0,{"colorTransform":{
            "tint":16752162,
            "tintAmount":1
         }});
      }
      
      public function removeListeners() : void
      {
         if(!this.selected)
         {
            TweenMax.to(this.bg,0,{"colorTransform":{"tintAmount":0}});
         }
         this.buttonMode = false;
         this.removeEventListener(MouseEvent.MOUSE_OVER,this.overHandler);
         this.removeEventListener(MouseEvent.MOUSE_OUT,this.outHandler);
         this.removeEventListener(MouseEvent.CLICK,this.answerClicked);
      }
      
      public function dispose() : void
      {
         this.removeListeners();
         this.sTxt = null;
         this.parent.removeChild(this);
      }
   }
}
