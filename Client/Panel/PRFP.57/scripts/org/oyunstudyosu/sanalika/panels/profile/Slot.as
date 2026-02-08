package org.oyunstudyosu.sanalika.panels.profile
{
   import com.oyunstudyosu.assets.AssetRequest;
   import com.oyunstudyosu.assets.IAssetRequest;
   import com.oyunstudyosu.enums.ModuleType;
   import com.oyunstudyosu.sanalika.extension.Connectr;
   import flash.display.Bitmap;
   import flash.display.MovieClip;
   import flash.text.TextField;
   
   [Embed(source="/_assets/assets.swf", symbol="org.oyunstudyosu.sanalika.panels.profile.Slot")]
   public class Slot extends MovieClip
   {
       
      
      public var lbl:TextField;
      
      public var id:int;
      
      public var container:MovieClip;
      
      public var exclamation:Exclamation;
      
      public function Slot()
      {
         super();
         this.lbl.visible = false;
      }
      
      public function loadAsset(param1:*) : void
      {
         var _loc2_:AssetRequest = new AssetRequest();
         _loc2_.context = Connectr.instance.domainModel.assetContext;
         _loc2_.name = this.clip;
         _loc2_.type = ModuleType.PNG;
         _loc2_.assetId = "/static/items/" + param1 + "/" + this.clip + ".png";
         _loc2_.loadedFunction = this.imgLoaded;
         Connectr.instance.assetModel.request(_loc2_);
      }
      
      private function imgLoaded(param1:IAssetRequest) : void
      {
         var _loc2_:Bitmap = param1.display as Bitmap;
         _loc2_.smoothing = false;
         if(_loc2_.height > 40)
         {
            _loc2_.width = _loc2_.width / _loc2_.height * 40;
            _loc2_.height = 40;
         }
         this.container.addChild(_loc2_);
         if(this.quantity > 1)
         {
            this.lbl.visible = true;
            this.lbl.text = "x" + this.quantity;
         }
      }
      
      public function get clip() : String
      {
         return null;
      }
      
      public function get quantity() : int
      {
         return 0;
      }
      
      public function dispose() : void
      {
         Connectr.instance.toolTipModel.removeTip(this.container);
         if(this.exclamation != null)
         {
            Connectr.instance.toolTipModel.removeTip(this.exclamation);
         }
      }
   }
}
