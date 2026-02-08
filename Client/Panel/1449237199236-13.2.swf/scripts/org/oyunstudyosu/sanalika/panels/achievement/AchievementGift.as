package org.oyunstudyosu.sanalika.panels.achievement
{
   import com.oyunstudyosu.utils.STextField;
   import com.oyunstudyosu.utils.TextFieldManager;
   import flash.display.MovieClip;
   import flash.text.TextField;
   
   public class AchievementGift extends MovieClip
   {
       
      
      public var data:Object;
      
      public var infoTextField:STextField;
      
      public function AchievementGift()
      {
         super();
      }
      
      public function process(param1:Object) : void
      {
         this.data = param1;
         this.buttonMode = true;
         this.mouseChildren = false;
         if(this.infoTextField == null)
         {
            this.infoTextField = TextFieldManager.convertAsArabicTextField(this.getChildByName("infoTxt") as TextField,false,false);
         }
      }
      
      public function dispose() : void
      {
      }
   }
}
