package org.oyunstudyosu.sanalika.panels.cellphone.icons
{
   import com.oyunstudyosu.events.Dispatcher;
   import flash.display.MovieClip;
   import org.oyunstudyosu.sanalika.panels.cellphone.apps.runwin.RunWinApplication;
   import org.oyunstudyosu.sanalika.panels.cellphone.events.ApplicationEvent;
   
   [Embed(source="/_assets/assets.swf", symbol="org.oyunstudyosu.sanalika.panels.cellphone.icons.RunWinIcon")]
   public class RunWinIcon extends BaseIcon
   {
       
      
      public var appIcon:MovieClip;
      
      private var app:RunWinApplication;
      
      public function RunWinIcon()
      {
         super();
      }
      
      override protected function init() : void
      {
         this.app = new RunWinApplication();
      }
      
      override protected function clicked() : void
      {
         Dispatcher.dispatchEvent(new ApplicationEvent(ApplicationEvent.SHOW_APPLICATION,this.app,this));
      }
   }
}
