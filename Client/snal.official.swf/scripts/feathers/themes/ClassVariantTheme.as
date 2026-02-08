package feathers.themes
{
   import feathers.events.FeathersEvent;
   import feathers.style.ClassVariantStyleProvider;
   import feathers.style.IStyleObject;
   import feathers.style.IStyleProvider;
   import feathers.style.ITheme;
   import feathers.style.IVariantStyleObject;
   import feathers.style.Theme;
   import flash.Boot;
   import flash.events.Event;
   
   public class ClassVariantTheme implements ITheme
   {
       
      
      public var styleProvider:ClassVariantStyleProvider;
      
      public function ClassVariantTheme()
      {
         if(Boot.skip_constructor)
         {
            return;
         }
         styleProvider = new ClassVariantStyleProvider();
      }
      
      public function getStyleProvider(param1:IStyleObject) : IStyleProvider
      {
         var _loc4_:* = null as IVariantStyleObject;
         var _loc7_:* = null as IStyleProvider;
         var _loc8_:* = null as ClassVariantStyleProvider;
         var _loc9_:* = null as Function;
         var _loc2_:Class = null;
         var _loc3_:String = null;
         if(param1 is IVariantStyleObject)
         {
            _loc2_ = (_loc4_ = param1).get_styleContext();
            _loc3_ = _loc4_.get_variant();
         }
         if(_loc2_ == null)
         {
            _loc2_ = Type.getClass(param1);
         }
         var _loc5_:Function;
         if((_loc5_ = styleProvider.getStyleFunction(_loc2_,_loc3_)) != null)
         {
            return styleProvider;
         }
         if(_loc3_ == null)
         {
            return null;
         }
         var _loc6_:ITheme = Theme.get_fallbackTheme();
         if(_loc6_ != null && _loc6_ != this && _loc6_ is ClassVariantTheme)
         {
            if((_loc8_ = (_loc7_ = _loc6_.getStyleProvider(param1)) as ClassVariantStyleProvider) != null)
            {
               if((_loc9_ = _loc8_.getStyleFunction(_loc2_,_loc3_)) != null)
               {
                  return null;
               }
            }
         }
         if((_loc5_ = styleProvider.getStyleFunction(_loc2_,null)) != null)
         {
            return styleProvider;
         }
         return null;
      }
      
      public function dispose() : void
      {
         FeathersEvent.dispatch(styleProvider,Event.CLEAR);
      }
   }
}
