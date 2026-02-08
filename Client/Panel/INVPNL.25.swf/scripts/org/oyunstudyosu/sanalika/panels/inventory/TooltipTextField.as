package org.oyunstudyosu.sanalika.panels.inventory
{
   import com.oyunstudyosu.utils.STextField;
   import com.oyunstudyosu.utils.TextFieldManager;
   import flash.text.TextField;
   import org.oyunstudyosu.components.CoreMovieClip;
   
   [Embed(source="/_assets/assets.swf", symbol="org.oyunstudyosu.sanalika.panels.inventory.TooltipTextField")]
   public class TooltipTextField extends CoreMovieClip
   {
       
      
      public var txt:TextField;
      
      public var sText:STextField;
      
      public function TooltipTextField()
      {
         super();
         if(this.sText == null)
         {
            this.sText = TextFieldManager.convertAsArabicTextField(this.getChildByName("txt") as TextField,true,false);
         }
      }
   }
}
