package org.oyunstudyosu.sanalika.mock
{
   import com.greensock.TweenMax;
   import com.oyunstudyosu.local.$;
   import com.oyunstudyosu.sanalika.interfaces.IToolTipModel;
   import com.oyunstudyosu.tooltip.TooltipAlign;
   import flash.display.DisplayObject;
   import flash.display.DisplayObjectContainer;
   import flash.display.MovieClip;
   import flash.display.Sprite;
   import flash.events.MouseEvent;
   import flash.text.TextFieldAutoSize;
   import flash.text.TextFormat;
   import flash.utils.Dictionary;
   import org.oyunstudyosu.assets.clips.StaticArabicTextField;
   import org.oyunstudyosu.assets.clips.ToolTipClip;
   
   public class ToolTipModel implements IToolTipModel
   {
       
      
      public const ALIGN_NONE:int = 0;
      
      public const ALIGN_LEFT:int = 1;
      
      public const ALIGN_RIGHT:int = 2;
      
      private var tfMc:MovieClip;
      
      private var myTextFormat:TextFormat;
      
      private var tip:Sprite;
      
      private var balloon:ToolTipClip;
      
      private var mc:DisplayObjectContainer;
      
      private var targetItem:DisplayObject;
      
      private var dictionary:Dictionary;
      
      public function ToolTipModel()
      {
         this.dictionary = new Dictionary(true);
         super();
         this.tfMc = new StaticArabicTextField();
         this.tfMc.name = "fld";
         this.tfMc.sText.multiline = true;
         this.tfMc.sText.width = 200;
         this.tfMc.sText.autoSize = TextFieldAutoSize.NONE;
         this.tfMc.x = 4;
         this.tfMc.y = 4;
         this.tip = new Sprite();
         this.balloon = new ToolTipClip();
         TweenMax.to(this.balloon,0,{"dropShadowFilter":{
            "color":1381653,
            "alpha":0.5,
            "blurX":2,
            "blurY":2,
            "distance":2,
            "angle":45
         }});
         this.tip.addChild(this.balloon);
         this.tip.addChild(this.tfMc);
         this.tip.visible = false;
      }
      
      public function showTip(param1:DisplayObject, param2:String, param3:int = 0) : void
      {
         this.dictionary[param1] = {
            "clip":param1,
            "message":param2,
            "align":param3
         };
         param1.addEventListener(MouseEvent.ROLL_OUT,this.outRightClickTip);
         this.drawTip(param1);
      }
      
      protected function outRightClickTip(param1:MouseEvent) : void
      {
         this.targetItem = param1.currentTarget as DisplayObject;
         if(this.targetItem.parent.contains(this.tip))
         {
            this.targetItem.removeEventListener(MouseEvent.ROLL_OUT,this.outRightClickTip);
            if(!this.tip.visible)
            {
               return;
            }
            this.tip.visible = false;
            this.targetItem.parent.removeChild(this.tip);
            delete this.dictionary[this.targetItem];
         }
      }
      
      public function addTip(param1:DisplayObject, param2:String, param3:int = 0) : void
      {
         this.dictionary[param1] = {
            "clip":param1,
            "message":param2,
            "align":param3
         };
         param1.addEventListener(MouseEvent.ROLL_OVER,this.overItem);
         param1.addEventListener(MouseEvent.ROLL_OUT,this.outItem);
         param1.addEventListener(MouseEvent.MOUSE_DOWN,this.downItem);
      }
      
      public function removeTip(param1:DisplayObject) : void
      {
         param1.removeEventListener(MouseEvent.ROLL_OVER,this.overItem);
         param1.removeEventListener(MouseEvent.ROLL_OUT,this.outItem);
         param1.removeEventListener(MouseEvent.MOUSE_DOWN,this.downItem);
         delete this.dictionary[param1];
      }
      
      protected function overItem(param1:MouseEvent) : void
      {
         this.targetItem = param1.currentTarget as DisplayObject;
         this.drawTip(this.targetItem);
      }
      
      private function drawTip(param1:DisplayObject) : void
      {
         var _loc2_:int = int(this.dictionary[param1].align);
         this.tfMc.sText.width = 180;
         this.tfMc.sText.htmlText = $(this.dictionary[param1].message);
         this.tfMc.sText.height = this.tfMc.sText.textHeight + 4;
         if(this.tfMc.sText.numLines == 1)
         {
            this.tfMc.sText.width = this.tfMc.sText.textWidth + 5;
            this.tfMc.sText.height = this.tfMc.sText.textHeight;
         }
         this.balloon.width = this.tfMc.width + this.tfMc.x * 2;
         this.balloon.height = this.tfMc.height + this.tfMc.y * 2;
         if(this.tip.visible)
         {
            return;
         }
         this.tip.y = param1.y - this.tip.height - 5;
         if(_loc2_ == TooltipAlign.ALIGN_NONE)
         {
            this.tip.x = param1.x + param1.width / 2 - this.tip.width / 2;
         }
         else if(_loc2_ == TooltipAlign.ALIGN_LEFT)
         {
            this.tip.x = param1.x + param1.width / 2 - this.tip.width;
         }
         else if(_loc2_ == TooltipAlign.ALIGN_RIGHT)
         {
            this.tip.x = param1.x + param1.width / 2;
         }
         else if(_loc2_ == TooltipAlign.ALIGN_BOTTOM)
         {
            this.tip.y = param1.y + param1.height + 4;
            this.tip.x = param1.x + param1.width / 2 - this.tip.width / 2;
         }
         param1.parent.addChild(this.tip);
         var _loc3_:DisplayObjectContainer = this.tip;
         var _loc4_:Number = 0;
         var _loc5_:Number = 0;
         while(_loc3_ != null)
         {
            _loc4_ += _loc3_.x;
            _loc5_ += _loc3_.y;
            _loc3_ = _loc3_.parent;
         }
         if(_loc4_ < 5)
         {
            this.tip.x += 5 - _loc4_;
         }
         else if(_loc4_ > Sanalika.instance.layerModel.stage.stageWidth - 5 - this.tip.width)
         {
            this.tip.x -= _loc4_ - (Sanalika.instance.layerModel.stage.stageWidth - 5 - this.tip.width);
         }
         if(_loc5_ <= 0)
         {
            this.tip.y += 5 + this.tip.height + param1.height + 5;
         }
         this.tip.visible = true;
      }
      
      protected function outItem(param1:MouseEvent) : void
      {
         this.targetItem = param1.currentTarget as DisplayObject;
         if(!this.tip.visible)
         {
            return;
         }
         this.tip.visible = false;
         try
         {
            this.targetItem.parent.removeChild(this.tip);
         }
         catch(e:Error)
         {
         }
      }
      
      protected function downItem(param1:MouseEvent) : void
      {
         this.targetItem = param1.currentTarget as DisplayObject;
         if(!this.tip.visible)
         {
            return;
         }
         this.tip.visible = false;
         this.targetItem.parent.removeChild(this.tip);
      }
   }
}
