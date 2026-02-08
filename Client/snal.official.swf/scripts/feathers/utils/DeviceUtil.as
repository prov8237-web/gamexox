package feathers.utils
{
   import flash.ui.Mouse;
   
   public class DeviceUtil
   {
      
      public static var MEDIA_QUERY_DESKTOP:String;
      
      public static var MEDIA_QUERY_MOBILE:String;
       
      
      public function DeviceUtil()
      {
      }
      
      public static function isDesktop() : Boolean
      {
         return Mouse.supportsCursor;
      }
      
      public static function isMobile() : Boolean
      {
         return !Mouse.supportsCursor;
      }
   }
}
