package org.oyunstudyosu.components.hud.menu
{
   import flash.display.MovieClip;
   
   [Embed(source="/_assets/assets.swf", symbol="org.oyunstudyosu.components.hud.menu.SettingsButton")]
   public class SettingsButton extends MainHudButton
   {
       
      
      public var hitMc:MovieClip;
      
      public var arrow:MovieClip;
      
      public function SettingsButton()
      {
         super();
      }
      
      override protected function added() : void
      {
      }
      
      override protected function clicked() : void
      {
      }
      
      override protected function removed() : void
      {
      }
   }
}
