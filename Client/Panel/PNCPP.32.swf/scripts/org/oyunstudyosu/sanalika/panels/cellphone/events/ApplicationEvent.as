package org.oyunstudyosu.sanalika.panels.cellphone.events
{
   import flash.events.Event;
   import org.oyunstudyosu.sanalika.panels.cellphone.CellPhoneApplication;
   import org.oyunstudyosu.sanalika.panels.cellphone.icons.BaseIcon;
   
   public class ApplicationEvent extends Event
   {
      
      public static const SHOW_APPLICATION:String = "ApplicationEvent.SHOW_APPLICATION";
      
      public static const CLOSE_APPLICATION:String = "ApplicationEvent.CLOSE_APPLICATION";
       
      
      public var app:CellPhoneApplication;
      
      public var icon:BaseIcon;
      
      public function ApplicationEvent(param1:String, param2:CellPhoneApplication = null, param3:BaseIcon = null)
      {
         if(param1 == SHOW_APPLICATION)
         {
            this.app = param2;
            this.icon = param3;
         }
         super(param1);
      }
   }
}
