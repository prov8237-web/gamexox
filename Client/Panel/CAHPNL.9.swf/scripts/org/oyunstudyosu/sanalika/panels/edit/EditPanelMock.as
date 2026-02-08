package org.oyunstudyosu.sanalika.panels.edit
{
   import com.oyunstudyosu.panel.PanelType;
   import com.oyunstudyosu.panel.PanelVO;
   import com.oyunstudyosu.sanalika.mock.IExtensionMock;
   import com.smartfoxserver.v2.SmartFox;
   
   public class EditPanelMock implements IExtensionMock
   {
       
      
      public function EditPanelMock()
      {
         super();
      }
      
      public function requestData(param1:String, param2:Object) : Object
      {
         var _loc3_:Object = null;
         if(param1 == "master.getdoor")
         {
            _loc3_ = {"door":{
               "active":true,
               "targetX":38,
               "roomKey":"street01",
               "primary":false,
               "targetY":23,
               "key":"d3",
               "targetDir":7,
               "property":{
                  "doorKey":"d1",
                  "cn":"RoomPanelProperty",
                  "key":"RoomListPanel",
                  "location":5
               }
            }};
            return {"data":_loc3_};
         }
         if(param1 == "master.roomdoorlist")
         {
            return {"data":{"list":["d1","d3","d3","d4"]}};
         }
         if(param1 == "master.roomlist")
         {
            return {"data":{"list":["academy","academyCanteen","academyClass","academyLab","albusLobby","anemon","bank","billiards","botanika","bowling","bungalow","burgerika","cafeMarina","cafetoria","cafetoriaWc","calleComercio","calledelSol","calleMarina01","calleMarina02","candyShop","carpeModo","carshop","cinema","cinemaSaloon","clubBuilding","comedy","diamondHairdresser","districtOne","dresser","engineRoom","exhibition","farEast01","farEast02","farEast03","farEast04","fashionHouse","ferryboat","fitness","fortuneTeller","goldenHorseHotelLobby","goldenHorseHotelPool","grocery","hairdresser","hairFair","hallofFame","hatShop","hotelLobby","iceAge01","iceAge02","iceRink","juguete","klakk","klinika","lazBakkalFarm","library","lootALot","lubnanRestaurant","market","mediaCenterLobby","mediaCenterMeetingRoom","mediaCenterRadio","modShop","monitte","monitteLounge","municipality","musicMarket","nautilusPier","nautilusShip","olimpos01","olimpos02","olimpos03","olimpos04","olimpos05","olimpos06","olimpos07","olimpos08","olimpos09","olimpos10","olimpos10Ramadan","olimposMetro","olimposPier","olimposPirate","optika","ottomanHairdresser","ottomanTent","petshop","pharmacy","pier","plazaMayor","plazaMayorNorte","plazaMayorSur","presidency","retroCafe","blueCafe","realEstate","restaurant","secondHandShop","snowWorld01","snowWorld02","space","spaceShip","sportika","startpoint","stockMarket","street01","street02","street03","street04","street05","street05Metro","street06","street07","street08","street09","street10","street11","street12","street13","studio","styleDome","swamp","titanicaPier","vipPool","toyStore","yosunLobby"]}};
         }
         if(param1 == "master.botlist")
         {
            return {"data":{"list":["ahmet","bengu","hasan","sakir","otobus","minibus"]}};
         }
         if(param1 == "master.panelist")
         {
            return {"data":{"list":["AlertPanel","GamePanel"]}};
         }
         if(param1 == "master.locationlist")
         {
            return {"data":{"list":[1,4,400,100,500]}};
         }
         return null;
      }
      
      public function getInitData() : Object
      {
         var _loc1_:Object = {};
         _loc1_.servicename = "bot";
         _loc1_.serviceparams = {"roomKey":"street02"};
         _loc1_.servicetype = "add";
         _loc1_.title = "Panel";
         return new PanelVO("EditPanel",PanelType.ROOM,_loc1_);
      }
      
      public function getExtensionResponse(param1:uint, param2:SmartFox) : void
      {
      }
      
      public function dispatchExtension(param1:uint) : Object
      {
         return null;
      }
   }
}
