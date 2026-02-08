package org.oyunstudyosu.sanalika.panels.cloth
{
   import com.oyunstudyosu.components.SanalikaButton;
   import com.oyunstudyosu.utils.TextFieldManager;
   import flash.display.MovieClip;
   import flash.text.TextField;
   
   [Embed(source="/_assets/assets.swf", symbol="org.oyunstudyosu.sanalika.panels.cloth.Slot")]
   public class Slot extends MovieClip
   {
       
      
      public var bar:MovieClip;
      
      public var barBg:MovieClip;
      
      public var bg:MovieClip;
      
      public var container:MovieClip;
      
      public var quantityTextField:TextField;
      
      public var quantity:MovieClip;
      
      public var barMask:MovieClip;
      
      public var closeButton:SanalikaButton;
      
      public var index:int;
      
      public var id:int;
      
      public var remove:int;
      
      public var def:String;
      
      public function Slot()
      {
         super();
         addFrameScript(0,this.frame1);
         if(this.quantityTextField == null)
         {
            this.quantityTextField = TextFieldManager.createNoneLanguageTextfield(this.quantity.getChildByName("lbl") as TextField);
         }
      }
      
      internal function frame1() : *
      {
         this.container.mouseEnabled = false;
      }
   }
}
