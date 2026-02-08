package org.oyunstudyosu.sanalika.panels.achievement
{
   import com.oyunstudyosu.local.$;
   import com.oyunstudyosu.sanalika.extension.Connectr;
   import com.printfas3.printf;
   import flash.text.TextField;
   
   [Embed(source="/_assets/assets.swf", symbol="org.oyunstudyosu.sanalika.panels.achievement.DiamondGift")]
   public class DiamondGift extends AchievementGift
   {
       
      
      public var infoTxt:TextField;
      
      public function DiamondGift()
      {
         super();
      }
      
      override public function process(param1:Object) : void
      {
         super.process(param1);
         var _loc2_:String = printf($("diamondPrice"),param1.amount);
         Connectr.instance.toolTipModel.addTip(this,_loc2_);
         infoTextField.text = param1.amount;
         infoTextField.width = infoTextField.textWidth + 4;
      }
      
      override public function dispose() : void
      {
         Connectr.instance.toolTipModel.removeTip(this);
      }
   }
}
