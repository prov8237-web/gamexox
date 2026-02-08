package org.oyunstudyosu.game.partyisland
{
   import flash.display.MovieClip;
   import flash.text.TextField;
   
   [Embed(source="/_assets/assets.swf", symbol="org.oyunstudyosu.game.partyisland.NotifyItem")]
   public dynamic class NotifyItem extends MovieClip
   {
       
      
      public var txtMsg:TextField;
      
      public function NotifyItem()
      {
         super();
      }
   }
}
