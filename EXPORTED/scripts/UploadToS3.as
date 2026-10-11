package
{
   import flash.events.Event;
   import flash.events.HTTPStatusEvent;
   import flash.events.IOErrorEvent;
   import flash.events.ProgressEvent;
   import flash.events.SecurityErrorEvent;
   import flash.net.URLLoader;
   import flash.net.URLRequest;
   import flash.net.URLRequestMethod;
   import flash.text.TextField;
   import flash.utils.ByteArray;
   
   public class UploadToS3 extends URLLoader
   {
      
      private var retryCount:int = 0;
      
      private var request:URLRequest;
      
      private var console:TextField;
      
      private var dispatched:Boolean = false;
      
      public function UploadToS3(param1:TextField)
      {
         var console:TextField = param1;
         this.console = console;
         addEventListener(IOErrorEvent.IO_ERROR,ioErrorHandler);
         addEventListener(SecurityErrorEvent.SECURITY_ERROR,securityErrorHandler);
         addEventListener(HTTPStatusEvent.HTTP_STATUS,httpStatusHandler);
         addEventListener(Event.COMPLETE,completeHandler);
         addEventListener(Event.OPEN,openHandler);
         addEventListener(ProgressEvent.PROGRESS,progressHandler);
         try
         {
            super();
         }
         catch(asd:*)
         {
         }
      }
      
      private function openHandler(param1:Event) : void
      {
         console.appendText("-------\n");
         console.appendText("openHandler: " + param1 + "\n");
         console.appendText("-------\n");
      }
      
      private function securityErrorHandler(param1:SecurityErrorEvent) : void
      {
         console.appendText("-------\n");
         console.appendText("securityErrorHandler: " + param1 + "\n");
         console.appendText("-------\n");
      }
      
      public function ioErrorHandler(param1:IOErrorEvent) : void
      {
         console.appendText("-------\n");
         console.appendText("ioErrorHandler: " + param1 + "\n");
         console.appendText("ioErrorHandler text: " + param1.text + "\n");
         console.appendText("ioErrorHandler type: " + param1.type + "\n");
         console.appendText("-------\n");
      }
      
      private function httpStatusHandler(param1:HTTPStatusEvent) : void
      {
         console.appendText("-------\n");
         console.appendText("httpStatusHandler: " + param1 + "\n");
         console.appendText("httpStatusHandler status: " + param1.status + "\n");
         console.appendText("-------\n");
         if(param1.status == 201)
         {
            if(!dispatched)
            {
               dispatched = true;
               dispatchEvent(new UploadToS3Event(UploadToS3Event.S3COMPLETE,"200"));
            }
            return;
         }
         if(param1.status == 200)
         {
            return;
         }
         if(param1.status == 400 || param1.status == 403 || param1.status == 409 || param1.status == 500 || param1.status == 503)
         {
            ++retryCount;
            if(retryCount <= 2)
            {
               load(request);
               return;
            }
            if(!dispatched)
            {
               dispatched = true;
               dispatchEvent(new UploadToS3Event(UploadToS3Event.S3ERROR,param1.status.toString()));
            }
         }
      }
      
      private function completeHandler(param1:Event) : void
      {
         console.appendText("-------\n");
         console.appendText("completeHandler: " + param1 + "\n");
         console.appendText("-------\n");
         if(!dispatched)
         {
            dispatched = true;
            dispatchEvent(new UploadToS3Event(UploadToS3Event.S3COMPLETE,"200"));
         }
      }
      
      public function uploadFileToAmazon(param1:String, param2:String, param3:String, param4:String, param5:String, param6:String, param7:String, param8:String, param9:ByteArray, param10:*, param11:String, param12:String) : void
      {
         var dataArray:ByteArray;
         var Boundary:String;
         var i:int;
         var s:String = null;
         var postUrl:String = param1;
         var key:String = param2;
         var acl:String = param3;
         var contentType:String = param4;
         var AWSAccessKeyId:String = param5;
         var policy:String = param6;
         var signature:String = param7;
         var fileName:String = param8;
         var fileData:ByteArray = param9;
         var metaData:* = param10;
         var md5:String = param11;
         var cacheControl:String = param12;
         request = new URLRequest(postUrl);
         dataArray = new ByteArray();
         Boundary = "---------------------------";
         i = 0;
         while(i < 16)
         {
            Boundary += String.fromCharCode(int(97 + Math.random() * 25));
            i++;
         }
         dataArray.writeMultiByte("--" + Boundary + "\r\nContent-Disposition: form-data; name=\"key\"\r\n\r\n" + key + "\r\n","ascii");
         dataArray.writeMultiByte("--" + Boundary + "\r\nContent-Disposition: form-data; name=\"acl\"\r\n\r\npublic-read\r\n","ascii");
         dataArray.writeMultiByte("--" + Boundary + "\r\nContent-Disposition: form-data; name=\"Content-Type\"\r\n\r\n" + contentType + "\r\n","ascii");
         dataArray.writeMultiByte("--" + Boundary + "\r\nContent-Disposition: form-data; name=\"AWSAccessKeyId\"\r\n\r\n" + AWSAccessKeyId + "\r\n","ascii");
         dataArray.writeMultiByte("--" + Boundary + "\r\nContent-Disposition: form-data; name=\"policy\"\r\n\r\n" + policy + "\r\n","ascii");
         dataArray.writeMultiByte("--" + Boundary + "\r\nContent-Disposition: form-data; name=\"success_action_status\"\r\n\r\n201\r\n","ascii");
         if(md5 != null)
         {
            dataArray.writeMultiByte("--" + Boundary + "\r\nContent-Disposition: form-data; name=\"Content-MD5\"\r\n\r\n" + md5 + "\r\n","ascii");
         }
         if(cacheControl != null)
         {
            dataArray.writeMultiByte("--" + Boundary + "\r\nContent-Disposition: form-data; name=\"Cache-Control\"\r\n\r\n" + cacheControl + "\r\n","ascii");
         }
         if(metaData != null)
         {
            for(s in metaData)
            {
               dataArray.writeMultiByte("--" + Boundary + "\r\nContent-Disposition: form-data; name=\"" + s + "\"\r\n\r\n" + metaData[s] + "\r\n","ascii");
            }
         }
         dataArray.writeMultiByte("--" + Boundary + "\r\nContent-Disposition: form-data; name=\"signature\"\r\n\r\n" + signature + "\r\n","ascii");
         dataArray.writeMultiByte("--" + Boundary + "\r\nContent-Disposition: form-data; name=\"file\"; filename=\"" + fileName + "\"\r\nContent-Type: " + contentType + "\r\n\r\n","ascii");
         dataArray.writeBytes(fileData,0,fileData.length);
         dataArray.writeMultiByte("\r\n","ascii");
         dataArray.writeMultiByte("--" + Boundary + "\r\nContent-Disposition: form-data; name=\"Upload\"\r\n\r\nSubmit Query\r\n","ascii");
         dataArray.writeMultiByte("--" + Boundary + "--","ascii");
         request.data = dataArray;
         request.method = URLRequestMethod.POST;
         request.contentType = "multipart/form-data; boundary=" + Boundary;
         try
         {
            load(request);
         }
         catch(error:Error)
         {
            trace("Unable to load requested document.");
         }
      }
      
      private function progressHandler(param1:ProgressEvent) : void
      {
         console.appendText("-------\n");
         console.appendText("progressHandler loaded:" + param1.bytesLoaded + " total: " + param1.bytesTotal + "\n");
         console.appendText("-------\n");
      }
   }
}

