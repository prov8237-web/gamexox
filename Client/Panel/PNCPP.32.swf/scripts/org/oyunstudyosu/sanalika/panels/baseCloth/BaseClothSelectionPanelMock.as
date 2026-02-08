package org.oyunstudyosu.sanalika.panels.baseCloth
{
   import com.oyunstudyosu.panel.PanelVO;
   import com.oyunstudyosu.sanalika.mock.IExtensionMock;
   import com.smartfoxserver.v2.SmartFox;
   
   public class BaseClothSelectionPanelMock implements IExtensionMock
   {
       
      
      public function BaseClothSelectionPanelMock()
      {
         super();
      }
      
      public function requestData(param1:String, param2:Object) : Object
      {
         if(param1 == "baseclotheslist")
         {
            return {"data":{"baseClothes":{
               "clothes":[{
                  "clip":"1",
                  "id":2,
                  "colors":["2","3","4","5","6","7","9"],
                  "placeBit":64
               },{
                  "clip":"10",
                  "id":3,
                  "colors":["3","4","5","6","7","8","9"],
                  "placeBit":131072
               },{
                  "clip":"11",
                  "id":4,
                  "colors":["1","2","3","4","6","7","9"],
                  "placeBit":131072
               },{
                  "clip":"12",
                  "id":5,
                  "colors":["1","3","4","5","6","7","8","9"],
                  "placeBit":131072
               },{
                  "clip":"13",
                  "id":6,
                  "colors":["4","5","6","7","9"],
                  "placeBit":512
               },{
                  "clip":"3",
                  "id":20,
                  "colors":["2","3","4","5","7","9"],
                  "placeBit":64
               },{
                  "clip":"5",
                  "id":28,
                  "colors":["1","3","4","5","6","7","9"],
                  "placeBit":512
               },{
                  "clip":"6",
                  "id":30,
                  "colors":["1","2","3","5","6","7","9"],
                  "placeBit":131072
               },{
                  "clip":"7",
                  "id":31,
                  "colors":["2","3","5","7","9","10"],
                  "placeBit":16
               },{
                  "clip":"8",
                  "id":32,
                  "colors":["2","3","4","5","6","7","8","9"],
                  "placeBit":131072
               },{
                  "clip":"9",
                  "id":33,
                  "colors":["1","2","3","5","7","9"],
                  "placeBit":131072
               },{
                  "clip":"A",
                  "id":1344,
                  "colors":["1","2","8","12"],
                  "placeBit":4
               },{
                  "clip":"B",
                  "id":1348,
                  "colors":["1","2","8","12"],
                  "placeBit":2
               },{
                  "clip":"C",
                  "id":1349,
                  "colors":["1","2","8","12"],
                  "placeBit":1
               }],
               "gender":"f"
            }}};
         }
         if(param1 == "savebaseclothes")
         {
            return {"data":{
               "res":"ok",
               "clothes":[{
                  "id":118758859,
                  "cn":"m_2_5",
                  "base":1,
                  "on":1
               },{
                  "id":118758861,
                  "cn":"m_6_6",
                  "base":1,
                  "on":1
               },{
                  "id":118758860,
                  "cn":"m_13_3",
                  "base":1,
                  "on":1
               },{
                  "id":118758855,
                  "cn":"m_C_1",
                  "base":1,
                  "on":1
               },{
                  "id":118758856,
                  "cn":"m_B_1",
                  "base":1,
                  "on":1
               },{
                  "id":118758857,
                  "cn":"m_A_1",
                  "base":1,
                  "on":1
               },{
                  "id":118758858,
                  "cn":"m_7_1",
                  "base":1,
                  "on":1
               }]
            }};
         }
         return null;
      }
      
      public function getInitData() : Object
      {
         return new PanelVO();
      }
      
      public function getExtensionResponse(param1:uint, param2:SmartFox) : void
      {
      }
      
      public function dispatchExtension(param1:uint) : Object
      {
         return null;
      }
   }
}
