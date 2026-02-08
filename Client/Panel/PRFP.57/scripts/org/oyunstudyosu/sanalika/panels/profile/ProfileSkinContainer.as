package org.oyunstudyosu.sanalika.panels.profile
{
   import com.greensock.TweenMax;
   import com.greensock.easing.Back;
   import com.oyunstudyosu.enums.RequestDataKey;
   import com.oyunstudyosu.sanalika.extension.Connectr;
   import flash.display.MovieClip;
   import flash.display.SimpleButton;
   import flash.events.MouseEvent;
   
   [Embed(source="/_assets/assets.swf", symbol="org.oyunstudyosu.sanalika.panels.profile.ProfileSkinContainer")]
   public class ProfileSkinContainer extends MovieClip
   {
       
      
      public var container:MovieClip;
      
      public var bg:MovieClip;
      
      private var slots:Array;
      
      private var profileSkins:Array;
      
      public var btnRemoveProfileSkin:SimpleButton;
      
      public var btnNext:SimpleButton;
      
      public var btnPrev:SimpleButton;
      
      private var currentPage:int = 1;
      
      private var slotCount:int = 23;
      
      public function ProfileSkinContainer()
      {
         this.slots = [];
         this.profileSkins = [];
         super();
      }
      
      public function init() : void
      {
         x = 10;
         y = 24;
         this.container.removeChildren();
         this.btnRemoveProfileSkin.visible = false;
         this.btnNext.visible = false;
         this.btnPrev.visible = false;
      }
      
      public function move() : void
      {
         if(this.x > 0)
         {
            Connectr.instance.serviceModel.requestData(RequestDataKey.PROFILE_SKIN_LIST,{
               "search":"",
               "page":1,
               "sort":"created_desc"
            },this.skinResponse);
         }
         else
         {
            TweenMax.to(this,0.5,{
               "x":10,
               "ease":Back.easeOut
            });
         }
      }
      
      private function skinResponse(param1:Object) : void
      {
         var xPos:int;
         var pos:int;
         var j:int;
         var xThis:int;
         var profileSkin:Object = null;
         var slot:SkinSlot = null;
         var data:Object = param1;
         this.profileSkins = data.items.list;
         xPos = 0;
         pos = 0;
         if(data.pageSelected == 1)
         {
            this.btnRemoveProfileSkin.visible = true;
            this.btnRemoveProfileSkin.addEventListener(MouseEvent.CLICK,function(param1:MouseEvent):void
            {
               (parent as ProfilePanel).profileSkin.init(null);
            });
            this.btnRemoveProfileSkin.y = 4;
            this.btnRemoveProfileSkin.x = 4;
            pos++;
         }
         if(this.profileSkins.length > this.slotCount)
         {
            this.btnNext.visible = true;
            this.btnPrev.visible = true;
            this.btnNext.addEventListener(MouseEvent.CLICK,this.nextPage);
            this.btnNext.addEventListener(MouseEvent.CLICK,this.prevPage);
         }
         j = 0;
         while(j < this.profileSkins.length)
         {
            profileSkin = this.profileSkins[j];
            slot = new SkinSlot();
            if(pos % 6 == 0 && pos > 0)
            {
               xPos += 44;
            }
            slot.x = xPos;
            slot.y = pos % 6 * 43;
            slot.init(profileSkin);
            slot.loadAsset("profileskins");
            this.slots.push(slot);
            this.container.addChild(slot);
            this.slots.push(slot);
            pos++;
            j++;
         }
         xThis = -(Math.ceil(pos / 6) * 44) - 10;
         TweenMax.to(this,0.5,{
            "x":xThis,
            "ease":Back.easeOut
         });
      }
      
      private function nextPage(param1:MouseEvent) : void
      {
         if(this.currentPage < Math.floor(this.profileSkins.length / this.slotCount))
         {
            ++this.currentPage;
            Connectr.instance.serviceModel.requestData(RequestDataKey.PROFILE_SKIN_LIST,{
               "search":"",
               "page":this.currentPage,
               "sort":"created_desc"
            },this.skinResponse);
         }
      }
      
      private function prevPage(param1:MouseEvent) : void
      {
         --this.currentPage;
         if(this.currentPage < 1)
         {
            this.currentPage = 1;
         }
         Connectr.instance.serviceModel.requestData(RequestDataKey.PROFILE_SKIN_LIST,{
            "search":"",
            "page":this.currentPage,
            "sort":"created_desc"
         },this.skinResponse);
      }
      
      private function removeSkinResponse(param1:Object) : void
      {
      }
      
      public function reset(param1:Array) : void
      {
         this.init();
      }
      
      public function dispose() : void
      {
         var _loc1_:Slot = null;
         this.btnNext.removeEventListener(MouseEvent.CLICK,this.nextPage);
         this.btnNext.removeEventListener(MouseEvent.CLICK,this.prevPage);
         for each(_loc1_ in this.slots)
         {
            _loc1_.dispose();
         }
         this.slots = [];
      }
   }
}
