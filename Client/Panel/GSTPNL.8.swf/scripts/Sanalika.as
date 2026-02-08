package
{
   import com.oyunstudyosu.sanalika.extension.Connectr;
   import com.oyunstudyosu.sanalika.mock.SanalikaMock;
   import flash.events.Event;
   import org.oyunstudyosu.sanalika.mock.CookieModel;
   import org.oyunstudyosu.sanalika.mock.Engine;
   import org.oyunstudyosu.sanalika.mock.PanelManager;
   import org.oyunstudyosu.sanalika.mock.QuestModel;
   import org.oyunstudyosu.sanalika.mock.ServiceModel;
   import org.oyunstudyosu.sanalika.mock.ToolTipModel;
   import org.oyunstudyosu.sanalika.mock.UpdateModel;
   
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
         instance = this;
         Connectr.instance = this;
         super.onAddedStage(param1);
         if(serviceModel)
         {
            serviceModel = null;
         }
         serviceModel = new ServiceModel();
         toolTipModel = new ToolTipModel();
         updateModel = new UpdateModel();
         cookieModel = new CookieModel();
         questModel = new QuestModel();
         panelManager = new PanelManager(this);
         this.engine = new Engine(stage);
      }
   }
}
