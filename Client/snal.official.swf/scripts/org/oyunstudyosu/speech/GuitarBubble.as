package org.oyunstudyosu.speech
{
   import flash.display.MovieClip;
   import flash.text.TextField;
   
   [Embed(source="/_assets/assets.swf", symbol="org.oyunstudyosu.speech.GuitarBubble")]
   public dynamic class GuitarBubble extends MovieClip
   {
       
      
      public var bg:MovieClip;
      
      public var effect:MovieClip;
      
      public var speechTxt:TextField;
      
      public var tip:MovieClip;
      
      public function GuitarBubble()
      {
         super();
      }
   }
}
