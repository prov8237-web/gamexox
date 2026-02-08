package org.oyunstudyosu.sanalika.panels.cellphone.apps.privatechat
{
   import com.greensock.TweenLite;
   import com.greensock.easing.Strong;
   import com.greensock.plugins.ThrowPropsPlugin;
   import com.oyunstudyosu.buddy.BuddyResponseTypes;
   import com.oyunstudyosu.buddy.BuddyVo;
   import com.oyunstudyosu.events.Dispatcher;
   import com.oyunstudyosu.events.PrivateChatEvent;
   import com.oyunstudyosu.local.$;
   import com.oyunstudyosu.sanalika.extension.Connectr;
   import com.oyunstudyosu.utils.BlitMask;
   import com.oyunstudyosu.utils.DrawUtils;
   import flash.display.Sprite;
   import flash.events.MouseEvent;
   import flash.geom.Rectangle;
   import flash.utils.getTimer;
   import org.oyunstudyosu.components.CoreMovieClip;
   
   public class FriendsView extends CoreMovieClip
   {
       
      
      private var onlineHeader:BuddyHeader;
      
      private var offlineHeader:BuddyHeader;
      
      private var onlineContainer:Sprite;
      
      private var offlineContainer:Sprite;
      
      private var buddies:Vector.<BuddyVo>;
      
      private var buddyView:BuddyView;
      
      private const FRIEND_VIEW_HEIGHT:int = 42;
      
      private var friendContainer:Sprite;
      
      private var friendContainerBg:Sprite;
      
      private var bounds:Rectangle;
      
      private var t1:uint;
      
      private var t2:uint;
      
      private var y1:Number;
      
      private var y2:Number;
      
      private var yOverlap:Number;
      
      private var yOffset:Number;
      
      private var blitMask:BlitMask;
      
      public function FriendsView()
      {
         super();
      }
      
      override public function added() : void
      {
         this.buddies = Connectr.instance.buddyModel.buddies;
         this.onlineHeader = new BuddyHeader($("ONLINE"));
         this.offlineHeader = new BuddyHeader($("OFFLINE"));
         this.friendContainer = new Sprite();
         this.onlineContainer = new Sprite();
         this.offlineContainer = new Sprite();
         this.friendContainerBg = DrawUtils.getRectangleSprite(228,100,0,0);
         this.addChild(this.friendContainer);
         this.friendContainer.addChild(this.friendContainerBg);
         this.friendContainer.addChild(this.onlineHeader);
         this.friendContainer.addChild(this.onlineContainer);
         this.friendContainer.addChild(this.offlineHeader);
         this.friendContainer.addChild(this.offlineContainer);
         if(Connectr.instance.privateChatModel.isActivated)
         {
            this.friendsInit();
         }
         else
         {
            Dispatcher.addEventListener(PrivateChatEvent.LIST_ACTIVATED,this.listActivated);
         }
      }
      
      private function listActivated(param1:PrivateChatEvent) : void
      {
         Dispatcher.removeEventListener(PrivateChatEvent.LIST_ACTIVATED,this.listActivated);
         this.friendsInit();
      }
      
      private function onBuddyRemoved(param1:Object) : void
      {
         if(param1.avatarID == null)
         {
            return;
         }
         var _loc2_:int = 0;
         _loc2_ = 0;
         while(_loc2_ < this.onlineContainer.numChildren)
         {
            this.buddyView = this.onlineContainer.getChildAt(_loc2_) as BuddyView;
            if(this.buddyView.vo.avatarID == param1.avatarID)
            {
               this.onlineContainer.removeChild(this.buddyView);
               this.buddyView = null;
               this.setPositions();
               return;
            }
            _loc2_++;
         }
         _loc2_ = 0;
         while(_loc2_ < this.offlineContainer.numChildren)
         {
            this.buddyView = this.offlineContainer.getChildAt(_loc2_) as BuddyView;
            if(this.buddyView.vo.avatarID == param1.avatarID)
            {
               this.offlineContainer.removeChild(this.buddyView);
               this.buddyView = null;
               this.setPositions();
               return;
            }
            _loc2_++;
         }
      }
      
      private function onBuddyAdded(param1:Object) : void
      {
         if(param1.avatarID == null)
         {
            return;
         }
         var _loc2_:BuddyVo = new BuddyVo();
         _loc2_.avatarID = param1.avatarID;
         _loc2_.avatarName = param1.avatarName;
         if(param1.status)
         {
            _loc2_.status = param1.status;
         }
         else
         {
            _loc2_.status = "";
         }
         _loc2_.isOnline = param1.isOnline;
         _loc2_.mood = param1.mood;
         _loc2_.buddyMood = param1.buddyRating;
         _loc2_.myMood = param1.myRating;
         this.buddyView = new BuddyView();
         if(_loc2_.isOnline)
         {
            this.onlineContainer.addChildAt(this.buddyView,0);
         }
         else
         {
            this.offlineContainer.addChildAt(this.buddyView,0);
         }
         this.buddyView.vo = _loc2_;
         this.setPositions();
      }
      
      private function chatFriendStatusChanged(param1:Object) : void
      {
         var _loc2_:int = 0;
         if(param1.isOnline == true)
         {
            _loc2_ = 0;
            while(_loc2_ < this.offlineContainer.numChildren)
            {
               this.buddyView = this.offlineContainer.getChildAt(_loc2_) as BuddyView;
               if(this.buddyView.vo.avatarID == param1.avatarID)
               {
                  this.offlineContainer.removeChild(this.buddyView);
                  this.buddyView.vo.isOnline = true;
                  this.buddyView.isOnline = true;
                  this.onlineContainer.addChildAt(this.buddyView,0);
                  this.setPositions();
                  return;
               }
               _loc2_++;
            }
         }
         else
         {
            _loc2_ = 0;
            while(_loc2_ < this.onlineContainer.numChildren)
            {
               this.buddyView = this.onlineContainer.getChildAt(_loc2_) as BuddyView;
               if(this.buddyView.vo.avatarID == param1.avatarID)
               {
                  this.onlineContainer.removeChild(this.buddyView);
                  this.buddyView.vo.isOnline = false;
                  this.buddyView.isOnline = false;
                  this.offlineContainer.addChildAt(this.buddyView,0);
                  this.setPositions();
                  return;
               }
               _loc2_++;
            }
         }
      }
      
      private function friendsInit() : void
      {
         var _loc2_:BuddyVo = null;
         var _loc1_:int = int(Connectr.instance.buddyModel.buddyLen);
         var _loc3_:int = 0;
         while(_loc3_ < _loc1_)
         {
            _loc2_ = this.buddies[_loc3_];
            this.buddyView = new BuddyView();
            if(_loc2_.isOnline)
            {
               this.onlineContainer.addChild(this.buddyView);
            }
            else
            {
               this.offlineContainer.addChild(this.buddyView);
            }
            this.buddyView.vo = _loc2_;
            this.buddyView.cacheAsBitmap = true;
            _loc3_++;
         }
         this.setPositions();
         this.bounds = new Rectangle(this.friendContainer.x,this.friendContainer.y,228,290);
         this.blitMask = new BlitMask(this.friendContainer,this.bounds.x,this.bounds.y,this.bounds.width,this.bounds.height,false,true);
         this.blitMask.bitmapMode = false;
         this.blitMask.addEventListener(MouseEvent.MOUSE_DOWN,this.mouseDownHandler);
         Connectr.instance.serviceModel.listenExtension(BuddyResponseTypes.BUDDY_ONLINE_STATUS_CHANGED,this.chatFriendStatusChanged);
         Connectr.instance.serviceModel.listenExtension(BuddyResponseTypes.BUDDY_ADDED,this.onBuddyAdded);
         Connectr.instance.serviceModel.listenExtension(BuddyResponseTypes.BUDDY_REMOVED,this.onBuddyRemoved);
      }
      
      public function setPositions() : void
      {
         var _loc1_:int = 0;
         while(_loc1_ < this.onlineContainer.numChildren)
         {
            this.buddyView = this.onlineContainer.getChildAt(_loc1_) as BuddyView;
            this.buddyView.y = this.FRIEND_VIEW_HEIGHT * _loc1_;
            _loc1_++;
         }
         var _loc2_:int = 0;
         while(_loc2_ < this.offlineContainer.numChildren)
         {
            this.buddyView = this.offlineContainer.getChildAt(_loc2_) as BuddyView;
            this.buddyView.y = this.FRIEND_VIEW_HEIGHT * _loc2_;
            _loc2_++;
         }
         this.onlineHeader.y = 0;
         this.onlineContainer.y = this.onlineHeader.y + this.onlineHeader.height + 5;
         this.offlineHeader.y = this.onlineContainer.y + this.FRIEND_VIEW_HEIGHT * this.onlineContainer.numChildren + 5;
         this.offlineContainer.y = this.offlineHeader.y + this.offlineHeader.height + 5;
         this.friendContainerBg.height = this.onlineHeader.height + this.offlineHeader.height + 10 + (this.onlineContainer.numChildren + this.offlineContainer.numChildren) * this.FRIEND_VIEW_HEIGHT;
      }
      
      private function mouseDownHandler(param1:MouseEvent) : void
      {
         TweenLite.killTweensOf(this.friendContainer);
         this.y1 = this.y2 = this.friendContainer.y;
         this.yOffset = this.mouseY - this.friendContainer.y;
         this.yOverlap = Math.max(0,this.friendContainerBg.height - this.bounds.height);
         this.t1 = this.t2 = getTimer();
         Connectr.instance.layerModel.stage.addEventListener(MouseEvent.MOUSE_MOVE,this.mouseMoveHandler);
         Connectr.instance.layerModel.stage.addEventListener(MouseEvent.MOUSE_UP,this.mouseUpHandler);
      }
      
      private function mouseMoveHandler(param1:MouseEvent) : void
      {
         this.friendContainer.mouseEnabled = false;
         this.friendContainer.mouseChildren = false;
         var _loc2_:Number = this.mouseY - this.yOffset;
         if(_loc2_ > this.bounds.top)
         {
            this.friendContainer.y = (_loc2_ + this.bounds.top) * 0.5;
         }
         else if(_loc2_ < this.bounds.top - this.yOverlap)
         {
            this.friendContainer.y = (_loc2_ + this.bounds.top - this.yOverlap) * 0.5;
         }
         else
         {
            this.friendContainer.y = _loc2_;
         }
         this.blitMask.update();
         var _loc3_:uint = uint(getTimer());
         if(_loc3_ - this.t2 > 50)
         {
            this.y2 = this.y1;
            this.t2 = this.t1;
            this.y1 = this.friendContainer.y;
            this.t1 = _loc3_;
         }
         param1.updateAfterEvent();
      }
      
      private function mouseUpHandler(param1:MouseEvent) : void
      {
         param1.stopPropagation();
         this.friendContainer.mouseEnabled = true;
         this.friendContainer.mouseChildren = true;
         Connectr.instance.layerModel.stage.removeEventListener(MouseEvent.MOUSE_UP,this.mouseUpHandler);
         Connectr.instance.layerModel.stage.removeEventListener(MouseEvent.MOUSE_MOVE,this.mouseMoveHandler);
         var _loc2_:Number = (getTimer() - this.t2) / 1000;
         var _loc3_:Number = (this.friendContainer.y - this.y2) / _loc2_;
         ThrowPropsPlugin.to(this.friendContainer,{
            "throwProps":{"y":{
               "velocity":_loc3_,
               "max":this.bounds.top,
               "min":this.bounds.top - this.yOverlap,
               "resistance":300
            }},
            "onUpdate":this.blitMask.update,
            "ease":Strong.easeOut
         },1,0.3,1);
      }
      
      override public function removed() : void
      {
         if(this.blitMask)
         {
            this.blitMask.removeEventListener(MouseEvent.MOUSE_DOWN,this.mouseDownHandler);
            this.blitMask.dispose();
         }
         Connectr.instance.serviceModel.removeExtension(BuddyResponseTypes.BUDDY_ONLINE_STATUS_CHANGED,this.chatFriendStatusChanged);
         Connectr.instance.serviceModel.removeExtension(BuddyResponseTypes.BUDDY_ADDED,this.onBuddyAdded);
         Connectr.instance.serviceModel.removeExtension(BuddyResponseTypes.BUDDY_REMOVED,this.onBuddyRemoved);
      }
   }
}
