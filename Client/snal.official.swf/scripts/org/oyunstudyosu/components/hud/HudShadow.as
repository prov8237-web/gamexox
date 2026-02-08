package org.oyunstudyosu.components.hud
{
   import org.oyunstudyosu.components.CoreMovieClip;
   
   [Embed(source="/_assets/assets.swf", symbol="org.oyunstudyosu.components.hud.HudShadow")]
   public class HudShadow extends CoreMovieClip
   {
       
      
      public function HudShadow()
      {
         super();
         visible = false;
      }
   }
}
