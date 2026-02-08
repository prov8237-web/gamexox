package org.oyunstudyosu.sanalika.panels.profile
{
   import flash.display.MovieClip;
   
   [Embed(source="/_assets/assets.swf", symbol="org.oyunstudyosu.sanalika.panels.profile.ProfileStickerContainer")]
   public class ProfileStickerContainer extends MovieClip
   {
       
      
      public var container:MovieClip;
      
      public var bg:MovieClip;
      
      private var slots:Array;
      
      public function ProfileStickerContainer()
      {
         this.slots = [];
         super();
      }
      
      public function init(param1:Object, param2:Object) : void
      {
         var _loc3_:MovieClip = null;
         var _loc4_:int = 0;
         var _loc5_:int = 0;
         var _loc7_:Object = null;
         x = 50;
         y = 24;
         _loc4_ = 176 - (Math.ceil((param1.length + param2.length) / 6) - 1) * 44;
         _loc5_ = 0;
         while(_loc5_ < param1.length)
         {
            _loc7_ = param1[_loc5_];
            _loc3_ = new CardSlot();
            if(_loc5_ % 6 == 0 && _loc5_ > 0)
            {
               _loc4_ += 44;
            }
            _loc3_.x = _loc4_;
            _loc3_.y = _loc5_ % 6 * 44;
            _loc3_.init(param1[_loc5_],param1);
            _loc3_.loadAsset("cards");
            this.slots.push(_loc3_);
            this.container.addChild(_loc3_);
            _loc5_++;
         }
         var _loc6_:int = 0;
         while(_loc6_ < param2.length)
         {
            _loc3_ = new StickerSlot();
            if((_loc5_ + _loc6_) % 6 == 0 && _loc5_ + _loc6_ > 0)
            {
               _loc4_ += 44;
            }
            _loc3_.x = _loc4_;
            _loc3_.y = (_loc5_ + _loc6_) % 6 * 44;
            _loc3_.init(param2[_loc6_]);
            _loc3_.loadAsset("stickers");
            this.slots.push(_loc3_);
            this.container.addChild(_loc3_);
            _loc6_++;
         }
      }
      
      public function dispose() : void
      {
         var _loc1_:Slot = null;
         for each(_loc1_ in this.slots)
         {
            _loc1_.dispose();
         }
         this.slots = [];
      }
   }
}
