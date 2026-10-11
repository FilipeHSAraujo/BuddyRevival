package com.buddylabs.player
{
   import flash.utils.ByteArray;
   
   public class BuddyDesc
   {
      
      public var bc:String;
      
      public var fl:String;
      
      public var tfs:int;
      
      public var bfa:String;
      
      public var a:String;
      
      public var m:Array;
      
      public var bfs:int;
      
      public var p:String;
      
      public var s:ByteArray = new ByteArray();
      
      public var f:String;
      
      public var tc:String;
      
      public var v:ByteArray = new ByteArray();
      
      public var tfa:String;
      
      public function BuddyDesc()
      {
         super();
      }
      
      public function dispose() : void
      {
         p = null;
         m = null;
         s = null;
         v = null;
      }
   }
}

