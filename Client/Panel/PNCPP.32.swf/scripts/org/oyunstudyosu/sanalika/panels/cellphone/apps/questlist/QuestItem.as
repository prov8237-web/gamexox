package org.oyunstudyosu.sanalika.panels.cellphone.apps.questlist
{
   import com.oyunstudyosu.local.$;
   import com.oyunstudyosu.utils.STextField;
   import com.oyunstudyosu.utils.TextFieldManager;
   import flash.display.MovieClip;
   import flash.text.TextField;
   import org.oyunstudyosu.components.CoreMovieClip;
   
   [Embed(source="/_assets/assets.swf", symbol="org.oyunstudyosu.sanalika.panels.cellphone.apps.questlist.QuestItem")]
   public class QuestItem extends CoreMovieClip
   {
       
      
      public var txtName:TextField;
      
      public var sName:STextField;
      
      public var statusIndicator:MovieClip;
      
      public var indicator:MovieClip;
      
      public var data:Object;
      
      public function QuestItem()
      {
         super();
         if(this.sName == null)
         {
            this.sName = TextFieldManager.convertAsArabicTextField(this.getChildByName("txtName") as TextField,false);
         }
      }
      
      override public function added() : void
      {
         this.sName.text = $("quest_" + this.data.metaKey + "_title");
         this.statusIndicator.gotoAndStop(this.data.status);
         if(this.data.currentStep > 1)
         {
            this.indicator.width = this.data.currentStep / this.data.totalStep * 230;
         }
         else
         {
            this.indicator.visible = false;
         }
      }
      
      override public function removed() : void
      {
         this.data = null;
      }
   }
}
