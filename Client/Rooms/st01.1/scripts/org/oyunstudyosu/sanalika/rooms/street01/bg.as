package org.oyunstudyosu.sanalika.rooms.street01
{
   import com.oyunstudyosu.room.RoomLayer;
   import com.oyunstudyosu.sanalika.extension.Connectr;
   import com.oyunstudyosu.sanalika.interfaces.IGameModel;
   import flash.display.MovieClip;
   
   [Embed(source="/_assets/assets.swf", symbol="org.oyunstudyosu.sanalika.rooms.street01.bg")]
   public class bg extends RoomLayer
   {
       
      
      public var mcBillboard:MovieClip;
      
      public var playerWidth:int = 170;
      
      public var playerHeight:int = 68;
      
      public var mcSign:MovieClip;
      
      public var gameModel:IGameModel;
      
      public var snow:MovieClip;
      
      public var christmas:MovieClip;
      
      public var halloween:MovieClip;
      
      public var MartiDuz02:MovieClip;
      
      public function bg()
      {
         super();
      }
      
      override public function init() : void
      {
         super.init();
         this.mcSign.gotoAndStop(Connectr.instance.gameModel.language);
         this.snow.visible = false;
         this.christmas.visible = false;
         this.halloween.visible = false;
         if(Connectr.instance.gameModel.roomTheme.indexOf("snow") > -1)
         {
            this.snow.visible = true;
         }
         if(Connectr.instance.gameModel.roomTheme.indexOf("christmas") > -1)
         {
            this.christmas.visible = true;
         }
         if(Connectr.instance.gameModel.roomTheme.indexOf("halloween") > -1)
         {
            this.halloween.visible = true;
         }
         if(!this.MartiDuz02)
         {
         }
      }
      
      override public function dispose() : void
      {
         super.dispose();
      }
   }
}
