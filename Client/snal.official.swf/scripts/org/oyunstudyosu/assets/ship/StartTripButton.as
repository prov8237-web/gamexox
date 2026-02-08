package org.oyunstudyosu.assets.ship
{
   import com.oyunstudyosu.components.DynamicSanalikaButton;
   import flash.text.TextField;
   
   [Embed(source="/_assets/assets.swf", symbol="org.oyunstudyosu.assets.ship.StartTripButton")]
   public class StartTripButton extends DynamicSanalikaButton
   {
       
      
      public var lbl_Button:TextField;
      
      public function StartTripButton()
      {
         super();
      }
   }
}
