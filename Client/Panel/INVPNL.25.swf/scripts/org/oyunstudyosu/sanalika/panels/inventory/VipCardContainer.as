package org.oyunstudyosu.sanalika.panels.inventory
{
   import com.oyunstudyosu.inventory.Item;
   import flash.display.MovieClip;
   
   [Embed(source="/_assets/assets.swf", symbol="org.oyunstudyosu.sanalika.panels.inventory.VipCardContainer")]
   public class VipCardContainer extends MovieClip
   {
       
      
      public var background:MovieClip;
      
      public var container:MovieClip;
      
      private var slots:Array;
      
      public function VipCardContainer()
      {
         this.slots = [];
         super();
      }
      
      public function init(param1:Object) : void
      {
         var _loc2_:CardSlot = null;
         var _loc3_:int = 0;
         var _loc5_:Item = null;
         x = 10;
         y = 8;
         _loc3_ = 0;
         var _loc4_:int = 0;
         while(_loc4_ < param1.length)
         {
            _loc5_ = param1[_loc4_];
            _loc2_ = new CardSlot();
            if(_loc4_ % 5 == 0 && _loc4_ > 0)
            {
               _loc3_ += 54;
            }
            _loc2_.x = _loc3_;
            _loc2_.y = _loc4_ % 5 * 54;
            _loc2_.init(_loc5_,param1);
            _loc2_.loadAsset("cards");
            this.slots.push(_loc2_);
            this.container.addChild(_loc2_);
            _loc4_++;
         }
      }
      
      public function dispose() : void
      {
         var _loc1_:CardSlot = null;
         for each(_loc1_ in this.slots)
         {
            _loc1_.dispose();
         }
         this.slots = [];
      }
   }
}
