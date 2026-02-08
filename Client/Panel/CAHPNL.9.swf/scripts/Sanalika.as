package
{
   import com.oyunstudyosu.sanalika.mock.SanalikaMock;
   import flash.events.Event;
   import org.oyunstudyosu.sanalika.mock.Engine;
   import org.oyunstudyosu.sanalika.mock.PanelManager;
   
   public class Sanalika extends SanalikaMock
   {
      
      public static var instance:Sanalika;
      
      public static var panelManager:PanelManager;
       
      
      public var engine:Engine;
      
      public function Sanalika()
      {
         super();
      }
      
      override protected function onAddedStage(param1:Event) : void
      {
      }
   }
}
