package org.oyunstudyosu.sanalika.panels.achievement
{
   public class AchievementData
   {
       
      
      public var achievementID:String;
      
      public var metaKey:String;
      
      public var title:String;
      
      public var description:String;
      
      public var currentStep:int;
      
      public var totalStep:int;
      
      public var rewardSteps:Array;
      
      public var stepCurrentValue:int;
      
      public var stepRequirementValue:int;
      
      private var _steps:Array;
      
      private var _state:String;
      
      private var _status:String;
      
      public function AchievementData()
      {
         super();
      }
      
      public function get steps() : Array
      {
         return this._steps;
      }
      
      public function set steps(param1:Array) : void
      {
         if(param1 == null)
         {
            return;
         }
         this._steps = param1;
      }
      
      public function get state() : String
      {
         return this._state;
      }
      
      public function set state(param1:String) : void
      {
         this._state = param1;
      }
      
      public function get status() : String
      {
         return this._status;
      }
      
      public function set status(param1:String) : void
      {
         this._status = param1;
         if(param1 == "WAITING")
         {
         }
      }
   }
}
