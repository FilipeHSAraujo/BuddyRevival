package com.buddylabs.player
{
   public class Controller extends BaseObj
   {
      
      internal var targetRef:Node;
      
      public var channel:Object;
      
      internal var channelIndex:int = -1;
      
      public var target:Object;
      
      public var pos:Object;
      
      public var rot:Object;
      
      public var posLength:uint;
      
      public var rotLength:uint;
      
      public var vis:Object;
      
      public var visLength:uint;
      
      public var mat:Object;
      
      public var matLength:uint;
      
      public var weight:Object;
      
      public var weightLength:uint;
      
      public function Controller()
      {
         super();
      }
      
      override public function dispose() : void
      {
         target = null;
         targetRef = null;
         channel = null;
         if(pos is Array)
         {
            GCUtil.disposeArray(pos as Array,false);
         }
         pos = null;
         if(vis != null)
         {
            vis = null;
         }
         if(rot is Array)
         {
            GCUtil.disposeArray(rot as Array,false);
         }
         rot = null;
         if(weight is Array)
         {
            GCUtil.disposeArray(weight as Array,false);
         }
         weight = null;
         if(mat is Array)
         {
            GCUtil.disposeArray(mat as Array,false);
         }
         mat = null;
      }
      
      internal function animate(param1:Anim, param2:Context) : void
      {
         var _loc5_:int = 0;
         var _loc6_:BaseMaterial = null;
         var _loc7_:int = 0;
         var _loc8_:uint = 0;
         var _loc3_:Scene = param2.scene;
         if(targetRef == null && target != null)
         {
            targetRef = Node(_loc3_.getNodeByName(String(target)));
            if(pos != null && targetRef != null && targetRef.pos == null)
            {
               targetRef.pos = new Vector3(0,0,0);
            }
            if(rot != null && targetRef != null && targetRef.rot == null)
            {
               targetRef.rot = new AxisAngle(0,1,0,0);
            }
         }
         if(targetRef == null)
         {
            return;
         }
         var _loc4_:int = param1.current - param1.start;
         if(mat != null)
         {
            _loc5_ = _loc4_;
            if(_loc5_ >= mat.length)
            {
               _loc5_ = 0;
            }
            if(targetRef.mesh != null && targetRef.mesh.material != null)
            {
               _loc6_ = targetRef.mesh.material;
               _loc7_ = 0;
               _loc6_.test = mat[_loc5_];
               targetRef.mesh.updateTextures();
            }
         }
         if(pos != null)
         {
            _loc5_ = _loc4_ * 3;
            if(_loc5_ >= pos.length)
            {
               _loc5_ = 0;
            }
            targetRef.pos.x = pos[_loc5_];
            targetRef.pos.y = pos[_loc5_ + 1];
            targetRef.pos.z = pos[_loc5_ + 2];
         }
         if(vis != null)
         {
            _loc5_ = _loc4_;
            if(_loc5_ >= vis.length)
            {
               _loc5_ = 0;
            }
            targetRef.visible = vis[_loc5_] == 1;
         }
         if(rot != null)
         {
            _loc5_ = _loc4_ * 4;
            if(_loc5_ >= rot.length)
            {
               _loc5_ = 0;
            }
            targetRef.rot.x = rot[_loc5_];
            targetRef.rot.y = rot[_loc5_ + 1];
            targetRef.rot.z = rot[_loc5_ + 2];
            targetRef.rot.angle = rot[_loc5_ + 3];
         }
         if(weight != null && targetRef.mesh != null && targetRef.mesh.modifier != null && targetRef.mesh.modifier.channels != null && targetRef.mesh.modifier.weights != null)
         {
            if(channelIndex < 0)
            {
               channelIndex = targetRef.mesh.modifier.channels.indexOf(channel);
            }
            _loc5_ = _loc4_;
            _loc8_ = uint(weight.length);
            if(_loc5_ >= _loc8_)
            {
               _loc5_ = 0;
            }
            targetRef.mesh.modifier.weights[channelIndex] = weight[_loc5_] / 100;
         }
      }
   }
}

