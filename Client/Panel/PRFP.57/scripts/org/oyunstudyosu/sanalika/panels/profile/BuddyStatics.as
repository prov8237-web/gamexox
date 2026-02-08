package org.oyunstudyosu.sanalika.panels.profile
{
   import com.greensock.TweenMax;
   import com.greensock.easing.Quad;
   import com.oyunstudyosu.utils.TextFieldManager;
   import flash.display.MovieClip;
   import flash.text.TextField;
   import org.oyunstudyosu.components.CoreMovieClip;
   
   [Embed(source="/_assets/assets.swf", symbol="org.oyunstudyosu.sanalika.panels.profile.BuddyStatics")]
   public class BuddyStatics extends CoreMovieClip
   {
       
      
      public var buddyCountTxt:TextField;
      
      public var buddyCountTextField:TextField;
      
      public var buddyRatingMask:MovieClip;
      
      public var buddyHover:MovieClip;
      
      private var _buddyRating:Number;
      
      private var _totalBuddy:int;
      
      public function BuddyStatics()
      {
         super();
         if(this.buddyCountTextField == null)
         {
            this.buddyCountTextField = TextFieldManager.createNoneLanguageTextfield(this.getChildByName("buddyCountTxt") as TextField);
         }
      }
      
      public function get buddyRating() : Number
      {
         return this._buddyRating;
      }
      
      public function set buddyRating(param1:Number) : void
      {
         this._buddyRating = param1;
         this.buddyRatingMask.scaleX = 0;
         TweenMax.to(this.buddyRatingMask,0.5,{
            "scaleX":param1 / 5,
            "ease":Quad.easeOut
         });
      }
      
      public function get totalBuddy() : int
      {
         return this._totalBuddy;
      }
      
      public function set totalBuddy(param1:int) : void
      {
         this._totalBuddy = param1;
         this.buddyCountTextField.text = "(" + param1.toString() + ")";
      }
   }
}
