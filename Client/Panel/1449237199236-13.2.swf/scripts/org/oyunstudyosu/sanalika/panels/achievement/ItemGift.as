package org.oyunstudyosu.sanalika.panels.achievement
{
   import com.oyunstudyosu.local.$;
   import com.oyunstudyosu.sanalika.extension.Connectr;
   import flash.text.TextField;
   
   [Embed(source="/_assets/assets.swf", symbol="org.oyunstudyosu.sanalika.panels.achievement.ItemGift")]
   public class ItemGift extends AchievementGift
   {
       
      
      public var infoTxt:TextField;
      
      public function ItemGift()
      {
         super();
      }
      
      override public function process(param1:Object) : void
      {
         super.process(param1);
         var _loc2_:String = param1.quantity + " " + $("pro_" + param1.clip);
         Connectr.instance.toolTipModel.addTip(this,_loc2_);
         infoTextField.text = $("SUPRISE");
         infoTextField.width = 55;
      }
      
      override public function dispose() : void
      {
         Connectr.instance.toolTipModel.removeTip(this);
      }
   }
}
