package com.buddylabs.player
{
   import flash.utils.ByteArray;
   
   public class AnimLibrary
   {
      
      public var channels:Array;
      
      public var targets:Array;
      
      public var bounds:ByteArray;
      
      public var numAnim:int;
      
      public function AnimLibrary()
      {
         super();
      }
      
      public function dispose() : void
      {
         GCUtil.disposeArray(targets,false);
         targets = null;
         GCUtil.disposeArray(channels,false);
         channels = null;
         bounds = null;
      }
   }
}

