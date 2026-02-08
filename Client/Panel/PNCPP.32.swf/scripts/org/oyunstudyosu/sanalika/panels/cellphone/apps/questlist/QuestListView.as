package org.oyunstudyosu.sanalika.panels.cellphone.apps.questlist
{
   import com.greensock.TweenMax;
   import com.greensock.easing.Linear;
   import com.oyunstudyosu.assets.AssetRequest;
   import com.oyunstudyosu.assets.IAssetRequest;
   import com.oyunstudyosu.enums.ModuleType;
   import com.oyunstudyosu.enums.RequestDataKey;
   import com.oyunstudyosu.events.Dispatcher;
   import com.oyunstudyosu.events.QuestEvent;
   import com.oyunstudyosu.local.$;
   import com.oyunstudyosu.sanalika.extension.Connectr;
   import com.oyunstudyosu.utils.STextField;
   import com.oyunstudyosu.utils.TextFieldManager;
   import feathers.controls.ScrollContainer;
   import feathers.controls.ScrollPolicy;
   import feathers.layout.VerticalLayout;
   import flash.display.MovieClip;
   import flash.events.MouseEvent;
   import flash.text.TextField;
   import org.oyunstudyosu.components.CoreMovieClip;
   
   [Embed(source="/_assets/assets.swf", symbol="org.oyunstudyosu.sanalika.panels.cellphone.apps.questlist.QuestListView")]
   public class QuestListView extends CoreMovieClip
   {
       
      
      public var txtDescription:TextField;
      
      public var txtHeader:TextField;
      
      public var txtRoom:TextField;
      
      private var listContainer:ScrollContainer;
      
      private var questItem:QuestItem;
      
      private var botClip:MovieClip;
      
      private var botKey:String;
      
      private var myListID:Object;
      
      public var headerBg:MovieClip;
      
      public var sHeader:STextField;
      
      public var sDescription:STextField;
      
      public var sRoom:STextField;
      
      public var mc_sanil:MovieClip;
      
      public var mc_diamond:MovieClip;
      
      public var mc_badge:MovieClip;
      
      public var mc_item:MovieClip;
      
      public var request:AssetRequest;
      
      public var botContainer:MovieClip;
      
      public var mc_progress:MovieClip;
      
      public function QuestListView()
      {
         addFrameScript(0,this.frame1);
         super();
      }
      
      override public function added() : void
      {
         this.listContainer = new ScrollContainer();
         this.listContainer.y = 20;
         this.listContainer.width = 230;
         this.listContainer.height = 352;
         this.listContainer.scrollPolicyX = ScrollPolicy.OFF;
         var _loc1_:VerticalLayout = new VerticalLayout();
         _loc1_.set_gap(6);
         this.listContainer.layout = _loc1_;
         addChild(this.listContainer);
         if(this.sHeader == null)
         {
            this.sHeader = TextFieldManager.convertAsArabicTextField(this.getChildByName("txtHeader") as TextField,false);
            this.sDescription = TextFieldManager.convertAsArabicTextField(this.getChildByName("txtDescription") as TextField,true,false);
            this.sRoom = TextFieldManager.convertAsArabicTextField(this.getChildByName("txtRoom") as TextField,false);
         }
         this.headerBg.addEventListener(MouseEvent.CLICK,this.closeView);
         this.headerBg.buttonMode = true;
         this.mc_progress.visible = false;
         Dispatcher.addEventListener(QuestEvent.QUEST_ACTION,this.reset);
         this.getList();
      }
      
      private function reset(param1:QuestEvent) : void
      {
         this.closeView();
         this.getList();
      }
      
      private function onError(param1:Object) : void
      {
         this.request.dispose();
      }
      
      private function onLoaded(param1:IAssetRequest) : void
      {
         this.botClip = Connectr.instance.roomModel.botModel.getBotClip(param1.context.applicationDomain,this.botKey);
         if(this.botClip != null)
         {
            if(this.botClip.width > 60)
            {
               this.botClip.height = this.botClip.height / this.botClip.width * 60;
               this.botClip.width = 60;
            }
            this.botContainer.addChild(this.botClip);
         }
         param1.dispose();
      }
      
      public function openView(param1:MouseEvent) : void
      {
         var _loc4_:int = 0;
         this.mc_sanil.lbl_info.text = "-";
         this.mc_diamond.lbl_info.text = "-";
         this.mc_badge.lbl_info.text = "-";
         this.mc_item.lbl_info.text = "-";
         var _loc2_:Object = (param1.target as QuestItem).data;
         this.sHeader.text = $("quest_" + _loc2_.metaKey + "_title");
         this.mc_progress.lbl_progress.text = _loc2_.currentStep.toString() + " / " + _loc2_.totalStep.toString();
         this.mc_progress.bar.width = (this.mc_progress.width - 20) * (_loc2_.currentStep / _loc2_.totalStep) + 20;
         this.mc_progress.visible = true;
         this.botKey = _loc2_.steps[_loc2_.currentStep - 1].botKey;
         var _loc3_:String = String(Connectr.instance.moduleModel.getPath(this.botKey,ModuleType.BOT));
         this.request = new AssetRequest();
         this.request.context = Connectr.instance.domainModel.assetContext;
         this.request.assetId = _loc3_;
         this.request.loadedFunction = this.onLoaded;
         this.request.errorFunction = this.onError;
         Connectr.instance.assetModel.request(this.request);
         this.sDescription.text = $("quest_" + _loc2_.metaKey + "_list");
         this.sRoom.text = $("room_" + _loc2_.steps[_loc2_.currentStep - 1].roomKey);
         if(_loc2_.rewards)
         {
            _loc4_ = 0;
            while(_loc4_ < _loc2_.rewards.length)
            {
               if(_loc2_.rewards[_loc4_].type == "SANIL")
               {
                  this.mc_sanil.lbl_info.text = _loc2_.rewards[_loc4_].data.amount;
               }
               if(_loc2_.rewards[_loc4_].type == "DIAMOND")
               {
                  this.mc_diamond.lbl_info.text = _loc2_.rewards[_loc4_].data.amount;
               }
               if(_loc2_.rewards[_loc4_].type == "ITEM")
               {
                  this.mc_item.lbl_info.text = _loc2_.rewards[_loc4_].data.amount;
               }
               if(_loc2_.rewards[_loc4_].type == "BADGE")
               {
                  this.mc_badge.lbl_info.text = _loc2_.rewards[_loc4_].data.amount;
               }
               _loc4_++;
            }
         }
         TweenMax.to(this,0.3,{
            "x":-230,
            "ease":Linear.easeOut
         });
      }
      
      public function closeView(param1:MouseEvent = null) : void
      {
         TweenMax.to(this,0.2,{
            "x":0,
            "ease":Linear.easeIn
         });
         if(this.botClip)
         {
            this.botContainer.removeChild(this.botClip);
            this.botClip = null;
         }
      }
      
      public function getList() : void
      {
         Connectr.instance.serviceModel.requestData(RequestDataKey.QUEST_LIST,{"showDetail":true},this.onQuestList);
      }
      
      private function onQuestList(param1:*) : void
      {
         while(this.listContainer.numChildren > 0)
         {
            (this.listContainer.getChildAt(0) as QuestItem).removeEventListener(MouseEvent.CLICK,this.openView);
            (this.listContainer.getChildAt(0) as QuestItem).removed();
            this.listContainer.removeChildAt(0);
         }
         Connectr.instance.serviceModel.removeRequestData(RequestDataKey.QUEST_LIST,this.onQuestList);
         var _loc2_:int = 0;
         while(_loc2_ < param1.quests.length)
         {
            this.questItem = new QuestItem();
            this.questItem.data = param1.quests[_loc2_];
            this.questItem.addEventListener(MouseEvent.CLICK,this.openView);
            this.questItem.buttonMode = true;
            this.listContainer.addChild(this.questItem);
            this.questItem.y = _loc2_ * 30 + 28;
            _loc2_++;
         }
         param1 = null;
      }
      
      override public function removed() : void
      {
         this.headerBg.removeEventListener(MouseEvent.CLICK,this.closeView);
         Dispatcher.removeEventListener(QuestEvent.QUEST_ACTION,this.reset);
         if(this.botClip)
         {
            this.botContainer.removeChild(this.botClip);
            this.botClip = null;
         }
         while(this.listContainer.numChildren > 0)
         {
            (this.listContainer.getChildAt(0) as QuestItem).removeEventListener(MouseEvent.CLICK,this.openView);
            (this.listContainer.getChildAt(0) as QuestItem).removed();
            this.listContainer.removeChildAt(0);
         }
         this.removeChild(this.listContainer);
      }
      
      internal function frame1() : *
      {
         stop();
      }
   }
}
