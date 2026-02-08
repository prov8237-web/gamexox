package org.oyunstudyosu.sanalika.panels.quest
{
   import com.oyunstudyosu.local.$;
   import com.oyunstudyosu.sanalika.extension.Connectr;
   import com.printfas3.printf;
   import flash.text.TextField;
   
   [Embed(source="/_assets/assets.swf", symbol="org.oyunstudyosu.sanalika.panels.quest.DiamondGift")]
   public class DiamondGift extends QuestGift
   {
       
      
      public var lbl_info:TextField;
      
      public function DiamondGift()
      {
         super();
      }
      
      override public function process(param1:Object, param2:Object) : void
      {
         super.process(param1,param2);
         var _loc3_:String = $("questReward") + ": " + printf($("diamondPrice"),param1.amount);
         Connectr.instance.toolTipModel.addTip(this,_loc3_);
         infoTextField.text = param1.amount;
      }
      
      override public function dispose() : void
      {
         Connectr.instance.toolTipModel.removeTip(this);
      }
   }
}
