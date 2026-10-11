package com.buddylabs.player
{
   public class Quaternion
   {
      
      public var w:Number;
      
      public var x:Number;
      
      public var y:Number;
      
      public var z:Number;
      
      public function Quaternion(param1:Number = 0, param2:Number = 0, param3:Number = 0, param4:Number = 1)
      {
         super();
         this.x = param1;
         this.y = param2;
         this.z = param3;
         this.w = param4;
      }
      
      public static function mult(param1:Quaternion, param2:Quaternion, param3:Quaternion) : void
      {
         var _loc4_:Number = param1.x * param2.w + param1.y * param2.z - param1.z * param2.y + param1.w * param2.x;
         var _loc5_:Number = -param1.x * param2.z + param1.y * param2.w + param1.z * param2.x + param1.w * param2.y;
         var _loc6_:Number = param1.x * param2.y - param1.y * param2.x + param1.z * param2.w + param1.w * param2.z;
         var _loc7_:Number = -param1.x * param2.x - param1.y * param2.y - param1.z * param2.z + param1.w * param2.w;
         param3.x = _loc4_;
         param3.y = _loc5_;
         param3.z = _loc6_;
         param3.w = _loc7_;
      }
      
      public static function dotProduct(param1:Quaternion, param2:Quaternion) : Number
      {
         return param1.w * param2.w + param1.x * param2.x + param1.y * param2.y + param1.z * param2.z;
      }
      
      public static function copyTo(param1:Quaternion, param2:Quaternion) : void
      {
         param2.x = param1.x;
         param2.y = param1.y;
         param2.z = param1.z;
         param2.w = param1.w;
      }
      
      public static function conjugate(param1:Quaternion, param2:Quaternion) : void
      {
         param2.w = param1.w;
         param2.x = -param1.x;
         param2.y = -param1.y;
         param2.z = -param1.z;
      }
      
      public static function quaternionToAxisAngle(param1:Quaternion, param2:AxisAngle) : void
      {
         if(param1.w > 1)
         {
            param1.w = 1;
         }
         if(param1.w < -1)
         {
            param1.w = -1;
         }
         param2.angle = 2 * Math.acos(param1.w);
         var _loc3_:Number = 1 - param1.w * param1.w;
         if(_loc3_ == 0)
         {
            param2.x = 0;
            param2.y = 1;
            param2.z = 0;
            return;
         }
         var _loc4_:Number = Math.sqrt(_loc3_);
         if(_loc4_ < 0.001)
         {
            param2.x = 0;
            param2.y = 1;
            param2.z = 0;
         }
         else
         {
            param2.x = param1.x / _loc4_;
            param2.y = param1.y / _loc4_;
            param2.z = param1.z / _loc4_;
         }
      }
      
      public static function slerp(param1:Quaternion, param2:Quaternion, param3:Number, param4:Quaternion) : void
      {
         var _loc10_:Number = NaN;
         var _loc11_:Number = NaN;
         var _loc12_:Number = NaN;
         var _loc13_:Number = NaN;
         var _loc14_:Number = NaN;
         if(param3 <= 0)
         {
            copyTo(param1,param4);
            return;
         }
         if(param3 >= 1)
         {
            copyTo(param2,param4);
            return;
         }
         var _loc5_:Number = dotProduct(param1,param2);
         var _loc6_:Number = param2.w;
         var _loc7_:Number = param2.x;
         var _loc8_:Number = param2.y;
         var _loc9_:Number = param2.z;
         if(_loc5_ < 0)
         {
            _loc6_ = -_loc6_;
            _loc7_ = -_loc7_;
            _loc8_ = -_loc8_;
            _loc9_ = -_loc9_;
            _loc5_ = -_loc5_;
         }
         if(_loc5_ > 0.9999)
         {
            _loc10_ = 1 - param3;
            _loc11_ = param3;
         }
         else
         {
            _loc12_ = Math.sqrt(1 - _loc5_ * _loc5_);
            _loc13_ = Math.atan2(_loc12_,_loc5_);
            _loc14_ = 1 / _loc12_;
            _loc10_ = Math.sin((1 - param3) * _loc13_) * _loc14_;
            _loc11_ = Math.sin(param3 * _loc13_) * _loc14_;
         }
         param4.x = _loc10_ * param1.x + _loc11_ * _loc7_;
         param4.y = _loc10_ * param1.y + _loc11_ * _loc8_;
         param4.z = _loc10_ * param1.z + _loc11_ * _loc9_;
         param4.w = _loc10_ * param1.w + _loc11_ * _loc6_;
      }
      
      public static function normalize(param1:Quaternion) : void
      {
         var _loc2_:Number = Math.sqrt(param1.x * param1.x + param1.y * param1.y + param1.z * param1.z + param1.w * param1.w);
         param1.x /= _loc2_;
         param1.y /= _loc2_;
         param1.z /= _loc2_;
         param1.w /= _loc2_;
      }
      
      public static function inverse(param1:Quaternion, param2:Quaternion) : void
      {
         var _loc3_:Number = param1.w * param1.w + param1.x * param1.x + param1.y * param1.y + param1.z * param1.z;
         if(_loc3_ == 0)
         {
            _loc3_ = 0.0001;
         }
         var _loc4_:Number = 1 / _loc3_;
         param2.x = param1.w * _loc4_;
         param2.y = -param1.x * _loc4_;
         param2.z = -param1.y * _loc4_;
         param2.w = -param1.z * _loc4_;
      }
      
      public function easeSpeed(param1:Number) : Number
      {
         return (Math.sin(param1 * Math.PI - Math.PI / 2) + 1) / 2;
      }
      
      public function toAxisAngle(param1:AxisAngle) : void
      {
         quaternionToAxisAngle(this,param1);
      }
      
      public function mult(param1:Number) : void
      {
         x *= param1;
         y *= param1;
         z *= param1;
         w *= param1;
      }
      
      public function normalize() : void
      {
         Quaternion.normalize(this);
      }
      
      public function clone() : Quaternion
      {
         return new Quaternion(x,y,z,w);
      }
      
      public function identity() : void
      {
         x = 0;
         y = 0;
         z = 0;
         w = 1;
      }
      
      public function copyTo(param1:Quaternion) : void
      {
         param1.x = x;
         param1.y = y;
         param1.z = z;
         param1.w = w;
      }
   }
}

