package org.oyunstudyosu.sanalika.panels.quest
{
   import com.oyunstudyosu.local.$;
   import com.oyunstudyosu.sanalika.extension.Connectr;
   import flash.text.TextField;
   
   [Embed(source="/_assets/assets.swf", symbol="org.oyunstudyosu.sanalika.panels.quest.ItemGift")]
   public class ItemGift extends QuestGift
   {
       
      
      public var lbl_info:TextField;
      
      public function ItemGift()
      {
         super();
      }
      
      override public function process(param1:Object, param2:Object) : void
      {
         super.process(param1,param2);
         var _loc3_:String = $("questReward") + ": " + param1.quantity + " " + $("pro_" + param1.clip);
         Connectr.instance.toolTipModel.addTip(this,_loc3_);
         infoTextField.text = $("ITEM");
      }
      
      override public function dispose() : void
      {
         Connectr.instance.toolTipModel.removeTip(this);
      }
   }
}
