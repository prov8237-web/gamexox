package org.oyunstudyosu.sanalika.panels.cellphone.icons
{
   import com.oyunstudyosu.events.Dispatcher;
   import flash.display.MovieClip;
   import org.oyunstudyosu.sanalika.panels.cellphone.apps.questlist.QuestListApplication;
   import org.oyunstudyosu.sanalika.panels.cellphone.events.ApplicationEvent;
   
   [Embed(source="/_assets/assets.swf", symbol="org.oyunstudyosu.sanalika.panels.cellphone.icons.QuestListIcon")]
   public class QuestListIcon extends BaseIcon
   {
       
      
      public var appIcon:MovieClip;
      
      private var app:QuestListApplication;
      
      public function QuestListIcon()
      {
         super();
      }
      
      override protected function init() : void
      {
         this.app = new QuestListApplication();
      }
      
      override protected function clicked() : void
      {
         Dispatcher.dispatchEvent(new ApplicationEvent(ApplicationEvent.SHOW_APPLICATION,this.app,this));
      }
   }
}
