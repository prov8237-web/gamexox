package org.oyunstudyosu.sanalika.panels.cellphone.icons
{
   import com.greensock.TweenMax;
   import com.oyunstudyosu.utils.TextFieldManager;
   import flash.display.MovieClip;
   import flash.events.MouseEvent;
   import flash.text.TextField;
   import org.oyunstudyosu.components.CoreMovieClip;
   
   public class BaseIcon extends CoreMovieClip
   {
       
      
      public var icon:MovieClip;
      
      public var tIcon:MovieClip;
      
      public var titleTf:TextField;
      
      public function BaseIcon()
      {
         super();
      }
      
      override public function added() : void
      {
         this.icon = this.getChildByName("appIcon") as MovieClip;
         this.titleTf = TextFieldManager.createNoneLanguageTextfield(this.getChildByName("titleTxt") as TextField);
         this.icon.addEventListener(MouseEvent.CLICK,this.iconClicked);
         this.icon.addEventListener(MouseEvent.ROLL_OVER,this.iconOver);
         this.icon.addEventListener(MouseEvent.ROLL_OUT,this.iconOut);
         this.icon.buttonMode = true;
         this.icon.mouseChildren = false;
         this.init();
      }
      
      protected function iconOver(param1:MouseEvent) : void
      {
         TweenMax.to(this.icon,0.4,{"glowFilter":{
            "color":16777215,
            "alpha":1,
            "blurX":4,
            "blurY":4,
            "strength":4
         }});
      }
      
      protected function iconOut(param1:MouseEvent) : void
      {
         TweenMax.to(this.icon,0.4,{"glowFilter":{
            "color":16777215,
            "alpha":0,
            "blurX":4,
            "blurY":4,
            "strength":4
         }});
      }
      
      protected function init() : void
      {
      }
      
      protected function iconClicked(param1:MouseEvent) : void
      {
         this.clicked();
      }
      
      protected function clicked() : void
      {
      }
      
      override public function removed() : void
      {
      }
   }
}
