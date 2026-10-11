package com.buddylabs.player
{
   public class Ray
   {
      
      public var position:Vector3;
      
      public var direction:Vector3;
      
      public function Ray(param1:Vector3 = null, param2:Vector3 = null)
      {
         super();
         this.position = param1 == null ? new Vector3() : param1;
         this.direction = param2 == null ? new Vector3(0,0,-1) : param2;
      }
   }
}

