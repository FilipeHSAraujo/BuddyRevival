package com.buddylabs.player
{
   import flash.utils.ByteArray;
   import flash.utils.Dictionary;
   
   public class Node extends BaseObj
   {
      
      public var deformScale:Vector3;
      
      public var cscale:ByteArray;
      
      internal var initialTransform:GLMatrix;
      
      public var scale:Vector3;
      
      public var deformPos:Vector3;
      
      public var cpos:ByteArray;
      
      public var deformRot:AxisAngle;
      
      public var pos:Vector3;
      
      public var rot:AxisAngle;
      
      public var crot:ByteArray;
      
      internal var invInitialTransform:GLMatrix;
      
      public var localToWorldTransform:GLMatrix = new GLMatrix();
      
      internal var transform:GLMatrix = new GLMatrix();
      
      public var mesh:Mesh;
      
      public var visible:Boolean = true;
      
      public var prevLocalToWorldTransform:GLMatrix;
      
      public var parentDeformScale:Vector3;
      
      public var children:Array;
      
      public function Node()
      {
         super();
      }
      
      protected function popMatrix(param1:Context) : void
      {
         param1.hworld = prevLocalToWorldTransform;
      }
      
      public function addChild(param1:BaseObj) : void
      {
         if(children == null)
         {
            children = new Array();
         }
         children.push(param1);
      }
      
      public function getLocalToWorldMatrix() : GLMatrix
      {
         return localToWorldTransform;
      }
      
      override public function draw(param1:Context) : void
      {
         var _loc2_:uint = 0;
         var _loc3_:uint = 0;
         pushMatrix(param1);
         if(mesh != null && this.visible && mesh.material != null)
         {
            if(!mesh.inited)
            {
               trace("decode faces and verts for " + this.name);
            }
            mesh.material.update();
            mesh.draw(param1);
         }
         if(children != null)
         {
            _loc2_ = children.length;
            _loc3_ = 0;
            while(_loc3_ < _loc2_)
            {
               children[_loc3_].draw(param1);
               _loc3_++;
            }
         }
         popMatrix(param1);
      }
      
      protected function pushMatrix(param1:Context) : void
      {
         if(pos == null)
         {
            transform.glLoadIdentity();
         }
         else
         {
            transform.glIdentityTranslatef(pos.x,pos.y,pos.z);
         }
         if(parentDeformScale != null)
         {
            transform.glScalef(parentDeformScale.x,parentDeformScale.y,parentDeformScale.z);
         }
         if(rot != null && rot.angle != 0)
         {
            transform.glRotateRad(rot.angle,rot.x,rot.y,rot.z);
         }
         if(scale != null)
         {
            transform.glScalef(scale.x,scale.y,scale.z);
         }
         if(deformPos != null)
         {
            transform.glTranslatef(deformPos.x,deformPos.y,deformPos.z);
         }
         if(deformRot != null && deformRot.angle != 0)
         {
            transform.glRotateRad(deformRot.angle,deformRot.x,deformRot.y,deformRot.z);
         }
         if(deformScale != null)
         {
            transform.glScalef(deformScale.x,deformScale.y,deformScale.z);
         }
         prevLocalToWorldTransform = param1.hworld;
         param1.hworld.copyTo(localToWorldTransform);
         localToWorldTransform.glMultMatrix(transform);
         param1.hworld = localToWorldTransform;
      }
      
      override public function dispose() : void
      {
         pos = null;
         cpos = null;
         scale = null;
         cscale = null;
         rot = null;
         crot = null;
         deformPos = null;
         deformScale = null;
         deformRot = null;
         parentDeformScale = null;
         if(mesh != null)
         {
            mesh.dispose();
         }
         mesh = null;
         transform = null;
         initialTransform = null;
         invInitialTransform = null;
         localToWorldTransform = null;
         prevLocalToWorldTransform = null;
         super.dispose();
         if(children != null)
         {
            GCUtil.disposeArray(children,true);
            children = null;
         }
      }
      
      public function getWorldPosition(param1:Vector3) : void
      {
         param1.x = localToWorldTransform.m12;
         param1.y = localToWorldTransform.m13;
         param1.z = localToWorldTransform.m14;
      }
      
      override public function init(param1:Context) : void
      {
         var _loc2_:int = 0;
         var _loc4_:Dictionary = null;
         var _loc5_:Object = null;
         var _loc6_:Dictionary = null;
         var _loc7_:Boolean = false;
         var _loc8_:Node = null;
         var _loc9_:Array = null;
         var _loc10_:Object = null;
         var _loc11_:uint = 0;
         super.init(param1);
         if(param1.scene.config != null)
         {
            _loc4_ = param1.scene.config.xformsDict;
            if(this.name != null && _loc4_ != null)
            {
               _loc5_ = _loc4_[this.name];
               if(_loc5_ != null)
               {
                  deformPos = SceneUtil.readVector3(_loc5_.deformPos);
                  deformRot = SceneUtil.readAxisAngle(_loc5_.deformRot);
                  deformScale = SceneUtil.readVector3(_loc5_.deformScale);
                  parentDeformScale = SceneUtil.readVector3(_loc5_.parentDeformScale);
               }
            }
            if(children != null)
            {
               _loc6_ = param1.scene.config.visibleDict;
               if(_loc6_ != null)
               {
                  _loc7_ = false;
                  _loc2_ = int(children.length);
                  while(--_loc2_ >= 0)
                  {
                     if(children[_loc2_] is Node && !(children[_loc2_] is Bone) && children[_loc2_].name != null)
                     {
                        _loc8_ = Node(children[_loc2_]);
                        _loc8_.visible = _loc6_[_loc8_.name] != null;
                        if(_loc8_.visible == false)
                        {
                           children[_loc2_] = null;
                           _loc7_ = true;
                        }
                     }
                  }
                  if(_loc7_)
                  {
                     _loc9_ = new Array();
                     for each(_loc10_ in children)
                     {
                        if(_loc10_ != null)
                        {
                           _loc9_.push(_loc10_);
                        }
                     }
                     children = _loc9_;
                  }
               }
            }
         }
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
         if(cpos != null)
         {
            scale = SceneUtil.readVector3(cscale);
            cscale = null;
         }
         transform.glLoadIdentity();
         if(pos != null)
         {
            transform.glTranslatef(pos.x,pos.y,pos.z);
         }
         if(rot != null && rot.angle != 0)
         {
            transform.glRotateRad(rot.angle,rot.x,rot.y,rot.z);
         }
         if(scale != null)
         {
            transform.glScalef(scale.x,scale.y,scale.z);
         }
         prevLocalToWorldTransform = param1.hworld;
         param1.hworld.copyTo(localToWorldTransform);
         localToWorldTransform.glMultMatrix(transform);
         param1.hworld = localToWorldTransform;
         var _loc3_:GLMatrix = param1.hworld;
         initialTransform = new GLMatrix();
         invInitialTransform = new GLMatrix();
         localToWorldTransform = new GLMatrix();
         _loc3_.copyTo(initialTransform);
         initialTransform.copyTo(invInitialTransform);
         invInitialTransform.inverseMatrix4();
         if(children != null)
         {
            _loc11_ = children.length;
            _loc2_ = 0;
            while(_loc2_ < _loc11_)
            {
               children[_loc2_].init(param1);
               _loc2_++;
            }
         }
         param1.hworld = prevLocalToWorldTransform;
      }
   }
}

