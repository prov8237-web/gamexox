package org.oyunstudyosu.sanalika.mock
{
   import com.oyunstudyosu.alert.AlertEvent;
   import com.oyunstudyosu.alert.AlertType;
   import com.oyunstudyosu.alert.AlertVo;
   import com.oyunstudyosu.enums.RequestDataKey;
   import com.oyunstudyosu.events.Dispatcher;
   import com.oyunstudyosu.events.QuestEvent;
   import com.oyunstudyosu.local.$;
   import com.oyunstudyosu.quest.IQuestModel;
   import flash.utils.Dictionary;
   
   public class QuestModel implements IQuestModel
   {
       
      
      private var _questlist:Object;
      
      private var _questlistroom:Dictionary;
      
      public function QuestModel()
      {
         this._questlistroom = new Dictionary();
         super();
         Sanalika.instance.serviceModel.listenExtension(RequestDataKey.QUEST_LIST_ROOM,this.onQuestListRoom);
         Sanalika.instance.serviceModel.listenExtension(RequestDataKey.QUEST_STEP_COMPLETE,this.onQuestStepComplete);
         Sanalika.instance.serviceModel.listenExtension(RequestDataKey.QUEST_COMPLETE,this.onQuestComplete);
      }
      
      public function get questlist() : Object
      {
         return this._questlist;
      }
      
      public function set questlist(param1:Object) : void
      {
         this._questlist = param1;
      }
      
      public function get questlistroom() : Dictionary
      {
         return this._questlistroom;
      }
      
      private function onTerminateGame(param1:*) : void
      {
         trace("onTerminateGame questlistroom ");
      }
      
      private function onQuestListRoom(param1:*) : void
      {
         this.questlistroom[param1.quests[0].roomKey] = param1.quests;
         Dispatcher.dispatchEvent(new QuestEvent(QuestEvent.QUEST_LIST_ROOM_READY));
         var _loc2_:AlertVo = new AlertVo();
         _loc2_.alertType = AlertType.TOOLTIP;
         _loc2_.description = $("questAlert");
         Dispatcher.dispatchEvent(new AlertEvent(_loc2_));
      }
      
      private function onQuestStepComplete(param1:*) : void
      {
         var _loc2_:String = String(param1.id);
         Dispatcher.dispatchEvent(new QuestEvent(QuestEvent.QUEST_COMPLETED));
         var _loc3_:AlertVo = new AlertVo();
         _loc3_.alertType = AlertType.TOOLTIP;
         _loc3_.description = $("questStepCompleted") + " " + $("questNextRoom") + ": " + $("room_" + param1.nextRoom);
         Dispatcher.dispatchEvent(new AlertEvent(_loc3_));
      }
      
      private function onQuestComplete(param1:*) : void
      {
         var _loc2_:String = String(param1.id);
         Dispatcher.dispatchEvent(new QuestEvent(QuestEvent.QUEST_COMPLETED));
         var _loc3_:AlertVo = new AlertVo();
         _loc3_.alertType = AlertType.TOOLTIP;
         _loc3_.description = $("questCompleted");
         Dispatcher.dispatchEvent(new AlertEvent(_loc3_));
      }
      
      public function dispose() : void
      {
         Sanalika.instance.serviceModel.removeExtension(RequestDataKey.QUEST_LIST_ROOM,this.onQuestListRoom);
         Sanalika.instance.serviceModel.removeExtension(RequestDataKey.QUEST_COMPLETE,this.onQuestComplete);
      }
   }
}
