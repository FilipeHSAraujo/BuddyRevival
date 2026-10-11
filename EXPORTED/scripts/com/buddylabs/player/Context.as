package com.buddylabs.player
{
   import flash.display.Graphics;
   import flash.geom.Matrix;
   import flash.utils.getTimer;
   
   public class Context
   {
      
      public static var SMOOTH_TEXTURES:Boolean = false;
      
      public static var RENDER_WIREFRAME:Boolean = false;
      
      public static var RENDER_NORMAL:uint = 0;
      
      public static var RENDER_BACKGROUND:uint = 1;
      
      private static var FARZ:String = "farz";
      
      private static var DESCENDING_NUMERIC:uint = Array.DESCENDING | Array.NUMERIC;
      
      public var hproj:GLMatrix = new GLMatrix();
      
      internal var width:int;
      
      internal var graphics:Graphics = null;
      
      public var hview:GLMatrix = new GLMatrix();
      
      public var scene:Scene;
      
      internal var visibleTriList:Array = new Array();
      
      private var cameras:Array;
      
      internal var imageTracker:MediaTracker = new MediaTracker();
      
      public var camera:Camera;
      
      internal var rootPath:String;
      
      internal var triList:Array = new Array();
      
      public var hworld:GLMatrix = new GLMatrix();
      
      public var simStepFraction:Number = 1;
      
      internal var height:int;
      
      internal var renderType:uint;
      
      internal var visibleTriCount:uint = 0;
      
      internal var invhview:GLMatrix = new GLMatrix();
      
      internal var triListFetchCount:int = 0;
      
      public function Context()
      {
         super();
      }
      
      public function draw(param1:Graphics, param2:Scene, param3:uint = 0) : void
      {
         this.renderType = param3;
         this.graphics = param1;
         this.scene = param2;
         visibleTriCount = 0;
         visibleTriList.length = triList.length + 10;
         triListFetchCount = 0;
         camera.update(this);
         hproj.gluPerspective(camera.fov,height / width);
         hview = camera.view;
         if(invhview == null)
         {
            invhview = new GLMatrix();
         }
         hview.copyTo(invhview);
         invhview.inverseMatrix3in4();
         hworld.glLoadIdentity();
         param2.draw(this);
         if(visibleTriCount > 0)
         {
            visibleTriList.length = visibleTriCount;
            if(visibleTriCount > 1)
            {
               visibleTriList.sortOn(FARZ,DESCENDING_NUMERIC);
            }
            renderTri(param2);
         }
      }
      
      public function getRayFromScreenCoords(param1:Number, param2:Number) : Ray
      {
         var _loc3_:Number = camera.fov;
         var _loc4_:Number = 1 / Math.tan(_loc3_ / 2);
         var _loc5_:Number = Math.atan(Math.tan(_loc3_ / 2) * (height / Number(width))) * 2;
         var _loc6_:Number = 1 / Math.tan(_loc5_ / 2);
         var _loc7_:Number = width * 0.5;
         var _loc8_:Number = height * 0.5;
         var _loc9_:GLMatrix = camera.cameraToWorld;
         var _loc10_:Vector3 = new Vector3();
         _loc10_.z = -1;
         _loc10_.x = (param1 / _loc7_ - 1) / _loc4_;
         _loc10_.y = -(param2 / _loc8_ - 1) / _loc6_;
         _loc10_.normalize();
         _loc9_.rotateVector(_loc10_);
         return new Ray(camera.pos.clone(),_loc10_);
      }
      
      public function init(param1:int, param2:int) : void
      {
         width = param1;
         height = param2;
         if(height == 0)
         {
            height = 1;
         }
      }
      
      public function initScene(param1:Scene) : void
      {
         this.scene = param1;
         initCamera(param1);
         hworld.glLoadIdentity();
         param1.init(this);
      }
      
      public function dispose() : void
      {
         if(imageTracker != null)
         {
            imageTracker.dispose();
         }
         imageTracker = null;
         rootPath = null;
         camera = null;
         hview = null;
         invhview = null;
         hworld = null;
         hproj = null;
         graphics = null;
         if(triList != null)
         {
            GCUtil.disposeArray(triList,true);
            triList = null;
         }
         if(visibleTriList != null)
         {
            GCUtil.disposeArray(visibleTriList,true);
            visibleTriList = null;
         }
         if(scene != null)
         {
            scene.dispose();
         }
         scene = null;
      }
      
      public function findCameras() : Array
      {
         cameras = new Array();
         Searcher.searchAllByType(Camera,scene,cameras);
         return cameras;
      }
      
      internal function initCamera(param1:Scene) : void
      {
         camera = Searcher.findWithType(Camera,param1) as Camera;
         if(camera == null)
         {
            camera = new Camera();
         }
         camera.isBound = true;
         camera.bindTime = getTimer();
      }
      
      internal function renderTri(param1:Scene) : void
      {
         var _loc2_:Number = NaN;
         var _loc3_:Number = NaN;
         var _loc4_:Number = NaN;
         var _loc5_:Number = NaN;
         var _loc6_:Matrix = null;
         var _loc7_:Triangle = null;
         var _loc10_:Vector3 = null;
         var _loc11_:Vector3 = null;
         var _loc12_:Vector3 = null;
         var _loc8_:Matrix = new Matrix();
         var _loc9_:Boolean = SMOOTH_TEXTURES;
         if(RENDER_WIREFRAME)
         {
            graphics.lineStyle(0,0,1,false);
            for each(_loc7_ in visibleTriList)
            {
               _loc10_ = _loc7_.screen_v0;
               _loc11_ = _loc7_.screen_v1;
               _loc12_ = _loc7_.screen_v2;
               _loc2_ = _loc11_.x - _loc10_.x;
               _loc3_ = _loc11_.y - _loc10_.y;
               _loc4_ = _loc12_.x - _loc10_.x;
               _loc5_ = _loc12_.y - _loc10_.y;
               _loc6_ = _loc7_.UVMat;
               _loc8_.a = _loc6_.a * _loc2_ + _loc6_.b * _loc4_;
               _loc8_.b = _loc6_.a * _loc3_ + _loc6_.b * _loc5_;
               _loc8_.c = _loc6_.c * _loc2_ + _loc6_.d * _loc4_;
               _loc8_.d = _loc6_.c * _loc3_ + _loc6_.d * _loc5_;
               _loc8_.tx = _loc6_.tx * _loc2_ + _loc6_.ty * _loc4_ + _loc10_.x;
               _loc8_.ty = _loc6_.tx * _loc3_ + _loc6_.ty * _loc5_ + _loc10_.y;
               graphics.moveTo(_loc10_.x,_loc10_.y);
               graphics.beginBitmapFill(_loc7_.bmd,_loc8_,true,_loc9_);
               graphics.lineTo(_loc11_.x,_loc11_.y);
               graphics.lineTo(_loc12_.x,_loc12_.y);
               graphics.lineTo(_loc10_.x,_loc10_.y);
               graphics.endFill();
            }
         }
         else
         {
            graphics.lineStyle(undefined,0,1,false);
            for each(_loc7_ in visibleTriList)
            {
               _loc10_ = _loc7_.screen_v0;
               _loc11_ = _loc7_.screen_v1;
               _loc12_ = _loc7_.screen_v2;
               _loc2_ = _loc11_.x - _loc10_.x;
               _loc3_ = _loc11_.y - _loc10_.y;
               _loc4_ = _loc12_.x - _loc10_.x;
               _loc5_ = _loc12_.y - _loc10_.y;
               _loc6_ = _loc7_.UVMat;
               _loc8_.a = _loc6_.a * _loc2_ + _loc6_.b * _loc4_;
               _loc8_.b = _loc6_.a * _loc3_ + _loc6_.b * _loc5_;
               _loc8_.c = _loc6_.c * _loc2_ + _loc6_.d * _loc4_;
               _loc8_.d = _loc6_.c * _loc3_ + _loc6_.d * _loc5_;
               _loc8_.tx = _loc6_.tx * _loc2_ + _loc6_.ty * _loc4_ + _loc10_.x;
               _loc8_.ty = _loc6_.tx * _loc3_ + _loc6_.ty * _loc5_ + _loc10_.y;
               graphics.moveTo(_loc10_.x,_loc10_.y);
               graphics.beginBitmapFill(_loc7_.bmd,_loc8_,true,_loc9_);
               graphics.lineTo(_loc11_.x,_loc11_.y);
               graphics.lineTo(_loc12_.x,_loc12_.y);
               graphics.endFill();
            }
         }
      }
      
      public function firstCamera() : void
      {
         if(cameras == null)
         {
            findCameras();
         }
         if(cameras.length > 0)
         {
            camera = cameras[0];
         }
      }
      
      public function nextCamera() : void
      {
         var _loc1_:uint = 0;
         var _loc2_:uint = 0;
         if(cameras == null)
         {
            findCameras();
         }
         if(cameras.length > 0)
         {
            if(camera == null)
            {
               camera = cameras[0];
               return;
            }
            _loc1_ = 0;
            _loc2_ = 0;
            while(_loc2_ < cameras.length)
            {
               if(cameras[_loc2_] == camera)
               {
                  _loc1_ = _loc2_;
                  break;
               }
               _loc2_++;
            }
            _loc1_++;
            if(_loc1_ == cameras.length)
            {
               _loc1_ = 0;
            }
            camera = cameras[_loc1_];
         }
      }
   }
}

