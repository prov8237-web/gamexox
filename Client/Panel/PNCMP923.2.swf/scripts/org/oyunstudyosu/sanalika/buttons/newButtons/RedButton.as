package org.oyunstudyosu.sanalika.buttons.newButtons
{
   import com.oyunstudyosu.components.DynamicSanalikaButton;
   import flash.text.TextField;
   
   [Embed(source="/_assets/assets.swf", symbol="org.oyunstudyosu.sanalika.buttons.newButtons.RedButton")]
   public class RedButton extends DynamicSanalikaButton
   {
       
      
      public var lbl_Button:TextField;
      
      public function RedButton()
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
