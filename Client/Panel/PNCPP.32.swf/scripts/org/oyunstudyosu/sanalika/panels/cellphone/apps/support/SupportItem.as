package org.oyunstudyosu.sanalika.panels.cellphone.apps.support
{
   import com.oyunstudyosu.local.$;
   import com.oyunstudyosu.utils.STextField;
   import com.oyunstudyosu.utils.TextFieldManager;
   import flash.display.MovieClip;
   import flash.text.TextField;
   import org.oyunstudyosu.components.CoreMovieClip;
   
   [Embed(source="/_assets/assets.swf", symbol="org.oyunstudyosu.sanalika.panels.cellphone.apps.support.SupportItem")]
   public class SupportItem extends CoreMovieClip
   {
       
      
      public var txtName:TextField;
      
      public var sName:STextField;
      
      public var typeIndicator:MovieClip;
      
      public var id:int;
      
      public var data:Object;
      
      public function SupportItem()
      {
         super();
         if(this.sName == null)
         {
            this.sName = TextFieldManager.convertAsArabicTextField(this.getChildByName("txtName") as TextField,false);
         }
      }
      
      override public function added() : void
      {
         this.sName.text = $(this.data.supportSubject);
         this.typeIndicator.gotoAndStop(this.data.state);
         this.typeIndicator.mouseEnabled = false;
      }
      
      override public function removed() : void
      {
         this.sName = null;
         this.data = null;
      }
   }
}
