package org.oyunstudyosu.sanalika.panels.balloonGame
{
   import com.oyunstudyosu.panel.PanelVO;
   import com.oyunstudyosu.sanalika.mock.IExtensionMock;
   import com.smartfoxserver.v2.entities.Room;
   import flash.ui.Keyboard;
   import org.oyunstudyosu.sanalika.panels.balloonGame.enums.BalloonServiceEnums;
   
   public class BalloonGamePanelMock implements IExtensionMock
   {
       
      
      private var room:Room;
      
      public function BalloonGamePanelMock()
      {
         super();
      }
      
      public function requestData(param1:String, param2:Object) : Object
      {
         if(param1 == "balloonGameJoin")
         {
            return {"data":{
               "roomName":"balloonRoom",
               "list":[{"nick":"emin"}]
            }};
         }
         return null;
      }
      
      public function getInitData() : Object
      {
         return new PanelVO("BalloonGamePanel","",{});
      }
      
      public function dispatchExtension(param1:uint) : Object
      {
         var _loc2_:Object = {};
         _loc2_.params = {};
         switch(param1)
         {
            case Keyboard.NUMBER_1:
               _loc2_.key = BalloonServiceEnums.START_BALLOON_GAME;
               return _loc2_;
            case Keyboard.NUMBER_2:
               _loc2_.key = BalloonServiceEnums.UPDATE_BALLOON_GAME;
               return _loc2_;
            case Keyboard.NUMBER_3:
               _loc2_.key = BalloonServiceEnums.NEW_WIND;
               _loc2_.params.windPos = Math.random() * 400 + 50;
               _loc2_.params.windSpeed = Math.random() * 10;
               return _loc2_;
            case Keyboard.NUMBER_2:
               _loc2_.key = BalloonServiceEnums.UPDATE_BALLOON_GAME;
               return _loc2_;
            default:
               return {};
         }
      }
   }
}
