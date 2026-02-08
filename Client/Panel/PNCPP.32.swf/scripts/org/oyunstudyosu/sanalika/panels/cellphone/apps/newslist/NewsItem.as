package org.oyunstudyosu.sanalika.panels.cellphone.apps.newslist
{
   import com.oyunstudyosu.utils.STextField;
   import com.oyunstudyosu.utils.TextFieldManager;
   import flash.display.MovieClip;
   import flash.text.TextField;
   import org.oyunstudyosu.components.CoreMovieClip;
   
   [Embed(source="/_assets/assets.swf", symbol="org.oyunstudyosu.sanalika.panels.cellphone.apps.newslist.NewsItem")]
   public class NewsItem extends CoreMovieClip
   {
       
      
      public var txtName:TextField;
      
      public var sName:STextField;
      
      public var statusIndicator:MovieClip;
      
      public var indicator:MovieClip;
      
      public var data:Object;
      
      public function NewsItem()
      {
         super();
         if(this.sName == null)
         {
            this.sName = TextFieldManager.convertAsArabicTextField(this.getChildByName("txtName") as TextField,false);
         }
      }
      
      override public function added() : void
      {
         this.sName.text = this.data.title;
      }
      
      override public function removed() : void
      {
         this.data = null;
      }
   }
}
