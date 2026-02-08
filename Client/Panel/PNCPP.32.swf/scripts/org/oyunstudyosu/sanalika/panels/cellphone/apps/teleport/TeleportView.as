package org.oyunstudyosu.sanalika.panels.cellphone.apps.teleport
{
   import com.oyunstudyosu.alert.AlertEvent;
   import com.oyunstudyosu.enums.RequestDataKey;
   import com.oyunstudyosu.events.Dispatcher;
   import com.oyunstudyosu.sanalika.extension.Connectr;
   import flash.display.MovieClip;
   import flash.events.MouseEvent;
   import org.oyunstudyosu.components.CoreMovieClip;
   import org.oyunstudyosu.sanalika.panels.cellphone.events.ApplicationEvent;
   
   public class TeleportView extends CoreMovieClip
   {
       
      
      public var street01:MovieClip;
      
      public var street06:MovieClip;
      
      public var street08:MovieClip;
      
      public var street10:MovieClip;
      
      public var street12:MovieClip;
      
      public var olimpos01:MovieClip;
      
      public function TeleportView()
      {
         super();
      }
      
      override public function added() : void
      {
         this.changeVar();
      }
      
      public function changeVar() : void
      {
         this.street01.addEventListener(MouseEvent.CLICK,this.onTeleport);
         this.street06.addEventListener(MouseEvent.CLICK,this.onTeleport);
         this.street08.addEventListener(MouseEvent.CLICK,this.onTeleport);
         this.street10.addEventListener(MouseEvent.CLICK,this.onTeleport);
         this.street12.addEventListener(MouseEvent.CLICK,this.onTeleport);
         this.olimpos01.addEventListener(MouseEvent.CLICK,this.onTeleport);
         this.street01.buttonMode = this.street06.buttonMode = this.street08.buttonMode = this.street10.buttonMode = this.street12.buttonMode = this.olimpos01.buttonMode = true;
      }
      
      protected function btnAdClicked(param1:MouseEvent) : void
      {
      }
      
      private function onTeleport(param1:MouseEvent) : void
      {
         Dispatcher.dispatchEvent(new ApplicationEvent(ApplicationEvent.CLOSE_APPLICATION));
         Connectr.instance.serviceModel.requestData(RequestDataKey.TELEPORT,{"roomKey":param1.target.name},this.onTeleportResponse);
      }
      
      private function onTeleportResponse(param1:Object) : void
      {
         Connectr.instance.serviceModel.removeRequestData(RequestDataKey.TELEPORT,this.onTeleportResponse);
         if(param1.errorKey != undefined)
         {
            Dispatcher.dispatchEvent(new AlertEvent(param1.errorKey));
         }
         Connectr.instance.roomModel.checkMap(param1);
      }
   }
}
