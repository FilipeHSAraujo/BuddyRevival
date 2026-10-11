package
{
   import flash.utils.ByteArray;
   import flash.utils.Dictionary;
   
   public class MessageBundle
   {
      
      private static var dict:Dictionary;
      
      internal static const th:Class = MessageBundle_th;
      
      internal static const pt:Class = MessageBundle_pt;
      
      internal static const es:Class = MessageBundle_es;
      
      internal static const fr:Class = MessageBundle_fr;
      
      internal static const zh:Class = MessageBundle_zh;
      
      public function MessageBundle()
      {
         super();
      }
      
      public static function msg(param1:String, param2:Boolean = false) : String
      {
         var _loc4_:String = null;
         if(dict == null)
         {
            return param1;
         }
         if(param2)
         {
            _loc4_ = dict[param1 + "(f)"];
            if(_loc4_ != null && _loc4_.length > 0)
            {
               return _loc4_;
            }
         }
         var _loc3_:String = dict[param1];
         if(_loc3_ == null)
         {
            _loc3_ = dict[param1.toLowerCase()];
         }
         if(_loc3_ == null)
         {
            return param1;
         }
         return _loc3_;
      }
      
      public static function init(param1:String) : void
      {
         var c:Class;
         var data:ByteArray;
         var str:String;
         var xml:XML = null;
         var messages:XMLList = null;
         var msg:XML = null;
         var name:String = null;
         var text:String = null;
         var language:String = param1;
         if(language == null)
         {
            return;
         }
         if(language.length > 2)
         {
            language = language.substring(0,2);
         }
         c = MessageBundle[language];
         if(c == null)
         {
            return;
         }
         data = new c() as ByteArray;
         if(data == null)
         {
            return;
         }
         data.uncompress();
         data.position = 0;
         str = data.readMultiByte(data.length,"utf-8");
         try
         {
            xml = new XML(str);
            messages = xml.msg;
            dict = new Dictionary();
            for each(msg in messages)
            {
               name = msg.@name;
               text = msg.text();
               dict[name] = text;
            }
         }
         catch(e:Error)
         {
            trace(e.toString());
         }
      }
   }
}

