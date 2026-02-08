package org.oyunstudyosu.sanalika.panels.profile
{
   import com.oyunstudyosu.local.$;
   import com.oyunstudyosu.sanalika.extension.Connectr;
   
   public class StickerSlot extends Slot
   {
       
      
      private var data:Object;
      
      public function StickerSlot()
      {
         super();
      }
      
      public function init(param1:Object) : void
      {
         this.data = param1;
         Connectr.instance.toolTipModel.addTip(this.container,$("pro_" + this.data.clip));
      }
      
      override public function get clip() : String
      {
         return this.data.clip;
      }
      
      override public function get quantity() : int
      {
         return this.data.q;
      }
   }
}
