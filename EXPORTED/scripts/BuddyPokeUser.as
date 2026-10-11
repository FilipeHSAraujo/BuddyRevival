package
{
   public class BuddyPokeUser
   {
      
      public function BuddyPokeUser()
      {
         super();
      }
      
      public function get userIsFemale() : Boolean
      {
         return false;
      }
      
      public function get userWebUri() : String
      {
         return null;
      }
      
      public function cacheBuddy(param1:String) : void
      {
      }
      
      public function get userId() : String
      {
         return null;
      }
      
      protected function getKeyValue(param1:Array, param2:String) : String
      {
         var _loc3_:int = int(param1.length);
         var _loc4_:int = 0;
         while(_loc4_ < _loc3_)
         {
            if(param2 == param1[_loc4_]["key"])
            {
               return param1[_loc4_]["value"];
            }
            _loc4_++;
         }
         return null;
      }
      
      public function get buddyHistory() : Array
      {
         return null;
      }
      
      public function get userImage() : String
      {
         return null;
      }
      
      public function set buddyDesc(param1:String) : void
      {
      }
      
      public function get userName() : String
      {
         return null;
      }
      
      public function get buddyDesc() : String
      {
         return null;
      }
      
      public function set buddyHistory(param1:Array) : void
      {
      }
      
      public function get userError() : Boolean
      {
         return true;
      }
   }
}

