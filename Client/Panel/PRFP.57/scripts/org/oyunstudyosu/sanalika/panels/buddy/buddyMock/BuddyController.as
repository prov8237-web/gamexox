package org.oyunstudyosu.sanalika.panels.buddy.buddyMock
{
   import com.oyunstudyosu.buddy.BuddyRequestTypes;
   import com.oyunstudyosu.buddy.BuddyResponseTypes;
   import com.oyunstudyosu.events.BuddyEvent;
   import com.oyunstudyosu.events.Dispatcher;
   
   public class BuddyController
   {
       
      
      public function BuddyController()
      {
         super();
         Dispatcher.addEventListener(BuddyEvent.CHANGE_RELATION,this.changeRelationRequest);
         Dispatcher.addEventListener(BuddyEvent.SEND_DIAMOND,this.sendDiamondRequest);
         Dispatcher.addEventListener(BuddyEvent.SEND_MESSAGE,this.sendMessageRequest);
         Dispatcher.addEventListener(BuddyEvent.REMOVE_BUDDY,this.removeFriendRequest);
         Dispatcher.addEventListener(BuddyEvent.ADD_FRIEND,this.addFriendRequest);
         Dispatcher.addEventListener(BuddyEvent.CHANGE_MOOD,this.moodChangeRequest);
         Dispatcher.addEventListener(BuddyEvent.CHANGE_STATUS_MESSAGE,this.statusMessageChangeRequest);
         Dispatcher.addEventListener(BuddyEvent.ACCEPT_FRIEND_REQUEST,this.friendRequestAccept);
         Dispatcher.addEventListener(BuddyEvent.REJECT_FRIEND_REQUEST,this.friendRequestRejected);
         Sanalika.instance.serviceModel.listenExtension(BuddyResponseTypes.BUDDY_ADDED,this.newBuddyAdded);
         Sanalika.instance.serviceModel.listenExtension(BuddyResponseTypes.BUDDY_REMOVED,this.buddyRemoved);
         Sanalika.instance.serviceModel.listenExtension(BuddyResponseTypes.BUDDY_RELATION_CHANGED,this.buddyRelationChanged);
         Sanalika.instance.serviceModel.listenExtension(BuddyResponseTypes.BUDDY_REQUEST,this.newRequestAdded);
         Sanalika.instance.serviceModel.listenExtension(BuddyResponseTypes.BUDDY_MOOD_CHANGED,this.buddyMoodChanged);
         Sanalika.instance.serviceModel.listenExtension(BuddyResponseTypes.BUDDY_ONLINE_STATUS_CHANGED,this.buddyOnlineStatusChanged);
         Sanalika.instance.serviceModel.listenExtension(BuddyResponseTypes.BUDDY_STATUS_MESSAGE_CHANGED,this.buddyStatusMessageChanged);
         Sanalika.instance.serviceModel.requestData(BuddyRequestTypes.BUDDY_LIST,{},this.friendListResponse);
      }
      
      private function friendListResponse(param1:Object) : void
      {
         var _loc2_:Object = null;
         var _loc3_:Object = null;
         for each(_loc2_ in param1.buddies)
         {
            Sanalika.instance.buddyModel.add(_loc2_);
         }
         for each(_loc3_ in param1.requests)
         {
            Sanalika.instance.buddyModel.addNewRequest(_loc3_);
         }
         Sanalika.instance.buddyModel.isActived = true;
         Dispatcher.dispatchEvent(new BuddyEvent(BuddyEvent.REQUEST_LIST_INITALIZED));
         Dispatcher.dispatchEvent(new BuddyEvent(BuddyEvent.BUDDY_LIST_INITALIZED));
      }
      
      private function buddyOnlineStatusChanged(param1:Object) : void
      {
         Sanalika.instance.buddyModel.changeOnlineStatus(param1);
      }
      
      private function buddyRelationChanged(param1:Object) : void
      {
         Sanalika.instance.buddyModel.changeRelation(param1);
      }
      
      private function buddyMoodChanged(param1:Object) : void
      {
         Sanalika.instance.buddyModel.changeMood(param1);
      }
      
      private function buddyStatusMessageChanged(param1:Object) : void
      {
         Sanalika.instance.buddyModel.changeStatusMessage(param1);
      }
      
      private function buddyRemoved(param1:Object) : void
      {
         trace("buddyRemoved : ",JSON.stringify(param1));
         Sanalika.instance.buddyModel.removeFromFriend(param1);
      }
      
      private function newBuddyAdded(param1:Object) : void
      {
         trace("osman");
         Sanalika.instance.serviceModel.requestData(BuddyRequestTypes.GET_BUDDY,{"id":param1.avatarID},this.buddyInfoResponse);
      }
      
      private function buddyInfoResponse(param1:Object) : void
      {
         Sanalika.instance.buddyModel.addNewBuddy(param1);
      }
      
      private function newRequestAdded(param1:Object) : void
      {
         Sanalika.instance.buddyModel.addNewRequest(param1);
      }
      
      private function addFriendRequest(param1:BuddyEvent) : void
      {
         Sanalika.instance.serviceModel.requestData(BuddyRequestTypes.ADD_TO_BUDDY,{"id":param1.avatarID},null);
      }
      
      private function moodChangeRequest(param1:BuddyEvent) : void
      {
         Sanalika.instance.serviceModel.requestData(BuddyRequestTypes.CHANGE_MOOD,{"mood":param1.moodID},null);
      }
      
      private function statusMessageChangeRequest(param1:BuddyEvent) : void
      {
         Sanalika.instance.serviceModel.requestData(BuddyRequestTypes.CHANGE_STATUS_MESSAGE,{"statusMessage":param1.message},null);
      }
      
      private function changeRelationRequest(param1:BuddyEvent) : void
      {
         var _loc2_:Object = {};
         _loc2_.id = param1.avatarID;
         _loc2_.myRelationToBuddy = param1.relationID;
         this.buddyRelationChanged(_loc2_);
         Sanalika.instance.serviceModel.requestData(BuddyRequestTypes.CHANGE_BUDDY_RELATION,{
            "id":param1.avatarID,
            "relationID":param1.relationID
         },null);
      }
      
      private function friendRequestAccept(param1:BuddyEvent) : void
      {
         var _loc2_:Object = {};
         _loc2_.buddyID = param1.avatarID;
         _loc2_.response = "ACCEPTED";
         Sanalika.instance.buddyModel.removeRequest(_loc2_);
         Sanalika.instance.serviceModel.requestData(BuddyRequestTypes.ADD_BUDDY,_loc2_,null);
      }
      
      private function friendRequestRejected(param1:BuddyEvent) : void
      {
         var _loc2_:Object = {};
         _loc2_.buddyID = param1.avatarID;
         _loc2_.response = "REJECTED";
         Sanalika.instance.buddyModel.removeRequest(_loc2_);
         Sanalika.instance.serviceModel.requestData(BuddyRequestTypes.ADD_BUDDY,_loc2_,null);
      }
      
      private function removeFriendRequest(param1:BuddyEvent) : void
      {
         Sanalika.instance.serviceModel.requestData(BuddyRequestTypes.REMOVE_FROM_BUDDY,{"id":param1.avatarID},null);
      }
      
      private function sendMessageRequest(param1:BuddyEvent) : void
      {
      }
      
      private function sendDiamondRequest(param1:BuddyEvent) : void
      {
      }
      
      public function dispose() : void
      {
         Dispatcher.removeEventListener(BuddyEvent.CHANGE_RELATION,this.changeRelationRequest);
         Dispatcher.removeEventListener(BuddyEvent.SEND_DIAMOND,this.sendDiamondRequest);
         Dispatcher.removeEventListener(BuddyEvent.SEND_MESSAGE,this.sendMessageRequest);
         Dispatcher.removeEventListener(BuddyEvent.REMOVE_BUDDY,this.removeFriendRequest);
         Dispatcher.removeEventListener(BuddyEvent.ADD_FRIEND,this.addFriendRequest);
      }
   }
}
