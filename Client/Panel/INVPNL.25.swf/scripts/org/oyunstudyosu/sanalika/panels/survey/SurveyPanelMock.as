package org.oyunstudyosu.sanalika.panels.survey
{
   import com.oyunstudyosu.panel.PanelVO;
   import com.oyunstudyosu.sanalika.mock.IExtensionMock;
   
   public class SurveyPanelMock implements IExtensionMock
   {
       
      
      public function SurveyPanelMock()
      {
         super();
      }
      
      public function requestData(param1:String, param2:Object) : Object
      {
         if(param1 == "surveylist")
         {
            return {"data":{"surveyList":[{
               "id":2,
               "text":"ne renk seversin?",
               "answerList":[{
                  "id":1,
                  "text":"mavi"
               },{
                  "id":2,
                  "text":"kirmizi"
               },{
                  "id":3,
                  "text":"yesil"
               }]
            }]}};
         }
         return null;
      }
      
      public function getInitData() : Object
      {
         return new PanelVO("SurveyPanel","",{});
      }
      
      public function dispatchExtension(param1:uint) : Object
      {
         return null;
      }
   }
}
