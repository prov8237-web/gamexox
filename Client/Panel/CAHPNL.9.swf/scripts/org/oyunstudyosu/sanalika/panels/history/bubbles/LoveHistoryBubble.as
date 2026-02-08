package org.oyunstudyosu.sanalika.panels.history.bubbles
{
   import com.oyunstudyosu.sanalika.extension.Connectr;
   import com.oyunstudyosu.sanalika.interfaces.IHistorySpeechBubble;
   import com.oyunstudyosu.utils.STextField;
   import com.oyunstudyosu.utils.TextFieldManager;
   import flash.display.MovieClip;
   import flash.text.TextField;
   import flash.text.TextFieldAutoSize;
   
   [Embed(source="/_assets/assets.swf", symbol="org.oyunstudyosu.sanalika.panels.history.bubbles.LoveHistoryBubble")]
   public class LoveHistoryBubble extends BaseHistoryBubble implements IHistorySpeechBubble
   {
       
      
      public var speechTxt:TextField;
      
      public var bg:MovieClip;
      
      private var sText:STextField;
      
      private var _avatarId:String;
      
      private var _avatarName:String;
      
      private var _message:String;
      
      public function LoveHistoryBubble()
      {
         super();
      }
      
      public function get avatarId() : String
      {
         return this._avatarId;
      }
      
      public function get avatarName() : String
      {
         return this._avatarName;
      }
      
      public function get message() : String
      {
         return this._message;
      }
      
      public function get isMe() : Boolean
      {
         return this._avatarId == Connectr.instance.avatarModel.avatarId;
      }
      
      public function speech(param1:String, param2:String, param3:String = "") : void
      {
         this._avatarId = param1;
         this._avatarName = param2;
         this._message = param3;
         if(this.sText == null)
         {
            this.sText = TextFieldManager.convertAsArabicTextField(getChildByName("speechTxt") as TextField);
         }
         this.sText.x = 4;
         this.sText.y = 0;
         this.sText.multiline = true;
         this.sText.wordWrap = true;
         this.sText.width = 210;
         this.sText.autoSize = TextFieldAutoSize.NONE;
         this.sText.htmlText = "<font color=\"#8B418E\">" + param2 + ": " + "</font>" + "<font color=\"#5E5E5E\">" + param3 + "</font>";
         this.sText.height = this.sText.textHeight + 6;
         if(this.sText.numLines == 1)
         {
            this.sText.width = this.sText.textWidth + 6;
         }
         this.bg.width = this.sText.width + (this.sText.x - this.bg.x) * 2;
         this.bg.height = this.sText.height + (this.sText.y - this.bg.y) * 2;
         copyMessage(this.sText,param3);
      }
   }
}
