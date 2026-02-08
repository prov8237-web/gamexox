package org.oyunstudyosu.sanalika.panels.achievement
{
   import com.oyunstudyosu.assets.AssetRequest;
   import com.oyunstudyosu.assets.IAssetRequest;
   import com.oyunstudyosu.enums.ModuleType;
   import com.oyunstudyosu.events.AchievementEvent;
   import com.oyunstudyosu.events.Dispatcher;
   import com.oyunstudyosu.local.$;
   import com.oyunstudyosu.sanalika.extension.Connectr;
   import com.oyunstudyosu.utils.STextField;
   import com.oyunstudyosu.utils.TextFieldManager;
   import com.printfas3.printf;
   import flash.display.Bitmap;
   import flash.display.MovieClip;
   import flash.display.Sprite;
   import flash.events.MouseEvent;
   import flash.text.TextField;
   import org.oyunstudyosu.components.CoreMovieClip;
   import org.oyunstudyosu.sanalika.buttons.newButtons.AchievementGiftButton;
   
   [Embed(source="/_assets/assets.swf", symbol="org.oyunstudyosu.sanalika.panels.achievement.AchievementItem")]
   public class AchievementItem extends CoreMovieClip
   {
       
      
      public var descTxt:TextField;
      
      public var progressTxt:TextField;
      
      public var titleTxt:TextField;
      
      private var achievementData:AchievementData;
      
      private var titleTextField:STextField;
      
      private var descTextField:STextField;
      
      private var completedTextField:STextField;
      
      private var progressTextField:TextField;
      
      public var stars:MovieClip;
      
      private var giftcontainer:Sprite;
      
      public var diamondGift:AchievementGift;
      
      public var sanilGift:AchievementGift;
      
      public var itemGift:AchievementGift;
      
      public var badgeGift:AchievementGift;
      
      private var giftMargin:int;
      
      private var giftWidth:int = 24;
      
      public var progressBg:MovieClip;
      
      public var progressBar:MovieClip;
      
      private var progressWidth:int = 150;
      
      private var progressMinWidth:int = 10;
      
      public var giftButton:AchievementGiftButton;
      
      public var images:MovieClip;
      
      public function AchievementItem(param1:AchievementData)
      {
         super();
         this.achievementData = param1;
      }
      
      public function init() : void
      {
         this.diamondGift.visible = this.sanilGift.visible = this.itemGift.visible = this.badgeGift.visible = false;
         this.processGiftButton();
         this.processStars();
         this.processTexts();
         this.processGifts();
         this.processProgress();
         this.loadAsset(this.achievementData.metaKey);
      }
      
      private function processGiftButton() : void
      {
         this.giftButton.dark.visible = true;
         if(this.achievementData.rewardSteps.length > 0)
         {
            this.giftButton.dark.visible = false;
            ++Connectr.instance.achievementModel.rewardCount;
            this.giftButton.setText($("GET GIFT"));
            this.giftButton.enabled = true;
            this.giftButton.mouseEnabled = true;
            this.giftButton.addEventListener(MouseEvent.CLICK,this.giftButtonClicked);
         }
         else if(this.achievementData.status == "COMPLETE")
         {
            this.giftButton.setText($("COMPLETED"));
            this.giftButton.mouseEnabled = false;
         }
         else
         {
            this.giftButton.setText($("GET GIFT"));
            this.giftButton.mouseEnabled = false;
         }
      }
      
      private function processProgress() : void
      {
         var _loc1_:int = this.achievementData.currentStep;
         if(this.achievementData.rewardSteps.length > 0)
         {
            _loc1_ = int(this.achievementData.rewardSteps[0]);
         }
         var _loc2_:int = int(this.achievementData.steps[_loc1_ - 1].currentValue);
         if(this.achievementData.steps[_loc1_ - 1].currentValue > this.achievementData.steps[_loc1_ - 1].requirementValue)
         {
            _loc2_ = int(this.achievementData.steps[_loc1_ - 1].requirementValue);
         }
         this.progressTextField.text = _loc2_ + "/" + this.achievementData.steps[_loc1_ - 1].requirementValue;
         this.progressBar.width = (this.progressWidth - this.progressMinWidth) * (_loc2_ / this.achievementData.steps[_loc1_ - 1].requirementValue) + this.progressMinWidth;
         this.progressBg.width = this.progressWidth;
         if(this.achievementData.steps[_loc1_ - 1].currentValue == 0)
         {
            this.progressBar.visible = false;
         }
         else
         {
            this.progressBar.mouseEnabled = false;
            this.progressBar.mouseChildren = false;
         }
      }
      
      protected function giftButtonClicked(param1:MouseEvent) : void
      {
         this.giftButton.enabled = false;
         if(this.achievementData.rewardSteps.length > 0)
         {
            this.achievementData.rewardSteps.splice(0,1);
         }
         else
         {
            ++this.achievementData.currentStep;
         }
         this.init();
         Dispatcher.dispatchEvent(new AchievementEvent(AchievementEvent.GET_REWARD,this.achievementData.achievementID));
      }
      
      private function processGifts() : void
      {
         var _loc1_:Array = null;
         var _loc2_:String = null;
         if(this.achievementData.rewardSteps.length > 0)
         {
            _loc1_ = this.achievementData.steps[this.achievementData.rewardSteps[0] - 1].rewards;
         }
         else
         {
            _loc1_ = this.achievementData.steps[this.achievementData.currentStep - 1].rewards;
         }
         if(!_loc1_)
         {
            return;
         }
         this.giftcontainer = new Sprite();
         addChild(this.giftcontainer);
         var _loc3_:int = int(_loc1_.length);
         this.giftMargin = 30 - 5 * _loc3_;
         var _loc4_:int = 0;
         while(_loc4_ < _loc3_)
         {
            _loc2_ = String(_loc1_[_loc4_].type);
            switch(_loc2_)
            {
               case AchievementGiftTypes.SANIL:
                  this.sanilGift.visible = true;
                  this.sanilGift.process(_loc1_[_loc4_].data);
                  break;
               case AchievementGiftTypes.DIAMOND:
                  this.diamondGift.visible = true;
                  this.diamondGift.process(_loc1_[_loc4_].data);
                  break;
               case AchievementGiftTypes.HAND:
                  this.itemGift.visible = true;
                  this.itemGift.process(_loc1_[_loc4_].data);
                  break;
               case AchievementGiftTypes.BADGE:
                  this.badgeGift.visible = true;
                  this.badgeGift.process(_loc1_[_loc4_].data);
                  break;
            }
            _loc4_++;
         }
         this.giftcontainer.y = 45;
         this.giftcontainer.x = 280 + (166 - this.giftcontainer.width) / 2;
      }
      
      private function processTexts() : void
      {
         if(this.titleTextField == null)
         {
            this.titleTextField = TextFieldManager.convertAsArabicTextField(getChildByName("titleTxt") as TextField,true,false);
            this.descTextField = TextFieldManager.convertAsArabicTextField(getChildByName("descTxt") as TextField,true,true);
            this.progressTextField = TextFieldManager.createNoneLanguageTextfield(getChildByName("progressTxt") as TextField);
         }
         this.titleTextField.text = this.achievementData.title;
         this.descTextField.text = printf(this.achievementData.description,this.achievementData.steps[this.achievementData.currentStep - 1].requirementValue);
         this.titleTextField.width = this.descTextField.width = 195;
         this.titleTextField.height = 19;
      }
      
      private function processStars() : void
      {
         if(this.achievementData.rewardSteps.length > 0)
         {
            try
            {
               this.stars.gotoAndStop(this.achievementData.rewardSteps[0]);
            }
            catch(e:Error)
            {
            }
         }
         else if(this.achievementData.status == "COMPLETE")
         {
            this.stars.gotoAndStop(4);
         }
         else
         {
            this.stars.gotoAndStop(this.achievementData.currentStep);
         }
      }
      
      public function loadAsset(param1:*) : void
      {
         var _loc2_:AssetRequest = new AssetRequest();
         _loc2_.context = Connectr.instance.domainModel.assetContext;
         _loc2_.name = param1;
         _loc2_.type = ModuleType.PNG;
         _loc2_.assetId = "/static/quests/" + param1 + ".png";
         _loc2_.loadedFunction = this.imgLoaded;
         Connectr.instance.assetModel.request(_loc2_);
      }
      
      private function imgLoaded(param1:IAssetRequest) : void
      {
         var _loc2_:Bitmap = param1.display as Bitmap;
         _loc2_.smoothing = true;
         if(_loc2_.height > 60)
         {
            _loc2_.width = _loc2_.width / _loc2_.height * 60;
            _loc2_.height = 60;
         }
         _loc2_.x = -_loc2_.width / 2;
         _loc2_.y = -_loc2_.height / 2;
         this.images.addChild(_loc2_);
      }
      
      override public function removed() : void
      {
         this.achievementData = null;
         this.giftButton.removeEventListener(MouseEvent.CLICK,this.giftButtonClicked);
      }
      
      public function dispose() : void
      {
         this.giftButton.removeEventListener(MouseEvent.CLICK,this.giftButtonClicked);
      }
   }
}
