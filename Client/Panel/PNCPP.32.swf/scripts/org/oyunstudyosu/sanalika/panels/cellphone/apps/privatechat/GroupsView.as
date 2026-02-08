package org.oyunstudyosu.sanalika.panels.cellphone.apps.privatechat
{
   import com.greensock.TweenLite;
   import com.greensock.easing.Strong;
   import com.greensock.plugins.ThrowPropsPlugin;
   import com.greensock.plugins.TweenPlugin;
   import com.oyunstudyosu.buddy.BuddyResponseTypes;
   import com.oyunstudyosu.events.Dispatcher;
   import com.oyunstudyosu.events.PrivateChatEvent;
   import com.oyunstudyosu.privatechat.IPrivateChatGroup;
   import com.oyunstudyosu.sanalika.extension.Connectr;
   import com.oyunstudyosu.utils.BlitMask;
   import com.oyunstudyosu.utils.DrawUtils;
   import flash.display.Sprite;
   import flash.events.MouseEvent;
   import flash.geom.Rectangle;
   import flash.utils.getTimer;
   import org.oyunstudyosu.components.CoreMovieClip;
   
   public class GroupsView extends CoreMovieClip
   {
       
      
      private var groups:Array;
      
      private var group:IPrivateChatGroup;
      
      private var groupItem:GroupListItem;
      
      private const GROUP_VIEW_HEIGHT:int = 42;
      
      private var groupContainer:Sprite;
      
      private var groupListContainer:Sprite;
      
      private var groupContainerBg:Sprite;
      
      private var bounds:Rectangle;
      
      private var t1:uint;
      
      private var t2:uint;
      
      private var y1:Number;
      
      private var y2:Number;
      
      private var yOverlap:Number;
      
      private var yOffset:Number;
      
      private var blitMask:BlitMask;
      
      public function GroupsView()
      {
         super();
      }
      
      override public function added() : void
      {
         TweenPlugin.activate([ThrowPropsPlugin]);
         if(Connectr.instance.privateChatModel.isActivated)
         {
            this.initGroups();
         }
         else
         {
            Dispatcher.addEventListener(PrivateChatEvent.LIST_ACTIVATED,this.listActivated);
            Dispatcher.dispatchEvent(new PrivateChatEvent(PrivateChatEvent.GET_LIST));
         }
      }
      
      private function listActivated(param1:PrivateChatEvent) : void
      {
         Dispatcher.removeEventListener(PrivateChatEvent.LIST_ACTIVATED,this.listActivated);
         this.initGroups();
      }
      
      private function onBuddyRemoved(param1:Object) : void
      {
         if(param1.avatarID == null)
         {
            return;
         }
         var _loc2_:int = 0;
         _loc2_ = 0;
         while(_loc2_ < this.groupListContainer.numChildren)
         {
            this.groupItem = this.groupListContainer.getChildAt(_loc2_) as GroupListItem;
            if(this.groupItem.group.avatarID == param1.avatarID)
            {
               this.groupListContainer.removeChild(this.groupItem);
               this.groupItem.removeEventListener(PrivateChatEvent.REMOVE_GROUP,this.removeGroup);
               this.groupItem = null;
               this.setPositions();
               return;
            }
            _loc2_++;
         }
      }
      
      private function removeGroup(param1:PrivateChatEvent) : void
      {
         this.groupItem = param1.currentTarget as GroupListItem;
         if(this.groupItem)
         {
            Connectr.instance.privateChatModel.removeGroup(this.groupItem.group.groupID);
            this.groupListContainer.removeChild(this.groupItem);
            this.groupItem.removeEventListener(PrivateChatEvent.REMOVE_GROUP,this.removeGroup);
            this.groupItem = null;
            this.setPositions();
         }
      }
      
      private function newMessageAdded(param1:PrivateChatEvent) : void
      {
         var _loc3_:GroupListItem = null;
         var _loc2_:IPrivateChatGroup = param1.group;
         if(_loc2_)
         {
            _loc3_ = this.getViewByGroupID(_loc2_.groupID);
            if(_loc3_)
            {
               this.groupListContainer.setChildIndex(_loc3_,0);
               this.setPositions();
            }
         }
      }
      
      private function newGroupAdded(param1:PrivateChatEvent) : void
      {
         if(param1.group)
         {
            this.groupItem = new GroupListItem();
            this.groupListContainer.addChildAt(this.groupItem,0);
            this.groupItem.group = param1.group;
            this.groupItem.cacheAsBitmap = true;
            this.groupItem.addEventListener(PrivateChatEvent.REMOVE_GROUP,this.removeGroup);
         }
         this.setPositions();
      }
      
      private function initGroups() : void
      {
         this.groupContainer = new Sprite();
         this.addChild(this.groupContainer);
         this.groupContainerBg = DrawUtils.getRectangleSprite(228,100,0,0);
         this.groupContainer.addChild(this.groupContainerBg);
         this.groupListContainer = new Sprite();
         this.groupContainer.addChild(this.groupListContainer);
         this.groups = Connectr.instance.privateChatModel.getGroupList();
         var _loc1_:int = 0;
         while(_loc1_ < this.groups.length)
         {
            this.group = this.groups[_loc1_];
            this.groupItem = new GroupListItem();
            this.groupListContainer.addChild(this.groupItem);
            this.groupItem.group = this.group;
            this.groupItem.cacheAsBitmap = true;
            this.groupItem.addEventListener(PrivateChatEvent.REMOVE_GROUP,this.removeGroup);
            _loc1_++;
         }
         this.setPositions();
         this.bounds = new Rectangle(this.groupContainer.x,this.groupContainer.y,228,290);
         this.blitMask = new BlitMask(this.groupContainer,this.bounds.x,this.bounds.y,this.bounds.width,this.bounds.height,false,true);
         this.blitMask.bitmapMode = false;
         this.blitMask.addEventListener(MouseEvent.MOUSE_DOWN,this.mouseDownHandler);
         Dispatcher.addEventListener(PrivateChatEvent.NEW_GROUP_ADDED,this.newGroupAdded);
         Dispatcher.addEventListener(PrivateChatEvent.NEW_MESSAGE_ADDED,this.newMessageAdded);
         Connectr.instance.serviceModel.listenExtension(BuddyResponseTypes.BUDDY_REMOVED,this.onBuddyRemoved);
      }
      
      public function setPositions() : void
      {
         var _loc1_:int = 0;
         while(_loc1_ < this.groupListContainer.numChildren)
         {
            this.groupItem = this.groupListContainer.getChildAt(_loc1_) as GroupListItem;
            this.groupItem.y = this.GROUP_VIEW_HEIGHT * _loc1_;
            _loc1_++;
         }
         this.groupContainerBg.height = this.groupListContainer.numChildren * this.GROUP_VIEW_HEIGHT;
      }
      
      private function mouseDownHandler(param1:MouseEvent) : void
      {
         TweenLite.killTweensOf(this.groupContainer);
         this.y1 = this.y2 = this.groupContainer.y;
         this.yOffset = this.mouseY - this.groupContainer.y;
         this.yOverlap = Math.max(0,this.groupContainerBg.height - this.bounds.height);
         this.t1 = this.t2 = getTimer();
         Connectr.instance.layerModel.stage.addEventListener(MouseEvent.MOUSE_MOVE,this.mouseMoveHandler);
         Connectr.instance.layerModel.stage.addEventListener(MouseEvent.MOUSE_UP,this.mouseUpHandler);
      }
      
      private function mouseMoveHandler(param1:MouseEvent) : void
      {
         this.groupContainer.mouseEnabled = false;
         this.groupContainer.mouseChildren = false;
         var _loc2_:Number = this.mouseY - this.yOffset;
         if(_loc2_ > this.bounds.top)
         {
            this.groupContainer.y = (_loc2_ + this.bounds.top) * 0.5;
         }
         else if(_loc2_ < this.bounds.top - this.yOverlap)
         {
            this.groupContainer.y = (_loc2_ + this.bounds.top - this.yOverlap) * 0.5;
         }
         else
         {
            this.groupContainer.y = _loc2_;
         }
         this.blitMask.update();
         var _loc3_:uint = uint(getTimer());
         if(_loc3_ - this.t2 > 50)
         {
            this.y2 = this.y1;
            this.t2 = this.t1;
            this.y1 = this.groupContainer.y;
            this.t1 = _loc3_;
         }
         param1.updateAfterEvent();
      }
      
      private function mouseUpHandler(param1:MouseEvent) : void
      {
         param1.stopPropagation();
         this.groupContainer.mouseEnabled = true;
         this.groupContainer.mouseChildren = true;
         Connectr.instance.layerModel.stage.removeEventListener(MouseEvent.MOUSE_UP,this.mouseUpHandler);
         Connectr.instance.layerModel.stage.removeEventListener(MouseEvent.MOUSE_MOVE,this.mouseMoveHandler);
         var _loc2_:Number = (getTimer() - this.t2) / 1000;
         var _loc3_:Number = (this.groupContainer.y - this.y2) / _loc2_;
         ThrowPropsPlugin.to(this.groupContainer,{
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
      
      public function getViewByGroupID(param1:String) : GroupListItem
      {
         var _loc2_:int = 0;
         while(_loc2_ < this.groupListContainer.numChildren)
         {
            this.groupItem = this.groupListContainer.getChildAt(_loc2_) as GroupListItem;
            if(this.groupItem.group.groupID == param1)
            {
               return this.groupItem;
            }
            _loc2_++;
         }
         return null;
      }
      
      override public function removed() : void
      {
         if(this.blitMask)
         {
            this.blitMask.removeEventListener(MouseEvent.MOUSE_DOWN,this.mouseDownHandler);
            this.blitMask.dispose();
         }
         Dispatcher.removeEventListener(PrivateChatEvent.NEW_GROUP_ADDED,this.newGroupAdded);
         Dispatcher.removeEventListener(PrivateChatEvent.NEW_MESSAGE_ADDED,this.newMessageAdded);
         Dispatcher.removeEventListener(PrivateChatEvent.LIST_ACTIVATED,this.listActivated);
         Connectr.instance.layerModel.stage.removeEventListener(MouseEvent.MOUSE_UP,this.mouseUpHandler);
         Connectr.instance.layerModel.stage.removeEventListener(MouseEvent.MOUSE_MOVE,this.mouseMoveHandler);
         Connectr.instance.serviceModel.removeExtension(BuddyResponseTypes.BUDDY_REMOVED,this.onBuddyRemoved);
      }
   }
}
