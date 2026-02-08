package org.oyunstudyosu.sanalika.panels.cellphone.apps.privatechat.bubble
{
   import com.greensock.TweenMax;
   import com.greensock.plugins.TintPlugin;
   import com.greensock.plugins.TweenPlugin;
   import com.oyunstudyosu.privatechat.IPrivateChatMessage;
   import com.oyunstudyosu.utils.STextField;
   import com.oyunstudyosu.utils.TextFieldManager;
   import flash.display.BlendMode;
   import flash.display.MovieClip;
   import flash.text.TextField;
   import org.oyunstudyosu.components.CoreMovieClip;
   
   [Embed(source="/_assets/assets.swf", symbol="org.oyunstudyosu.sanalika.panels.cellphone.apps.privatechat.bubble.ChatBubble")]
   public class ChatBubble extends CoreMovieClip
   {
       
      
      public var messageTxt:TextField;
      
      private var message:IPrivateChatMessage;
      
      public var bgContainer:MovieClip;
      
      private var messageTextField:STextField;
      
      public function ChatBubble(param1:IPrivateChatMessage)
      {
         super();
         this.message = param1;
      }
      
      override public function added() : void
      {
         TweenPlugin.activate([TintPlugin]);
         if(this.messageTextField == null)
         {
            this.messageTextField = TextFieldManager.convertAsArabicTextField(this.getChildByName("messageTxt") as TextField,true,false);
         }
         this.messageTextField.multiline = true;
         this.messageTextField.wordWrap = true;
         this.messageTextField.width = 190;
         this.messageTextField.text = this.message.content;
         this.messageTextField.width = this.messageTextField.textWidth + 6;
         this.bgContainer.bg.width = int(this.messageTextField.width + 10);
         this.messageTextField.height = this.messageTextField.textHeight + 4;
         this.bgContainer.bg.height = int(this.messageTextField.height + 8);
         this.bgContainer.arrow.y = this.bgContainer.bg.height / 2;
         if(this.message.isAdmin)
         {
            this.bgContainer.arrow.visible = false;
            TweenMax.to(this.bgContainer.bg,0,{"tint":15684432});
            this.x = int(228 - this.bgContainer.bg.width - 20);
         }
         else if(this.message.isMine)
         {
            this.bgContainer.arrow.gotoAndStop(2);
            this.bgContainer.bg.gotoAndStop(2);
            this.bgContainer.arrow.scaleX = -1;
            this.bgContainer.arrow.x = this.bgContainer.bg.width + 2;
            this.x = int(228 - this.bgContainer.bg.width - 10);
            TweenMax.to(this.bgContainer,0,{"dropShadowFilter":{
               "color":0,
               "alpha":0.3,
               "blurX":1,
               "blurY":1,
               "distance":1,
               "angle":90
            }});
         }
         else
         {
            this.x = 10;
            TweenMax.to(this.bgContainer,0,{"dropShadowFilter":{
               "color":0,
               "alpha":0.3,
               "blurX":1,
               "blurY":1,
               "distance":1,
               "angle":90
            }});
         }
         this.buttonMode = true;
         this.mouseChildren = false;
         this.blendMode = BlendMode.LAYER;
         this.cacheAsBitmap = true;
      }
   }
}
