package com.buddylabs.player
{
   import flash.utils.getDefinitionByName;
   
   public class AxisAngle
   {
      
      public var angle:Number;
      
      public var x:Number;
      
      public var y:Number;
      
      public var z:Number;
      
      public function AxisAngle(param1:Number = 0, param2:Number = 1, param3:Number = 0, param4:Number = 0)
      {
         super();
         this.x = param1;
         this.y = param2;
         this.z = param3;
         this.angle = param4;
      }
      
      public static function parse(param1:String) : AxisAngle
      {
         var a:Array = null;
         var str:String = param1;
         try
         {
            a = str.split(" ");
            return new AxisAngle(a[0],a[1],a[2],a[3]);
         }
         catch(e:*)
         {
         }
         return new AxisAngle();
      }
      
      public static function axisAngleToQuaternion(param1:AxisAngle, param2:Quaternion) : void
      {
         var _loc3_:Number = Math.sin(param1.angle / 2);
         param2.x = param1.x * _loc3_;
         param2.y = param1.y * _loc3_;
         param2.z = param1.z * _loc3_;
         param2.w = Math.cos(param1.angle / 2);
      }
      
      public function toQuaternion(param1:Quaternion) : void
      {
         axisAngleToQuaternion(this,param1);
      }
      
      public function clone() : AxisAngle
      {
         return new AxisAngle(x,y,z,angle);
      }
   }
}

