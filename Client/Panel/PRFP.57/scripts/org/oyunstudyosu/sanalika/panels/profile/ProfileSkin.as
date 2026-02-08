package org.oyunstudyosu.sanalika.panels.profile
{
   import com.oyunstudyosu.assets.AssetRequest;
   import com.oyunstudyosu.cloth.ItemFileData;
   import com.oyunstudyosu.enums.ModuleType;
   import com.oyunstudyosu.sanalika.extension.Connectr;
   import flash.display.MovieClip;
   import flash.display.Sprite;
   
   public class ProfileSkin extends Sprite
   {
       
      
      private var request:AssetRequest;
      
      public var clip:String;
      
      public var property:Object;
      
      public var roles:String;
      
      public function ProfileSkin()
      {
         super();
      }
      
      public function init(param1:Object) : void
      {
         this.dispose();
         if(param1 != null)
         {
            this.clip = param1.clip;
            this.property = param1.property;
            this.roles = param1.roles;
            trace("property:" + param1.property);
         }
         else
         {
            this.clip = null;
            this.property = null;
            this.roles = null;
            if(parent != null)
            {
               (parent as ProfilePanel).applyDefaultSkinStyle();
            }
         }
         if(this.clip == null)
         {
            return;
         }
         var _loc2_:ItemFileData = Connectr.instance.itemModel.getItemFileDataDict()[this.clip];
         var _loc3_:String = "";
         if(_loc2_ != null && _loc2_.version > 0)
         {
            _loc3_ = "." + _loc2_.version;
         }
         this.request = new AssetRequest();
         this.request.assetId = Connectr.instance.moduleModel.getPath(this.clip,ModuleType.PROFILE_SKIN) + _loc3_ + ".swf";
         this.request.type = ModuleType.PROFILE_SKIN;
         this.request.loadedFunction = this.onLoaded;
         this.request.context = Connectr.instance.domainModel.assetContext;
         this.request.priority = 99;
         Connectr.instance.assetModel.request(this.request);
      }
      
      private function onLoaded(param1:AssetRequest) : void
      {
         var _loc3_:MovieClip = null;
         var _loc2_:MovieClip = param1.display as MovieClip;
         if(_loc2_ != null)
         {
            if(_loc2_.numChildren > 0)
            {
               _loc3_ = _loc2_.getChildAt(0) as MovieClip;
               _loc3_.play();
               addChild(_loc3_);
               _loc2_.removeChildren();
            }
         }
         if(parent != null)
         {
            (parent as ProfilePanel).applySkinStyle(this.property,true);
            (parent as ProfilePanel).btnSaveVisible();
         }
      }
      
      public function dispose() : void
      {
         removeChildren();
         if(this.request != null)
         {
            this.request.dispose();
         }
      }
   }
}
