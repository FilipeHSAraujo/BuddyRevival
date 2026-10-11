package
{
   import flash.events.Event;
   
   public class SelectedFriendEvent extends Event
   {
      
      public static const SELECT_FRIEND:String = "selectFriend";
      
      private var _user:BuddyPokeUser;
      
      public function SelectedFriendEvent(param1:String, param2:BuddyPokeUser)
      {
         super(param1,true);
         _user = param2;
      }
      
      public function get user() : BuddyPokeUser
      {
         return _user;
      }
   }
}

