package org.oyunstudyosu.sanalika.panels.cellphone.apps.snowball
{
   import com.oyunstudyosu.events.Dispatcher;
   import com.oyunstudyosu.events.ProfileEvent;
   import com.oyunstudyosu.utils.STextField;
   import com.oyunstudyosu.utils.TextFieldManager;
   import flash.display.MovieClip;
   import flash.events.MouseEvent;
   import flash.text.TextField;
   import org.oyunstudyosu.components.CoreMovieClip;
   
   [Embed(source="/_assets/assets.swf", symbol="org.oyunstudyosu.sanalika.panels.cellphone.apps.snowball.TeamItem")]
   public class TeamItem extends CoreMovieClip
   {
       
      
      public var txtName:TextField;
      
      public var sName:STextField;
      
      public var statusIndicator:MovieClip;
      
      public var indicator:MovieClip;
      
      public var data:Object;
      
      public function TeamItem()
      {
         super();
         if(this.sName == null)
         {
            this.sName = TextFieldManager.convertAsArabicTextField(this.getChildByName("txtName") as TextField,false);
         }
      }
      
      override public function added() : void
      {
         this.sName.text = this.data.an;
         this.buttonMode = true;
         this.addEventListener(MouseEvent.CLICK,this.openProfile);
      }
      
      public function openProfile(param1:MouseEvent) : void
      {
         var _loc2_:ProfileEvent = new ProfileEvent(ProfileEvent.SHOW_PROFILE);
         _loc2_.avatarID = this.data.avatarID;
         Dispatcher.dispatchEvent(_loc2_);
      }
      
      override public function removed() : void
      {
         this.removeEventListener(MouseEvent.CLICK,this.openProfile);
         this.data = null;
      }
   }
}
