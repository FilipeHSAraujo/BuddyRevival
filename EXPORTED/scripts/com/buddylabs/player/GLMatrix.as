package com.buddylabs.player
{
   public class GLMatrix
   {
      
      public var m10:Number = 1;
      
      public var m11:Number = 0;
      
      public var m12:Number = 0;
      
      public var m13:Number = 0;
      
      public var m15:Number = 1;
      
      public var m14:Number = 0;
      
      public var m0:Number = 1;
      
      public var m1:Number = 0;
      
      public var m2:Number = 0;
      
      public var m3:Number = 0;
      
      public var m4:Number = 0;
      
      public var m5:Number = 1;
      
      public var m6:Number = 0;
      
      public var m7:Number = 0;
      
      public var m8:Number = 0;
      
      public var m9:Number = 0;
      
      public function GLMatrix()
      {
         super();
      }
      
      internal static function crossProduct(param1:Array, param2:Array, param3:Array) : void
      {
         param3[0] = param1[1] * param2[2] - param1[2] * param2[1];
         param3[1] = param1[2] * param2[0] - param1[0] * param2[2];
         param3[2] = param1[0] * param2[1] - param1[1] * param2[0];
      }
      
      public function gluLookAt(param1:Number, param2:Number, param3:Number, param4:Number, param5:Number, param6:Number, param7:Number, param8:Number, param9:Number) : void
      {
         var _loc11_:Number = NaN;
         var _loc12_:Number = NaN;
         var _loc10_:Array = new Array(3);
         _loc10_[0] = param4 - param1;
         _loc10_[1] = param5 - param2;
         _loc10_[2] = param6 - param3;
         _loc11_ = Math.sqrt(_loc10_[0] * _loc10_[0] + _loc10_[1] * _loc10_[1] + _loc10_[2] * _loc10_[2]);
         _loc12_ = Math.sqrt(param7 * param7 + param8 * param8 + param9 * param9);
         if(_loc11_ != 0)
         {
            _loc10_[0] /= _loc11_;
            _loc10_[1] /= _loc11_;
            _loc10_[2] /= _loc11_;
         }
         if(_loc12_ != 0)
         {
            param7 /= _loc12_;
            param8 /= _loc12_;
            param9 /= _loc12_;
         }
         var _loc13_:Array = new Array(3);
         var _loc14_:Array = new Array(3);
         var _loc15_:Array = new Array(3);
         _loc15_[0] = param7;
         _loc15_[1] = param8;
         _loc15_[2] = param9;
         crossProduct(_loc10_,_loc15_,_loc13_);
         crossProduct(_loc13_,_loc10_,_loc14_);
         m0 = _loc13_[0];
         m4 = _loc14_[0];
         m8 = -_loc10_[0];
         m1 = _loc13_[1];
         m5 = _loc14_[1];
         m9 = -_loc10_[1];
         m2 = _loc13_[2];
         m6 = _loc14_[2];
         m10 = -_loc10_[2];
         glTranslatef(-param1,-param2,-param3);
      }
      
      public function rotateVector(param1:Vector3) : void
      {
         var _loc2_:Number = param1.x;
         var _loc3_:Number = param1.y;
         var _loc4_:Number = param1.z;
         param1.x = m0 * _loc2_ + m4 * _loc3_ + m8 * _loc4_;
         param1.y = m1 * _loc2_ + m5 * _loc3_ + m9 * _loc4_;
         param1.z = m2 * _loc2_ + m6 * _loc3_ + m10 * _loc4_;
      }
      
      public function matrix3FromMatrix4(param1:GLMatrix) : void
      {
         param1.m0 = m0;
         param1.m3 = m4;
         param1.m6 = m8;
         param1.m1 = m1;
         param1.m4 = m5;
         param1.m7 = m9;
         param1.m2 = m2;
         param1.m5 = m6;
         param1.m8 = m10;
      }
      
      public function transposeMatrix3(param1:GLMatrix) : void
      {
         param1.m0 = m0;
         param1.m3 = m1;
         param1.m6 = m2;
         param1.m1 = m3;
         param1.m4 = m4;
         param1.m7 = m5;
         param1.m2 = m6;
         param1.m5 = m7;
         param1.m8 = m8;
      }
      
      public function glTranslatef(param1:Number, param2:Number, param3:Number) : void
      {
         m12 = m0 * param1 + m4 * param2 + m8 * param3 + m12;
         m13 = m1 * param1 + m5 * param2 + m9 * param3 + m13;
         m14 = m2 * param1 + m6 * param2 + m10 * param3 + m14;
      }
      
      public function glScalef(param1:Number, param2:Number, param3:Number) : void
      {
         m0 *= param1;
         m1 *= param1;
         m2 *= param1;
         m4 *= param2;
         m5 *= param2;
         m6 *= param2;
         m8 *= param3;
         m9 *= param3;
         m10 *= param3;
      }
      
      public function inverseMatrix3in4() : Boolean
      {
         var _loc1_:Number = -m12;
         var _loc2_:Number = -m13;
         var _loc3_:Number = -m14;
         var _loc4_:Number = -m8 * m5 * m2 + m4 * m9 * m2 + m8 * m1 * m6 - m0 * m9 * m6 - m4 * m1 * m10 + m0 * m5 * m10;
         if(_loc4_ == 0)
         {
            return false;
         }
         var _loc5_:Number = (-m9 * m6 + m5 * m10) / _loc4_;
         var _loc6_:Number = (m8 * m6 - m4 * m10) / _loc4_;
         var _loc7_:Number = (-m8 * m5 + m4 * m9) / _loc4_;
         var _loc8_:Number = (m9 * m2 - m1 * m10) / _loc4_;
         var _loc9_:Number = (-m8 * m2 + m0 * m10) / _loc4_;
         var _loc10_:Number = (m8 * m1 - m0 * m9) / _loc4_;
         var _loc11_:Number = (-m5 * m2 + m1 * m6) / _loc4_;
         var _loc12_:Number = (m4 * m2 - m0 * m6) / _loc4_;
         var _loc13_:Number = (-m4 * m1 + m0 * m5) / _loc4_;
         m0 = _loc5_;
         m1 = _loc8_;
         m2 = _loc11_;
         m4 = _loc6_;
         m5 = _loc9_;
         m6 = _loc12_;
         m8 = _loc7_;
         m9 = _loc10_;
         m10 = _loc13_;
         m12 = _loc1_ * m0 + _loc2_ * m4 + _loc3_ * m8;
         m13 = _loc1_ * m1 + _loc2_ * m5 + _loc3_ * m9;
         m14 = _loc1_ * m2 + _loc2_ * m6 + _loc3_ * m10;
         return true;
      }
      
      public function inverseMatrix3(param1:GLMatrix) : Boolean
      {
         var _loc2_:Number = determinant3();
         if(_loc2_ == 0)
         {
            return false;
         }
         param1.m0 = (-m7 * m5 + m4 * m8) / _loc2_;
         param1.m3 = (m6 * m5 - m3 * m8) / _loc2_;
         param1.m6 = (-m6 * m4 + m3 * m7) / _loc2_;
         param1.m1 = (m7 * m2 - m1 * m8) / _loc2_;
         param1.m4 = (-m6 * m2 + m0 * m8) / _loc2_;
         param1.m7 = (m6 * m1 - m0 * m7) / _loc2_;
         param1.m2 = (-m4 * m2 + m1 * m5) / _loc2_;
         param1.m5 = (m3 * m2 - m0 * m5) / _loc2_;
         param1.m8 = (-m3 * m1 + m0 * m4) / _loc2_;
         return true;
      }
      
      public function inverseMatrix4() : Boolean
      {
         var _loc1_:Number = determinant4();
         if(_loc1_ == 0)
         {
            return false;
         }
         var _loc2_:Number = m0;
         var _loc3_:Number = m1;
         var _loc4_:Number = m2;
         var _loc5_:Number = m3;
         var _loc6_:Number = m4;
         var _loc7_:Number = m5;
         var _loc8_:Number = m6;
         var _loc9_:Number = m7;
         var _loc10_:Number = m8;
         var _loc11_:Number = m9;
         var _loc12_:Number = m10;
         var _loc13_:Number = m11;
         var _loc14_:Number = m12;
         var _loc15_:Number = m13;
         var _loc16_:Number = m14;
         var _loc17_:Number = m15;
         m0 = (-_loc15_ * _loc12_ * _loc9_ + _loc11_ * _loc16_ * _loc9_ + _loc15_ * _loc8_ * _loc13_ - _loc7_ * _loc16_ * _loc13_ - _loc11_ * _loc8_ * _loc17_ + _loc7_ * _loc12_ * _loc17_) / _loc1_;
         m4 = (_loc14_ * _loc12_ * _loc9_ - _loc10_ * _loc16_ * _loc9_ - _loc14_ * _loc8_ * _loc13_ + _loc6_ * _loc16_ * _loc13_ + _loc10_ * _loc8_ * _loc17_ - _loc6_ * _loc12_ * _loc17_) / _loc1_;
         m8 = (-_loc14_ * _loc11_ * _loc9_ + _loc10_ * _loc15_ * _loc9_ + _loc14_ * _loc7_ * _loc13_ - _loc6_ * _loc15_ * _loc13_ - _loc10_ * _loc7_ * _loc17_ + _loc6_ * _loc11_ * _loc17_) / _loc1_;
         m12 = (_loc14_ * _loc11_ * _loc8_ - _loc10_ * _loc15_ * _loc8_ - _loc14_ * _loc7_ * _loc12_ + _loc6_ * _loc15_ * _loc12_ + _loc10_ * _loc7_ * _loc16_ - _loc6_ * _loc11_ * _loc16_) / _loc1_;
         m1 = (_loc15_ * _loc12_ * _loc5_ - _loc11_ * _loc16_ * _loc5_ - _loc15_ * _loc4_ * _loc13_ + _loc3_ * _loc16_ * _loc13_ + _loc11_ * _loc4_ * _loc17_ - _loc3_ * _loc12_ * _loc17_) / _loc1_;
         m5 = (-_loc14_ * _loc12_ * _loc5_ + _loc10_ * _loc16_ * _loc5_ + _loc14_ * _loc4_ * _loc13_ - _loc2_ * _loc16_ * _loc13_ - _loc10_ * _loc4_ * _loc17_ + _loc2_ * _loc12_ * _loc17_) / _loc1_;
         m9 = (_loc14_ * _loc11_ * _loc5_ - _loc10_ * _loc15_ * _loc5_ - _loc14_ * _loc3_ * _loc13_ + _loc2_ * _loc15_ * _loc13_ + _loc10_ * _loc3_ * _loc17_ - _loc2_ * _loc11_ * _loc17_) / _loc1_;
         m13 = (-_loc14_ * _loc11_ * _loc4_ + _loc10_ * _loc15_ * _loc4_ + _loc14_ * _loc3_ * _loc12_ - _loc2_ * _loc15_ * _loc12_ - _loc10_ * _loc3_ * _loc16_ + _loc2_ * _loc11_ * _loc16_) / _loc1_;
         m2 = (-_loc15_ * _loc8_ * _loc5_ + _loc7_ * _loc16_ * _loc5_ + _loc15_ * _loc4_ * _loc9_ - _loc3_ * _loc16_ * _loc9_ - _loc7_ * _loc4_ * _loc17_ + _loc3_ * _loc8_ * _loc17_) / _loc1_;
         m6 = (_loc14_ * _loc8_ * _loc5_ - _loc6_ * _loc16_ * _loc5_ - _loc14_ * _loc4_ * _loc9_ + _loc2_ * _loc16_ * _loc9_ + _loc6_ * _loc4_ * _loc17_ - _loc2_ * _loc8_ * _loc17_) / _loc1_;
         m10 = (-_loc14_ * _loc7_ * _loc5_ + _loc6_ * _loc15_ * _loc5_ + _loc14_ * _loc3_ * _loc9_ - _loc2_ * _loc15_ * _loc9_ - _loc6_ * _loc3_ * _loc17_ + _loc2_ * _loc7_ * _loc17_) / _loc1_;
         m14 = (_loc14_ * _loc7_ * _loc4_ - _loc6_ * _loc15_ * _loc4_ - _loc14_ * _loc3_ * _loc8_ + _loc2_ * _loc15_ * _loc8_ + _loc6_ * _loc3_ * _loc16_ - _loc2_ * _loc7_ * _loc16_) / _loc1_;
         m3 = (_loc11_ * _loc8_ * _loc5_ - _loc7_ * _loc12_ * _loc5_ - _loc11_ * _loc4_ * _loc9_ + _loc3_ * _loc12_ * _loc9_ + _loc7_ * _loc4_ * _loc13_ - _loc3_ * _loc8_ * _loc13_) / _loc1_;
         m7 = (-_loc10_ * _loc8_ * _loc5_ + _loc6_ * _loc12_ * _loc5_ + _loc10_ * _loc4_ * _loc9_ - _loc2_ * _loc12_ * _loc9_ - _loc6_ * _loc4_ * _loc13_ + _loc2_ * _loc8_ * _loc13_) / _loc1_;
         m11 = (_loc10_ * _loc7_ * _loc5_ - _loc6_ * _loc11_ * _loc5_ - _loc10_ * _loc3_ * _loc9_ + _loc2_ * _loc11_ * _loc9_ + _loc6_ * _loc3_ * _loc13_ - _loc2_ * _loc7_ * _loc13_) / _loc1_;
         m15 = (-_loc10_ * _loc7_ * _loc4_ + _loc6_ * _loc11_ * _loc4_ + _loc10_ * _loc3_ * _loc8_ - _loc2_ * _loc11_ * _loc8_ - _loc6_ * _loc3_ * _loc12_ + _loc2_ * _loc7_ * _loc12_) / _loc1_;
         return true;
      }
      
      public function glLoadIdentity() : void
      {
         m0 = 1;
         m4 = 0;
         m8 = 0;
         m12 = 0;
         m1 = 0;
         m5 = 1;
         m9 = 0;
         m13 = 0;
         m2 = 0;
         m6 = 0;
         m10 = 1;
         m14 = 0;
         m3 = 0;
         m7 = 0;
         m11 = 0;
         m15 = 1;
      }
      
      public function glRotateRad(param1:Number, param2:Number, param3:Number, param4:Number) : void
      {
         param1 = -param1;
         var _loc5_:Number = Math.cos(param1);
         var _loc6_:Number = Math.sin(param1);
         var _loc7_:Number = 1 - _loc5_;
         var _loc8_:Number = _loc5_ + param2 * param2 * _loc7_;
         var _loc9_:Number = param4 * _loc6_ + param3 * param2 * _loc7_;
         var _loc10_:Number = -param3 * _loc6_ + param4 * param2 * _loc7_;
         var _loc11_:Number = -param4 * _loc6_ + param2 * param3 * _loc7_;
         var _loc12_:Number = _loc5_ + param3 * param3 * _loc7_;
         var _loc13_:Number = param2 * _loc6_ + param4 * param3 * _loc7_;
         var _loc14_:Number = param3 * _loc6_ + param2 * param4 * _loc7_;
         var _loc15_:Number = -param2 * _loc6_ + param3 * param4 * _loc7_;
         var _loc16_:Number = _loc5_ + param4 * param4 * _loc7_;
         var _loc17_:Number = m0;
         var _loc18_:Number = m1;
         var _loc19_:Number = m2;
         var _loc20_:Number = m4;
         var _loc21_:Number = m5;
         var _loc22_:Number = m6;
         var _loc23_:Number = m8;
         var _loc24_:Number = m9;
         var _loc25_:Number = m10;
         m0 = _loc17_ * _loc8_ + _loc20_ * _loc11_ + _loc23_ * _loc14_;
         m1 = _loc18_ * _loc8_ + _loc21_ * _loc11_ + _loc24_ * _loc14_;
         m2 = _loc19_ * _loc8_ + _loc22_ * _loc11_ + _loc25_ * _loc14_;
         m4 = _loc17_ * _loc9_ + _loc20_ * _loc12_ + _loc23_ * _loc15_;
         m5 = _loc18_ * _loc9_ + _loc21_ * _loc12_ + _loc24_ * _loc15_;
         m6 = _loc19_ * _loc9_ + _loc22_ * _loc12_ + _loc25_ * _loc15_;
         m8 = _loc17_ * _loc10_ + _loc20_ * _loc13_ + _loc23_ * _loc16_;
         m9 = _loc18_ * _loc10_ + _loc21_ * _loc13_ + _loc24_ * _loc16_;
         m10 = _loc19_ * _loc10_ + _loc22_ * _loc13_ + _loc25_ * _loc16_;
      }
      
      public function glMultMatrix(param1:GLMatrix) : void
      {
         var _loc2_:Number = param1.m0;
         var _loc3_:Number = param1.m1;
         var _loc4_:Number = param1.m2;
         var _loc5_:Number = param1.m4;
         var _loc6_:Number = param1.m5;
         var _loc7_:Number = param1.m6;
         var _loc8_:Number = param1.m8;
         var _loc9_:Number = param1.m9;
         var _loc10_:Number = param1.m10;
         var _loc11_:Number = param1.m12;
         var _loc12_:Number = param1.m13;
         var _loc13_:Number = param1.m14;
         var _loc14_:Number = m0;
         var _loc15_:Number = m1;
         var _loc16_:Number = m2;
         var _loc17_:Number = m4;
         var _loc18_:Number = m5;
         var _loc19_:Number = m6;
         var _loc20_:Number = m8;
         var _loc21_:Number = m9;
         var _loc22_:Number = m10;
         var _loc23_:Number = m12;
         var _loc24_:Number = m13;
         var _loc25_:Number = m14;
         m0 = _loc14_ * _loc2_ + _loc17_ * _loc3_ + _loc20_ * _loc4_;
         m1 = _loc15_ * _loc2_ + _loc18_ * _loc3_ + _loc21_ * _loc4_;
         m2 = _loc16_ * _loc2_ + _loc19_ * _loc3_ + _loc22_ * _loc4_;
         m4 = _loc14_ * _loc5_ + _loc17_ * _loc6_ + _loc20_ * _loc7_;
         m5 = _loc15_ * _loc5_ + _loc18_ * _loc6_ + _loc21_ * _loc7_;
         m6 = _loc16_ * _loc5_ + _loc19_ * _loc6_ + _loc22_ * _loc7_;
         m8 = _loc14_ * _loc8_ + _loc17_ * _loc9_ + _loc20_ * _loc10_;
         m9 = _loc15_ * _loc8_ + _loc18_ * _loc9_ + _loc21_ * _loc10_;
         m10 = _loc16_ * _loc8_ + _loc19_ * _loc9_ + _loc22_ * _loc10_;
         m12 = _loc14_ * _loc11_ + _loc17_ * _loc12_ + _loc20_ * _loc13_ + _loc23_;
         m13 = _loc15_ * _loc11_ + _loc18_ * _loc12_ + _loc21_ * _loc13_ + _loc24_;
         m14 = _loc16_ * _loc11_ + _loc19_ * _loc12_ + _loc22_ * _loc13_ + _loc25_;
      }
      
      public function copyTo(param1:GLMatrix) : void
      {
         param1.m0 = m0;
         param1.m1 = m1;
         param1.m2 = m2;
         param1.m3 = m3;
         param1.m4 = m4;
         param1.m5 = m5;
         param1.m6 = m6;
         param1.m7 = m7;
         param1.m8 = m8;
         param1.m9 = m9;
         param1.m10 = m10;
         param1.m11 = m11;
         param1.m12 = m12;
         param1.m13 = m13;
         param1.m14 = m14;
      }
      
      public function printMatrix(param1:String) : void
      {
         trace("GLMatrix " + param1);
         trace(m0 + "\t\t" + m4 + "\t\t" + m8 + "\t\t" + m12);
         trace(m1 + "\t\t" + m5 + "\t\t" + m9 + "\t\t" + m13);
         trace(m2 + "\t\t" + m6 + "\t\t" + m10 + "\t\t" + m14);
         trace(m3 + "\t\t" + m7 + "\t\t" + m11 + "\t\t" + m15);
         trace("");
      }
      
      public function decompose(param1:Vector3, param2:Quaternion, param3:Vector3) : Boolean
      {
         return true;
      }
      
      public function gluPerspective(param1:Number, param2:Number) : void
      {
         var _loc3_:Number = 1 / Math.tan(param1 / 2);
         var _loc4_:Number = Math.atan(Math.tan(param1 / 2) * param2) * 2;
         var _loc5_:Number = 1 / Math.tan(_loc4_ / 2);
         m0 = _loc3_;
         m1 = 0;
         m2 = 0;
         m3 = 0;
         m4 = 0;
         m5 = _loc5_;
         m6 = 0;
         m7 = 0;
         m8 = 0;
         m9 = 0;
         m10 = -1;
         m11 = -1;
         m12 = 0;
         m13 = 0;
         m14 = 0;
         m15 = 0;
      }
      
      public function matrixToAxisAngle(param1:AxisAngle) : void
      {
         var _loc3_:Number = NaN;
         var _loc4_:Number = NaN;
         var _loc5_:Number = NaN;
         var _loc6_:Number = NaN;
         var _loc7_:Number = NaN;
         var _loc2_:Number = m0 + m5 + m10;
         if(_loc2_ >= 0)
         {
            _loc7_ = Math.sqrt(_loc2_ + 1);
            _loc6_ = 0.5 * _loc7_;
            _loc7_ = 0.5 / _loc7_;
            _loc3_ = (m6 - m9) * _loc7_;
            _loc4_ = (m8 - m2) * _loc7_;
            _loc5_ = (m1 - m4) * _loc7_;
         }
         else if(m0 > m5 && m0 > m10)
         {
            _loc7_ = Math.sqrt(1 + m0 - m5 - m10);
            _loc3_ = _loc7_ * 0.5;
            _loc7_ = 0.5 / _loc7_;
            _loc4_ = (m1 + m4) * _loc7_;
            _loc5_ = (m8 + m2) * _loc7_;
            _loc6_ = (m6 - m9) * _loc7_;
         }
         else if(m5 > m10)
         {
            _loc7_ = Math.sqrt(1 + m5 - m0 - m10);
            _loc4_ = _loc7_ * 0.5;
            _loc7_ = 0.5 / _loc7_;
            _loc3_ = (m1 + m4) * _loc7_;
            _loc5_ = (m6 + m9) * _loc7_;
            _loc6_ = (m8 - m2) * _loc7_;
         }
         else
         {
            _loc7_ = Math.sqrt(1 + m10 - m0 - m5);
            _loc5_ = _loc7_ * 0.5;
            _loc7_ = 0.5 / _loc7_;
            _loc3_ = (m8 + m2) * _loc7_;
            _loc4_ = (m6 + m9) * _loc7_;
            _loc6_ = (m1 - m4) * _loc7_;
         }
         param1.angle = 2 * Math.acos(_loc6_);
         var _loc8_:Number = Math.sqrt(1 - _loc6_ * _loc6_);
         if(_loc8_ < 0.001)
         {
            param1.x = _loc3_;
            param1.y = _loc4_;
            param1.z = _loc5_;
         }
         else
         {
            param1.x = _loc3_ / _loc8_;
            param1.y = _loc4_ / _loc8_;
            param1.z = _loc5_ / _loc8_;
         }
      }
      
      public function glIdentityTranslatef(param1:Number, param2:Number, param3:Number) : void
      {
         m0 = 1;
         m4 = 0;
         m8 = 0;
         m12 = param1;
         m1 = 0;
         m5 = 1;
         m9 = 0;
         m13 = param2;
         m2 = 0;
         m6 = 0;
         m10 = 1;
         m14 = param3;
         m3 = 0;
         m7 = 0;
         m11 = 0;
         m15 = 1;
      }
      
      public function determinant3() : Number
      {
         return -m6 * m4 * m2 + m3 * m7 * m2 + m6 * m1 * m5 - m0 * m7 * m5 - m3 * m1 * m8 + m0 * m4 * m8;
      }
      
      public function determinant4() : Number
      {
         return m12 * m9 * m6 * m3 - m8 * m13 * m6 * m3 - m12 * m5 * m10 * m3 + m4 * m13 * m10 * m3 + m8 * m5 * m14 * m3 - m4 * m9 * m14 * m3 - m12 * m9 * m2 * m7 + m8 * m13 * m2 * m7 + m12 * m1 * m10 * m7 - m0 * m13 * m10 * m7 - m8 * m1 * m14 * m7 + m0 * m9 * m14 * m7 + m12 * m5 * m2 * m11 - m4 * m13 * m2 * m11 - m12 * m1 * m6 * m11 + m0 * m13 * m6 * m11 + m4 * m1 * m14 * m11 - m0 * m5 * m14 * m11 - m8 * m5 * m2 * m15 + m4 * m9 * m2 * m15 + m8 * m1 * m6 * m15 - m0 * m9 * m6 * m15 - m4 * m1 * m10 * m15 + m0 * m5 * m10 * m15;
      }
   }
}

