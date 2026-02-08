package org.oyunstudyosu.game.partyisland
{
   import flash.display.MovieClip;
   import flash.text.TextField;
   
   [Embed(source="/_assets/assets.swf", symbol="org.oyunstudyosu.game.partyisland.LobbyUITimer")]
   public class LobbyUITimer extends MovieClip
   {
       
      
      public var txtTimer:TextField;
      
      public function LobbyUITimer()
      {
         super();
      }
   }
}
