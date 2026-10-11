package gadgets.io
{
   import flash.external.ExternalInterface;
   
   public function makeRequest(param1:String, param2:String, param3:*) : void
   {
      ExternalInterface.call("makeFlashRequest",param1,param2,param3);
   }
}

