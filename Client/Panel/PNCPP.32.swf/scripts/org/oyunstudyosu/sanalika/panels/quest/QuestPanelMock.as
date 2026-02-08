package org.oyunstudyosu.sanalika.panels.quest
{
   import com.oyunstudyosu.enums.RequestDataKey;
   import com.oyunstudyosu.sanalika.mock.IExtensionMock;
   
   public class QuestPanelMock implements IExtensionMock
   {
       
      
      public function QuestPanelMock()
      {
         super();
      }
      
      public function requestData(param1:String, param2:Object) : Object
      {
         if(param1 == RequestDataKey.QUEST_DETAIL)
         {
            return {"data":{
               "id":131,
               "type":"PERIODIC",
               "metaKey":"p1",
               "state":"COMPLETE",
               "status":"ACTIVE",
               "tags":["NEW","VIP"],
               "expireTime":"3d",
               "steps":[{
                  "currentValue":5,
                  "requirementValue":5,
                  "isCompleted":true
               },{
                  "currentValue":0,
                  "requirementValue":3,
                  "isCompleted":false
               },{
                  "currentValue":0,
                  "requirementValue":4,
                  "isCompleted":false
               }],
               "rewards":[{
                  "type":"SANIL",
                  "data":{"amount":1000}
               },{
                  "type":"DIAMOND",
                  "data":{"amount":100}
               }]
            }};
         }
         if(param1 == RequestDataKey.QUEST_LIST)
         {
            return {"data":{"quests":[{
               "id":131,
               "metaKey":"p1",
               "state":"COMPLETE",
               "status":"ACTIVE"
            },{
               "id":131,
               "metaKey":"p2",
               "state":"COMPLETE",
               "status":"ACTIVE"
            },{
               "id":131,
               "metaKey":"p3",
               "state":"ACTIVE",
               "status":"ACTIVE"
            }]}};
         }
         if(param1 == RequestDataKey.QUEST_ACCEPT)
         {
            return {"data":{}};
         }
         return null;
      }
      
      public function getInitData() : Object
      {
         return null;
      }
      
      public function dispatchExtension(param1:uint) : Object
      {
         return null;
      }
   }
}
