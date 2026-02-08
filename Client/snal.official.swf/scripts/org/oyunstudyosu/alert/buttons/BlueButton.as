package org.oyunstudyosu.alert.buttons
{
   import com.oyunstudyosu.components.DynamicSanalikaButton;
   import flash.text.TextField;
   
   [Embed(source="/_assets/assets.swf", symbol="org.oyunstudyosu.alert.buttons.BlueButton")]
   public class BlueButton extends DynamicSanalikaButton
   {
       
      
      public var lbl_Button:TextField;
      
      public function BlueButton()
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
