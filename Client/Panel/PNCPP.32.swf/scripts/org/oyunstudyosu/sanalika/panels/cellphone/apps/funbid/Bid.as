package org.oyunstudyosu.sanalika.panels.cellphone.apps.funbid
{
   import com.oyunstudyosu.local.$;
   import flash.display.MovieClip;
   import flash.events.MouseEvent;
   import flash.text.TextField;
   import org.oyunstudyosu.sanalika.buttons.newButtons.RedButton;
   
   [Embed(source="/_assets/assets.swf", symbol="org.oyunstudyosu.sanalika.panels.cellphone.apps.funbid.Bid")]
   public class Bid extends MovieClip
   {
       
      
      public var btnBid:RedButton;
      
      public var inpField:TextField;
      
      public function Bid()
      {
         super();
         this.visible = false;
      }
      
      public function init() : void
      {
         this.inpField.restrict = "0-9";
         this.inpField.text = "";
         this.btnBid.addEventListener(MouseEvent.CLICK,this.bidClicked);
         this.enableButton();
         this.visible = true;
      }
      
      private function bidClicked(param1:MouseEvent) : void
      {
         var _loc2_:int = int(this.inpField.text);
         if(_loc2_ > 0)
         {
            this.btnBid.mouseEnabled = false;
            this.btnBid.buttonMode = false;
            this.btnBid.setText(Sanalika.instance.localizationModel.translate("offered"));
            (parent as FunbidView).bid(_loc2_);
         }
      }
      
      public function disableButton() : void
      {
         this.btnBid.mouseEnabled = false;
         this.btnBid.buttonMode = false;
      }
      
      public function enableButton() : void
      {
         this.btnBid.mouseEnabled = true;
         this.btnBid.buttonMode = true;
         this.btnBid.setText($("OFFER"));
      }
      
      public function dispose() : void
      {
         this.visible = false;
         this.btnBid.removeEventListener(MouseEvent.CLICK,this.bidClicked);
      }
   }
}
