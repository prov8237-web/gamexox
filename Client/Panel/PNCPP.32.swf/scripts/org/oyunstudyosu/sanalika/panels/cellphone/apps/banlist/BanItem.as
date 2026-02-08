package org.oyunstudyosu.sanalika.panels.cellphone.apps.banlist
{
   import com.oyunstudyosu.utils.STextField;
   import com.oyunstudyosu.utils.TextFieldManager;
   import com.oyunstudyosu.utils.TimeConverter;
   import flash.display.MovieClip;
   import flash.text.TextField;
   import org.oyunstudyosu.components.CoreMovieClip;
   
   [Embed(source="/_assets/assets.swf", symbol="org.oyunstudyosu.sanalika.panels.cellphone.apps.banlist.BanItem")]
   public class BanItem extends CoreMovieClip
   {
       
      
      public var txtName:TextField;
      
      public var sName:STextField;
      
      public var banTypeIndicator:MovieClip;
      
      public var data:Object;
      
      public function BanItem()
      {
         super();
         if(this.sName == null)
         {
            this.sName = TextFieldManager.convertAsArabicTextField(this.getChildByName("txtName") as TextField,false);
         }
      }
      
      override public function added() : void
      {
         this.sName.text = TimeConverter.convertTimestampToString(this.data.startDate);
         this.banTypeIndicator.gotoAndStop(this.data.type);
         this.banTypeIndicator.mouseEnabled = false;
      }
      
      override public function removed() : void
      {
         this.data = null;
      }
   }
}
