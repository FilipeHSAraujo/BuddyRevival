package com.buddylabs.player
{
   import flash.utils.getDefinitionByName;
   
   public class Vector3
   {
      
      public var x:Number;
      
      public var y:Number;
      
      public var z:Number;
      
      public function Vector3(param1:Number = 0, param2:Number = 0, param3:Number = 0)
      {
         super();
         this.x = param1;
         this.y = param2;
         this.z = param3;
      }
      
      public static function add(param1:Vector3, param2:Vector3, param3:Vector3) : void
      {
         param3.x = param1.x + param2.x;
         param3.y = param1.y + param2.y;
         param3.z = param1.z + param2.z;
      }
      
      public static function dotProduct(param1:Vector3, param2:Vector3) : Number
      {
         return param1.x * param2.x + param1.y * param2.y + param1.z * param2.z;
      }
      
      public static function normalize(param1:Vector3) : void
      {
         param1.normalize();
      }
      
      public static function crossProduct(param1:Vector3, param2:Vector3, param3:Vector3) : void
      {
         var _loc4_:Number = param1.y * param2.z - param1.z * param2.y;
         var _loc5_:Number = param1.z * param2.x - param1.x * param2.z;
         var _loc6_:Number = param1.x * param2.y - param1.y * param2.x;
         param3.x = _loc4_;
         param3.y = _loc5_;
         param3.z = _loc6_;
      }
      
      public static function magnitude(param1:Vector3) : Number
      {
         return Math.sqrt(param1.x * param1.x + param1.y * param1.y + param1.z * param1.z);
      }
      
      public static function distanceSquared(param1:Vector3, param2:Vector3) : Number
      {
         var _loc3_:Number = param1.x - param2.x;
         var _loc4_:Number = param1.y - param2.y;
         var _loc5_:Number = param1.z - param2.z;
         return _loc3_ * _loc3_ + _loc4_ * _loc4_ + _loc5_ * _loc5_;
      }
      
      public static function parse(param1:String) : Vector3
      {
         var a:Array = null;
         var str:String = param1;
         try
         {
            a = str.split(" ");
            return new Vector3(a[0],a[1],a[2]);
         }
         catch(e:*)
         {
         }
         return new Vector3();
      }
      
      public static function subtract(param1:Vector3, param2:Vector3, param3:Vector3) : void
      {
         param3.x = param1.x - param2.x;
         param3.y = param1.y - param2.y;
         param3.z = param1.z - param2.z;
      }
      
      public static function distance(param1:Vector3, param2:Vector3) : Number
      {
         var _loc3_:Number = param1.x - param2.x;
         var _loc4_:Number = param1.y - param2.y;
         var _loc5_:Number = param1.z - param2.z;
         return Math.sqrt(_loc3_ * _loc3_ + _loc4_ * _loc4_ + _loc5_ * _loc5_);
      }
      
      public static function copyTo(param1:Vector3, param2:Vector3) : void
      {
         param2.x = param1.x;
         param2.y = param1.y;
         param2.z = param1.z;
      }
      
      public static function multScalar(param1:Number, param2:Vector3, param3:Vector3) : void
      {
         param3.x = param1 * param2.x;
         param3.y = param1 * param2.y;
         param3.z = param1 * param2.z;
      }
      
      public static function lerp(param1:Vector3, param2:Vector3, param3:Number, param4:Vector3) : void
      {
         param4.x = param3 * (param2.x - param1.x) + param1.x;
         param4.y = param3 * (param2.y - param1.y) + param1.y;
         param4.z = param3 * (param2.z - param1.z) + param1.z;
      }
      
      public function cross(param1:Vector3) : void
      {
         crossProduct(this,param1,this);
      }
      
      public function add(param1:Vector3) : void
      {
         this.x += param1.x;
         this.y += param1.y;
         this.z += param1.z;
      }
      
      public function heading2D() : Number
      {
         var _loc1_:Number = Math.atan2(-y,x);
         return -1 * _loc1_;
      }
      
      public function multiply(param1:Number) : void
      {
         x *= param1;
         y *= param1;
         z *= param1;
      }
      
      public function zero() : void
      {
         x = 0;
         y = 0;
         z = 0;
      }
      
      public function dot(param1:Vector3) : Number
      {
         return x * param1.x + y * param1.y + z * param1.z;
      }
      
      public function toString() : String
      {
         return "[ " + x.toPrecision(3) + ", " + y.toPrecision(3) + ", " + z.toPrecision(3) + " ]";
      }
      
      public function normalize() : void
      {
         var _loc1_:Number = NaN;
         _loc1_ = x * x + y * y + z * z;
         if(_loc1_ > 0)
         {
            _loc1_ = Math.sqrt(_loc1_);
            x /= _loc1_;
            y /= _loc1_;
            z /= _loc1_;
         }
      }
      
      public function magnitude() : Number
      {
         return Math.sqrt(x * x + y * y + z * z);
      }
      
      public function copyTo(param1:Vector3) : void
      {
         param1.x = x;
         param1.y = y;
         param1.z = z;
      }
      
      public function limit(param1:Number) : void
      {
         var _loc2_:Number = NaN;
         var _loc3_:int = 0;
         if(magnitude() > param1)
         {
            normalize();
            multScalar(param1,this,this);
            _loc2_ = Math.sqrt(x * x + y * y + z * z);
            _loc3_ = 0;
         }
      }
      
      public function clone() : Vector3
      {
         return new Vector3(x,y,z);
      }
      
      public function setXYZ(param1:Number = 0, param2:Number = 0, param3:Number = 0) : *
      {
         this.x = param1;
         this.y = param2;
         this.z = param3;
      }
      
      public function mult(param1:Number) : void
      {
         x *= param1;
         y *= param1;
         z *= param1;
      }
   }
}

