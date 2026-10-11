package com.buddylabs.player
{
   import flash.display.BitmapData;
   import flash.geom.Point;
   import flash.utils.ByteArray;
   
   public class Camera extends BaseObj
   {
      
      public var angularAcceleration:Array;
      
      public var damping:Number = 600;
      
      public var cpos:ByteArray;
      
      public var envMaxFov:Number = 1.5707963267948966;
      
      public var crot:ByteArray;
      
      public var angularDeceleration:Array;
      
      public var envMapRot:Array;
      
      public var bindTime:int;
      
      public var view:GLMatrix = new GLMatrix();
      
      public var lookAt:Object;
      
      public var minFov:Number = 0.1;
      
      public var stiffness:Number = 1800;
      
      private var lookAtRot:AxisAngle;
      
      public var centerOffset:Point;
      
      public var maxFov:Number = 1.5707963267948966;
      
      public var fov:Number = 0.785398;
      
      public var envMapBmd:BitmapData;
      
      public var rot:AxisAngle;
      
      public var pos:Vector3;
      
      public var envMapSize:Number = 4800;
      
      public var cameraToWorld:GLMatrix = new GLMatrix();
      
      public var mass:Number = 50;
      
      public var isBound:Boolean = false;
      
      public function Camera()
      {
         super();
      }
      
      override public function init(param1:Context) : void
      {
         super.init(param1);
         if(cpos != null)
         {
            pos = SceneUtil.readVector3(cpos);
            cpos = null;
         }
         if(crot != null)
         {
            rot = SceneUtil.readAxisAngle(crot);
            crot = null;
         }
         if(pos == null)
         {
            pos = new Vector3(0,0,10);
         }
         if(rot == null)
         {
            rot = new AxisAngle(0,1,0,0);
         }
      }
      
      public function getWorldPosition(param1:Vector3) : void
      {
         param1.x = pos.x;
         param1.y = pos.y;
         param1.z = pos.z;
      }
      
      override public function dispose() : void
      {
         pos = null;
         cpos = null;
         rot = null;
         crot = null;
         lookAt = null;
         centerOffset = null;
         view = null;
         cameraToWorld = null;
         angularAcceleration = null;
         angularDeceleration = null;
         envMapRot = null;
         if(envMapBmd != null)
         {
            envMapBmd.dispose();
         }
         envMapBmd = null;
      }
      
      internal function update(param1:Context) : void
      {
         var _loc2_:Number = NaN;
         var _loc3_:Number = NaN;
         var _loc4_:Number = NaN;
         var _loc5_:int = 0;
         var _loc6_:Node = null;
         var _loc7_:Number = NaN;
         var _loc8_:Number = NaN;
         var _loc9_:Number = NaN;
         var _loc10_:Number = NaN;
         var _loc11_:Number = NaN;
         var _loc12_:Number = NaN;
         var _loc13_:Number = NaN;
         var _loc14_:Number = NaN;
         var _loc15_:Number = NaN;
         if(lookAt != null)
         {
            if(lookAt is Array)
            {
               _loc2_ = Number(lookAt[0]);
               _loc3_ = Number(lookAt[1]);
               _loc4_ = Number(lookAt[2]);
            }
            else
            {
               _loc6_ = Node(lookAt);
               _loc2_ = _loc6_.localToWorldTransform.m12;
               _loc3_ = _loc6_.localToWorldTransform.m13;
               _loc4_ = _loc6_.localToWorldTransform.m14;
            }
            view.glLoadIdentity();
            view.gluLookAt(pos.x,pos.y,pos.z,_loc2_,_loc3_,_loc4_,0,1,0);
            if(lookAtRot == null)
            {
               lookAtRot = new AxisAngle();
            }
            view.matrixToAxisAngle(lookAtRot);
            view.glLoadIdentity();
            if(centerOffset != null)
            {
               _loc7_ = fov;
               _loc8_ = param1.height / param1.width;
               _loc9_ = Math.atan(Math.tan(_loc7_ / 2) * _loc8_) * 2;
               _loc11_ = _loc10_ = 1 / Math.tan(_loc7_ / 2);
               _loc12_ = centerOffset.x;
               _loc13_ = centerOffset.y;
               _loc14_ = _loc12_ / (param1.width * 0.5) / _loc10_;
               _loc15_ = -(_loc13_ / (param1.height * 0.5));
               view.glRotateRad(_loc14_,0,-1,0);
               view.glRotateRad(_loc15_,1,0,0);
            }
            view.glRotateRad(-lookAtRot.angle,lookAtRot.x,lookAtRot.y,lookAtRot.z);
            view.glTranslatef(-pos.x,-pos.y,-pos.z);
            _loc5_ = 0;
         }
         else
         {
            view.glLoadIdentity();
            if(centerOffset != null)
            {
               _loc7_ = fov;
               _loc8_ = param1.height / param1.width;
               _loc9_ = Math.atan(Math.tan(_loc7_ / 2) * _loc8_) * 2;
               _loc11_ = _loc10_ = 1 / Math.tan(_loc7_ / 2);
               _loc12_ = centerOffset.x;
               _loc13_ = centerOffset.y;
               _loc14_ = _loc12_ / (param1.width * 0.5) / _loc10_;
               _loc15_ = -(_loc13_ / (param1.height * 0.5));
               view.glRotateRad(_loc14_,0,-1,0);
               view.glRotateRad(_loc15_,1,0,0);
            }
            if(rot == null)
            {
               rot = new AxisAngle(0,1,0,0);
            }
            view.glRotateRad(-rot.angle,rot.x,rot.y,rot.z);
            if(pos == null)
            {
               pos = new Vector3(0,0,10);
            }
            view.glTranslatef(-pos.x,-pos.y,-pos.z);
         }
         view.copyTo(cameraToWorld);
         cameraToWorld.inverseMatrix3in4();
      }
      
      private function ease(param1:Number) : Number
      {
         return (Math.sin(param1 * Math.PI - Math.PI / 2) + 1) / 2;
      }
   }
}

