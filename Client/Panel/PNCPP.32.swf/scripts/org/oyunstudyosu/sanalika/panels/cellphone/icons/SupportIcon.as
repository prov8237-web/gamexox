package org.oyunstudyosu.sanalika.panels.cellphone.icons
{
   import com.oyunstudyosu.events.Dispatcher;
   import flash.display.MovieClip;
   import org.oyunstudyosu.sanalika.panels.cellphone.apps.support.SupportApplication;
   import org.oyunstudyosu.sanalika.panels.cellphone.events.ApplicationEvent;
   
   [Embed(source="/_assets/assets.swf", symbol="org.oyunstudyosu.sanalika.panels.cellphone.icons.SupportIcon")]
   public class SupportIcon extends BaseIcon
   {
       
      
      public var appIcon:MovieClip;
      
      private var app:SupportApplication;
      
      public function SupportIcon()
      {
         super();
      }
      
      override protected function init() : void
      {
         this.app = new SupportApplication();
      }
      
      override protected function clicked() : void
      {
         Dispatcher.dispatchEvent(new ApplicationEvent(ApplicationEvent.SHOW_APPLICATION,this.app,this));
      }
   }
}
