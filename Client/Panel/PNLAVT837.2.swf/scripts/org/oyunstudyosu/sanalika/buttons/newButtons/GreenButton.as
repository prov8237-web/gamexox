package org.oyunstudyosu.sanalika.buttons.newButtons
{
   import com.oyunstudyosu.components.DynamicSanalikaButton;
   import flash.display.MovieClip;
   import flash.text.TextField;
   
   [Embed(source="/_assets/assets.swf", symbol="org.oyunstudyosu.sanalika.buttons.newButtons.GreenButton")]
   public class GreenButton extends DynamicSanalikaButton
   {
       
      
      public var bg:MovieClip;
      
      public var lbl_Button:TextField;
      
      public function GreenButton()
      {
         super();
      }
   }
}
