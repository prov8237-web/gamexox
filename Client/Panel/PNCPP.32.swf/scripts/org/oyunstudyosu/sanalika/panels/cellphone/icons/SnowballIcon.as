package org.oyunstudyosu.sanalika.panels.cellphone.icons
{
   import com.oyunstudyosu.events.Dispatcher;
   import flash.display.MovieClip;
   import org.oyunstudyosu.sanalika.panels.cellphone.apps.snowball.SnowballApplication;
   import org.oyunstudyosu.sanalika.panels.cellphone.events.ApplicationEvent;
   
   [Embed(source="/_assets/assets.swf", symbol="org.oyunstudyosu.sanalika.panels.cellphone.icons.SnowballIcon")]
   public class SnowballIcon extends BaseIcon
   {
       
      
      public var appIcon:MovieClip;
      
      private var app:SnowballApplication;
      
      public function SnowballIcon()
      {
         super();
      }
      
      override protected function init() : void
      {
         this.app = new SnowballApplication();
      }
      
      override protected function clicked() : void
      {
         Dispatcher.dispatchEvent(new ApplicationEvent(ApplicationEvent.SHOW_APPLICATION,this.app,this));
      }
   }
}
