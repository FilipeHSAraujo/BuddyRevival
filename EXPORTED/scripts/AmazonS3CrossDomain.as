package
{
   import flash.system.Security;
   
   public class AmazonS3CrossDomain
   {
      
      private static var loadedPolicyFile:Boolean = false;
      
      public function AmazonS3CrossDomain()
      {
         super();
      }
      
      public static function loadPolicyFile() : void
      {
         if(loadedPolicyFile == false)
         {
            loadedPolicyFile = true;
            Security.loadPolicyFile("http://buddypoke.s3.amazonaws.com/crossdomain.xml");
         }
      }
   }
}

