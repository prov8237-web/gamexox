package org.oyunstudyosu.sanalika.panels.quest
{
   import com.oyunstudyosu.utils.STextField;
   import com.oyunstudyosu.utils.TextFieldManager;
   import flash.display.MovieClip;
   import flash.text.TextField;
   
   public class QuestGift extends MovieClip
   {
       
      
      public var data:Object;
      
      public var quest:Object;
      
      public var infoTextField:STextField;
      
      public function QuestGift()
      {
         super();
      }
      
      public function process(param1:Object, param2:Object) : void
      {
         this.quest = param2;
         this.data = param1;
         this.buttonMode = true;
         this.mouseChildren = false;
         if(this.infoTextField == null)
         {
            this.infoTextField = TextFieldManager.convertAsArabicTextField(this.getChildByName("lbl_info") as TextField,false,false);
         }
      }
      
      public function dispose() : void
      {
      }
   }
}
