package org.oyunstudyosu.sanalika.panels.cellphone.apps.support
{
   import flash.display.MovieClip;
   import flash.display.SimpleButton;
   import flash.text.TextField;
   import org.oyunstudyosu.components.CoreMovieClip;
   
   [Embed(source="/_assets/assets.swf", symbol="org.oyunstudyosu.sanalika.panels.cellphone.apps.support.SupportNew")]
   public class SupportNew extends CoreMovieClip
   {
       
      
      public var id:int;
      
      public var message:String;
      
      public var bg:MovieClip;
      
      public var btnSend:SimpleButton;
      
      public var inpNew:TextField;
      
      public function SupportNew()
      {
         super();
         this.inpNew.maxChars = 250;
      }
      
      override public function removed() : void
      {
         this.message = null;
      }
   }
}
