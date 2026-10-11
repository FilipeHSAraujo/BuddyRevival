package
{
   import com.adobe.serialization.json.JSON;
   import flash.display.*;
   import flash.events.*;
   import flash.external.ExternalInterface;
   import flash.geom.*;
   import flash.net.*;
   import flash.text.*;
   import flash.utils.*;
   import gadgets.io.*;
   
   public class OSUser extends BuddyPokeUser
   {
      
      public static var console:TextField;
      
      public static var domain:String = "orkut.com";
      
      private const MAX_RETRY_COUNT:int = 3;
      
      private var msCallback:Function;
      
      private var bdData:*;
      
      private var msRetryCount:int = 0;
      
      private var bdCallback:Function;
      
      private var bdRetryCount:int = 0;
      
      private var _msLoaded:Boolean = false;
      
      private var _bdError:Boolean;
      
      private var okToLoadBuddyFromCache:Boolean = true;
      
      private var isOwner:Boolean = false;
      
      private var _msError:Boolean;
      
      private var _bdLoaded:Boolean = false;
      
      private var bdUrl:String;
      
      private var isViewer:Boolean = false;
      
      private var _gender:String;
      
      private var msUrl:String;
      
      private var msData:*;
      
      public function OSUser()
      {
         super();
      }
      
      public function loadBuddy(param1:Function) : void
      {
         var cache:BuddyCache;
         var ts:int;
         var cachedFile:String = null;
         var callback:Function = param1;
         this.bdCallback = callback;
         if(console != null)
         {
            console.appendText("OSUser.loadBuddy()\n");
         }
         cache = BuddyCache.GetInstance();
         if(cache != null && okToLoadBuddyFromCache)
         {
            cachedFile = null;
            if(isOwner || isViewer)
            {
               cachedFile = cache.getBuddy20Mins(this.userId);
            }
            else
            {
               cachedFile = cache.getBuddy3Hours(this.userId);
            }
            if(cachedFile != null && cachedFile != "null" && cachedFile.length > 10)
            {
               try
               {
                  bdData = com.adobe.serialization.json.JSON.decode(cachedFile);
                  _bdLoaded = true;
                  if(bdCallback != null)
                  {
                     bdCallback(this);
                  }
                  return;
               }
               catch(e:*)
               {
               }
            }
         }
         ts = int(BuddyPoke.timeStamp());
         if(isOwner)
         {
            ts = Math.floor((ts - 299) / 300) * 300;
            loadBuddyFromAppData(ts);
         }
         else if(isViewer)
         {
            ts = Math.floor(ts / 1200) * 1200;
            loadBuddyFromAppData(ts);
         }
         else
         {
            ts = Math.floor((ts - 10799) / 10800) * 10800;
            loadBuddyFromAppData(ts);
         }
      }
      
      override public function get userIsFemale() : Boolean
      {
         return _gender == null ? false : "female" == _gender;
      }
      
      internal function createUser(param1:String, param2:String, param3:String, param4:Boolean, param5:Boolean) : void
      {
         this.isOwner = param4;
         this.isViewer = param5;
         this._gender = param3;
         msData = {
            "userId":param1,
            "name":param2
         };
         _msError = false;
         _msLoaded = true;
      }
      
      internal function createDummy(param1:String, param2:String, param3:String, param4:String) : void
      {
         var userId:String = param1;
         var userName:String = param2;
         var gender:String = param3;
         var data:String = param4;
         msData = {
            "userId":userId,
            "name":userName
         };
         this._gender = gender;
         _msError = false;
         _msLoaded = true;
         _bdLoaded = true;
         _bdError = data == null;
         if(data != null)
         {
            try
            {
               bdData = com.adobe.serialization.json.JSON.decode(data);
            }
            catch(e:*)
            {
               _bdError = true;
            }
         }
      }
      
      public function addEventToHistory(param1:*) : void
      {
         if(bdData == null || bdData.data == null || bdData.data.history == null)
         {
            return;
         }
         bdData.data.history.splice(0,0,param1);
         if(bdData.data.history.length > 20)
         {
            bdData.data.history.pop();
         }
      }
      
      override public function get userWebUri() : String
      {
         if(msData == null)
         {
            return null;
         }
         return msData.webUri;
      }
      
      private function loadBuddyAppEngine(param1:int) : void
      {
         var callbackName:String;
         var onLoad:Function;
         var params:Object;
         var user:OSUser = null;
         var ts:int = param1;
         bdUrl = "http://app.buddypoke.com/user?uid=" + msData.userId + "&ts=" + ts;
         user = this;
         onLoad = function(param1:*):void
         {
            var cache:BuddyCache = null;
            var data:* = param1;
            if(console != null)
            {
               console.appendText("loadBuddyAppEngine.onLoad " + data + "\n");
            }
            try
            {
               bdData = com.adobe.serialization.json.JSON.decode(data);
               cache = BuddyCache.GetInstance();
               if(cache != null)
               {
                  cache.cacheBuddy(userId,data);
               }
               _bdLoaded = true;
               if(bdCallback != null)
               {
                  bdCallback(user);
               }
            }
            catch(e:Error)
            {
               if(console != null)
               {
                  console.appendText("loadBuddyAppEngine failed " + e.message + "\n" + e.getStackTrace() + "\n");
               }
               ++bdRetryCount;
               if(bdRetryCount < 2)
               {
                  loadBuddyAppEngine(ts);
                  return;
               }
               _bdLoaded = true;
               _bdError = true;
               if(bdCallback != null)
               {
                  bdCallback(this);
               }
            }
         };
         callbackName = "onLoad" + BuddyPoke.timeStamp();
         ExternalInterface.addCallback(callbackName,onLoad);
         params = {};
         params[RequestParameters.METHOD] = MethodType.GET;
         params[RequestParameters.CONTENT_TYPE] = ContentType.TEXT;
         params[RequestParameters.AUTHORIZATION] = AuthorizationType.SIGNED;
         makeRequest(bdUrl,callbackName,params);
      }
      
      public function get loadedBuddy() : Boolean
      {
         return _bdLoaded;
      }
      
      private function loadBuddyS3(param1:int) : void
      {
         var callbackName:String;
         var onLoadS3:Function;
         var params:Object;
         var user:OSUser = null;
         var ts:int = param1;
         bdUrl = "http://buddypoke.s3.amazonaws.com/" + domain + "/" + msData.userId + "/" + msData.userId + "?ts=" + ts;
         user = this;
         onLoadS3 = function(param1:*):void
         {
            var cache:BuddyCache = null;
            var data:* = param1;
            if(console != null)
            {
               console.appendText("loadBuddyS3.onLoad " + data + "\n");
            }
            try
            {
               bdData = com.adobe.serialization.json.JSON.decode(data);
               cache = BuddyCache.GetInstance();
               if(cache != null)
               {
                  cache.cacheBuddy(userId,data);
               }
               _bdLoaded = true;
               if(bdCallback != null)
               {
                  bdCallback(user);
               }
            }
            catch(e:Error)
            {
               if(console != null)
               {
                  console.appendText("loadBuddyS3 failed " + bdUrl + "\n");
                  console.appendText("loadBuddyS3 error " + e.message + "\n" + e.getStackTrace() + "\n");
               }
               loadBuddyAppEngine(ts);
            }
         };
         callbackName = "onLoadS3" + BuddyPoke.timeStamp();
         ExternalInterface.addCallback(callbackName,onLoadS3);
         params = {};
         params[RequestParameters.METHOD] = MethodType.GET;
         params[RequestParameters.CONTENT_TYPE] = ContentType.TEXT;
         makeRequest(bdUrl,callbackName,params);
      }
      
      private function loadBuddyFromAppData(param1:int) : void
      {
         var callbackName:String;
         var onLoadedAppData:Function;
         var user:OSUser = null;
         var ts:int = param1;
         user = this;
         if(isOwner)
         {
            loadBuddyS3(ts);
            return;
         }
         onLoadedAppData = function(param1:String):void
         {
            var buddy:String = null;
            var data:String = param1;
            console.appendText("\n----------\n onLoadedAppData " + data + "\n\n");
            try
            {
               if(this.domain == "myspace.com")
               {
                  console.appendText("loaded buddy from app data for myspace..\n");
                  buddy = data;
                  if(buddy == null || buddy == "null" || buddy.length < 1)
                  {
                     loadBuddyS3(ts);
                     return;
                  }
                  bdData = {
                     "buddy":buddy,
                     "data":{"history":""},
                     "points":"0",
                     "pokeCnt":"0",
                     "recCnt":"0",
                     "state":"0"
                  };
                  _bdLoaded = true;
                  if(bdCallback != null)
                  {
                     bdCallback(user);
                  }
               }
               else if(data != null && data != "null" && data.length > 10)
               {
                  bdData = com.adobe.serialization.json.JSON.decode(data);
                  _bdLoaded = true;
                  if(bdCallback != null)
                  {
                     bdCallback(user);
                  }
                  return;
               }
            }
            catch(e:*)
            {
            }
            loadBuddyS3(ts);
         };
         callbackName = "onLoadedAppData" + BuddyPoke.timeStamp();
         ExternalInterface.addCallback(callbackName,onLoadedAppData);
         ExternalInterface.call("fetchBuddyAppData",callbackName,userId,"bdpkbd");
      }
      
      public function saveBuddy(param1:String) : void
      {
         var _loc2_:BuddyCache = BuddyCache.GetInstance();
         if(_loc2_ != null)
         {
            _loc2_.cacheBuddy(userId,param1);
            _loc2_.saveCache();
         }
      }
      
      public function setGender(param1:String) : void
      {
         if(param1 == null)
         {
            return;
         }
         this._gender = param1.toLowerCase();
      }
      
      override public function get userImage() : String
      {
         if(msData == null)
         {
            return null;
         }
         return msData.image;
      }
      
      override public function get userId() : String
      {
         if(msData == null)
         {
            return null;
         }
         return msData.userId;
      }
      
      public function get buddyError() : Boolean
      {
         return _bdError;
      }
      
      override public function set buddyHistory(param1:Array) : void
      {
         if(bdData == null)
         {
            bdData = {
               "buddy":"",
               "data":{"history":param1},
               "points":"0",
               "pokeCnt":"0",
               "recCnt":"0",
               "state":"0"
            };
         }
         else
         {
            bdData.data = {"history":param1};
         }
      }
      
      override public function cacheBuddy(param1:String) : void
      {
         var _loc2_:BuddyCache = BuddyCache.GetInstance();
         if(_loc2_ != null)
         {
            _loc2_.cacheBuddy(userId,param1);
         }
      }
      
      override public function get buddyHistory() : Array
      {
         if(bdData == null)
         {
            return null;
         }
         var _loc1_:* = bdData.data;
         if(_loc1_ == null)
         {
            return null;
         }
         return _loc1_.history;
      }
      
      override public function set buddyDesc(param1:String) : void
      {
         if(bdData == null)
         {
            bdData = {
               "buddy":param1,
               "data":{"history":""},
               "points":"0",
               "pokeCnt":"0",
               "recCnt":"0",
               "state":"0"
            };
         }
         else
         {
            bdData.buddy = param1;
         }
         _bdLoaded = true;
         _bdError = false;
      }
      
      override public function get userName() : String
      {
         if(msData == null)
         {
            return null;
         }
         return msData.name;
      }
      
      override public function get buddyDesc() : String
      {
         return bdData == null ? Buddy.DEFAULT : bdData.buddy;
      }
      
      override public function get userError() : Boolean
      {
         return _msError;
      }
      
      public function get loadedUser() : Boolean
      {
         return _msLoaded;
      }
   }
}

