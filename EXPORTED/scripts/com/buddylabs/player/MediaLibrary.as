package com.buddylabs.player
{
   import flash.display.*;
   import flash.events.*;
   import flash.filters.BitmapFilter;
   import flash.filters.ColorMatrixFilter;
   import flash.geom.Matrix;
   import flash.geom.Point;
   import flash.geom.Rectangle;
   import flash.system.ApplicationDomain;
   import flash.system.LoaderContext;
   import flash.utils.*;
   
   public class MediaLibrary extends MediaBinary implements SymbolLibrary
   {
      
      private static var paletteCache:Dictionary = new Dictionary();
      
      private var stage:Stage;
      
      private var imageLoader:Loader;
      
      private var colorOptionsLut:Dictionary = new Dictionary();
      
      private var mat50Percent:Array = [1,0,0,0,0,0,1,0,0,0,0,0,1,0,0,0,0,0,0.5,0];
      
      private var maskFilterDict:Dictionary;
      
      private var symbolCache:Dictionary = new Dictionary();
      
      private var lightmapDict:Dictionary;
      
      private var clipRectDict:Dictionary;
      
      private var colorTintLut:Dictionary = new Dictionary();
      
      public var library:* = null;
      
      public function MediaLibrary(param1:Stage, param2:String = null)
      {
         super();
         this.stage = param1;
         if(param2 != null)
         {
            this.url = param2;
         }
      }
      
      public static function fixSymbolName(param1:String) : String
      {
         if(param1 == null)
         {
            return param1;
         }
         while(param1.indexOf(" ") >= 0)
         {
            param1 = param1.replace(" ","_");
         }
         while(param1.indexOf("+") >= 0)
         {
            param1 = param1.replace("+","And");
         }
         return param1;
      }
      
      public function getLightmap(param1:String, param2:Rectangle) : DisplayObject
      {
         var _loc3_:Object = null;
         if(param1 == null)
         {
            return null;
         }
         if(lightmapDict == null)
         {
            lightmapDict = new Dictionary();
            for each(_loc3_ in library.lightmaps)
            {
               if(_loc3_ != null)
               {
                  lightmapDict[_loc3_.name] = _loc3_.symbol;
               }
            }
         }
         return this.getSymbol(lightmapDict[param1]);
      }
      
      override protected function onLoaded(param1:Event) : void
      {
         imageLoader = new Loader();
         imageLoader.contentLoaderInfo.addEventListener(Event.COMPLETE,onLoadedImage);
         var _loc2_:LoaderContext = new LoaderContext();
         if("allowLoadBytesCodeExecution" in _loc2_)
         {
            _loc2_["allowLoadBytesCodeExecution"] = true;
         }
         imageLoader.loadBytes(loader.data,_loc2_);
      }
      
      public function getClipRect(param1:String) : Rectangle
      {
         var _loc2_:Object = null;
         if(clipRectDict == null)
         {
            clipRectDict = new Dictionary();
            for each(_loc2_ in library.clipRects)
            {
               if(_loc2_ != null)
               {
                  clipRectDict[_loc2_.name] = _loc2_.rect;
               }
            }
         }
         return clipRectDict[param1];
      }
      
      public function getMasks() : Array
      {
         return library.masks;
      }
      
      public function createMaterial(param1:XML, param2:String = null, param3:BitmapData = null, param4:int = 1) : BitmapData
      {
         var _loc11_:Matrix = null;
         trace("                          " + param1.parent().parent().@name + ", " + param1.parent().@name + ", " + param1.@name + ", " + param1.@clipRect + ",  createMaterial " + param4);
         var _loc5_:Number = getTimer();
         var _loc6_:DisplayObjectContainer = createMaterialInternal(param1,param2);
         if(_loc6_ == null)
         {
            return null;
         }
         if(param4 != 1)
         {
            SceneUtil.advanceMovieClipsToFrame(_loc6_,param4);
         }
         var _loc7_:Rectangle = getClipRect(param1.@clipRect);
         var _loc8_:* = param1.@hasAlpha.toString() == "true";
         var _loc9_:Number = 1;
         var _loc10_:Number = 1;
         if(param3 == null)
         {
            param3 = new BitmapData(_loc7_.width - _loc7_.x,_loc7_.height - _loc7_.x,_loc8_,16777215);
         }
         else if(_loc7_.width != param3.width || _loc7_.height != param3.height)
         {
            _loc9_ = param3.width / _loc7_.width;
            _loc10_ = param3.height / _loc7_.height;
         }
         _loc6_.visible = false;
         stage.addChild(_loc6_);
         if(_loc9_ != 1 || _loc10_ != 1)
         {
            _loc11_ = new Matrix();
            _loc11_.createBox(_loc9_,_loc10_);
            param3.draw(_loc6_,_loc11_,null,null,null,true);
         }
         else
         {
            param3.draw(_loc6_);
         }
         stage.removeChild(_loc6_);
         GCUtil.deleteDisplayObject(_loc6_);
         _loc6_ = null;
         return param3;
      }
      
      public function getSymbol(param1:String) : DisplayObject
      {
         var _loc3_:Class = null;
         var _loc4_:Object = null;
         var _loc5_:Sprite = null;
         var _loc6_:BitmapData = null;
         var _loc2_:ApplicationDomain = imageLoader.contentLoaderInfo.applicationDomain;
         if(_loc2_.hasDefinition(param1))
         {
            _loc3_ = Class(_loc2_.getDefinition(param1));
            _loc4_ = new _loc3_();
            if(_loc4_ is BitmapData)
            {
               _loc5_ = new Sprite();
               _loc6_ = BitmapData(_loc4_);
               _loc5_.addChild(new Bitmap(_loc6_));
               return _loc5_;
            }
            return _loc4_ as Sprite;
         }
         return null;
      }
      
      public function createMaterialMovieClip(param1:*, param2:XML) : DisplayObjectContainer
      {
         return createMaterialInternal(param2);
      }
      
      override public function dispose() : void
      {
         if(library != null)
         {
            GCUtil.disposeLibrary(library);
         }
         if(imageLoader != null)
         {
            imageLoader.unload();
         }
         imageLoader = null;
         library = null;
         GCUtil.disposeArray(mat50Percent,false);
         mat50Percent = null;
         super.dispose();
      }
      
      public function initData(param1:ByteArray) : void
      {
         imageLoader = new Loader();
         imageLoader.contentLoaderInfo.addEventListener(Event.COMPLETE,onLoadedImage);
         var _loc2_:LoaderContext = new LoaderContext();
         if("allowLoadBytesCodeExecution" in _loc2_)
         {
            _loc2_["allowLoadBytesCodeExecution"] = true;
         }
         imageLoader.loadBytes(param1,_loc2_);
      }
      
      public function getColorTintOption(param1:String) : Array
      {
         var _loc4_:Object = null;
         var _loc5_:Array = null;
         var _loc6_:Array = null;
         var _loc7_:Array = null;
         var _loc8_:uint = 0;
         if(param1 == null || library == null)
         {
            return null;
         }
         var _loc2_:Array = colorTintLut[param1];
         if(_loc2_ != null)
         {
            return _loc2_;
         }
         var _loc3_:Array = library.colorOptions;
         if(_loc3_ == null)
         {
            return null;
         }
         for each(_loc4_ in _loc3_)
         {
            if(_loc4_ != null && _loc4_.name == param1)
            {
               _loc5_ = loadPalette(_loc4_.palette);
               if(_loc5_ != null)
               {
                  colorTintLut[param1] = _loc5_;
                  return _loc5_;
               }
               _loc6_ = _loc4_.colorMat;
               if(_loc6_ != null)
               {
                  _loc7_ = new Array(_loc6_.length);
                  _loc8_ = 0;
                  while(_loc8_ < _loc7_.length)
                  {
                     _loc7_[_loc8_] = _loc8_;
                     _loc8_++;
                  }
                  colorTintLut[param1] = _loc7_;
                  return _loc7_;
               }
            }
         }
         return null;
      }
      
      public function getSymbols() : Array
      {
         return library.symbols;
      }
      
      private function createMaterialInternal(param1:XML, param2:String = null) : DisplayObjectContainer
      {
         var grabbedMaskLut:Dictionary;
         var materialBlendMode:String;
         var sprite:Sprite;
         var rect:Rectangle;
         var k:int = 0;
         var sel:String = null;
         var lName:String = null;
         var alayer:XML = null;
         var lightmap:DisplayObject = null;
         var key:String = null;
         var whichTexture:int = 0;
         var whichColor:int = 0;
         var colorLayer:XML = null;
         var textures:XMLList = null;
         var numTextures:int = 0;
         var atexture:XML = null;
         var layerName:String = null;
         var symbolName:String = null;
         var layerLock:String = null;
         var colorLock:String = null;
         var s:String = null;
         var symbol:DisplayObject = null;
         var grabbedMask:Boolean = false;
         var maskNames:XMLList = null;
         var masks:Array = null;
         var mask:DisplayObject = null;
         var blendMode:String = null;
         var whichColorOption:String = null;
         var colorIndex:int = 0;
         var grabMask:String = null;
         var grabMaskLayer:XML = null;
         var grabMaskTextureIndex:int = 0;
         var maskName:String = null;
         var maskBmd:BitmapData = null;
         var maskSprite:Sprite = null;
         var maskedLayer:Sprite = null;
         var maskComposite:Sprite = null;
         var maskFilters:Array = null;
         var b0:BitmapData = null;
         var b1:BitmapData = null;
         var afilter:BitmapFilter = null;
         var temp:BitmapData = null;
         var colorSelStr:String = null;
         var option:Object = null;
         var colorMatArray:Array = null;
         var cmaLen:int = 0;
         var colorsInPalette:Array = null;
         var cipLen:int = 0;
         var colorVal:int = 0;
         var mat:Array = null;
         var lightmap2:DisplayObject = null;
         var material:XML = param1;
         var lightmapName:String = param2;
         var numCached:int = 0;
         var layers:XMLList = material.layer;
         var numLayers:int = int(layers.length());
         if(numLayers < 1)
         {
            return null;
         }
         rect = getClipRect(material.@clipRect);
         if(rect == null)
         {
            return null;
         }
         sprite = new Sprite();
         materialBlendMode = material.@blendMode;
         if(materialBlendMode != null && materialBlendMode.length > 0)
         {
            sprite.blendMode = materialBlendMode;
         }
         else
         {
            sprite.blendMode = BlendMode.LAYER;
         }
         grabbedMaskLut = new Dictionary();
         for each(alayer in layers)
         {
            whichTexture = -1;
            whichColor = -1;
            if(alayer.hasOwnProperty("@lockTexture"))
            {
               layerLock = alayer.@lockTexture;
               sel = layers.(@name == layerLock).@textureIndex;
               if(sel != null && sel.length > 0)
               {
                  whichTexture = int(sel);
               }
            }
            colorLayer = null;
            if(alayer.hasOwnProperty("@lockColor"))
            {
               colorLock = alayer.@lockColor;
               colorLayer = layers.(@name == colorLock)[0];
               sel = colorLayer.@colorIndex;
               if(sel != null && sel.length > 0)
               {
                  whichColor = int(sel);
               }
            }
            textures = alayer.texture;
            numTextures = int(textures.length());
            if(whichTexture == -1)
            {
               s = alayer.@textureIndex;
               if(s != null && s.length > 0)
               {
                  whichTexture = int(s);
               }
               else
               {
                  whichTexture = numTextures <= 1 ? 0 : SceneUtil.randomInt(numTextures - 1);
               }
            }
            if(whichTexture >= numTextures)
            {
               whichTexture = numTextures - 1;
            }
            atexture = textures[whichTexture];
            layerName = alayer.@name;
            if(layerName != null && layerName.length > 0)
            {
               alayer.@textureIndex = whichTexture;
            }
            symbolName = atexture.@symbol;
            if(symbolName != null && symbolName.length > 0)
            {
               symbol = getSymbol(symbolName);
               if(symbol == null)
               {
                  return null;
               }
               grabbedMask = false;
               maskNames = null;
               if(alayer.hasOwnProperty("@grabMask"))
               {
                  grabMask = alayer.@grabMask;
                  grabMaskLayer = layers.(@name == grabMask)[0];
                  grabMaskTextureIndex = int(grabMaskLayer.@textureIndex);
                  maskNames = grabMaskLayer.texture[grabMaskTextureIndex].mask.@maskSelection;
                  if(maskNames != null && maskNames.length() > 0)
                  {
                     grabbedMask = true;
                  }
               }
               masks = null;
               if(grabbedMask == true || atexture.mask != null && atexture.mask.length() > 0)
               {
                  if(!grabbedMask)
                  {
                     maskNames = atexture.mask.@maskSelection;
                  }
                  masks = new Array();
                  for each(maskName in maskNames)
                  {
                     mask = getSymbol(maskName);
                     if(mask != null)
                     {
                        masks.push(mask);
                     }
                  }
               }
               if(masks != null && masks.length > 0)
               {
                  if(grabbedMask)
                  {
                     maskBmd = grabbedMaskLut[grabMask];
                  }
                  else
                  {
                     maskComposite = new Sprite();
                     for each(mask in masks)
                     {
                        maskComposite.addChild(mask);
                     }
                     maskBmd = new BitmapData(rect.width,rect.height,true,16777215);
                     maskComposite.visible = false;
                     stage.addChild(maskComposite);
                     maskBmd.draw(maskComposite,null,null,null,rect,true);
                     stage.removeChild(maskComposite);
                     GCUtil.deleteSprite(maskComposite);
                     maskComposite = null;
                     maskFilters = getMaskFilter(atexture.@maskFilter);
                     if(maskFilters != null)
                     {
                        b0 = maskBmd;
                        b1 = maskBmd.clone();
                        for each(afilter in maskFilters)
                        {
                           b0.applyFilter(b1,maskBmd.rect,new Point(0,0),afilter);
                           temp = b0;
                           b0 = b1;
                           b1 = temp;
                        }
                        maskBmd = b1;
                        b0.dispose();
                        b0 = null;
                     }
                     grabbedMaskLut[layerName] = maskBmd;
                  }
                  maskSprite = new Sprite();
                  maskSprite.addChild(new Bitmap(maskBmd));
                  maskSprite.blendMode = BlendMode.ALPHA;
                  maskedLayer = new Sprite();
                  maskedLayer.blendMode = BlendMode.LAYER;
                  maskedLayer.addChild(symbol);
                  maskedLayer.addChild(maskSprite);
                  sprite.addChild(maskedLayer);
               }
               else
               {
                  sprite.addChild(symbol);
               }
               blendMode = alayer.@blendMode;
               if(blendMode != null && blendMode.length > 0)
               {
                  symbol.blendMode = blendMode;
               }
               whichColorOption = atexture.@color;
               if(whichColor != -1)
               {
                  colorIndex = whichColor;
                  atexture.@colorSelection = whichColor;
               }
               else
               {
                  colorSelStr = atexture.@colorSelection;
                  if(colorSelStr == null || colorSelStr.length == 0)
                  {
                     colorIndex = -1;
                  }
                  else
                  {
                     colorIndex = int(colorSelStr);
                  }
               }
               if(whichColorOption != null)
               {
                  option = colorOptionsLut[whichColorOption];
                  if(option != null)
                  {
                     colorMatArray = option.colorMat;
                     if(colorMatArray != null && colorIndex < (cmaLen = int(colorMatArray.length)))
                     {
                        if(colorIndex >= cmaLen)
                        {
                           colorIndex = cmaLen - 1;
                        }
                        else if(colorIndex == -1)
                        {
                           colorIndex = cmaLen <= 1 ? 0 : int(Math.floor(Math.random() * (cmaLen - 0.001)));
                        }
                        symbol.filters = [colorMatArray[colorIndex].clone()];
                        colorMatArray = null;
                     }
                     else
                     {
                        colorsInPalette = loadPalette(option.palette);
                        if(colorsInPalette != null)
                        {
                           cipLen = int(colorsInPalette.length);
                           if(colorIndex >= cipLen)
                           {
                              colorIndex = cipLen - 1;
                           }
                           else if(colorIndex == -1)
                           {
                              colorIndex = cipLen <= 1 ? 0 : int(Math.floor(Math.random() * (cipLen - 0.001)));
                           }
                           colorVal = int(colorsInPalette[colorIndex]);
                           mat = [(colorVal >> 16 & 0xFF) / 255,0,0,0,0,0,(colorVal >> 8 & 0xFF) / 255,0,0,0,0,0,(colorVal & 0xFF) / 255,0,0,0,0,0,1,0];
                           symbol.filters = [new ColorMatrixFilter(mat)];
                        }
                     }
                  }
                  atexture.@colorSelection = colorIndex;
                  alayer.@colorIndex = colorIndex;
               }
            }
         }
         lightmap = getLightmap(lightmapName,rect);
         if(lightmap != null)
         {
            lightmap.blendMode = BlendMode.HARDLIGHT;
            lightmap.filters = [new ColorMatrixFilter(mat50Percent)];
            lightmap2 = getLightmap(lightmapName,rect);
            lightmap2.blendMode = BlendMode.OVERLAY;
            lightmap2.filters = [new ColorMatrixFilter(mat50Percent)];
            sprite.addChild(lightmap);
            sprite.addChild(lightmap2);
         }
         rect = null;
         for(key in grabbedMaskLut)
         {
            grabbedMaskLut[key] = null;
         }
         grabbedMaskLut = null;
         return sprite;
      }
      
      public function getClipRects() : Array
      {
         return library.clipRects;
      }
      
      public function getMaskOptions(param1:String) : Array
      {
         var _loc3_:Object = null;
         var _loc4_:Array = null;
         var _loc2_:Array = getMasks();
         for each(_loc3_ in _loc2_)
         {
            if(_loc3_.name == param1)
            {
               return _loc3_.mask;
            }
         }
         return null;
      }
      
      public function getColorOptions() : Array
      {
         return library.colorOptions;
      }
      
      public function loadPalette(param1:Class) : Array
      {
         var _loc4_:Object = null;
         var _loc5_:Array = null;
         if(param1 == null)
         {
            return null;
         }
         var _loc2_:String = getQualifiedClassName(param1);
         var _loc3_:Array = paletteCache[_loc2_];
         if(_loc3_ != null)
         {
            return _loc3_;
         }
         _loc4_ = new param1(0,0);
         if(_loc4_ is BitmapData)
         {
            _loc5_ = SceneUtil.readIntArray(_loc4_.getPixels(_loc4_.rect));
            paletteCache[_loc2_] = _loc5_;
            _loc4_.dispose();
            return _loc5_;
         }
         if(_loc4_ is Bitmap)
         {
            _loc5_ = SceneUtil.readIntArray(_loc4_.bitmapData.getPixels(_loc4_.bitmapData.rect));
            paletteCache[_loc2_] = _loc5_;
            _loc4_.bitmapData.dispose();
            return _loc5_;
         }
         return null;
      }
      
      public function getLightmaps() : Array
      {
         return library.lightmaps;
      }
      
      public function getMaskFilters() : Array
      {
         return library.maskFilters;
      }
      
      public function getMaskFilter(param1:String) : Array
      {
         var _loc3_:Object = null;
         if(param1 == null)
         {
            return null;
         }
         if(maskFilterDict == null)
         {
            maskFilterDict = new Dictionary();
            for each(_loc3_ in library.maskFilters)
            {
               if(_loc3_ != null)
               {
                  maskFilterDict[_loc3_.name] = _loc3_;
               }
            }
         }
         var _loc2_:Class = maskFilterDict[param1];
         if(_loc2_ == null)
         {
            return null;
         }
         return _loc2_();
      }
      
      public function createScaledMaterial(param1:XML, param2:Number, param3:int = 1) : BitmapData
      {
         var _loc4_:DisplayObjectContainer = createMaterialInternal(param1);
         if(_loc4_ == null)
         {
            return null;
         }
         if(param3 != 1)
         {
            SceneUtil.advanceMovieClipsToFrame(_loc4_,param3);
         }
         var _loc5_:Rectangle = getClipRect(param1.@clipRect);
         var _loc6_:* = param1.@hasAlpha.toString() == "true";
         var _loc7_:BitmapData = new BitmapData((_loc5_.width - _loc5_.x) * param2,(_loc5_.height - _loc5_.x) * param2,_loc6_,16777215);
         _loc4_.visible = false;
         stage.addChild(_loc4_);
         var _loc8_:Matrix = new Matrix();
         _loc8_.createBox(param2,param2);
         _loc7_.draw(_loc4_,_loc8_,null,null,null,true);
         stage.removeChild(_loc4_);
         GCUtil.deleteDisplayObject(_loc4_);
         return _loc7_;
      }
      
      protected function onLoadedImage(param1:Event) : void
      {
         var _loc3_:Object = null;
         imageLoader.contentLoaderInfo.removeEventListener(Event.COMPLETE,onLoadedImage);
         library = imageLoader.content;
         var _loc2_:Array = library.colorOptions;
         for each(_loc3_ in _loc2_)
         {
            if(_loc3_ != null && _loc3_.name != null)
            {
               trace(_loc3_.name);
               colorOptionsLut[_loc3_.name] = _loc3_;
            }
         }
         state = COMPLETE;
         dispatchEvent(param1);
      }
   }
}

