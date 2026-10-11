package com.buddylabs.player
{
   import flash.display.BitmapData;
   import flash.geom.Matrix;
   
   public class Triangle
   {
      
      public var farz:Number;
      
      public var screen_v0:Vector3;
      
      public var local_v0:Vector3;
      
      public var local_v1:Vector3;
      
      public var local_v2:Vector3;
      
      public var screen_v1:Vector3;
      
      public var screen_v2:Vector3;
      
      internal var bmd:BitmapData;
      
      internal var UVMat:Matrix = null;
      
      public function Triangle()
      {
         super();
      }
      
      public function dispose() : void
      {
         bmd = null;
         UVMat = null;
         local_v0 = null;
         local_v1 = null;
         local_v2 = null;
         screen_v0 = null;
         screen_v1 = null;
         screen_v2 = null;
      }
   }
}

