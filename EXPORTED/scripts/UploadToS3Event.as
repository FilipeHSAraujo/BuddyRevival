package
{
   import flash.events.Event;
   
   public class UploadToS3Event extends Event
   {
      
      public static const S3COMPLETE:String = "S3COMPLETE";
      
      public static const S3ERROR:String = "S3ERROR";
      
      private var _code:String = "";
      
      public function UploadToS3Event(param1:String, param2:String)
      {
         super(param1,true);
         _code = param2;
      }
      
      public function get code() : String
      {
         return _code;
      }
   }
}

