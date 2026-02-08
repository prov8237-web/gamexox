package org.oyunstudyosu.sanalika.buttons.newButtons
{
   import com.oyunstudyosu.components.DynamicSanalikaButton;
   import com.oyunstudyosu.utils.STextField;
   import flash.display.MovieClip;
   import flash.text.TextField;
   
   [Embed(source="/_assets/assets.swf", symbol="org.oyunstudyosu.sanalika.buttons.newButtons.AchievementGiftButton")]
   public class AchievementGiftButton extends DynamicSanalikaButton
   {
       
      
      public var lbl_Button:TextField;
      
      public var sText:STextField;
      
      public var dark:MovieClip;
      
      public function AchievementGiftButton()
      {
         super();
      }
   }
}
