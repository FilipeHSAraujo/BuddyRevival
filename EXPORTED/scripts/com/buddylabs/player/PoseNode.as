package com.buddylabs.player
{
   public class PoseNode
   {
      
      private static var zeroQuaternion:Quaternion = new Quaternion(0,0,0,1);
      
      public var pos:Vector3;
      
      public var quat:Quaternion;
      
      public function PoseNode(param1:Node = null)
      {
         super();
         if(param1 != null)
         {
            if(param1.pos != null)
            {
               pos = param1.pos.clone();
            }
            if(param1.rot != null)
            {
               quat = new Quaternion();
               param1.rot.toQuaternion(quat);
            }
         }
      }
      
      public static function add(param1:PoseNode, param2:PoseNode, param3:PoseNode) : void
      {
         if(param1.pos != null && param2.pos != null)
         {
            Vector3.add(param1.pos,param2.pos,param3.pos);
         }
         if(param1.quat != null && param2.quat != null)
         {
            Quaternion.mult(param1.quat,param2.quat,param3.quat);
         }
      }
      
      public static function subtract(param1:PoseNode, param2:PoseNode, param3:PoseNode) : void
      {
         var _loc4_:Quaternion = null;
         if(param1.pos != null && param2.pos != null)
         {
            Vector3.subtract(param1.pos,param2.pos,param3.pos);
         }
         if(param1.quat != null && param2.quat != null)
         {
            _loc4_ = new Quaternion();
            Quaternion.conjugate(param2.quat,_loc4_);
            Quaternion.mult(param1.quat,_loc4_,param3.quat);
         }
      }
      
      public static function lerp(param1:Number, param2:PoseNode, param3:PoseNode, param4:PoseNode) : void
      {
         var _loc5_:Vector3 = param2.pos;
         var _loc6_:Vector3 = param3.pos;
         if(_loc5_ != null || _loc6_ != null)
         {
            if(_loc5_ == null)
            {
               _loc5_ = new Vector3();
            }
            if(_loc6_ == null)
            {
               _loc6_ = new Vector3();
            }
            if(param4.pos == null)
            {
               param4.pos = new Vector3();
            }
            Vector3.lerp(_loc5_,_loc6_,param1,param4.pos);
         }
         var _loc7_:Quaternion = param2.quat;
         var _loc8_:Quaternion = param3.quat;
         if(_loc7_ != null || _loc8_ != null)
         {
            if(_loc7_ == null)
            {
               _loc7_ = new Quaternion();
            }
            if(_loc8_ == null)
            {
               _loc8_ = new Quaternion();
            }
            if(param4.quat == null)
            {
               param4.quat = new Quaternion();
            }
            Quaternion.slerp(_loc7_,_loc8_,param1,param4.quat);
         }
      }
      
      public static function scale(param1:Number, param2:PoseNode, param3:PoseNode) : void
      {
         if(param2.pos != null)
         {
            Vector3.multScalar(param1,param2.pos,param3.pos);
         }
         if(param2.quat != null)
         {
            Quaternion.slerp(zeroQuaternion,param2.quat,param1,param3.quat);
         }
      }
      
      public function copyFromNode(param1:Node) : void
      {
         if(param1.pos != null)
         {
            if(pos == null)
            {
               pos = new Vector3();
            }
            pos.x = param1.pos.x;
            pos.y = param1.pos.y;
            pos.z = param1.pos.z;
         }
         if(param1.rot != null)
         {
            if(quat == null)
            {
               quat = new Quaternion();
            }
            param1.rot.toQuaternion(quat);
         }
      }
      
      public function copyToNode(param1:Node) : void
      {
         if(param1.pos != null && pos != null)
         {
            param1.pos.x = pos.x;
            param1.pos.y = pos.y;
            param1.pos.z = pos.z;
         }
         if(param1.rot != null && quat != null)
         {
            quat.toAxisAngle(param1.rot);
         }
      }
      
      public function clone() : PoseNode
      {
         var _loc1_:PoseNode = new PoseNode();
         if(quat != null)
         {
            _loc1_.quat = quat.clone();
         }
         if(pos != null)
         {
            _loc1_.pos = pos.clone();
         }
         return _loc1_;
      }
   }
}

