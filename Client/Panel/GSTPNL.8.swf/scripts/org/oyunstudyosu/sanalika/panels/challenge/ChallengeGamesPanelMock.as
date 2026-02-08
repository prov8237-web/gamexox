package org.oyunstudyosu.sanalika.panels.challenge
{
   import com.oyunstudyosu.sanalika.mock.IExtensionMock;
   import org.oyunstudyosu.sanalika.panels.challenge.enums.ChallengeServiceEnums;
   
   public class ChallengeGamesPanelMock implements IExtensionMock
   {
       
      
      public function ChallengeGamesPanelMock()
      {
         super();
      }
      
      public function requestData(param1:String, param2:Object) : Object
      {
         if(param1 == "start.game")
         {
            return {"data":{
               "questions":[{"question":"1 - [ 2 + 3 ] = "},{"question":"2  + [ 7 - 9 ]  = "},{"question":"3 - [ 1 - 5 ] + 5 = "},{"question":"4 - [ 3 - 8 ]  = "}],
               "options":[{"option":[3,5,7,9]},{"option":[7,22,35,65]},{"option":[9,25,63,79]},{"option":[4,6,85,27]}]
            }};
         }
         if(param1 == ChallengeServiceEnums.OPERATION_ANSWER)
         {
            return {"data":{
               "success":true,
               "qId":Math.floor(Math.random() * 4)
            }};
         }
         if(param1 == ChallengeServiceEnums.FLICK_MASTER_ANSWER)
         {
            return {"data":{
               "success":true,
               "qId":Math.floor(Math.random() * 6)
            }};
         }
         if(param1 == ChallengeServiceEnums.RPS_ANSWER)
         {
            return {"data":{
               "success":true,
               "qId":Math.floor(Math.random() * 6)
            }};
         }
         if(param1 == ChallengeServiceEnums.TEXT_MATCHING_ANSWER)
         {
            return {"data":{
               "success":true,
               "qId":Math.floor(Math.random() * 7)
            }};
         }
         if(param1 == ChallengeServiceEnums.HIGH_OR_LOW_ANSWER)
         {
            return {"data":{
               "success":true,
               "question":Math.floor(Math.random() * 99) + 1
            }};
         }
         if(param1 == ChallengeServiceEnums.TAP_COLOR_ANSWER)
         {
            return {"data":{
               "success":true,
               "qId":Math.floor(Math.random() * 2)
            }};
         }
         if(param1 == ChallengeServiceEnums.SIMPLICITY_ANSWER)
         {
            return {"data":{
               "success":true,
               "qId":Math.floor(Math.random() * 4)
            }};
         }
         return null;
      }
      
      public function getInitData() : Object
      {
         return {"name":"ChallengeGamesPanel"};
      }
      
      public function dispatchExtension(param1:uint) : Object
      {
         return null;
      }
   }
}
