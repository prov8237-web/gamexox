package org.oyunstudyosu.sanalika.rooms.street02
{
   import com.oyunstudyosu.room.RoomLayer;
   import flash.display.MovieClip;
   import flash.events.MouseEvent;
   
   [Embed(source="/_assets/assets.swf", symbol="org.oyunstudyosu.sanalika.rooms.street02.ceiling")]
   public class ceiling extends RoomLayer
   {
       
      
      public var d1:MovieClip;
      
      public var d2:MovieClip;
      
      public var d3:MovieClip;
      
      public var d4:MovieClip;
      
      public var d5:MovieClip;
      
      public var d6:MovieClip;
      
      public var d7:MovieClip;
      
      public var campaignButton:MovieClip;
      
      public function ceiling()
      {
         super();
      }
      
      override public function init() : void
      {
         super.init();
      }
      
      protected function campaignButtonClicked(param1:MouseEvent) : void
      {
      }
      
      private function sutasQuestResponse(param1:Object) : void
      {
      }
      
      override public function dispose() : void
      {
         super.dispose();
      }
   }
}
