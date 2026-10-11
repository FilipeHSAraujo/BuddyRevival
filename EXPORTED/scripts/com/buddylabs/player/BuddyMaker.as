package com.buddylabs.player
{
   import flash.net.registerClassAlias;
   import flash.utils.ByteArray;
   import flash.utils.Dictionary;
   
   public class BuddyMaker
   {
      
      public function BuddyMaker()
      {
         super();
      }
      
      private static function maskNameToIndex(param1:MediaLibrary, param2:String) : int
      {
         var _loc5_:Object = null;
         var _loc3_:Array = param1.getMasks();
         var _loc4_:int = 0;
         for each(_loc5_ in _loc3_)
         {
            if(_loc5_.name == param2)
            {
               return _loc4_;
            }
            _loc4_++;
         }
         return 0;
      }
      
      public static function makeMaterialPreset(param1:XML, param2:Scene, param3:MediaLibrary) : ByteArray
      {
         var _loc6_:XML = null;
         var _loc7_:ByteArray = null;
         var _loc8_:Object = null;
         var _loc9_:String = null;
         var _loc10_:int = 0;
         var _loc11_:XML = null;
         var _loc12_:String = null;
         var _loc13_:XMLList = null;
         var _loc14_:XML = null;
         var _loc15_:Object = null;
         var _loc16_:String = null;
         var _loc17_:int = 0;
         var _loc18_:XML = null;
         var _loc19_:XMLList = null;
         var _loc20_:String = null;
         var _loc21_:String = null;
         var _loc22_:Array = null;
         var _loc23_:uint = 0;
         var _loc24_:uint = 0;
         var _loc25_:* = false;
         var _loc26_:XML = null;
         var _loc4_:BuddyDesc = new BuddyDesc();
         var _loc5_:Array = new Array();
         for each(_loc6_ in param1.materialOptions.materialOption)
         {
            _loc8_ = new Object();
            _loc5_.push(_loc8_);
            _loc8_.mo = _loc6_.childIndex();
            _loc9_ = _loc6_.@materialIndex;
            _loc10_ = 0;
            if(_loc9_ != null && _loc9_.length > 0)
            {
               _loc10_ = int(_loc9_);
            }
            _loc11_ = _loc6_.material[_loc10_];
            _loc12_ = _loc11_.@name;
            _loc8_.m = _loc10_;
            _loc8_.l = new Array();
            _loc13_ = _loc11_.layer;
            for each(_loc14_ in _loc13_)
            {
               _loc15_ = new Object();
               _loc8_.l.push(_loc15_);
               _loc16_ = _loc14_.@name;
               _loc15_.n = _loc14_.childIndex();
               _loc17_ = int(_loc14_.@textureIndex);
               if(_loc14_.@lockTexture != "true")
               {
                  _loc20_ = _loc14_.texture[_loc17_].@symbol;
                  _loc15_.t = _loc17_;
               }
               _loc18_ = _loc14_.texture[_loc17_];
               if(_loc14_.@lockColor != "true")
               {
                  _loc21_ = _loc18_.@color;
                  if(_loc21_ != null && _loc21_.length > 0)
                  {
                     _loc22_ = param3.getColorTintOption(_loc21_);
                     if(_loc22_ != null && _loc22_.length > 1)
                     {
                        _loc23_ = uint(_loc14_.@colorIndex);
                        _loc24_ = uint(_loc22_[_loc23_]);
                        _loc15_.c = _loc23_;
                     }
                  }
               }
               _loc19_ = _loc18_.mask;
               if(_loc19_ != null && _loc19_.length() > 0)
               {
                  _loc25_ = _loc14_.@grabMask == "true";
                  if(!_loc25_)
                  {
                     _loc15_.m = new ByteArray();
                     for each(_loc26_ in _loc19_)
                     {
                        _loc15_.m.writeShort(maskNameToIndex(param3,_loc26_.@mask));
                        _loc15_.m.writeShort(maskSelectionToIndex(param3,_loc26_.@mask,_loc26_.@maskSelection));
                     }
                     _loc15_.m.position = 0;
                  }
               }
            }
         }
         _loc4_.m = _loc5_;
         _loc7_ = new ByteArray();
         registerClassAlias("desc",BuddyDesc);
         _loc7_.writeObject(_loc4_);
         _loc7_.position = 0;
         _loc7_.compress();
         _loc7_.position = 0;
         _loc4_.dispose();
         return _loc7_;
      }
      
      private static function maskSelectionToIndex(param1:MediaLibrary, param2:String, param3:String) : int
      {
         var _loc5_:Object = null;
         var _loc6_:Array = null;
         var _loc7_:uint = 0;
         var _loc8_:uint = 0;
         var _loc4_:Array = param1.getMasks();
         for each(_loc5_ in _loc4_)
         {
            if(_loc5_.name == param2)
            {
               _loc6_ = _loc5_.mask;
               _loc7_ = _loc6_.length;
               _loc8_ = 0;
               while(_loc8_ < _loc7_)
               {
                  if(_loc6_[_loc8_] == param3)
                  {
                     return _loc8_;
                  }
                  _loc8_++;
               }
            }
         }
         return 0;
      }
      
      public static function loadBinaryDesc(param1:BuddyDesc, param2:XML, param3:Scene, param4:MediaLibrary) : void
      {
         var backgroundXML:XML;
         var matOptionsXML:XMLList;
         var encodedVisibility:ByteArray;
         var animationXML:XML;
         var name:String = null;
         var matOptionXML:XML = null;
         var matOptions:Array = null;
         var matSettings:Object = null;
         var sliders:XMLList = null;
         var slider:XML = null;
         var items:XMLList = null;
         var item:XML = null;
         var alwaysVis:Boolean = false;
         var materialsXML:XMLList = null;
         var materialXML:XML = null;
         var layersXML:XMLList = null;
         var layerXML:XML = null;
         var texturesXML:XMLList = null;
         var textureXML:XML = null;
         var masksXML:XMLList = null;
         var maskXML:XML = null;
         var matOption:XML = null;
         var layers:Array = null;
         var layerSettings:Object = null;
         var textureIndex:int = 0;
         var maskData:ByteArray = null;
         var maskName:String = null;
         var maskSelection:String = null;
         var desc:BuddyDesc = param1;
         var catalogXML:XML = param2;
         var scene:Scene = param3;
         var materialLibrary:MediaLibrary = param4;
         var encodedSliders:ByteArray = desc.s;
         if(encodedSliders != null)
         {
            sliders = catalogXML.sliderSet.slider;
            while(encodedSliders.bytesAvailable > 0)
            {
               slider = sliders[desc.s.readShort()];
               slider.@value = desc.s.readShort();
            }
            SceneUtil.setSliders(sliders,scene);
         }
         encodedVisibility = desc.v;
         if(encodedVisibility != null)
         {
            items = catalogXML.group.categories.itemCategory.item;
            for each(item in items)
            {
               alwaysVis = item.@alwaysVis == "true";
               if(alwaysVis)
               {
                  item.@visible = false;
               }
            }
            while(encodedVisibility.bytesAvailable > 0)
            {
               item = items[desc.v.readShort()];
               item.@visible = true;
            }
         }
         backgroundXML = catalogXML.background[0];
         backgroundXML.@font = desc.f;
         backgroundXML.@fontLib = desc.fl;
         backgroundXML.@topText = desc.tc;
         backgroundXML.@bottomText = desc.bc;
         backgroundXML.@topFontSize = desc.tfs;
         backgroundXML.@bottomFontSize = desc.bfs;
         backgroundXML.@topFontAlignment = desc.tfa;
         backgroundXML.@bottomFontAlignment = desc.bfa;
         animationXML = catalogXML.animations[0];
         animationXML.@selected = desc.a;
         matOptionsXML = catalogXML.materialOptions.materialOption;
         for each(matOptionXML in matOptionsXML)
         {
            name = matOptionXML.@name;
            matOptionXML.@hashCode = hash(name);
            materialsXML = matOptionXML.material;
            for each(materialXML in materialsXML)
            {
               name = materialXML.@name;
               materialXML.@hashCode = hash(name);
               layersXML = materialXML.layer;
               for each(layerXML in layersXML)
               {
                  name = layerXML.@name;
                  layerXML.@hashCode = hash(name);
                  texturesXML = layerXML.texture;
                  for each(textureXML in texturesXML)
                  {
                     name = textureXML.@symbol;
                     textureXML.@hashCode = hash(name);
                     masksXML = textureXML.mask;
                     for each(maskXML in masksXML)
                     {
                        name = maskXML.@mask;
                        maskXML.@hashCode = hash(name);
                     }
                  }
               }
            }
         }
         matOptions = desc.m;
         for each(matSettings in matOptions)
         {
            matOption = catalogXML.materialOptions.materialOption[matSettings.mo];
            materialXML = matOption.material[matSettings.m];
            matOption.@materialIndex = materialXML.childIndex();
            layers = matSettings.l;
            for each(layerSettings in layers)
            {
               layerXML = materialXML.layer[layerSettings.n];
               if(layerSettings.t != null)
               {
                  layerXML.@textureIndex = layerSettings.t;
               }
               textureIndex = int(layerXML.@textureIndex);
               textureXML = layerXML.texture[textureIndex];
               if(layerSettings.c != null)
               {
                  layerXML.@colorIndex = layerSettings.c;
                  textureXML.@colorSelection = layerSettings.c;
               }
               if(layerSettings.m != null)
               {
                  maskData = layerSettings.m;
                  while(maskData.bytesAvailable > 0)
                  {
                     maskName = maskIndexToName(materialLibrary,maskData.readShort());
                     maskXML = textureXML.mask.(@mask == maskName)[0];
                     if(maskXML != null)
                     {
                        maskSelection = maskSelectionIndexToName(materialLibrary,maskName,maskData.readShort());
                        maskXML.@maskSelection = maskSelection;
                     }
                  }
               }
            }
         }
      }
      
      private static function maskIndexToName(param1:MediaLibrary, param2:int) : String
      {
         var _loc3_:Array = param1.getMasks();
         return _loc3_[param2].name;
      }
      
      public static function makeBinaryDesc(param1:String, param2:XML, param3:Scene, param4:MediaLibrary) : ByteArray
      {
         var matOptions:Array;
         var sliders:XMLList;
         var slider:XML = null;
         var items:XMLList = null;
         var visibleMaterials:Dictionary = null;
         var itemIndex:int = 0;
         var item:XML = null;
         var animationXML:XML = null;
         var backgroundXML:XML = null;
         var matOptionName:String = null;
         var buddyAMF3:ByteArray = null;
         var sliderName:String = null;
         var value:int = 0;
         var itemName:String = null;
         var matName:String = null;
         var materialOption:String = null;
         var materialName:String = null;
         var materialXML:XML = null;
         var matOptionXML:XML = null;
         var matSettings:Object = null;
         var matOption:XML = null;
         var materialIndexStr:String = null;
         var materialIndex:int = 0;
         var material:XML = null;
         var layers:XMLList = null;
         var layer:XML = null;
         var layerSettings:Object = null;
         var layerName:String = null;
         var textureIndex:int = 0;
         var texture:XML = null;
         var masksXML:XMLList = null;
         var textureSymbolName:String = null;
         var color:String = null;
         var colorOptionArray:Array = null;
         var colorIndex:uint = 0;
         var tint:uint = 0;
         var grabMask:Boolean = false;
         var mask:XML = null;
         var descXMLPath:String = param1;
         var catalogXML:XML = param2;
         var scene:Scene = param3;
         var materialLibrary:MediaLibrary = param4;
         var desc:BuddyDesc = new BuddyDesc();
         desc.p = descXMLPath;
         sliders = catalogXML.sliderSet.slider;
         for each(slider in sliders)
         {
            sliderName = slider.@name;
            value = int(slider.@value);
            if(value != 0)
            {
               desc.s.writeShort(slider.childIndex());
               desc.s.writeShort(value);
            }
         }
         desc.s.position = 0;
         items = catalogXML.group.categories.itemCategory.item;
         visibleMaterials = new Dictionary();
         itemIndex = 0;
         for each(item in items)
         {
            if(item.@alwaysVis == "true" || item.@visible == "true")
            {
               itemName = item.@name;
               desc.v.writeShort(itemIndex);
               matName = item.@mat;
               visibleMaterials[matName] = matName;
            }
            itemIndex++;
         }
         desc.v.position = 0;
         animationXML = catalogXML.animations[0];
         desc.a = animationXML.@selected;
         backgroundXML = catalogXML.background[0];
         if(backgroundXML != null && backgroundXML.@customized == "true")
         {
            desc.f = backgroundXML.@font;
            desc.fl = backgroundXML.@fontLib;
            desc.tc = backgroundXML.@topText;
            desc.bc = backgroundXML.@bottomText;
            desc.tfs = backgroundXML.@topFontSize;
            desc.bfs = backgroundXML.@bottomFontSize;
            desc.tfa = backgroundXML.@topFontAlignment;
            if(desc.tfa == "null")
            {
               desc.tfa = null;
            }
            desc.bfa = backgroundXML.@bottomFontAlignment;
            if(desc.bfa == "null")
            {
               desc.bfa = null;
            }
            materialOption = backgroundXML.@materialOption;
            materialName = backgroundXML.@material;
            materialXML = catalogXML.materialOptions.materialOption.(@name == materialOption).material.(@name == materialName)[0];
            if(materialXML != null)
            {
               matOptionXML = materialXML.parent();
               matOptionXML.@materialIndex = materialXML.childIndex();
               visibleMaterials[materialOption] = materialOption;
            }
         }
         matOptions = new Array();
         for each(matOptionName in visibleMaterials)
         {
            matSettings = new Object();
            matOptions.push(matSettings);
            matOption = catalogXML.materialOptions.materialOption.(@name == matOptionName)[0];
            matSettings.mo = matOption.childIndex();
            materialIndexStr = matOption.@materialIndex;
            materialIndex = 0;
            if(materialIndexStr != null && materialIndexStr.length > 0)
            {
               materialIndex = int(materialIndexStr);
            }
            material = matOption.material[materialIndex];
            materialName = material.@name;
            matSettings.m = materialIndex;
            matSettings.l = new Array();
            layers = material.layer;
            for each(layer in layers)
            {
               layerSettings = new Object();
               matSettings.l.push(layerSettings);
               layerName = layer.@name;
               layerSettings.n = layer.childIndex();
               textureIndex = int(layer.@textureIndex);
               if(layer.@lockTexture != "true")
               {
                  textureSymbolName = layer.texture[textureIndex].@symbol;
                  layerSettings.t = textureIndex;
               }
               texture = layer.texture[textureIndex];
               if(layer.@lockColor != "true")
               {
                  color = texture.@color;
                  if(color != null && color.length > 0)
                  {
                     colorOptionArray = materialLibrary.getColorTintOption(color);
                     if(colorOptionArray != null && colorOptionArray.length > 1)
                     {
                        colorIndex = uint(layer.@colorIndex);
                        tint = uint(colorOptionArray[colorIndex]);
                        layerSettings.c = colorIndex;
                     }
                  }
               }
               masksXML = texture.mask;
               if(masksXML != null && masksXML.length() > 0)
               {
                  grabMask = layer.@grabMask == "true";
                  if(!grabMask)
                  {
                     layerSettings.m = new ByteArray();
                     for each(mask in masksXML)
                     {
                        layerSettings.m.writeShort(maskNameToIndex(materialLibrary,mask.@mask));
                        layerSettings.m.writeShort(maskSelectionToIndex(materialLibrary,mask.@mask,mask.@maskSelection));
                     }
                     layerSettings.m.position = 0;
                  }
               }
            }
         }
         desc.m = matOptions;
         buddyAMF3 = new ByteArray();
         registerClassAlias("desc",BuddyDesc);
         buddyAMF3.writeObject(desc);
         buddyAMF3.position = 0;
         buddyAMF3.compress();
         buddyAMF3.position = 0;
         desc.dispose();
         return buddyAMF3;
      }
      
      private static function hash(param1:String) : int
      {
         var _loc2_:int = 0;
         var _loc3_:int = param1.length;
         var _loc4_:int = 0;
         while(_loc4_ < _loc3_)
         {
            _loc2_ = 31 * _loc2_ + int(param1.charCodeAt(_loc4_));
            _loc4_++;
         }
         return _loc2_;
      }
      
      private static function maskSelectionIndexToName(param1:MediaLibrary, param2:String, param3:int) : String
      {
         var _loc5_:Object = null;
         var _loc6_:Array = null;
         var _loc7_:uint = 0;
         var _loc4_:Array = param1.getMasks();
         for each(_loc5_ in _loc4_)
         {
            if(_loc5_.name == param2)
            {
               _loc6_ = _loc5_.mask;
               _loc7_ = _loc6_.length;
               if(param3 < _loc7_)
               {
                  return _loc6_[param3];
               }
            }
         }
         return null;
      }
   }
}

