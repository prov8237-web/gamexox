package org.oyunstudyosu.sanalika.panels.inventory
{
   import com.oyunstudyosu.assets.AssetRequest;
   import com.oyunstudyosu.assets.IAssetRequest;
   import com.oyunstudyosu.enums.ModuleType;
   import com.oyunstudyosu.inventory.Item;
   import com.oyunstudyosu.local.$;
   import com.oyunstudyosu.sanalika.extension.Connectr;
   import com.oyunstudyosu.tooltip.TooltipAlign;
   import flash.display.Bitmap;
   
   public class CardSlot extends Slot
   {
       
      
      public var exclamation:Exclamation;
      
      public function CardSlot()
      {
         super();
      }
      
      public function init(param1:Item, param2:Object) : void
      {
         var _loc3_:Array = null;
         var _loc4_:Boolean = false;
         var _loc5_:Object = null;
         this.item = param1;
         Connectr.instance.toolTipModel.addTip(this,item.getInfo(),TooltipAlign.ALIGN_LEFT);
         if(item.clip == "CARD_DIAMOND_CLUB")
         {
            _loc3_ = ["CARD_GOLD","CARD_DIAMOND","CARD_MUSIC","CARD_GUARD","CARD_GUIDE","CARD_SECURITY","CARD_PAINTER","CARD_JOURNALIST","CARD_PHOTOGRAPHER","CARD_DIRECTOR"];
            _loc4_ = false;
            for each(_loc5_ in param2)
            {
               if(_loc3_.indexOf(_loc5_.clip) != -1)
               {
                  _loc4_ = true;
               }
               if(_loc4_)
               {
                  break;
               }
            }
            if(!_loc4_)
            {
               this.exclamation = new Exclamation();
               this.exclamation.x = 36;
               this.addChild(this.exclamation);
               Connectr.instance.toolTipModel.addTip(this.exclamation,$("diamondClubWarn"),TooltipAlign.ALIGN_RIGHT);
            }
         }
         if(item.lifeTime > -1)
         {
            bar.visible = true;
            barbg.visible = true;
            if(item.timeLeft / item.lifeTime > 1)
            {
               bar.width = barbg.width;
            }
            else if(item.timeLeft > 0 && item.timeLeft != item.lifeTime)
            {
               bar.width = barbg.width * item.timeLeft / item.lifeTime;
            }
            else
            {
               bar.visible = false;
               barbg.visible = false;
            }
         }
         else
         {
            bar.visible = false;
            barbg.visible = false;
         }
      }
      
      public function loadAsset(param1:*) : void
      {
         var _loc2_:AssetRequest = new AssetRequest();
         _loc2_.context = Connectr.instance.domainModel.assetContext;
         _loc2_.name = item.clip;
         _loc2_.type = ModuleType.PNG;
         _loc2_.assetId = "/static/items/" + param1 + "/" + item.clip + ".png";
         _loc2_.loadedFunction = this.imgLoaded;
         Connectr.instance.assetModel.request(_loc2_);
      }
      
      private function imgLoaded(param1:IAssetRequest) : void
      {
         var _loc2_:Bitmap = param1.display as Bitmap;
         _loc2_.smoothing = false;
         var _loc3_:int = 42;
         if(_loc2_.height > _loc3_)
         {
            _loc2_.width = _loc2_.width / _loc2_.height * _loc3_;
            _loc2_.height = _loc3_;
         }
         _loc2_.x = -_loc3_ / 2;
         _loc2_.y = -_loc3_ / 2;
         holder.addChild(_loc2_);
      }
      
      public function dispose() : void
      {
         Connectr.instance.toolTipModel.removeTip(this);
         if(this.exclamation != null)
         {
            Connectr.instance.toolTipModel.removeTip(this.exclamation);
         }
      }
   }
}
