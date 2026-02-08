package org.oyunstudyosu.sanalika.panels.cellphone.apps.funwin
{
   import com.greensock.TweenMax;
   import com.oyunstudyosu.utils.STextField;
   import com.oyunstudyosu.utils.TextFieldManager;
   import flash.display.MovieClip;
   import flash.events.Event;
   import flash.events.MouseEvent;
   import flash.text.TextField;
   
   [Embed(source="/_assets/assets.swf", symbol="org.oyunstudyosu.sanalika.panels.cellphone.apps.funwin.FunwinItem")]
   public class FunwinItem extends MovieClip
   {
       
      
      public var txtTitle:TextField;
      
      private var sTxtTitle:STextField;
      
      private var sTxtAnswer:STextField;
      
      private var answerLength:int;
      
      public var answerContainer:MovieClip;
      
      public var bg:MovieClip;
      
      private var letterList:Array;
      
      public function FunwinItem()
      {
         this.letterList = ["A","B","C","D"];
         super();
         if(this.sTxtTitle == null)
         {
            this.sTxtTitle = TextFieldManager.convertAsArabicTextField(getChildByName("txtTitle") as TextField,true,false);
            this.sTxtTitle.wordWrap = true;
         }
      }
      
      public function init(param1:Object) : void
      {
         var _loc3_:MovieClip = null;
         this.sTxtTitle.text = param1.q;
         this.answerContainer.y = this.sTxtTitle.height + 4;
         this.answerLength = param1.o.length;
         while(this.answerContainer.numChildren > 0)
         {
            (this.answerContainer.getChildAt(0) as FunwinAnswer).dispose();
            this.answerContainer.removeChildAt(0);
         }
         var _loc2_:int = 0;
         while(_loc2_ < this.answerLength)
         {
            _loc3_ = new FunwinAnswer();
            _loc3_.name = "mcAns" + _loc2_;
            _loc3_.txtLetter.text = this.letterList[_loc2_] + ")";
            if(_loc2_ != 0)
            {
               _loc3_.y = this.answerContainer.getChildByName("mcAns" + (_loc2_ - 1)).y + this.answerContainer.getChildByName("mcAns" + (_loc2_ - 1)).height + 2;
            }
            _loc3_.answerID = _loc2_;
            _loc3_.questionID = param1.id;
            _loc3_.answer = param1.o[_loc2_];
            this.answerContainer.addChild(_loc3_);
            _loc3_.init();
            _loc2_++;
         }
      }
      
      public function showAnswer(param1:*) : void
      {
         var _loc3_:FunwinAnswer = null;
         var _loc4_:int = 0;
         var _loc2_:int = 0;
         while(_loc2_ < this.answerLength)
         {
            _loc3_ = this.answerContainer.getChildByName("mcAns" + _loc2_) as FunwinAnswer;
            _loc4_ = 18;
            _loc3_.bar.width = 0;
            if(param1.w > 0)
            {
               _loc4_ = param1.i[_loc2_] / param1.w * _loc3_.bg.width;
            }
            if(_loc2_ != param1.c)
            {
               TweenMax.to(_loc3_.bar,0,{"colorTransform":{
                  "tint":16711680,
                  "tintAmount":1
               }});
            }
            _loc3_.bar.visible = true;
            _loc3_.bar.height = _loc3_.bg.height;
            TweenMax.to(_loc3_.bar,1,{"width":_loc4_});
            _loc3_.txtCount.text = param1.i[_loc2_];
            _loc2_++;
         }
      }
      
      public function stopEvents() : void
      {
         var _loc2_:FunwinAnswer = null;
         var _loc1_:int = 0;
         while(_loc1_ < this.answerLength)
         {
            _loc2_ = this.answerContainer.getChildByName("mcAns" + _loc1_) as FunwinAnswer;
            _loc2_.removeListeners();
            _loc1_++;
         }
      }
      
      private function trueClicked(param1:MouseEvent) : void
      {
         dispatchEvent(new Event("next"));
      }
      
      public function dispose() : void
      {
         while(this.answerContainer.numChildren > 0)
         {
            (this.answerContainer.getChildAt(0) as FunwinAnswer).dispose();
         }
      }
   }
}
