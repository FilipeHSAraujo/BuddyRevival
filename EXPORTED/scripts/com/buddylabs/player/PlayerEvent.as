package com.buddylabs.player
{
   import flash.events.Event;
   
   public class PlayerEvent extends Event
   {
      
      public static const GEOMETRY_LOADED:String = "geo";
      
      public static const MATERIALS_LOADED:String = "mat";
      
      public function PlayerEvent(param1:String, param2:Boolean = false, param3:Boolean = false)
      {
         super(param1,param2,param3);
      }
   }
}

