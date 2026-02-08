package org.oyunstudyosu.sanalika.panels.smiley
{
   import com.greensock.TweenMax;
   import com.greensock.plugins.GlowFilterPlugin;
   import com.greensock.plugins.TweenPlugin;
   import com.oyunstudyosu.alert.AlertEvent;
   import com.oyunstudyosu.alert.AlertType;
   import com.oyunstudyosu.alert.AlertVo;
   import com.oyunstudyosu.assets.AssetRequest;
   import com.oyunstudyosu.assets.IAssetRequest;
   import com.oyunstudyosu.enums.ModuleType;
   import com.oyunstudyosu.enums.RequestDataKey;
   import com.oyunstudyosu.events.Dispatcher;
   import com.oyunstudyosu.sanalika.extension.Connectr;
   import flash.display.Bitmap;
   import flash.display.MovieClip;
   import flash.events.MouseEvent;
   import org.oyunstudyosu.assets.clips.LoadingAnimationSmall;
   import org.oyunstudyosu.components.CoreMovieClip;
   
   [Embed(source="/_assets/assets.swf", symbol="org.oyunstudyosu.sanalika.panels.smiley.SmileyItem")]
   public class SmileyItem extends CoreMovieClip
   {
       
      
      private var _vo:ItemVo;
      
      private var _positionId:int;
      
      private var loading:LoadingAnimationSmall;
      
      private var container:MovieClip;
      
      private var request:AssetRequest;
      
      public var bg:MovieClip;
      
      public function SmileyItem()
      {
         super();
         this.container = new MovieClip();
         this.loading = new LoadingAnimationSmall();
         this.loading.x = this.container.x = this.width / 2;
         this.loading.y = this.container.y = this.height / 2;
         addChild(this.loading);
         addChild(this.container);
         this.mouseEnabled = false;
         this.alpha = 0.5;
         addEventListener(MouseEvent.ROLL_OVER,this.overHandler);
         addEventListener(MouseEvent.ROLL_OUT,this.outHandler);
         addEventListener(MouseEvent.CLICK,this.clicked);
         buttonMode = true;
      }
      
      public function clicked(param1:MouseEvent) : void
      {
         Connectr.instance.serviceModel.requestData(RequestDataKey.CHANGE_SMILEY,{"key":this.vo.key},this.onResponse);
      }
      
      public function onResponse(param1:Object) : void
      {
         var _loc2_:AlertVo = null;
         if(param1.errorCode != undefined && param1.errorCode != "INSUFFICIENT_ROLE")
         {
            _loc2_ = new AlertVo();
            _loc2_.alertType = AlertType.TOOLTIP;
            _loc2_.description = param1.errorCode;
            Dispatcher.dispatchEvent(new AlertEvent(_loc2_));
         }
      }
      
      private function overHandler(param1:MouseEvent) : void
      {
         TweenPlugin.activate([GlowFilterPlugin]);
         TweenMax.to(this.bg,1,{"glowFilter":{
            "color":65280,
            "blurX":10,
            "blurY":10,
            "strength":4,
            "alpha":1
         }});
      }
      
      private function outHandler(param1:MouseEvent) : void
      {
         TweenPlugin.activate([GlowFilterPlugin]);
         TweenMax.to(this.bg,2,{"glowFilter":{
            "color":65280,
            "blurX":10,
            "blurY":10,
            "strength":1,
            "alpha":0
         }});
      }
      
      public function get positionId() : int
      {
         return this._positionId;
      }
      
      public function set positionId(param1:int) : void
      {
         this._positionId = param1;
      }
      
      public function get vo() : ItemVo
      {
         return this._vo;
      }
      
      public function set vo(param1:ItemVo) : void
      {
         this._vo = param1;
         this.loading.visible = true;
         while(this.container.numChildren > 0)
         {
            this.container.removeChildAt(0);
         }
         if(this.vo != null)
         {
            this.loadReq();
         }
         else
         {
            this.mouseEnabled = false;
            this.alpha = 0.5;
         }
      }
      
      private function loadReq() : void
      {
         this.request = new AssetRequest();
         this.request.context = Connectr.instance.domainModel.assetContext;
         this.request.type = ModuleType.PNG;
         this.request.assetId = "/static/items/smileys/" + this.vo.key + ".png";
         this.request.loadedFunction = this.onLoaded;
         this.request.errorFunction = this.onError;
         Connectr.instance.assetModel.request(this.request);
      }
      
      private function onError(param1:IAssetRequest) : void
      {
         this.mouseEnabled = false;
         this.alpha = 0.5;
      }
      
      private function onLoaded(param1:IAssetRequest) : void
      {
         this.loading.visible = false;
         this.mouseEnabled = true;
         this.alpha = 1;
         var _loc2_:Bitmap = param1.display as Bitmap;
         _loc2_.smoothing = true;
         _loc2_.x = -(_loc2_.width / 2);
         _loc2_.y = -(_loc2_.height / 2);
         this.container.addChild(_loc2_);
         param1.dispose();
      }
      
      public function dispose() : void
      {
         this.request.dispose();
         Connectr.instance.serviceModel.removeRequestData(RequestDataKey.CHANGE_SMILEY,this.onResponse);
         this.loading = null;
         this.container = null;
         removeEventListener(MouseEvent.ROLL_OVER,this.overHandler);
         removeEventListener(MouseEvent.ROLL_OUT,this.outHandler);
         removeChildren();
      }
   }
}
