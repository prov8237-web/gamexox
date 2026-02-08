package org.oyunstudyosu.sanalika.buttons.newButtons
{
   import com.oyunstudyosu.components.DynamicSanalikaButton;
   import flash.display.MovieClip;
   import flash.text.TextField;
   
   [Embed(source="/_assets/assets.swf", symbol="org.oyunstudyosu.sanalika.buttons.newButtons.BuyVipDiamondButton")]
   public class BuyVipDiamondButton extends DynamicSanalikaButton
   {
       
      
      public var lbl_Button:TextField;
      
      public var icon:MovieClip;
      
      public function BuyVipDiamondButton()
      {
         super();
         addFrameScript(0,this.frame1);
      }
      
      internal function frame1() : *
      {
         stop();
      }
   }
}
