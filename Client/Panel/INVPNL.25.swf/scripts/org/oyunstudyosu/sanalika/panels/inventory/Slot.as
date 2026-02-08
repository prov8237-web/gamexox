package org.oyunstudyosu.sanalika.panels.inventory
{
   import com.oyunstudyosu.inventory.Item;
   import com.oyunstudyosu.utils.TextFieldManager;
   import flash.display.MovieClip;
   import flash.text.TextField;
   
   [Embed(source="/_assets/assets.swf", symbol="org.oyunstudyosu.sanalika.panels.inventory.Slot")]
   public class Slot extends MovieClip
   {
       
      
      public var bg:MovieClip;
      
      public var quantity:MovieClip;
      
      public var quantityTextField:TextField;
      
      public var id:int;
      
      public var clip:MovieClip;
      
      public var item:Item;
      
      public var holder:MovieClip;
      
      public var bar:MovieClip;
      
      public var barbg:MovieClip;
      
      public function Slot()
      {
         super();
         if(this.quantityTextField == null)
         {
            this.quantityTextField = TextFieldManager.createNoneLanguageTextfield(this.quantity.getChildByName("lbl") as TextField);
         }
      }
   }
}
