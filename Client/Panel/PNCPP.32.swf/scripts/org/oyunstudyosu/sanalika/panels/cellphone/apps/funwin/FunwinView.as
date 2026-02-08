package org.oyunstudyosu.sanalika.panels.cellphone.apps.funwin
{
   import com.greensock.TweenMax;
   import com.greensock.easing.Quad;
   import com.oyunstudyosu.enums.RequestDataKey;
   import com.oyunstudyosu.events.Dispatcher;
   import com.oyunstudyosu.events.FunwinEvent;
   import com.oyunstudyosu.events.HudEvent;
   import com.oyunstudyosu.local.$;
   import com.oyunstudyosu.sanalika.extension.Connectr;
   import com.oyunstudyosu.sanalika.sound.SoundKey;
   import com.oyunstudyosu.tooltip.TooltipAlign;
   import com.oyunstudyosu.utils.STextField;
   import com.oyunstudyosu.utils.TextFieldManager;
   import flash.display.MovieClip;
   import flash.text.TextField;
   import flash.utils.clearInterval;
   import flash.utils.setTimeout;
   import org.oyunstudyosu.components.CoreMovieClip;
   
   [Embed(source="/_assets/assets.swf", symbol="org.oyunstudyosu.sanalika.panels.cellphone.apps.funwin.FunwinView")]
   public class FunwinView extends CoreMovieClip
   {
       
      
      private var funwinItem:FunwinItem;
      
      public var mainContainer:MovieClip;
      
      private var sTxtMessage:STextField;
      
      private var myTime:int;
      
      private var remTimeout:uint;
      
      public var mcReamining:MovieClip;
      
      public var msg:MovieClip;
      
      public var flakes:MovieClip;
      
      public var winners:MovieClip;
      
      private var lastAnswerIndex:int = -1;
      
      private var lastQuestionID:int;
      
      public var demo:MovieClip;
      
      public var mcPrize:MovieClip;
      
      public var prize:int;
      
      public var currentPrize:int;
      
      public var spectator:MovieClip;
      
      public function FunwinView()
      {
         super();
      }
      
      override public function added() : void
      {
         if(this.sTxtMessage == null)
         {
            this.sTxtMessage = TextFieldManager.convertAsArabicTextField(this.msg.getChildByName("panelTxt") as TextField,true,true);
         }
         Dispatcher.addEventListener(HudEvent.SHOW_FUNWIN,this.joinFunwin);
         Dispatcher.addEventListener(HudEvent.HIDE_FUNWIN,this.leaveFunwin);
         Dispatcher.addEventListener(FunwinEvent.ANSWER,this.answerFunwin);
         Connectr.instance.serviceModel.listenExtension(RequestDataKey.FUNWIN,this.funwin);
         Connectr.instance.serviceModel.listenExtension(RequestDataKey.WALLET,this.getPrize);
         this.funwinItem = new FunwinItem();
         this.mainContainer.addChild(this.funwinItem);
         this.funwinItem.visible = false;
         this.mcReamining.visible = false;
         this.mcPrize.visible = false;
         Connectr.instance.toolTipModel.addTip(this.spectator,$("Spectator"),TooltipAlign.ALIGN_LEFT);
         this.spectator.visible = false;
         Connectr.instance.serviceModel.requestData(RequestDataKey.FUNWIN_ADD,{},this.onJoinResponse);
      }
      
      private function updateDemo(param1:Object) : void
      {
         TweenMax.to(this.demo,0,{"colorTransform":{
            "tint":9498114,
            "tintAmount":1
         }});
         if(param1.u)
         {
            TweenMax.to(this.demo,1,{"colorTransform":{
               "tint":9795021,
               "tintAmount":0
            }});
            this.demo.txt.text = param1.u;
         }
         if(param1.w)
         {
            this.demo.txt.text = param1.w + " / " + param1.u;
         }
      }
      
      private function getPrize(param1:Object) : void
      {
         if(param1.reason == "FUNWIN")
         {
            this.funwinItem.visible = false;
            Connectr.instance.soundModel.playSound(SoundKey.TADA,1,1);
            this.makeItFun(50);
            this.showMessage("funwinReward");
            this.mcPrize.visible = true;
            this.currentPrize = 0;
            TweenMax.to(this,10,{
               "currentPrize":this.prize,
               "onUpdate":this.changePrize,
               "ease":Quad.easeOut
            });
         }
      }
      
      private function changePrize() : void
      {
         this.mcPrize.txt.text = this.currentPrize.toString();
      }
      
      private function joinFunwin(param1:HudEvent) : void
      {
         Connectr.instance.serviceModel.requestData(RequestDataKey.FUNWIN_ADD,{},this.onJoinResponse);
      }
      
      private function leaveFunwin(param1:HudEvent) : void
      {
         this.showMessage("funwinNotActive");
         this.mcPrize.visible = false;
      }
      
      private function showMessage(param1:String) : void
      {
         var _loc2_:int = 0;
         var _loc3_:int = 0;
         TweenMax.to(this.msg,0,{"colorTransform":{
            "tint":9795021,
            "tintAmount":1
         }});
         this.sTxtMessage.htmlText = $(param1);
         this.msg.bgTxt.x = this.sTxtMessage.x - 2;
         this.msg.bgTxt.y = this.sTxtMessage.y + 2;
         this.msg.bgTxt.width = this.sTxtMessage.width + 2;
         this.msg.bgTxt.height = this.sTxtMessage.height + 2;
         this.msg.tipTxt.y = this.msg.bgTxt.height + this.msg.bgTxt.y - 1;
         this.msg.tipTxt.x = this.msg.bgTxt.x + 4;
         this.msg.crown.x = this.msg.bgTxt.x - 2;
         this.msg.crown.y = this.msg.bgTxt.y;
         if(Boolean(this.funwinItem) && this.funwinItem.visible)
         {
            _loc2_ = 20 + int((130 - this.msg.height) / 2);
            TweenMax.to(this.msg,1,{
               "y":_loc2_,
               "ease":Quad.easeOut
            });
         }
         else
         {
            _loc3_ = 20 + int((230 - this.msg.height) / 2);
            TweenMax.to(this.msg,1,{
               "y":_loc3_,
               "ease":Quad.easeOut
            });
         }
         TweenMax.to(this.msg,1,{"colorTransform":{"tintAmount":0}});
      }
      
      private function onJoinResponse(param1:Object) : void
      {
         Connectr.instance.serviceModel.removeRequestData(RequestDataKey.FUNWIN_ADD,this.onJoinResponse);
         this.sTxtMessage.visible = true;
         if(param1.status == "ready")
         {
            this.showMessage("funwinStarting");
         }
         else if(param1.status == "started")
         {
            this.showMessage("funwinStarted");
         }
         else
         {
            this.showMessage("funwinNotActive");
         }
         this.updateDemo(param1);
      }
      
      protected function remainingSecs() : void
      {
         --this.myTime;
         if(this.myTime > 0)
         {
            this.mcReamining.txtRemaining.text = " - " + this.myTime + " - ";
            this.remTimeout = setTimeout(this.remainingSecs,1000);
            if(this.myTime < 5)
            {
               TweenMax.to(this.mcReamining,0,{"colorTransform":{
                  "tint":16711680,
                  "tintAmount":1
               }});
               this.mcReamining.scaleX = 2;
               this.mcReamining.scaleY = 2;
               TweenMax.to(this.mcReamining,1,{
                  "scaleX":1,
                  "scaleY":1
               });
               TweenMax.to(this.mcReamining,1,{"colorTransform":{
                  "tint":16711680,
                  "tintAmount":0
               }});
            }
         }
         else
         {
            this.disableQuestion();
         }
      }
      
      private function disableQuestion() : void
      {
         this.mcReamining.visible = false;
         this.mcReamining.txtRemaining.text = "---";
         TweenMax.to(this.msg,1,{
            "y":y + 30,
            "ease":Quad.easeOut
         });
         TweenMax.to(this.funwinItem.bg,1,{"colorMatrixFilter":{"saturation":0}});
      }
      
      private function funwin(param1:Object) : void
      {
         var _loc2_:int = 0;
         var _loc3_:int = 0;
         switch(param1.type)
         {
            case "q":
               Connectr.instance.soundModel.playSound(SoundKey.ALERT,1,1);
               _loc2_ = int((130 - this.msg.height) / 2);
               TweenMax.to(this.msg,1,{
                  "y":_loc2_,
                  "ease":Quad.easeOut
               });
               this.myTime = param1.t;
               this.funwinItem.init(param1);
               TweenMax.to(this.funwinItem.bg,0,{"colorMatrixFilter":{"saturation":1}});
               clearInterval(this.remTimeout);
               this.funwinItem.visible = true;
               this.mcReamining.visible = true;
               this.remTimeout = setTimeout(this.remainingSecs,1000);
               break;
            case "e":
               Connectr.instance.soundModel.playSound(SoundKey.ALERT,1,1);
               this.funwinItem.stopEvents();
               if(this.lastAnswerIndex == -1)
               {
                  this.spectator.visible = true;
               }
               break;
            case "s":
               if(param1.id == this.lastQuestionID)
               {
                  if(param1.c != this.lastAnswerIndex)
                  {
                     Connectr.instance.soundModel.playSound(SoundKey.SAD,1,1);
                     this.showMessage("funwinEliminated");
                  }
               }
               this.funwinItem.showAnswer(param1);
               break;
            case "m":
               if(param1.m == "end")
               {
                  this.funwinItem.visible = false;
                  this.mcReamining.visible = false;
                  this.spectator.visible = false;
                  _loc3_ = 20 + int((300 - this.msg.height) / 2);
                  TweenMax.to(this.msg,1,{
                     "y":_loc3_,
                     "ease":Quad.easeOut
                  });
               }
               else
               {
                  this.showMessage(param1.m);
               }
               break;
            case "p":
               this.makeItFun(10);
               this.funwinItem.visible = false;
               this.spectator.visible = false;
               if(param1.p)
               {
                  this.prize = param1.p;
               }
               this.showMessage("funwinEnded");
               break;
            case "l":
               this.makeItWin(param1.n);
         }
         this.updateDemo(param1);
      }
      
      private function makeItWin(param1:Array) : void
      {
         var _loc3_:WinnerAvatar = null;
         var _loc2_:int = 0;
         while(_loc2_ < param1.length)
         {
            _loc3_ = new WinnerAvatar();
            _loc3_.avatarID = param1[_loc2_].id;
            _loc3_.avatarName = param1[_loc2_].an;
            _loc3_.gender = param1[_loc2_].ge;
            _loc3_.imgPath = param1[_loc2_].ip;
            this.winners.addChild(_loc3_);
            _loc3_.init();
            _loc2_++;
         }
      }
      
      private function makeItFun(param1:int) : void
      {
         var _loc3_:Flake = null;
         while(this.flakes.numChildren > 0)
         {
            this.flakes.removeChildAt(0);
         }
         var _loc2_:int = 0;
         while(_loc2_ < param1)
         {
            _loc3_ = new Flake();
            this.flakes.addChild(_loc3_);
            _loc3_.SetInitialProperties();
            _loc2_++;
         }
      }
      
      private function answerFunwin(param1:FunwinEvent) : void
      {
         this.funwinItem.stopEvents();
         this.lastAnswerIndex = param1.a;
         this.lastQuestionID = param1.id;
         Connectr.instance.serviceModel.requestData(RequestDataKey.FUNWIN_ANSWER,{
            "id":this.lastQuestionID,
            "a":this.lastAnswerIndex
         },this.onAnswerResponse);
      }
      
      private function onAnswerResponse(param1:Object) : void
      {
         Connectr.instance.serviceModel.removeRequestData(RequestDataKey.FUNWIN_ANSWER,this.onAnswerResponse);
         if(param1.status == "success")
         {
            (this.funwinItem.answerContainer.getChildByName("mcAns" + param1.a) as FunwinAnswer).savedAnswer();
         }
         else
         {
            this.spectator.visible = true;
         }
      }
      
      override public function removed() : void
      {
         clearInterval(this.remTimeout);
         while(this.flakes.numChildren > 0)
         {
            this.flakes.removeChildAt(0);
         }
         while(this.winners.numChildren > 0)
         {
            this.winners.removeChildAt(0);
         }
         Dispatcher.removeEventListener(HudEvent.SHOW_FUNWIN,this.joinFunwin);
         Dispatcher.removeEventListener(HudEvent.HIDE_FUNWIN,this.leaveFunwin);
         Dispatcher.removeEventListener(FunwinEvent.ANSWER,this.answerFunwin);
         Connectr.instance.serviceModel.removeExtension(RequestDataKey.FUNWIN,this.funwin);
         Connectr.instance.serviceModel.removeExtension(RequestDataKey.WALLET,this.getPrize);
         Connectr.instance.toolTipModel.removeTip(this.spectator);
         this.funwinItem.dispose();
         this.funwinItem = null;
         this.parent.removeChild(this);
      }
   }
}
