package org.oyunstudyosu.sanalika.panels.cellphone.apps.funwin
{
   import com.greensock.TweenMax;
   import com.oyunstudyosu.events.Dispatcher;
   import com.oyunstudyosu.events.ProfileEvent;
   import com.oyunstudyosu.utils.STextField;
   import com.oyunstudyosu.utils.TextFieldManager;
   import flash.display.MovieClip;
   import flash.events.MouseEvent;
   import flash.text.TextField;
   import org.oyunstudyosu.components.CoreMovieClip;
   
   [Embed(source="/_assets/assets.swf", symbol="org.oyunstudyosu.sanalika.panels.cellphone.apps.funwin.FunwinTopListItem")]
   public class FunwinTopListItem extends CoreMovieClip
   {
       
      
      public var txtName:TextField;
      
      public var sName:STextField;
      
      public var data:Object;
      
      public var order:int;
      
      public var txtOrder:TextField;
      
      public var txtPrize:TextField;
      
      public var txtCount:TextField;
      
      public var itemBg:MovieClip;
      
      public function FunwinTopListItem()
      {
         super();
         if(this.sName == null)
         {
            this.sName = TextFieldManager.convertAsArabicTextField(this.getChildByName("txtName") as TextField,false);
         }
      }
      
      override public function added() : void
      {
         this.sName.text = this.data.avatarName;
         this.txtOrder.text = this.order.toString();
         this.txtPrize.text = this.data.winPrize;
         this.txtCount.text = this.data.winCount;
         if(this.order == 1)
         {
            TweenMax.to(this.itemBg,3,{"colorTransform":{
               "tint":16498733,
               "tintAmount":1
            }});
         }
         else if(this.order == 2)
         {
            TweenMax.to(this.itemBg,2,{"colorTransform":{
               "tint":16771899,
               "tintAmount":1
            }});
         }
         else if(this.order == 3)
         {
            TweenMax.to(this.itemBg,1,{"colorTransform":{
               "tint":16773494,
               "tintAmount":1
            }});
         }
         this.buttonMode = true;
         this.addEventListener(MouseEvent.CLICK,this.openProfile);
      }
      
      public function openProfile(param1:MouseEvent) : void
      {
         var _loc2_:ProfileEvent = new ProfileEvent(ProfileEvent.SHOW_PROFILE);
         _loc2_.avatarID = this.data.avatarID;
         Dispatcher.dispatchEvent(_loc2_);
      }
      
      override public function removed() : void
      {
         this.removeEventListener(MouseEvent.CLICK,this.openProfile);
         this.data = null;
      }
   }
}
