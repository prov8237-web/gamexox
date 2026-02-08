package org.oyunstudyosu.sanalika.panels.cellphone.apps.privatechat
{
   import com.oyunstudyosu.utils.STextField;
   import com.oyunstudyosu.utils.TextFieldManager;
   import flash.text.TextField;
   import org.oyunstudyosu.components.CoreMovieClip;
   
   [Embed(source="/_assets/assets.swf", symbol="org.oyunstudyosu.sanalika.panels.cellphone.apps.privatechat.BuddyHeader")]
   public class BuddyHeader extends CoreMovieClip
   {
       
      
      public var headerTxt:TextField;
      
      private var title:String;
      
      public var headerTextField:STextField;
      
      public function BuddyHeader(param1:String)
      {
         super();
         this.title = param1;
      }
      
      override public function added() : void
      {
         if(this.headerTextField == null)
         {
            this.headerTextField = TextFieldManager.convertAsArabicTextField(this.getChildByName("headerTxt") as TextField,false);
         }
         this.headerTextField.text = this.title;
      }
   }
}
