package org.oyunstudyosu.sanalika.panels.quest
{
   import com.oyunstudyosu.local.$;
   import com.oyunstudyosu.sanalika.extension.Connectr;
   import com.printfas3.printf;
   import flash.display.MovieClip;
   import flash.text.TextField;
   
   [Embed(source="/_assets/assets.swf", symbol="org.oyunstudyosu.sanalika.panels.quest.SanilGift")]
   public class SanilGift extends QuestGift
   {
       
      
      public var lbl_info:TextField;
      
      public var mc_multip:MovieClip;
      
      public function SanilGift()
      {
         super();
      }
      
      override public function process(param1:Object, param2:Object) : void
      {
         super.process(param1,param2);
         var _loc3_:String = $("questReward") + ": " + printf($("sanilPrice"),param1.amount);
         if(param2.rewardMultiplier > 1)
         {
            this.mc_multip.visible = true;
            this.mc_multip.lbl_multiplier.text = "x" + param2.rewardMultiplier;
            _loc3_ += " x" + param2.rewardMultiplier;
         }
         else
         {
            this.mc_multip.visible = false;
         }
         Connectr.instance.toolTipModel.addTip(this,_loc3_);
         infoTextField.text = param1.amount;
      }
      
      override public function dispose() : void
      {
         Connectr.instance.toolTipModel.removeTip(this);
      }
   }
}
