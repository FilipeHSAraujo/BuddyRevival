package com.buddylabs.player
{
   import flash.display.BitmapData;
   
   public class BaseMaterial extends BaseObj implements Material
   {
      
      internal var bmd:BitmapData = null;
      
      private var disposed:Boolean = false;
      
      public var lightmap:String;
      
      private var frames:Array;
      
      public var desc:XML;
      
      public var materialLibrary:MediaLibrary;
      
      private var lastFrame:int = -1;
      
      public function BaseMaterial()
      {
         super();
      }
      
      public function set bitmapData(param1:BitmapData) : void
      {
         this.bmd = param1;
      }
      
      public function set test(param1:int) : void
      {
         var _loc2_:int = 0;
         if(bmd == null)
         {
            _loc2_ = 0;
         }
         if(materialLibrary == null)
         {
            return;
         }
         if(param1 == lastFrame)
         {
            return;
         }
         lastFrame = param1;
         if(frames == null)
         {
            frames = new Array();
         }
         if(param1 >= frames.length)
         {
            frames.length = param1 + 1;
         }
         if(frames[param1] == null)
         {
            bmd = materialLibrary.createMaterial(desc,lightmap,null,param1);
            frames[param1] = bmd;
         }
         else
         {
            bmd = frames[param1];
         }
      }
      
      public function update() : void
      {
         if(bmd == null && materialLibrary != null)
         {
            bmd = materialLibrary.createMaterial(desc,lightmap,null,1);
         }
      }
      
      public function get bitmapData() : BitmapData
      {
         return bmd;
      }
      
      override public function dispose() : void
      {
         if(disposed)
         {
            return;
         }
         disposed = true;
         if(bmd != null && bmd.width > 0 && bmd.height > 0)
         {
            bmd = null;
         }
         if(frames != null)
         {
            GCUtil.disposeArray(frames,false);
            frames = null;
         }
         desc = null;
         lightmap = null;
         super.dispose();
      }
   }
}

