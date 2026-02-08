package org.oyunstudyosu.sanalika.mock
{
   import com.oyunstudyosu.sanalika.mock.CharPreview;
   import flash.display.MovieClip;
   import flash.events.EventDispatcher;
   
   public class ClothManager extends EventDispatcher
   {
       
      
      public function ClothManager()
      {
         super(null);
      }
      
      public function getNewCharPreview(param1:MovieClip) : CharPreview
      {
         return new CharPreview();
      }
   }
}
