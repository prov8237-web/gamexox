package org.oyunstudyosu.sanalika.panels.cellphone.icons
{
   import com.oyunstudyosu.events.Dispatcher;
   import flash.display.MovieClip;
   import org.oyunstudyosu.sanalika.panels.cellphone.apps.newslist.NewsListApplication;
   import org.oyunstudyosu.sanalika.panels.cellphone.events.ApplicationEvent;
   
   [Embed(source="/_assets/assets.swf", symbol="org.oyunstudyosu.sanalika.panels.cellphone.icons.NewsListIcon")]
   public class NewsListIcon extends BaseIcon
   {
       
      
      public var appIcon:MovieClip;
      
      private var app:NewsListApplication;
      
      public function NewsListIcon()
      {
         super();
      }
      
      override protected function init() : void
      {
         this.app = new NewsListApplication();
      }
      
      override protected function clicked() : void
      {
         Dispatcher.dispatchEvent(new ApplicationEvent(ApplicationEvent.SHOW_APPLICATION,this.app,this));
      }
   }
}
