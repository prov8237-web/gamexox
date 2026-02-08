package org.oyunstudyosu.sanalika.panels.cellphone.apps.funwin
{
   import com.greensock.TweenLite;
   import com.greensock.TweenMax;
   import com.greensock.easing.Linear;
   import com.greensock.easing.Strong;
   import com.greensock.plugins.ThrowPropsPlugin;
   import com.greensock.plugins.TweenPlugin;
   import com.oyunstudyosu.assets.AssetRequest;
   import com.oyunstudyosu.enums.RequestDataKey;
   import com.oyunstudyosu.sanalika.extension.Connectr;
   import com.oyunstudyosu.utils.BlitMask;
   import com.oyunstudyosu.utils.DrawUtils;
   import com.oyunstudyosu.utils.STextField;
   import com.oyunstudyosu.utils.TextFieldManager;
   import flash.display.MovieClip;
   import flash.display.Sprite;
   import flash.events.MouseEvent;
   import flash.geom.Rectangle;
   import flash.text.TextField;
   import flash.utils.getTimer;
   import org.oyunstudyosu.components.CoreMovieClip;
   
   [Embed(source="/_assets/assets.swf", symbol="org.oyunstudyosu.sanalika.panels.cellphone.apps.funwin.FunwinTopListView")]
   public class FunwinTopListView extends CoreMovieClip
   {
       
      
      private var listContainer:Sprite;
      
      private var myItem:FunwinTopListItem;
      
      private var myListID:Object;
      
      public var headerBg:MovieClip;
      
      public var sHeader:STextField;
      
      public var sDescription:STextField;
      
      public var request:AssetRequest;
      
      private var scrollContainer:Sprite;
      
      private var scrollContainerBg:Sprite;
      
      private var bounds:Rectangle;
      
      private var t1:uint;
      
      private var t2:uint;
      
      private var y1:Number;
      
      private var y2:Number;
      
      private var yOverlap:Number;
      
      private var yOffset:Number;
      
      private var blitMask:BlitMask;
      
      private var boundHeight:int = 330;
      
      public function FunwinTopListView()
      {
         super();
      }
      
      override public function added() : void
      {
         this.scrollContainer = new Sprite();
         this.scrollContainer.y = this.headerBg.height + this.headerBg.y;
         this.listContainer = new Sprite();
         this.listContainer.y = 0;
         if(this.sHeader == null)
         {
            this.sHeader = TextFieldManager.convertAsArabicTextField(this.getChildByName("txtHeader") as TextField,false);
            this.sDescription = TextFieldManager.convertAsArabicTextField(this.getChildByName("txtDescription") as TextField,false);
         }
         this.scrollContainerBg = DrawUtils.getRectangleSprite(this.boundHeight,100,0,0);
         this.addChild(this.scrollContainer);
         this.scrollContainer.addChild(this.scrollContainerBg);
         this.scrollContainer.addChild(this.listContainer);
         this.headerBg.addEventListener(MouseEvent.CLICK,this.closeView);
         this.headerBg.buttonMode = true;
         TweenPlugin.activate([ThrowPropsPlugin]);
         Connectr.instance.serviceModel.requestData("toplistgame",{"gameKey":"funwin"},this.onList);
      }
      
      public function closeView(param1:MouseEvent = null) : void
      {
         TweenMax.to(this,0.2,{
            "x":0,
            "ease":Linear.easeIn
         });
      }
      
      private function onList(param1:*) : void
      {
         while(this.listContainer.numChildren > 0)
         {
            (this.listContainer.getChildAt(0) as FunwinTopListItem).removed();
            this.listContainer.removeChildAt(0);
         }
         Connectr.instance.serviceModel.removeRequestData(RequestDataKey.FUNWIN_TOPLIST,this.onList);
         var _loc2_:int = 0;
         while(_loc2_ < param1.toplist.length)
         {
            this.myItem = new FunwinTopListItem();
            this.myItem.data = param1.toplist[_loc2_];
            this.myItem.order = _loc2_ + 1;
            this.listContainer.addChild(this.myItem);
            this.myItem.y = _loc2_ * this.myItem.height + this.headerBg.height;
            _loc2_++;
         }
         this.setPositions();
         this.bounds = new Rectangle(this.scrollContainer.x,this.scrollContainer.y,228,this.boundHeight);
         this.blitMask = new BlitMask(this.scrollContainer,this.bounds.x,this.bounds.y,this.bounds.width,this.bounds.height,false,true);
         this.blitMask.bitmapMode = false;
         this.blitMask.addEventListener(MouseEvent.MOUSE_DOWN,this.mouseDownHandler);
         param1 = null;
      }
      
      public function setPositions() : void
      {
         var _loc1_:int = 0;
         while(_loc1_ < this.listContainer.numChildren)
         {
            this.myItem = this.listContainer.getChildAt(_loc1_) as FunwinTopListItem;
            this.myItem.y = this.myItem.height * _loc1_;
            _loc1_++;
         }
         if(this.myItem)
         {
            this.scrollContainerBg.height = this.listContainer.numChildren * this.myItem.height;
         }
      }
      
      private function mouseDownHandler(param1:MouseEvent) : void
      {
         TweenLite.killTweensOf(this.scrollContainer);
         this.y1 = this.y2 = this.scrollContainer.y;
         this.yOffset = this.mouseY - this.scrollContainer.y;
         this.yOverlap = Math.max(0,this.scrollContainer.height - this.bounds.height);
         this.t1 = this.t2 = getTimer();
         Connectr.instance.layerModel.stage.addEventListener(MouseEvent.MOUSE_MOVE,this.mouseMoveHandler);
         Connectr.instance.layerModel.stage.addEventListener(MouseEvent.MOUSE_UP,this.mouseUpHandler);
      }
      
      private function mouseMoveHandler(param1:MouseEvent) : void
      {
         this.scrollContainer.mouseEnabled = false;
         this.scrollContainer.mouseChildren = false;
         var _loc2_:Number = this.mouseY - this.yOffset;
         if(_loc2_ > this.bounds.top)
         {
            this.scrollContainer.y = (_loc2_ + this.bounds.top) * 0.5;
         }
         else if(_loc2_ < this.bounds.top - this.yOverlap)
         {
            this.scrollContainer.y = (_loc2_ + this.bounds.top - this.yOverlap) * 0.5;
         }
         else
         {
            this.scrollContainer.y = _loc2_;
         }
         this.blitMask.update();
         var _loc3_:uint = uint(getTimer());
         if(_loc3_ - this.t2 > 50)
         {
            this.y2 = this.y1;
            this.t2 = this.t1;
            this.y1 = this.scrollContainer.y;
            this.t1 = _loc3_;
         }
         param1.updateAfterEvent();
      }
      
      private function mouseUpHandler(param1:MouseEvent) : void
      {
         param1.stopPropagation();
         this.scrollContainer.mouseEnabled = true;
         this.scrollContainer.mouseChildren = true;
         Connectr.instance.layerModel.stage.removeEventListener(MouseEvent.MOUSE_UP,this.mouseUpHandler);
         Connectr.instance.layerModel.stage.removeEventListener(MouseEvent.MOUSE_MOVE,this.mouseMoveHandler);
         var _loc2_:Number = (getTimer() - this.t2) / 1000;
         var _loc3_:Number = (this.scrollContainer.y - this.y2) / _loc2_;
         ThrowPropsPlugin.to(this.scrollContainer,{
            "throwProps":{"y":{
               "velocity":_loc3_,
               "max":this.bounds.top,
               "min":this.bounds.top - this.yOverlap,
               "resistance":300
            }},
            "onUpdate":this.blitMask.update,
            "ease":Strong.easeOut
         },1,0.3,1);
      }
      
      override public function removed() : void
      {
         this.headerBg.removeEventListener(MouseEvent.CLICK,this.closeView);
         while(this.listContainer.numChildren > 0)
         {
            (this.listContainer.getChildAt(0) as FunwinTopListItem).removed();
            this.listContainer.removeChildAt(0);
         }
         this.scrollContainer.removeChild(this.listContainer);
         this.scrollContainer.removeChild(this.scrollContainerBg);
         this.removeChild(this.scrollContainer);
      }
   }
}
