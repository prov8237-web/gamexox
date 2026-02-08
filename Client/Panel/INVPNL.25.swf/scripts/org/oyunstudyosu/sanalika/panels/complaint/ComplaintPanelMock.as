package org.oyunstudyosu.sanalika.panels.complaint
{
   import com.oyunstudyosu.enums.RequestDataKey;
   import com.oyunstudyosu.panel.PanelVO;
   import com.oyunstudyosu.sanalika.mock.IExtensionMock;
   
   public class ComplaintPanelMock implements IExtensionMock
   {
       
      
      public function ComplaintPanelMock()
      {
         super();
      }
      
      public function requestData(param1:String, param2:Object) : Object
      {
         if(param1 == RequestDataKey.COMPLAINT_LIST)
         {
            return {"data":{"complaints":[{
               "id":"2",
               "reporterAvatarID":"1077",
               "reportedAvatarID":"1078",
               "message":"fuck yddo sdf sdf sdf sdf sdf sdfsdfsdfs sdfsdfopopopopopopo llllll lllll psdfsdpopu",
               "comment":"ayip yaaa",
               "createdAt":"2016-06-02 12:00",
               "banCount":"0",
               "nextBanMin":"3"
            },{
               "id":"3",
               "reporterAvatarID":"1077",
               "reportedAvatarID":"1078",
               "message":"fuck yodfgu",
               "comment":"ayip yaaa",
               "createdAt":"2016-06-02 12:00",
               "banCount":"5",
               "nextBanMin":"635"
            },{
               "id":"4",
               "reporterAvatarID":"1077",
               "reportedAvatarID":"1078",
               "message":"fuck yo dfgu",
               "comment":"ayip yaaa",
               "createdAt":"2016-06-02 12:00",
               "banCount":"2",
               "nextBanMin":"635"
            },{
               "id":"2",
               "reporterAvatarID":"1077",
               "reportedAvatarID":"1078",
               "message":"fuck yddou",
               "comment":"ayip yaaa",
               "createdAt":"2016-06-02 12:00",
               "banCount":"0",
               "nextBanMin":"3"
            },{
               "id":"3",
               "reporterAvatarID":"1077",
               "reportedAvatarID":"1078",
               "message":"fuck yodfgu",
               "comment":"ayip yaaa",
               "createdAt":"2016-06-02 12:00",
               "banCount":"5",
               "nextBanMin":"635"
            },{
               "id":"4",
               "reporterAvatarID":"1077",
               "reportedAvatarID":"1078",
               "message":"fuck yo dfgu",
               "comment":"ayip yaaa",
               "createdAt":"2016-06-02 12:00",
               "banCount":"2",
               "nextBanMin":"635"
            },{
               "id":"2",
               "reporterAvatarID":"1077",
               "reportedAvatarID":"1078",
               "message":"fuck yddou",
               "comment":"ayip yaaa",
               "createdAt":"2016-06-02 12:00",
               "banCount":"0",
               "nextBanMin":"3"
            },{
               "id":"3",
               "reporterAvatarID":"1077",
               "reportedAvatarID":"1078",
               "message":"fuck yodfgu",
               "comment":"ayip yaaa",
               "createdAt":"2016-06-02 12:00",
               "banCount":"5",
               "nextBanMin":"635"
            },{
               "id":"4",
               "reporterAvatarID":"1077",
               "reportedAvatarID":"1078",
               "message":"fuck yo dfgu",
               "comment":"ayip yaaa",
               "createdAt":"2016-06-02 12:00",
               "banCount":"2",
               "nextBanMin":"635"
            },{
               "id":"5",
               "reporterAvatarID":"1077",
               "reportedAvatarID":"1078",
               "message":"sonnnnn cumle",
               "comment":"ayip yaaa",
               "createdAt":"2016-06-02 12:00",
               "banCount":"0",
               "nextBanMin":"635"
            }]}};
         }
         return null;
      }
      
      public function getInitData() : Object
      {
         return new PanelVO("ComplaintPanel","",{});
      }
      
      public function dispatchExtension(param1:uint) : Object
      {
         return null;
      }
   }
}
