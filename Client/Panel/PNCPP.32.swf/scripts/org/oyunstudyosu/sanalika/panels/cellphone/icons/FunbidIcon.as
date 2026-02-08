package org.oyunstudyosu.sanalika.panels.cellphone.icons
{
   import com.oyunstudyosu.events.Dispatcher;
   import flash.display.MovieClip;
   import org.oyunstudyosu.sanalika.panels.cellphone.apps.funbid.FunbidApplication;
   import org.oyunstudyosu.sanalika.panels.cellphone.events.ApplicationEvent;
   
   [Embed(source="/_assets/assets.swf", symbol="org.oyunstudyosu.sanalika.panels.cellphone.icons.FunbidIcon")]
   public class FunbidIcon extends BaseIcon
   {
       
      
      public var appIcon:MovieClip;
      
      private var app:FunbidApplication;
      
      public function FunbidIcon()
      {
         super();
      }
      
      override protected function init() : void
      {
         this.app = new FunbidApplication();
      }
      
      override protected function clicked() : void
      {
         Dispatcher.dispatchEvent(new ApplicationEvent(ApplicationEvent.SHOW_APPLICATION,this.app,this));
      }
   }
}
