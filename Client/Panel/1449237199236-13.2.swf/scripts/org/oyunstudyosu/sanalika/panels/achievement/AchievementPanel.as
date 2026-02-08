package org.oyunstudyosu.sanalika.panels.achievement
{
   import com.oyunstudyosu.alert.AlertEvent;
   import com.oyunstudyosu.alert.AlertType;
   import com.oyunstudyosu.alert.AlertVo;
   import com.oyunstudyosu.components.CloseButton;
   import com.oyunstudyosu.components.MobileScroll;
   import com.oyunstudyosu.enums.RequestDataKey;
   import com.oyunstudyosu.events.AchievementEvent;
   import com.oyunstudyosu.events.Dispatcher;
   import com.oyunstudyosu.local.$;
   import com.oyunstudyosu.panel.Panel;
   import com.oyunstudyosu.sanalika.extension.Connectr;
   import com.oyunstudyosu.sanalika.mock.IExtensionMock;
   import com.oyunstudyosu.utils.STextField;
   import com.oyunstudyosu.utils.TextFieldManager;
   import flash.display.MovieClip;
   import flash.events.MouseEvent;
   import flash.text.TextField;
   
   [Embed(source="/_assets/assets.swf", symbol="org.oyunstudyosu.sanalika.panels.achievement.AchievementPanel")]
   public class AchievementPanel extends Panel
   {
       
      
      private var achievementData:AchievementData;
      
      private var achievementItem:AchievementItem;
      
      public var btnClose:CloseButton;
      
      private var achievementTextField:TextField;
      
      public var iext:IExtensionMock;
      
      public var dragger:MovieClip;
      
      public var background:MovieClip;
      
      private var scrollContainer:MobileScroll;
      
      public var header:MovieClip;
      
      public var achievementTxt:TextField;
      
      public var sAchievementTxt:STextField;
      
      public function AchievementPanel()
      {
         super();
      }
      
      override public function init() : void
      {
         super.init();
         dragHandler = this.dragger;
         this.btnClose = new CloseButton();
         this.btnClose.x = this.background.width - 18;
         this.btnClose.y = 16;
         this.addChild(this.btnClose);
         if(this.sAchievementTxt == null)
         {
            this.sAchievementTxt = TextFieldManager.convertAsArabicTextField(this.achievementTxt);
            this.sAchievementTxt.text = $("achievementsTitle");
         }
         this.getList();
         this.scrollContainer = new MobileScroll();
         this.scrollContainer.y = this.header.y + this.header.height + 4;
         this.addChild(this.scrollContainer);
      }
      
      private function getList() : void
      {
         Connectr.instance.serviceModel.requestData(RequestDataKey.ACHIEVEMENT_LIST,{},this.achievementListResponse);
         this.btnClose.addEventListener(MouseEvent.CLICK,this.closeClicked);
      }
      
      private function closeClicked(param1:MouseEvent) : void
      {
         close();
      }
      
      private function achievementListResponse(param1:Object) : void
      {
         Connectr.instance.achievementModel.rewardCount = 0;
         Connectr.instance.serviceModel.removeRequestData(RequestDataKey.ACHIEVEMENT_LIST,this.achievementListResponse);
         var _loc2_:Array = param1.achievements;
         if(!_loc2_)
         {
            return;
         }
         var _loc3_:int = 0;
         while(_loc3_ < _loc2_.length)
         {
            this.achievementData = new AchievementData();
            this.achievementData.achievementID = _loc2_[_loc3_].id;
            this.achievementData.metaKey = _loc2_[_loc3_].metaKey;
            this.achievementData.currentStep = _loc2_[_loc3_].currentStep;
            this.achievementData.totalStep = _loc2_[_loc3_].totalStep;
            this.achievementData.status = _loc2_[_loc3_].status;
            this.achievementData.steps = _loc2_[_loc3_].steps;
            this.achievementData.rewardSteps = _loc2_[_loc3_].rewardSteps;
            this.achievementData.title = $("quest_" + _loc2_[_loc3_].metaKey + "_title");
            this.achievementData.description = $("quest_" + _loc2_[_loc3_].metaKey + "_desc");
            this.achievementItem = new AchievementItem(this.achievementData);
            this.achievementItem.x = 30;
            this.achievementItem.init();
            this.scrollContainer.listContainer.addChild(this.achievementItem);
            _loc3_++;
         }
         this.scrollContainer.init(589,320,6);
         show();
         Dispatcher.addEventListener(AchievementEvent.GET_REWARD,this.getRewardRequest);
      }
      
      private function getRewardRequest(param1:AchievementEvent) : void
      {
         Connectr.instance.serviceModel.requestData(RequestDataKey.ACHIEVEMENT_GIVE_REWARD,{"id":param1.id},this.rewardResponse);
      }
      
      private function rewardResponse(param1:Object) : void
      {
         var _loc2_:AlertVo = null;
         Connectr.instance.serviceModel.removeRequestData(RequestDataKey.ACHIEVEMENT_GIVE_REWARD,this.rewardResponse);
         if(param1.id)
         {
            _loc2_ = new AlertVo();
            _loc2_.alertType = AlertType.TOOLTIP;
            _loc2_.description = $("achievementRewardGiven");
            Dispatcher.dispatchEvent(new AlertEvent(_loc2_));
            --Connectr.instance.achievementModel.rewardCount;
            Dispatcher.dispatchEvent(new AchievementEvent(AchievementEvent.REWARD_COUNT_UPDATED,param1.id));
         }
      }
      
      override public function dispose() : void
      {
         Connectr.instance.serviceModel.removeRequestData(RequestDataKey.ACHIEVEMENT_LIST,this.achievementListResponse);
         Dispatcher.removeEventListener(AchievementEvent.GET_REWARD,this.getRewardRequest);
         this.btnClose.removeEventListener(MouseEvent.CLICK,this.closeClicked);
         this.scrollContainer.dispose();
         this.removeChild(this.scrollContainer);
         super.dispose();
      }
   }
}
