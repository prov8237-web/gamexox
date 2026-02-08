package org.oyunstudyosu.sanalika.panels.avatarSwitch
{
   import com.oyunstudyosu.sanalika.mock.IExtensionMock;
   import com.smartfoxserver.v2.SmartFox;
   
   public class AvatarSwitchPanelMock implements IExtensionMock
   {
       
      
      public function AvatarSwitchPanelMock()
      {
         super();
      }
      
      public function requestData(param1:String, param2:Object) : Object
      {
         if(param1 == "avatarlist")
         {
            return {"data":{"avatarList":[{
               "avatarID":1078,
               "avatarName":"Kazım",
               "gender":"f",
               "statusMessage":"Selam kızlar",
               "loginCount":112,
               "lastLoginDate":189017821
            },{
               "avatarID":1079,
               "avatarName":"Osman",
               "gender":"m",
               "statusMessage":"Selam kızlar",
               "loginCount":112,
               "lastLoginDate":189017821
            },{
               "avatarID":1079,
               "avatarName":"Osman",
               "gender":"m",
               "statusMessage":"Selam kızlar",
               "loginCount":112,
               "lastLoginDate":189017821
            },{
               "avatarID":1079,
               "avatarName":"Osman",
               "gender":"m",
               "statusMessage":"Selam kızlar",
               "loginCount":112,
               "lastLoginDate":189017821
            },{
               "avatarID":1079,
               "avatarName":"Osman",
               "gender":"m",
               "statusMessage":"Selam kızlar",
               "loginCount":112,
               "lastLoginDate":189017821
            },{
               "avatarID":1079,
               "avatarName":"Osman",
               "gender":"m",
               "statusMessage":"Selam kızlar",
               "loginCount":112,
               "lastLoginDate":189017821
            }]}};
         }
         return null;
      }
      
      public function getInitData() : Object
      {
         return null;
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
