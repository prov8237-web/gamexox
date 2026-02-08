package org.oyunstudyosu.sanalika.panels.settings
{
   import com.greensock.TweenMax;
   import com.oyunstudyosu.alert.AlertEvent;
   import com.oyunstudyosu.alert.AlertType;
   import com.oyunstudyosu.alert.AlertVo;
   import com.oyunstudyosu.enums.AvatarPermission;
   import com.oyunstudyosu.events.Dispatcher;
   import com.oyunstudyosu.local.$;
   import com.oyunstudyosu.sanalika.extension.Connectr;
   import com.oyunstudyosu.utils.STextField;
   import com.oyunstudyosu.utils.TextFieldManager;
   import com.printfas3.printf;
   import flash.events.MouseEvent;
   import flash.text.TextField;
   import org.oyunstudyosu.components.CoreMovieClip;
   
   [Embed(source="/_assets/assets.swf", symbol="org.oyunstudyosu.sanalika.panels.settings.SettingItem")]
   public class SettingItem extends CoreMovieClip
   {
       
      
      public var txtName:TextField;
      
      private var sName:STextField;
      
      private var _key:String;
      
      public var btnOnOff:OnOffButton;
      
      private var requiredPermissions:Array;
      
      public function SettingItem(param1:String, param2:String, param3:Array)
      {
         super();
         this._key = param1;
         this.requiredPermissions = param3;
         if(this.sName == null)
         {
            this.sName = TextFieldManager.convertAsArabicTextField(this.getChildByName("txtName") as TextField,false);
            this.sName.text = $(param2);
         }
      }
      
      override public function added() : void
      {
         this.btnOnOff.selected = Connectr.instance.avatarModel.settings[this.key];
         this.initOnOffButton();
      }
      
      override public function removed() : void
      {
      }
      
      private function initOnOffButton() : void
      {
         var _loc1_:String = null;
         for each(_loc1_ in this.requiredPermissions)
         {
            if(!Connectr.instance.avatarModel.permission.check(AvatarPermission[_loc1_]))
            {
               Connectr.instance.avatarModel.settings.showInvitations = true;
               this.btnOnOff.disable();
               this.btnOnOff.addEventListener(MouseEvent.CLICK,this.insufficientPermission);
               TweenMax.to(this.btnOnOff,0,{"colorMatrixFilter":{"saturation":0}});
            }
         }
      }
      
      public function insufficientPermission(param1:MouseEvent) : void
      {
         var _loc2_:String = null;
         var _loc3_:AlertVo = null;
         param1.stopPropagation();
         for each(_loc2_ in this.requiredPermissions)
         {
            if(!Connectr.instance.avatarModel.permission.check(AvatarPermission[_loc2_]))
            {
               _loc3_ = new AlertVo();
               _loc3_.alertType = AlertType.TOOLTIP;
               _loc3_.description = printf($("REQUIREMENTS") + ": " + $("ROLE_ERROR_" + _loc2_));
               Dispatcher.dispatchEvent(new AlertEvent(_loc3_));
            }
         }
      }
      
      public function get key() : String
      {
         return this._key;
      }
      
      public function get value() : Boolean
      {
         return this.btnOnOff.selected;
      }
      
      public function set value(param1:Boolean) : void
      {
         this.btnOnOff.selected = param1;
      }
   }
}
