package org.oyunstudyosu.sanalika.rooms.street02
{
   import com.oyunstudyosu.room.RoomLayer;
   import com.oyunstudyosu.sanalika.extension.Connectr;
   import com.oyunstudyosu.sanalika.interfaces.IGameModel;
   import flash.display.MovieClip;
   
   [Embed(source="/_assets/assets.swf", symbol="org.oyunstudyosu.sanalika.rooms.street02.bg")]
   public class bg extends RoomLayer
   {
       
      
      public var mcBillboard:MovieClip;
      
      public var mcSign:MovieClip;
      
      public var gameModel:IGameModel;
      
      public var snow:MovieClip;
      
      public var christmas:MovieClip;
      
      public var halloween:MovieClip;
      
      public var snowLand:MovieClip;
      
      public var fishes:MovieClip;
      
      public function bg()
      {
         super();
      }
      
      override public function init() : void
      {
         super.init();
         this.mcSign.gotoAndStop(Connectr.instance.gameModel.language);
         this.snow.visible = false;
         if(Connectr.instance.gameModel.roomTheme.indexOf("snow") > -1)
         {
            this.snow.visible = true;
         }
         this.snowLand.visible = false;
         this.fishes.visible = !this.snowLand.visible;
         this.christmas.visible = false;
         if(Connectr.instance.gameModel.roomTheme.indexOf("christmas") > -1)
         {
            this.christmas.visible = true;
         }
         this.halloween.visible = false;
         if(Connectr.instance.gameModel.roomTheme.indexOf("halloween") > -1)
         {
            this.halloween.visible = true;
         }
      }
      
      override public function dispose() : void
      {
         super.dispose();
      }
   }
}
