package org.oyunstudyosu.speech
{
   import flash.display.MovieClip;
   import flash.text.TextField;
   
   [Embed(source="/_assets/assets.swf", symbol="org.oyunstudyosu.speech.BirdWing")]
   public dynamic class BirdWing extends MovieClip
   {
       
      
      public var bg:MovieClip;
      
      public var effect:MovieClip;
      
      public var speechTxt:TextField;
      
      public var tip:MovieClip;
      
      public function BirdWing()
      {
         super();
      }
   }
}
