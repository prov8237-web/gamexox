package org.oyunstudyosu.sanalika.panels.profile
{
   import com.oyunstudyosu.auth.Permission;
   import com.oyunstudyosu.inventory.Item;
   import com.oyunstudyosu.sanalika.extension.Connectr;
   
   public class ItemSlot extends Slot
   {
       
      
      protected var item:Item;
      
      protected var data:Object;
      
      public function ItemSlot()
      {
         super();
      }
      
      public function init(param1:Object) : void
      {
         this.data = param1;
         this.item = new Item(param1.transferrable,param1.productID,param1.clip,param1.lifeTime,param1.timeLeft,param1.subType,param1.createdAt,param1.id,param1.quantity,Permission.getGrantedIndexes(param1.roles));
         Connectr.instance.toolTipModel.addTip(this.container,this.item.getInfo());
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
