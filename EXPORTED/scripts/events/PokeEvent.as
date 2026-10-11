package events
{
   import flash.events.Event;
   
   public class PokeEvent extends Event
   {
      
      public static const SELECT_POKE:String = "selectPoke";
      
      private var _pokeId:String;
      
      public function PokeEvent(param1:String, param2:String)
      {
         super(param1,true);
         _pokeId = param2;
      }
      
      public function get pokeId() : String
      {
         return _pokeId;
      }
   }
}

