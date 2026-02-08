package org.oyunstudyosu.sanalika.panels.profile
{
   import flash.display.MovieClip;
   
   [Embed(source="/_assets/assets.swf", symbol="org.oyunstudyosu.sanalika.panels.profile.ProfileBadgeContainer")]
   public class ProfileBadgeContainer extends MovieClip
   {
       
      
      public var container:MovieClip;
      
      public var bg:MovieClip;
      
      private var slots:Array;
      
      public function ProfileBadgeContainer()
      {
         this.slots = [];
         super();
      }
      
      public function init(param1:Object) : void
      {
         var _loc2_:BadgeSlot = null;
         this.container.y = -40;
         x = 14;
         y = 354;
         if(param1.length > 5)
         {
            this.container.y -= int((param1.length - 1) / 5) * 44;
         }
         var _loc3_:int = 0;
         var _loc4_:int = 0;
         while(_loc4_ < param1.length)
         {
            if(_loc4_ % 5 == 0 && _loc4_ > 4)
            {
               _loc3_ += 44;
            }
            _loc2_ = new BadgeSlot();
            _loc2_.x = _loc4_ % 5 * 46;
            _loc2_.y = _loc3_;
            _loc2_.init(param1[_loc4_]);
            _loc2_.loadAsset("cards");
            this.slots.push(_loc2_);
            this.container.addChild(_loc2_);
            _loc4_++;
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
