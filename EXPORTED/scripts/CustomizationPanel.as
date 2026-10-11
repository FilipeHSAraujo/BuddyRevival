package
{
   import com.buddylabs.player.*;
   import fl.containers.ScrollPane;
   import fl.controls.*;
   import fl.events.*;
   import flash.display.*;
   import flash.events.*;
   import flash.geom.*;
   import flash.text.*;
   import flash.utils.*;
   
   public class CustomizationPanel extends Sprite
   {
      
      public static var tracker:Function;
      
      internal static var options:XML = <options>
    <option name="Head Color">
        <color path="Head;Material;Head;Head" id="hdc"/>
    </option>
    <option name="Body Color">
        <color path="Body;Material;Skin;Body" id="bdc"/>
    </option>
    <option name="Hair">
        <itemGroup path="Hair;HeadTop" id="hrt"/>
    </option>
    <option name="Hair Color">
        <color path="Hair;Material;Hair;Hair" id="hrc"/>
        <texture path="Hair;Material;HairPattern" id="hpt"/>
        <color path="Hair;Material;HairPatternColor;BlankClip" id="hpc"/>
    </option>
    <option name="Hair Streak">
        <texture path="Hair;Material;HairPattern2" id="hpt2"/>
        <color path="Hair;Material;HairPattern2Color;BlankClip" id="hpc2"/>
    </option>    
    <option name="Shaved Hair">
        <texture path="Hair_Shave;Material;Hair" id="hst"/>
        <color path="Hair_Shave;Material;HairColor;BlankClip" id="hsc"/>
    </option>
    <option name="Cap">
        <color path="BCap;Material;BCap;BCap" id="cpc"/>
        <color path="BCap;Material;BCapHair;BCap_Hair" id="chc"/>
        <texture path="BCap;Material;BCapPattern1" id="cp1"/>
        <color path="BCap;Material;BCapPatternColor1;BlankClip" id="cp2"/>
    </option>
    <option name="Cap 2">
        <texture path="BCap;Material;BCapPattern2" id="cp3"/>
        <color path="BCap;Material;BCapPatternColor2;BlankClip" id="cp4"/>
    </option>
    <option name="Eyes">
        <texture path="Head;Material;Eyes" id="eyt"/>
        <color path="Head;Material;EyesColor;BlankClip" id="eyc"/>
    </option>
    <option name="Eye Shadow">
        <texture path="Head;Material;EyeShadow" id="est"/>
        <color path="Head;Material;EyeShadowColor;BlankClip" id="esc"/>
    </option>
    <option name="Freckles">
        <texture path="Head;Material;Spot" id="spo"/>
        <color path="Head;Material;SpotColor;BlankClip" id="spr"/>
    </option>
    <option name="Mustache">
        <texture path="Head;Material;Mustache" id="mst"/>
        <texture path="Head;Material;Beard" id="mbt"/>
        <color path="Head;Material;BeardColor;BlankClip" id="mbc"/>
    </option>
    <option name="5 O'Clock">
        <texture path="Head;Material;5OClock" id="5ct"/>
    </option>
    <option name="Glasses">
        <texture path="Head;Material;Glas" id="glt"/>
        <color path="Head;Material;GlasColor;BlankClip" id="glc"/>
    </option>
    <option name="Mask">
        <texture path="Head;Material;Mask" id="mkt"/>
        <color path="Head;Material;MaskColor;BlankClip" id="mkc"/>
    </option>
    <option name="Shirt">
        <texture path="Body;Material;ShrtLength" id="sht"/>
        <color path="Body;Material;ShrtColor;BlankClip" id="shc"/>
        <texture path="Body;Material;ShrtLayer1" id="sl1t"/>
        <color path="Body;Material;ShrtLayer1Color;BlankClip" id="sl1c"/>
    </option>
    <option name="Shirt 2">
        <texture path="Body;Material;ShrtLayer2" id="sl2t"/>
        <color path="Body;Material;ShrtLayer2Color;BlankClip" id="sl2c"/>
    </option>
    <option name="Pants">
        <texture path="Body;Material;PantLength" id="plt"/>
        <color path="Body;Material;PantColor;BlankClip" id="plc"/>
        <texture path="Body;Material;PantPattern" id="ppt"/>
        <color path="Body;Material;PantPatternColor;BlankClip" id="ppc"/>
    </option>
    <option name="Pants 2">
        <texture path="Body;Material;PantPattern2" id="ppt2"/>
        <color path="Body;Material;PantPatternColor2;BlankClip" id="ppc2"/>
    </option>
    <option name="Skirt">
        <itemGroup path="Skrt;Skrt" id="ski"/>
    </option>
    <option name="Skirt 2">
        <color path="Skrt;Material;Skrt;Skrt_Solid" id="skc"/>
        <texture path="Skrt;Material;SkrtPattern" id="spt"/>
        <color path="Skrt;Material;SkrtPatternColor;BlankClip" id="spc"/>    
    </option>
    <option name="Skirt 3">
        <texture path="Skrt;Material;SkrtPattern2" id="spt2"/>
        <color path="Skrt;Material;SkrtPatternColor2;BlankClip" id="spc2"/>
    </option>    
    <option name="Belt">
        <texture path="Body;Material;Belt" id="blt"/>
        <color path="Body;Material;BeltColor;BlankClip" id="blc"/>
    </option>
    <option name="High Belt Pattern">
        <texture path="Body;Material;BeltRegPattern" id="hbp"/>
        <color path="Body;Material;BeltPatternColor;BlankClip" id="hbc"/>
    </option>
    <option name="Low Belt Pattern">
        <texture path="Body;Material;BeltLowPattern" id="lbp"/>
        <color path="Body;Material;BeltPatternColor;BlankClip" id="lbc"/>
    </option>
    <option name="Shoes">
        <texture path="Body;Material;Shoe" id="sst"/>
        <color path="Body;Material;ShoeColor;BlankClip" id="ssc"/>
        <texture path="Body;Material;ShoeSole" id="ss1"/>
        <color path="Body;Material;ShoeSoleColor;BlankClip" id="ss2"/>
    </option>
    <option name="Sling Pattern">
        <texture path="Body;Material;ShoeSlingDesign" id="sd1"/>
        <color path="Body;Material;ShoeSlingDesignColor;BlankClip" id="sd2"/>
    </option>    
    <option name="Shoe Pattern">
        <texture path="Body;Material;ShoeRegDesign" id="sd3"/>
        <color path="Body;Material;ShoeRegDesignColor;BlankClip" id="sd4"/>
        <texture path="Body;Material;ShoeRegLaces" id="sh1"/>
        <color path="Body;Material;ShoeRegLacesColor;BlankClip" id="sh2"/>
    </option>
    <option name="Boot Pattern">
        <texture path="Body;Material;ShoeBootDesign" id="sd5"/>
        <color path="Body;Material;ShoeBootDesignColor;BlankClip" id="sd6"/>
        <texture path="Body;Material;ShoeBootLaces" id="sh3"/>
        <color path="Body;Material;ShoeBootLacesColor;BlankClip" id="sh4"/>
    </option>
    <option name="Socks">
        <texture path="Body;Material;SockLength" id="sot"/>
        <color path="Body;Material;SockColor;BlankClip" id="soc"/>
        <texture path="Body;Material;SockPattern" id="sopt"/>
        <color path="Body;Material;SockPatternColor;BlankClip" id="sopc"/>
    </option>
    <option name="Gloves">
        <texture path="Body;Material;Glve" id="glvt"/>
        <color path="Body;Material;GlveColor;BlankClip" id="glvc"/>
    </option>
    <option name="Guitar">
        <color path="Strt;Material;Solid;Strt_Solid" id="gr1"/>
        <color path="Strt;Material;PickGuard;Strt_PickGuard" id="gr2"/>
    </option>
</options>;
      
      private var buddy:SceneObject;
      
      private var animSet:* = {
         "pose_contra":{
            "pose_contra":[0,0.1],
            "pose_contra_attention":[0.1,0.24],
            "pose_contra_lookFeet":[0.24,0.4],
            "pose_contra_shift":[0.4,0.52],
            "pose_contra_bow":[0.52,62],
            "pose_contra_canCan":[0.62,0.72],
            "pose_contra_toStand":[0.72,1]
         },
         "pose_contra_attention":{"pose_contra":[0,1]},
         "pose_contra_lookFeet":{"pose_contra":[0,1]},
         "pose_contra_shift":{"pose_contra":[0,1]},
         "pose_contra_toStand":{"pose_stand":[0,1]},
         "pose_contra_bow":{"pose_contra":[0,1]},
         "pose_contra_canCan":{"pose_contra":[0,1]},
         "pose_stand":{
            "pose_stand":[0,0.1],
            "pose_stand_lookAround":[0.1,0.333],
            "pose_stand_model":[0.333,0.566],
            "pose_stand_stretch":[0.566,0.8],
            "pose_stand_toContra":[0.8,1]
         },
         "pose_stand_lookAround":{"pose_stand":[0,1]},
         "pose_stand_model":{"pose_stand":[0,1]},
         "pose_stand_stretch":{"pose_stand":[0,1]},
         "pose_stand_toContra":{"pose_contra":[0,1]}
      };
      
      private var currentTrack:String = "pose_contra";
      
      internal var layerDependencies:* = {
         "sst":function(param1:int):void
         {
            if(param1 != 1 && param1 != 2 && param1 != 3)
            {
               resetLayers(["sd1"]);
            }
            if(param1 != 4)
            {
               resetLayers(["sd3","sh1"]);
            }
            if(param1 != 5)
            {
               resetLayers(["sd5","sh3"]);
            }
         },
         "blt":function(param1:int):void
         {
            if(param1 != 1 && param1 != 2 && param1 != 3)
            {
               resetLayers(["hbp"]);
            }
            if(param1 != 4 && param1 != 5 && param1 != 6)
            {
               resetLayers(["lbp"]);
            }
         }
      };
      
      private var aSp:ScrollPane = new ScrollPane();
      
      private var columnCount:int = 3;
      
      private var optionHolders:Array;
      
      private var opIdToComp:Dictionary;
      
      internal var dependencies:* = {
         "Hair Color":function():Boolean
         {
            var _loc1_:* = idSelection["hrt"];
            if(_loc1_ == 31)
            {
               return false;
            }
            return _loc1_ > 3;
         },
         "Hair Streak":function():Boolean
         {
            var _loc1_:* = idSelection["hrt"];
            if(_loc1_ == 31)
            {
               return false;
            }
            return _loc1_ > 3;
         },
         "Shaved Hair":function():Boolean
         {
            return idSelection["hrt"] == 31;
         },
         "Cap":function():Boolean
         {
            var _loc1_:* = idSelection["hrt"];
            return _loc1_ >= 0 && _loc1_ <= 3;
         },
         "Cap 2":function():Boolean
         {
            var _loc1_:* = idSelection["hrt"];
            return _loc1_ >= 0 && _loc1_ <= 3;
         },
         "High Belt Pattern":function():Boolean
         {
            var _loc1_:* = idSelection["blt"];
            return _loc1_ >= 1 && _loc1_ <= 3;
         },
         "Low Belt Pattern":function():Boolean
         {
            var _loc1_:* = idSelection["blt"];
            return _loc1_ >= 4 && _loc1_ <= 6;
         },
         "Sling Pattern":function():Boolean
         {
            var _loc1_:* = idSelection["sst"];
            return _loc1_ >= 0 && _loc1_ <= 3;
         },
         "Shoe Pattern":function():Boolean
         {
            var _loc1_:* = idSelection["sst"];
            return _loc1_ == 4;
         },
         "Boot Pattern":function():Boolean
         {
            var _loc1_:* = idSelection["sst"];
            return _loc1_ == 5;
         },
         "Skirt 2":function():Boolean
         {
            var _loc1_:* = idSelection["ski"];
            return _loc1_ >= 1;
         },
         "Skirt 3":function():Boolean
         {
            var _loc1_:* = idSelection["ski"];
            return _loc1_ >= 1;
         }
      };
      
      private var holder:Sprite = new Sprite();
      
      private var idSelection:Dictionary;
      
      private var optionToComp:Dictionary;
      
      public function CustomizationPanel(param1:int, param2:int, param3:int, param4:int, param5:int = 4)
      {
         testNameCollisions();
         super();
         this.x = param1;
         this.y = param2;
         var _loc6_:int = param3;
         var _loc7_:int = param4;
         this.columnCount = param5;
         var _loc8_:Sprite = new Sprite();
         _loc8_.graphics.lineStyle(1,13421772,0.5);
         _loc8_.graphics.beginFill(16777215,0.5);
         _loc8_.graphics.drawRect(0,0,_loc6_,_loc7_);
         _loc8_.graphics.endFill();
         aSp.setSize(_loc6_ - 10,_loc7_ - 10);
         aSp.move(5,5);
         aSp.verticalScrollPolicy = ScrollPolicy.ON;
         aSp.horizontalScrollPolicy = ScrollPolicy.OFF;
         _loc8_.addChild(aSp);
         this.addChild(_loc8_);
      }
      
      public static function testCollision(param1:Dictionary, param2:XMLList) : void
      {
         var _loc3_:XML = null;
         var _loc4_:String = null;
         var _loc5_:String = null;
         var _loc6_:int = 0;
         for each(_loc3_ in param2)
         {
            _loc4_ = _loc3_.@id;
            _loc5_ = param1[_loc4_];
            if(_loc5_ != null)
            {
               trace("collision " + _loc3_.@path + " " + _loc4_);
               _loc6_ = 0;
            }
            else
            {
               param1[_loc4_] = _loc4_;
            }
         }
      }
      
      public static function testNameCollisions() : void
      {
         var _loc1_:Dictionary = new Dictionary();
         testCollision(_loc1_,options.option.texture);
         testCollision(_loc1_,options.option.color);
         testCollision(_loc1_,options.option.item);
         testCollision(_loc1_,options.option.itemGroup);
      }
      
      private function resetLayers(param1:Array) : void
      {
         var opId:String = null;
         var catalogXML:XML = null;
         var subop:XML = null;
         var path:String = null;
         var pathA:Array = null;
         var layer:XML = null;
         var opIds:Array = param1;
         if(opIds == null)
         {
            return;
         }
         for each(opId in opIds)
         {
            catalogXML = buddy.catalogXML;
            idSelection[opId] = 0;
            opIdToComp[opId].selectedColor = 0;
            subop = options.option..texture.(@id == opId)[0];
            path = subop.@path;
            pathA = path.split(";");
            layer = catalogXML.materialOptions[0].materialOption.(@name == pathA[0]).material.(@name = pathA[1]).layer.(@name == pathA[2])[0];
            if(layer != null)
            {
               layer.@textureIndex = 0;
            }
         }
      }
      
      internal function initAnim(param1:SceneObject) : void
      {
         var _loc3_:String = null;
         var _loc4_:Anim = null;
         var _loc2_:Dictionary = param1.animationsDictionary;
         if(_loc2_ != null)
         {
            for(_loc3_ in animSet)
            {
               _loc4_ = _loc2_[_loc3_];
               if(_loc4_ != null)
               {
                  _loc4_.loop = false;
               }
            }
         }
         this.buddy = param1;
         currentTrack = "pose_contra";
         param1.selectedAnim = currentTrack;
      }
      
      private function onSelectItemHandler(param1:TexturePickerEvent) : void
      {
         var _loc2_:BTexturePicker = BTexturePicker(param1.target);
         var _loc3_:XML = _loc2_.data;
         var _loc4_:uint = _loc2_.selectedColor;
         idSelection[_loc2_.name] = _loc4_;
         _loc3_.@visible = _loc4_ == 1 ? "true" : "false";
         buddy.player.updateTextures(buddy.catalogXML,buddy.materialLibrary);
         buddy.player.setVisibleGeometry(buddy.catalogXML);
         updateVisibleOptions();
         if(tracker != null && _loc2_.trackName != null)
         {
            tracker(_loc2_.trackName + "/" + _loc4_);
         }
      }
      
      private function onChangeTextureHandler(param1:TexturePickerEvent) : void
      {
         var _loc2_:BTexturePicker = BTexturePicker(param1.target);
         var _loc3_:XML = _loc2_.data;
         var _loc4_:uint = _loc2_.selectedColor;
         idSelection[_loc2_.name] = _loc4_;
         var _loc5_:Function = layerDependencies[_loc2_.name];
         if(_loc5_ != null)
         {
            _loc5_(_loc4_);
         }
         _loc3_.@textureIndex = _loc4_ & 0xFFFFFF;
         buddy.player.updateTextures(buddy.catalogXML,buddy.materialLibrary);
         updateVisibleOptions();
         if(tracker != null && _loc2_.trackName != null)
         {
            tracker(_loc2_.trackName + "/" + _loc4_);
         }
      }
      
      internal function loadOptions(param1:SceneObject) : void
      {
         var y:int;
         var matlib:MediaLibrary;
         var ops:XMLList;
         var swatchx:int;
         var catalogXML:XML;
         var anop:XML = null;
         var name:String = null;
         var depends:String = null;
         var showOp:Boolean = false;
         var optionHolder:Sprite = null;
         var label:Label = null;
         var kids:XMLList = null;
         var offsetx:int = 0;
         var xIndex:int = 0;
         var subop:XML = null;
         var asd:* = undefined;
         var opId:String = null;
         var type:String = null;
         var path:String = null;
         var pathA:Array = null;
         var texture:XML = null;
         var layer:XML = null;
         var color:String = null;
         var colorOptionArray:Array = null;
         var colorIndex:uint = 0;
         var tint:int = 0;
         var aCp:BColorPicker = null;
         var colors:Array = null;
         var c:uint = 0;
         var textureIndex:int = 0;
         var textures:XMLList = null;
         var numTextures:int = 0;
         var options:Array = null;
         var bmps:Array = null;
         var i:int = 0;
         var tp:BTexturePicker = null;
         var sym:String = null;
         var item:XML = null;
         var visible:Boolean = false;
         var itemCategory:XML = null;
         var group:XML = null;
         var itemName:String = null;
         var itemCategoryName:String = null;
         var groupName:String = null;
         var bmpVisible:Bitmap = null;
         var bmpHidden:Bitmap = null;
         var items:XMLList = null;
         var numOptions:int = 0;
         var selected:int = 0;
         var vis:String = null;
         var buddy:SceneObject = param1;
         this.buddy = buddy;
         catalogXML = buddy.catalogXML;
         ops = CustomizationPanel.options.option;
         matlib = buddy.materialLibrary;
         y = 15;
         swatchx = 100;
         opIdToComp = new Dictionary();
         optionToComp = new Dictionary();
         idSelection = new Dictionary();
         optionHolders = new Array();
         for each(anop in ops)
         {
            name = anop.@name;
            depends = anop.@depends;
            showOp = true;
            if(depends != null && depends.length > 0)
            {
               showOp = Boolean(dependencies[depends]());
               asd = 0;
            }
            optionHolder = new Sprite();
            optionHolder.y = y;
            optionHolder.name = name;
            label = new Label();
            label.htmlText = "<font face=\'Arial\' color=\'#222222\' size=\'12px\'>" + MessageBundle.msg(name) + "</font>";
            label.x = 10;
            label.textField.autoSize = TextFieldAutoSize.LEFT;
            optionHolder.addChild(label);
            optionToComp[name] = [label];
            kids = anop.children();
            offsetx = 0;
            xIndex = 0;
            for each(subop in kids)
            {
               opId = subop.@id;
               type = subop.name();
               path = subop.@path;
               pathA = path.split(";");
               if("color" == type)
               {
                  texture = catalogXML.materialOptions[0].materialOption.(@name == pathA[0]).material.(@name = pathA[1]).layer.(@name == pathA[2]).texture.(@symbol == pathA[3])[0];
                  if(texture != null)
                  {
                     layer = texture.parent();
                     color = texture.@color;
                     if(color != null && color.length > 0)
                     {
                        colorOptionArray = buddy.materialLibrary.getColorTintOption(color);
                        if(colorOptionArray != null && colorOptionArray.length > 1)
                        {
                           layer.@colorIndex = texture.@colorSelection;
                           colorIndex = uint(layer.@colorIndex);
                           if(!isNaN(colorIndex))
                           {
                              tint = int(colorOptionArray[colorIndex]);
                           }
                           aCp = new BColorPicker(texture,name + "/" + path);
                           opIdToComp[opId] = aCp;
                           aCp.name = opId;
                           colors = new Array();
                           for each(c in colorOptionArray)
                           {
                              colors.push(c & 0xFFFFFF);
                           }
                           aCp.colors = colors;
                           aCp.x = swatchx + offsetx;
                           aCp.y = -4;
                           optionHolder.addChild(aCp);
                           aCp.selectedColor = tint & 0xFFFFFF;
                           aCp.addEventListener(ColorPickerEvent.CHANGE,onChangeColorHandler);
                           optionToComp[name].push(aCp);
                           aCp.setSharedStyle("columnCount",9);
                           aCp.setSharedStyle("swatchWidth",12);
                           aCp.setSharedStyle("swatchHeight",12);
                        }
                     }
                  }
               }
               else if("texture" == type)
               {
                  layer = catalogXML.materialOptions[0].materialOption.(@name == pathA[0]).material.(@name = pathA[1]).layer.(@name == pathA[2])[0];
                  if(layer != null)
                  {
                     textureIndex = int(layer.@textureIndex);
                     if(isNaN(textureIndex))
                     {
                        textureIndex = 0;
                     }
                     textures = layer.children();
                     numTextures = int(textures.length());
                     options = new Array();
                     bmps = new Array();
                     i = 0;
                     while(i < numTextures)
                     {
                        options[i] = i;
                        sym = textures[i].@symbol;
                        bmps[i] = cacheToBitmap(matlib.getSymbol("Icon_" + sym),36,36);
                        i++;
                     }
                     tp = new BTexturePicker(layer,name + "/" + path);
                     opIdToComp[opId] = tp;
                     tp.name = opId;
                     tp.bitmaps = bmps;
                     idSelection[opId] = textureIndex;
                     tp.selectedColor = textureIndex;
                     tp.x = swatchx + offsetx;
                     tp.y = -4;
                     optionHolder.addChild(tp);
                     tp.addEventListener(TexturePickerEvent.CHANGE,onChangeTextureHandler);
                     tp.setSharedStyle("columnCount",xIndex == 0 ? 4 : columnCount);
                     optionToComp[name].push(tp);
                  }
               }
               else if("item" == type)
               {
                  item = catalogXML.group[0].categories[0].itemCategory.(@name == pathA[0]).item.(@name == pathA[1])[0];
                  visible = "true" == item.@visible;
                  tp = new BTexturePicker(item,name + "/" + path);
                  opIdToComp[opId] = tp;
                  tp.name = opId;
                  itemCategory = item.parent();
                  group = itemCategory.parent().parent();
                  itemName = item.@name;
                  itemCategoryName = itemCategory.@name;
                  groupName = group.@name;
                  bmpVisible = cacheToBitmap(matlib.getSymbol(groupName + "_" + itemCategoryName + "_" + itemName),36,36);
                  bmpHidden = cacheToBitmap(matlib.getSymbol("Icon_BlankClip"),36,36);
                  tp.bitmaps = [bmpHidden,bmpVisible];
                  idSelection[opId] = visible ? 1 : 0;
                  tp.selectedColor = visible ? 1 : 0;
                  tp.x = swatchx + offsetx;
                  tp.y = -4;
                  optionHolder.addChild(tp);
                  tp.addEventListener(TexturePickerEvent.CHANGE,onSelectItemHandler);
                  tp.setSharedStyle("columnCount",xIndex == 0 ? 4 : columnCount);
                  optionToComp[name].push(tp);
               }
               else if("itemGroup" == type)
               {
                  items = catalogXML.group[0].categories[0].itemCategory.(@name == pathA[0]).item.(hasOwnProperty("@visGroup")).(@visGroup == pathA[1]);
                  numOptions = int(items.length());
                  bmps = new Array();
                  selected = 0;
                  i = 0;
                  while(i < numOptions)
                  {
                     item = items[i];
                     itemCategory = item.parent();
                     group = itemCategory.parent().parent();
                     itemName = item.@name;
                     itemCategoryName = itemCategory.@name;
                     groupName = group.@name;
                     bmps[i] = cacheToBitmap(matlib.getSymbol(groupName + "_" + itemCategoryName + "_" + itemName),36,36);
                     vis = items[i].@visible;
                     if("true" == vis)
                     {
                        selected = i;
                     }
                     i++;
                  }
                  tp = new BTexturePicker(items,name + "/" + path);
                  opIdToComp[opId] = tp;
                  tp.name = opId;
                  tp.setSharedStyle("columnCount",xIndex == 0 ? 4 : columnCount);
                  tp.bitmaps = bmps;
                  tp.selectedColor = selected;
                  idSelection[opId] = selected;
                  tp.x = swatchx + offsetx;
                  tp.y = -4;
                  optionHolder.addChild(tp);
                  tp.addEventListener(TexturePickerEvent.CHANGE,onSelectItemGroupHandler);
                  optionToComp[name].push(tp);
               }
               offsetx += 28;
               xIndex++;
            }
            optionHolders.push(optionHolder);
         }
         updateVisibleOptions();
         aSp.source = holder;
      }
      
      private function onSelectItemGroupHandler(param1:TexturePickerEvent) : void
      {
         var _loc2_:BTexturePicker = BTexturePicker(param1.target);
         var _loc3_:XMLList = _loc2_.data;
         var _loc4_:uint = _loc2_.selectedColor;
         var _loc5_:int = int(_loc3_.length());
         idSelection[_loc2_.name] = _loc4_;
         var _loc6_:int = 0;
         while(_loc6_ < _loc5_)
         {
            _loc3_[_loc6_].@visible = _loc4_ == _loc6_ ? "true" : "false";
            _loc6_++;
         }
         buddy.player.updateTextures(buddy.catalogXML,buddy.materialLibrary);
         buddy.player.setVisibleGeometry(buddy.catalogXML);
         updateVisibleOptions();
         if(tracker != null && _loc2_.trackName != null)
         {
            tracker(_loc2_.trackName + "/" + _loc4_);
         }
      }
      
      private function updateVisibleOptions() : void
      {
         var _loc2_:Sprite = null;
         var _loc3_:Rectangle = null;
         var _loc4_:String = null;
         holder.graphics.clear();
         var _loc1_:int = 15;
         for each(_loc2_ in optionHolders)
         {
            _loc4_ = _loc2_.name;
            if(dependencies[_loc4_] == null || Boolean(dependencies[_loc4_]()))
            {
               _loc2_.y = _loc1_;
               _loc1_ += 30;
               if(!holder.contains(_loc2_))
               {
                  holder.addChild(_loc2_);
               }
            }
            else if(holder.contains(_loc2_))
            {
               holder.removeChild(_loc2_);
            }
         }
         _loc3_ = holder.getBounds(holder);
         holder.graphics.beginFill(16777215,0);
         holder.graphics.drawRect(0,0,192,_loc3_.height + 25);
         holder.graphics.endFill();
         aSp.source = holder;
      }
      
      private function onChangeColorHandler(param1:Event) : void
      {
         var _loc2_:BColorPicker = BColorPicker(param1.target);
         var _loc3_:XML = _loc2_.data;
         var _loc4_:uint = _loc2_.selectedColor;
         var _loc5_:Array = _loc2_.colors;
         var _loc6_:int = 0;
         var _loc7_:int = int(_loc5_.length);
         var _loc8_:int = 0;
         while(_loc8_ < _loc7_)
         {
            if((_loc5_[_loc8_] & 0xFFFFFF) == (_loc4_ & 0xFFFFFF))
            {
               _loc6_ = _loc8_;
               break;
            }
            _loc8_++;
         }
         idSelection[_loc2_.name] = _loc6_;
         var _loc9_:XML = _loc3_.parent();
         if(_loc9_ != null)
         {
            _loc9_.@colorIndex = _loc6_;
            _loc3_.@colorSelection = _loc6_;
            buddy.player.updateTextures(buddy.catalogXML,buddy.materialLibrary);
         }
         updateVisibleOptions();
         if(tracker != null && _loc2_.trackName != null)
         {
            tracker(_loc2_.trackName + "/" + _loc6_);
         }
      }
      
      internal function updateAnim(param1:SceneObject) : void
      {
         var _loc3_:* = undefined;
         var _loc4_:Number = NaN;
         var _loc5_:Number = NaN;
         var _loc6_:String = null;
         var _loc7_:Number = NaN;
         var _loc8_:Number = NaN;
         this.buddy = param1;
         if(param1.animation == null)
         {
            return;
         }
         var _loc2_:Boolean = param1.animation.step(param1.player.context,true);
         if(_loc2_ == false)
         {
            param1.animation.reset();
            _loc3_ = animSet[currentTrack];
            _loc4_ = Math.random();
            _loc5_ = Math.random();
            for(_loc6_ in _loc3_)
            {
               _loc7_ = Number(_loc3_[_loc6_][0]);
               _loc8_ = Number(_loc3_[_loc6_][1]);
               if(_loc5_ + 0.001 >= _loc7_ && _loc5_ - 0.001 <= _loc8_)
               {
                  trace("switch to " + _loc6_);
                  currentTrack = _loc6_;
                  param1.selectedAnim = currentTrack;
                  break;
               }
            }
            param1.animation.reset();
         }
         param1.animation.step(param1.player.context,true);
      }
      
      private function cacheToBitmap(param1:DisplayObject, param2:int, param3:int) : Bitmap
      {
         var _loc4_:BitmapData = new BitmapData(param2,param3,false,16777215);
         var _loc5_:Matrix = new Matrix();
         _loc5_.translate(param2 * 0.5,param3 * 0.5);
         if(param1 != null)
         {
            _loc4_.draw(param1,_loc5_);
         }
         return new Bitmap(_loc4_);
      }
   }
}

