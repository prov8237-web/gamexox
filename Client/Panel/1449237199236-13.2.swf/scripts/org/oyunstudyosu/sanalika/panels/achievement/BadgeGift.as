package org.oyunstudyosu.sanalika.panels.achievement
{
   import com.oyunstudyosu.local.$;
   import com.oyunstudyosu.sanalika.extension.Connectr;
   import flash.text.TextField;
   
   [Embed(source="/_assets/assets.swf", symbol="org.oyunstudyosu.sanalika.panels.achievement.BadgeGift")]
   public class BadgeGift extends AchievementGift
   {
       
      
      public var infoTxt:TextField;
      
      public function BadgeGift()
      {
         super();
      }
      
      override public function process(param1:Object) : void
      {
         super.process(param1);
         var _loc2_:String = $("pro_" + param1.clip);
         Connectr.instance.toolTipModel.addTip(this,_loc2_);
         infoTextField.text = $("BADGE");
         infoTextField.width = 52;
      }
      
      override public function dispose() : void
      {
         Connectr.instance.toolTipModel.removeTip(this);
      }
   }
}
