package org.oyunstudyosu.sanalika.panels.cellphone.apps.privatechat
{
   import com.greensock.TweenMax;
   import com.greensock.easing.Quint;
   import com.oyunstudyosu.enums.RequestDataKey;
   import com.oyunstudyosu.events.Dispatcher;
   import com.oyunstudyosu.events.PrivateChatEvent;
   import com.oyunstudyosu.sanalika.extension.Connectr;
   import com.oyunstudyosu.utils.DrawUtils;
   import flash.display.MovieClip;
   import flash.display.Sprite;
   import org.oyunstudyosu.sanalika.panels.cellphone.CellPhoneApplication;
   
   [Embed(source="/_assets/assets.swf", symbol="org.oyunstudyosu.sanalika.panels.cellphone.apps.privatechat.PrivateChatApplication")]
   public class PrivateChatApplication extends CellPhoneApplication
   {
       
      
      private var welcomeView:WelcomeView;
      
      private var listView:ListView;
      
      private var chatDetailView:GroupChatDetailView;
      
      public var bg:MovieClip;
      
      private var index:int;
      
      private var sceneContainer:Sprite;
      
      private var sceneContainerMask:Sprite;
      
      public function PrivateChatApplication()
      {
         super();
      }
      
      override public function init() : void
      {
         this.index = this.getChildIndex(this.bg) + 1;
         this.sceneContainer = new Sprite();
         this.addChildAt(this.sceneContainer,this.index);
         this.sceneContainerMask = DrawUtils.getRectangleSprite(228,375,0,1);
         this.addChild(this.sceneContainerMask);
         this.sceneContainer.mask = this.sceneContainerMask;
         this.welcomeView = new WelcomeView();
         this.sceneContainer.addChild(this.welcomeView);
         TweenMax.delayedCall(2,this.showList);
      }
      
      private function showList() : void
      {
         this.listView = new ListView();
         this.sceneContainer.addChild(this.listView);
         this.listView.x = 230;
         Dispatcher.addEventListener(PrivateChatEvent.OPEN_MESSAGE_VIEW,this.showGroupChatDetail);
         Dispatcher.addEventListener(PrivateChatEvent.BACK_TO_LIST,this.backToList);
         TweenMax.to(this.listView,0.6,{
            "x":0,
            "ease":Quint.easeOut,
            "onComplete":this.clearWelcome
         });
      }
      
      private function clearWelcome() : void
      {
         if(this.welcomeView)
         {
            this.sceneContainer.removeChild(this.welcomeView);
            this.welcomeView = null;
         }
      }
      
      private function backToList(param1:PrivateChatEvent) : void
      {
         if(this.chatDetailView)
         {
            TweenMax.to(this.listView,0.6,{
               "x":0,
               "ease":Quint.easeOut
            });
            TweenMax.to(this.chatDetailView,0.6,{
               "x":230,
               "ease":Quint.easeOut,
               "onComplete":this.clearDetailView
            });
            Connectr.instance.serviceModel.requestData(RequestDataKey.SET_ACTIVE_GROUP,{"groupID":"0"},null);
         }
      }
      
      private function clearDetailView() : void
      {
         this.sceneContainer.removeChild(this.chatDetailView);
         this.chatDetailView = null;
         this.listView.mouseEnabled = this.listView.mouseChildren = true;
      }
      
      private function showGroupChatDetail(param1:PrivateChatEvent) : void
      {
         this.listView.mouseEnabled = this.listView.mouseChildren = false;
         if(this.chatDetailView == null)
         {
            this.chatDetailView = new GroupChatDetailView(param1.imageData);
            if(param1.group)
            {
               this.chatDetailView.group = param1.group;
            }
            else if(param1.avatarVo)
            {
               this.chatDetailView.buddyVo = param1.avatarVo;
            }
            this.sceneContainer.addChild(this.chatDetailView);
            this.chatDetailView.x = 230;
         }
         TweenMax.to(this.listView,0.6,{
            "x":-50,
            "delay":0.05,
            "ease":Quint.easeOut
         });
         TweenMax.to(this.chatDetailView,0.6,{
            "x":0,
            "ease":Quint.easeOut
         });
      }
      
      override public function dispose() : void
      {
         if(this.sceneContainer)
         {
            this.removeChild(this.sceneContainer);
            this.removeChild(this.sceneContainerMask);
         }
         this.sceneContainer = null;
         this.sceneContainerMask = null;
         this.welcomeView = null;
         this.listView = null;
         this.chatDetailView = null;
         TweenMax.killDelayedCallsTo(this.showList);
         TweenMax.killTweensOf(this.listView);
         TweenMax.killTweensOf(this.chatDetailView);
         Connectr.instance.serviceModel.requestData(RequestDataKey.SET_ACTIVE_GROUP,{"groupID":"0"},null);
         Dispatcher.removeEventListener(PrivateChatEvent.OPEN_MESSAGE_VIEW,this.showGroupChatDetail);
         Dispatcher.removeEventListener(PrivateChatEvent.BACK_TO_LIST,this.backToList);
      }
   }
}
