package org.oyunstudyosu.sanalika.panels.profile
{
   import com.oyunstudyosu.auth.Permission;
   import flash.events.MouseEvent;
   
   public class SkinSlot extends ItemSlot
   {
       
      
      public function SkinSlot()
      {
         super();
      }
      
      override public function init(param1:Object) : void
      {
         super.init(param1);
         this.addEventListener(MouseEvent.CLICK,this.onClick);
         this.buttonMode = true;
      }
      
      private function onClick(param1:MouseEvent) : void
      {
         var _loc4_:uint = 0;
         var _loc5_:Object = null;
         var _loc2_:Array = item.roles;
         var _loc3_:Permission = new Permission();
         for each(_loc4_ in _loc2_)
         {
            _loc3_.grant(_loc4_);
         }
         _loc5_ = {
            "clip":item.clip,
            "property":this.data.property,
            "roles":_loc3_.value
         };
         (parent.parent.parent as ProfilePanel).profileSkin.init(_loc5_);
      }
      
      override public function get clip() : String
      {
         return this.item.clip;
      }
      
      override public function get quantity() : int
      {
         return this.data.quantity;
      }
   }
}
