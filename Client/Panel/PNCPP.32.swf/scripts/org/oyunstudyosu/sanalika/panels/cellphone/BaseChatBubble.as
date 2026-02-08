package org.oyunstudyosu.sanalika.panels.cellphone
{
   import com.oyunstudyosu.utils.STextField;
   import flash.events.MouseEvent;
   import flash.system.System;
   import org.oyunstudyosu.components.CoreMovieClip;
   
   public class BaseChatBubble extends CoreMovieClip
   {
       
      
      private var _message:String;
      
      public function BaseChatBubble()
      {
         super();
      }
      
      public function copyMessage(param1:STextField, param2:*) : void
      {
         this._message = param2;
         if(!param1.hasEventListener(MouseEvent.CLICK))
         {
            param1.addEventListener(MouseEvent.CLICK,this.copyMessageClicked);
         }
      }
      
      protected function copyMessageClicked(param1:MouseEvent) : void
      {
         System.setClipboard(this._message);
      }
   }
}
