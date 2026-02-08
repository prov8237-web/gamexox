package org.oyunstudyosu.sanalika.panels.cellphone.apps.support
{
   import com.oyunstudyosu.utils.STextField;
   import com.oyunstudyosu.utils.TextFieldManager;
   import flash.display.MovieClip;
   import flash.text.TextField;
   import org.oyunstudyosu.components.CoreMovieClip;
   
   [Embed(source="/_assets/assets.swf", symbol="org.oyunstudyosu.sanalika.panels.cellphone.apps.support.SupportMessage")]
   public class SupportMessage extends CoreMovieClip
   {
       
      
      public var msg:TextField;
      
      public var sName:STextField;
      
      public var message:String;
      
      public var bg:MovieClip;
      
      public function SupportMessage()
      {
         super();
         if(this.sName == null)
         {
            this.sName = TextFieldManager.convertAsArabicTextField(this.getChildByName("msg") as TextField,true,false);
         }
      }
      
      override public function added() : void
      {
      }
      
      override public function removed() : void
      {
         this.sName = null;
         this.message = null;
      }
   }
}
