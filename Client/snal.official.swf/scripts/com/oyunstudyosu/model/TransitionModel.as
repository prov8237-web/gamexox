package com.oyunstudyosu.model
{
   import com.greensock.TweenMax;
   import com.greensock.easing.Sine;
   import com.oyunstudyosu.events.Dispatcher;
   import com.oyunstudyosu.events.GameEvent;
   import com.oyunstudyosu.sanalika.interfaces.ILayerModel;
   import flash.display.Bitmap;
   import flash.display.BitmapData;
   import flash.display.DisplayObject;
   import flash.events.Event;
   
   public class TransitionModel
   {
      
      private static const TRANSTION_STATE_NONE:int = 0;
      
      private static const TRANSTION_STATE_IN:int = 1;
      
      private static const TRANSTION_STATE_OUT:int = 2;
       
      
      private var layerModel:ILayerModel;
      
      private var effectIn:Bitmap;
      
      private var effectOut:Bitmap;
      
      private var playing:Boolean;
      
      private var time:Number = 0.2;
      
      private var state:int = 0;
      
      public function TransitionModel()
      {
         super();
         layerModel = Sanalika.instance.layerModel;
         com.oyunstudyosu.§model:TransitionModel§.layerModel.gameLayer.visible = false;
         Dispatcher.addEventListener("TRANSITION_IN",fadeIn);
         Dispatcher.addEventListener("TRANSITION_OUT",fadeOut);
      }
      
      protected function fadeOut(param1:Event) : void
      {
         if(state == 2)
         {
            return;
         }
         state = 2;
         var _loc5_:Number = com.oyunstudyosu.§model:TransitionModel§.layerModel.gameLayer.x;
         var _loc4_:Number = com.oyunstudyosu.§model:TransitionModel§.layerModel.gameLayer.y;
         var _loc3_:DisplayObject = com.oyunstudyosu.§model:TransitionModel§.layerModel.gameLayer.mask;
         com.oyunstudyosu.§model:TransitionModel§.layerModel.gameLayer.mask = null;
         com.oyunstudyosu.§model:TransitionModel§.layerModel.gameLayer.x = 0;
         com.oyunstudyosu.§model:TransitionModel§.layerModel.gameLayer.y = 0;
         var _loc2_:BitmapData = new BitmapData(com.oyunstudyosu.§model:TransitionModel§.layerModel.canvasWidth,com.oyunstudyosu.§model:TransitionModel§.layerModel.canvasHeight,true,0);
         _loc2_.draw(com.oyunstudyosu.§model:TransitionModel§.layerModel.gameLayer);
         com.oyunstudyosu.§model:TransitionModel§.layerModel.gameLayer.visible = false;
         com.oyunstudyosu.§model:TransitionModel§.layerModel.gameLayer.x = _loc5_;
         com.oyunstudyosu.§model:TransitionModel§.layerModel.gameLayer.y = _loc4_;
         effectOut = new Bitmap(_loc2_);
         com.oyunstudyosu.§model:TransitionModel§.layerModel.effectLayer.x = _loc5_;
         com.oyunstudyosu.§model:TransitionModel§.layerModel.effectLayer.y = _loc4_;
         com.oyunstudyosu.§model:TransitionModel§.layerModel.effectLayer.mask = _loc3_;
         com.oyunstudyosu.§model:TransitionModel§.layerModel.effectLayer.addChild(effectOut);
         TweenMax.to(effectOut,time,{
            "alpha":0.7,
            "ease":Sine.easeOut,
            "onComplete":onCompleteOut
         });
         playing = true;
      }
      
      private function onCompleteOut() : void
      {
         if(com.oyunstudyosu.§model:TransitionModel§.layerModel.effectLayer.getChildByName(effectOut.name) != null)
         {
            com.oyunstudyosu.§model:TransitionModel§.layerModel.effectLayer.removeChild(effectOut);
         }
         com.oyunstudyosu.§model:TransitionModel§.layerModel.gameLayer.mask = com.oyunstudyosu.§model:TransitionModel§.layerModel.effectLayer.mask;
         Dispatcher.dispatchEvent(new GameEvent("TRANSITION_OUT_COMPLETE"));
         if(!playing)
         {
            fadeIn();
         }
         else
         {
            playing = false;
         }
      }
      
      protected function fadeIn(param1:Event = null) : void
      {
         if(playing || state == 1)
         {
            playing = false;
            return;
         }
         state = 1;
         var _loc5_:Number = com.oyunstudyosu.§model:TransitionModel§.layerModel.gameLayer.x;
         var _loc4_:Number = com.oyunstudyosu.§model:TransitionModel§.layerModel.gameLayer.y;
         var _loc3_:DisplayObject = com.oyunstudyosu.§model:TransitionModel§.layerModel.gameLayer.mask;
         com.oyunstudyosu.§model:TransitionModel§.layerModel.gameLayer.mask = null;
         com.oyunstudyosu.§model:TransitionModel§.layerModel.gameLayer.x = _loc5_;
         com.oyunstudyosu.§model:TransitionModel§.layerModel.gameLayer.y = _loc4_;
         com.oyunstudyosu.§model:TransitionModel§.layerModel.gameLayer.visible = true;
         var _loc2_:BitmapData = new BitmapData(com.oyunstudyosu.§model:TransitionModel§.layerModel.canvasWidth,com.oyunstudyosu.§model:TransitionModel§.layerModel.canvasHeight,true,0);
         _loc2_.draw(com.oyunstudyosu.§model:TransitionModel§.layerModel.gameLayer);
         com.oyunstudyosu.§model:TransitionModel§.layerModel.gameLayer.visible = false;
         effectIn = new Bitmap(_loc2_);
         com.oyunstudyosu.§model:TransitionModel§.layerModel.effectLayer.x = _loc5_;
         com.oyunstudyosu.§model:TransitionModel§.layerModel.effectLayer.y = _loc4_;
         com.oyunstudyosu.§model:TransitionModel§.layerModel.effectLayer.mask = _loc3_;
         com.oyunstudyosu.§model:TransitionModel§.layerModel.effectLayer.addChild(effectIn);
         TweenMax.from(effectIn,time,{
            "alpha":0.7,
            "ease":Sine.easeOut,
            "onComplete":onCompleteIn
         });
      }
      
      private function onCompleteIn() : void
      {
         com.oyunstudyosu.§model:TransitionModel§.layerModel.gameLayer.visible = true;
         if(com.oyunstudyosu.§model:TransitionModel§.layerModel.effectLayer.getChildByName(effectIn.name) != null)
         {
            com.oyunstudyosu.§model:TransitionModel§.layerModel.effectLayer.removeChildren();
         }
         com.oyunstudyosu.§model:TransitionModel§.layerModel.gameLayer.mask = com.oyunstudyosu.§model:TransitionModel§.layerModel.effectLayer.mask;
         Dispatcher.dispatchEvent(new GameEvent("TRANSITION_IN_COMPLETE"));
      }
   }
}
