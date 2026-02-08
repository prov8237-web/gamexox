package org.oyunstudyosu.sanalika.panels.cellphone.icons
{
   import com.oyunstudyosu.events.Dispatcher;
   import flash.display.MovieClip;
   import org.oyunstudyosu.sanalika.panels.cellphone.apps.privatechat.PrivateChatApplication;
   import org.oyunstudyosu.sanalika.panels.cellphone.events.ApplicationEvent;
   
   [Embed(source="/_assets/assets.swf", symbol="org.oyunstudyosu.sanalika.panels.cellphone.icons.PrivateChatIcon")]
   public class PrivateChatIcon extends BaseIcon
   {
       
      
      public var appIcon:MovieClip;
      
      private var app:PrivateChatApplication;
      
      public function PrivateChatIcon()
      {
         super();
      }
      
      override protected function init() : void
      {
         this.app = new PrivateChatApplication();
      }
      
      override protected function clicked() : void
      {
         Dispatcher.dispatchEvent(new ApplicationEvent(ApplicationEvent.SHOW_APPLICATION,this.app,this));
      }
   }
}
