package com.buddylabs.player
{
   import flash.display.Bitmap;
   import flash.display.BitmapData;
   import flash.display.DisplayObject;
   import flash.display.Shape;
   import flash.display.Sprite;
   import flash.filters.BitmapFilter;
   import flash.filters.ColorMatrixFilter;
   import flash.text.StaticText;
   import flash.utils.Dictionary;
   import flash.utils.describeType;
   
   public class GCUtil
   {
      
      public function GCUtil()
      {
         super();
      }
      
      public static function deleteSprite(param1:Sprite) : void
      {
         var _loc3_:DisplayObject = null;
         var _loc4_:int = 0;
         param1.cacheAsBitmap = false;
         param1.mask = null;
         GCUtil.disposeFilterArray(param1.filters);
         param1.filters = null;
         param1.graphics.clear();
         param1.contextMenu = null;
         param1.hitArea = null;
         var _loc2_:int = param1.numChildren;
         while(--_loc2_ >= 0)
         {
            _loc3_ = param1.getChildAt(_loc2_);
            if(_loc3_ is Sprite)
            {
               deleteSprite(Sprite(_loc3_));
            }
            else if(_loc3_ is Shape)
            {
               deleteShape(Shape(_loc3_));
            }
            else if(_loc3_ is Bitmap)
            {
               deleteBitmap(Bitmap(_loc3_));
            }
            else if(_loc3_ is StaticText)
            {
               deleteStaticText(StaticText(_loc3_));
            }
            else
            {
               _loc4_ = 0;
            }
            param1.removeChildAt(_loc2_);
         }
      }
      
      public static function deleteBitmap(param1:Bitmap) : void
      {
         param1.cacheAsBitmap = false;
         if(param1.bitmapData != null)
         {
            param1.bitmapData.dispose();
         }
         GCUtil.disposeFilterArray(param1.filters);
         param1.filters = null;
      }
      
      public static function disposeFilterArray(param1:Array) : void
      {
         var _loc4_:BitmapFilter = null;
         var _loc5_:ColorMatrixFilter = null;
         var _loc6_:Array = null;
         if(param1 == null)
         {
            return;
         }
         var _loc2_:uint = param1.length;
         var _loc3_:uint = 0;
         while(_loc3_ < _loc2_)
         {
            _loc4_ = param1[_loc3_];
            if(_loc4_ is ColorMatrixFilter)
            {
               _loc5_ = ColorMatrixFilter(_loc4_);
               _loc6_ = _loc5_.matrix;
               disposeArray(_loc6_,false);
            }
            param1[_loc3_] = null;
            _loc3_++;
         }
         param1.splice(0,_loc2_);
      }
      
      public static function disposeDictionary(param1:Dictionary) : void
      {
         var _loc2_:Object = null;
         var _loc3_:Object = null;
         if(param1 == null)
         {
            return;
         }
         for each(_loc2_ in param1)
         {
            _loc2_ = null;
         }
         for(_loc3_ in param1)
         {
            param1[_loc3_] = null;
         }
      }
      
      public static function deleteDisplayObject(param1:DisplayObject) : void
      {
         var _loc2_:int = 0;
         if(param1 == null)
         {
            return;
         }
         param1.cacheAsBitmap = false;
         if(param1 is Sprite)
         {
            deleteSprite(Sprite(param1));
         }
         else if(param1 is Shape)
         {
            deleteShape(Shape(param1));
         }
         else if(param1 is Bitmap)
         {
            deleteBitmap(Bitmap(param1));
         }
         else if(param1 is StaticText)
         {
            deleteStaticText(StaticText(param1));
         }
         else
         {
            _loc2_ = 0;
         }
      }
      
      public static function disposeArray(param1:Array, param2:Boolean) : void
      {
         var _loc4_:uint = 0;
         var _loc5_:* = undefined;
         if(param1 == null)
         {
            return;
         }
         var _loc3_:uint = param1.length;
         if(param2)
         {
            _loc4_ = 0;
            while(_loc4_ < _loc3_)
            {
               _loc5_ = param1[_loc4_];
               if(_loc5_ is Disposable)
               {
                  Disposable(_loc5_).dispose();
               }
               else if(_loc5_ != null)
               {
                  _loc5_.dispose();
               }
               param1[_loc4_] = null;
               _loc4_++;
            }
         }
         else
         {
            _loc4_ = 0;
            while(_loc4_ < _loc3_)
            {
               param1[_loc4_] = null;
               _loc4_++;
            }
         }
         param1.splice(0,_loc3_);
      }
      
      public static function disposeLibrary(param1:*) : void
      {
         var _loc3_:XML = null;
         var _loc4_:int = 0;
         var _loc5_:String = null;
         var _loc6_:Object = null;
         var _loc7_:String = null;
         var _loc8_:int = 0;
         var _loc9_:BitmapData = null;
         var _loc10_:ColorMatrixFilter = null;
         var _loc11_:Array = null;
         var _loc2_:XMLList = describeType(param1).variable;
         for each(_loc3_ in _loc2_)
         {
            _loc5_ = _loc3_.@name;
            _loc6_ = param1[_loc5_];
            if(_loc5_ == "displacementCache")
            {
               for(_loc7_ in _loc6_)
               {
                  _loc9_ = _loc6_[_loc7_];
                  _loc9_.dispose();
                  _loc6_[_loc7_] = null;
               }
               _loc8_ = 0;
            }
            else if(_loc6_ is ColorMatrixFilter)
            {
               _loc10_ = ColorMatrixFilter(_loc6_);
               _loc11_ = _loc10_.matrix;
               GCUtil.disposeArray(_loc11_,false);
               _loc11_ = null;
            }
            else if(_loc6_ is Array)
            {
               GCUtil.disposeArray(_loc6_ as Array,false);
            }
            else if(_loc6_ is Object)
            {
               disposeLibrary(_loc6_);
            }
            param1[_loc5_] = null;
         }
         _loc2_ = null;
         _loc4_ = 0;
      }
      
      public static function deleteShape(param1:Shape) : void
      {
         param1.cacheAsBitmap = false;
         param1.graphics.clear();
         param1.mask = null;
         GCUtil.disposeFilterArray(param1.filters);
         param1.filters = null;
      }
      
      public static function deleteStaticText(param1:StaticText) : void
      {
         param1.cacheAsBitmap = false;
         GCUtil.disposeFilterArray(param1.filters);
         param1.filters = null;
      }
   }
}

