package org.oyunstudyosu.sanalika.panels.cellphone.icons
{
   import com.oyunstudyosu.events.Dispatcher;
   import flash.display.MovieClip;
   import org.oyunstudyosu.sanalika.panels.cellphone.apps.funwin.FunwinApplication;
   import org.oyunstudyosu.sanalika.panels.cellphone.events.ApplicationEvent;
   
   [Embed(source="/_assets/assets.swf", symbol="org.oyunstudyosu.sanalika.panels.cellphone.icons.FunwinIcon")]
   public class FunwinIcon extends BaseIcon
   {
       
      
      public var appIcon:MovieClip;
      
      private var app:FunwinApplication;
      
      public function FunwinIcon()
      {
         super();
      }
      
      override protected function init() : void
      {
         this.app = new FunwinApplication();
      }
      
      override protected function clicked() : void
      {
         Dispatcher.dispatchEvent(new ApplicationEvent(ApplicationEvent.SHOW_APPLICATION,this.app,this));
      }
   }
}
