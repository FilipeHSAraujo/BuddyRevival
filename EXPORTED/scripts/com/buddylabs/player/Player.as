package com.buddylabs.player
{
   import flash.display.Graphics;
   import flash.display.Stage;
   import flash.events.*;
   import flash.net.registerClassAlias;
   import flash.text.TextField;
   import flash.text.TextFieldAutoSize;
   import flash.utils.Dictionary;
   
   public class Player implements IEventDispatcher
   {
      
      public static var LOAD_STANDARD_TEXTURES:Boolean = false;
      
      private var LOADING_TEXTURES:int = 1;
      
      private var lastTime:Array = new Array(100);
      
      public var loaded:Boolean;
      
      public var fpsLabel:TextField = new TextField();
      
      public var scene:Scene;
      
      private var buddyConfigMedia:MediaObject = null;
      
      private var modelLoader:MediaObject = new MediaObject();
      
      private var LOADING_MODEL:int = 0;
      
      private var dispatcher:EventDispatcher;
      
      public var context:Context = new Context();
      
      private var loadingState:int = LOADING_MODEL;
      
      protected var tracker:MediaTracker = new MediaTracker();
      
      private var frameNum:int = 0;
      
      private var frameRate:String;
      
      private var stage:Stage;
      
      protected var showFrameRate:Boolean = true;
      
      public function Player(param1:Stage, param2:int, param3:int)
      {
         super();
         this.stage = param1;
         loaded = false;
         dispatcher = new EventDispatcher(this);
         context.init(param2,param3);
      }
      
      public function willTrigger(param1:String) : Boolean
      {
         return dispatcher.willTrigger(param1);
      }
      
      public function showGeometry(param1:Array) : void
      {
         var _loc4_:String = null;
         var _loc5_:BaseObj = null;
         if(scene == null || scene.nodeMap == null || param1 == null)
         {
            return;
         }
         var _loc2_:int = int(param1.length);
         var _loc3_:int = 0;
         while(_loc3_ < _loc2_)
         {
            _loc4_ = param1[_loc3_];
            _loc5_ = BaseObj(scene.nodeMap[_loc4_]);
            if(_loc5_ != null && _loc5_ is Node)
            {
               Node(_loc5_).visible = true;
            }
            _loc3_++;
         }
      }
      
      public function hideAllGeometry() : void
      {
         var _loc2_:BaseObj = null;
         var _loc1_:Dictionary = scene.nodeMap;
         if(_loc1_ == null)
         {
            return;
         }
         for each(_loc2_ in _loc1_)
         {
            if(_loc2_ is Node)
            {
               Node(_loc2_).visible = false;
            }
         }
      }
      
      public function cullByName(param1:String) : void
      {
         if(scene == null)
         {
            return;
         }
         scene.cullByName(param1);
      }
      
      public function initItemTextures(param1:XML, param2:MediaLibrary, param3:XML) : void
      {
         updateTexturesInternal(param1,param2,param3);
      }
      
      public function loadMedia(param1:String, param2:MediaObject) : void
      {
         loadObject(param1,param2.object);
      }
      
      public function dispose() : void
      {
         stage = null;
         if(buddyConfigMedia != null)
         {
            buddyConfigMedia.dispose();
         }
         buddyConfigMedia = null;
         if(modelLoader != null)
         {
            modelLoader.dispose();
         }
         modelLoader = null;
         if(tracker != null)
         {
            tracker.dispose();
         }
         tracker = null;
         GCUtil.disposeArray(lastTime,false);
         lastTime = null;
         fpsLabel = null;
         frameRate = null;
         scene = null;
         dispatcher = null;
         if(context != null)
         {
            context.dispose();
         }
         context = null;
      }
      
      private function updateTexturesInternal(param1:XML, param2:MediaLibrary, param3:XML = null) : void
      {
         var item:XML = null;
         var create:Boolean = false;
         var alwaysVisible:Boolean = false;
         var visible:Boolean = false;
         var prop:Boolean = false;
         var hashOnly:Boolean = false;
         var materialName:String = null;
         var matOptions:XMLList = null;
         var matOption:XML = null;
         var shared:Boolean = false;
         var indexStr:String = null;
         var numMaterials:int = 0;
         var index:int = 0;
         var material:XML = null;
         var catalogXML:XML = param1;
         var materialLibrary:MediaLibrary = param2;
         var specificItem:XML = param3;
         var materialHash:Dictionary = new Dictionary();
         var items:XMLList = catalogXML.group.categories.itemCategory.item;
         var catMaterialOptions:XMLList = catalogXML.materialOptions.materialOption;
         for each(item in items)
         {
            create = false;
            alwaysVisible = item.@alwaysVis == "true";
            visible = item.@visible == "true";
            if(alwaysVisible)
            {
               create = true;
            }
            else if(visible)
            {
               create = true;
            }
            prop = item.@prop == "true";
            hashOnly = false;
            if(specificItem != null)
            {
               if(item != specificItem)
               {
                  hashOnly = true;
               }
            }
            if(create)
            {
               materialName = item.@mat;
               matOptions = catMaterialOptions.(@name == materialName);
               if(matOptions != null && matOptions.length() > 0)
               {
                  matOption = matOptions[0];
                  shared = matOption.@shared.toString() == "true";
                  indexStr = matOption.@materialIndex;
                  numMaterials = int(matOption.material.length());
                  index = int(indexStr);
                  if(isNaN(index) || index >= numMaterials)
                  {
                     index = 0;
                     matOption.@materialIndex = 0;
                  }
                  material = matOption.material[index];
                  if(material != null)
                  {
                     if(item.hasOwnProperty("@geo1"))
                     {
                        applyTexture(item.@geo1,materialHash,materialLibrary,materialName,material,item.@lightmap1,shared,hashOnly,prop);
                     }
                     if(item.hasOwnProperty("@geo2"))
                     {
                        applyTexture(item.@geo2,materialHash,materialLibrary,materialName,material,item.@lightmap2,shared,hashOnly,prop);
                     }
                     if(item.hasOwnProperty("@geo3"))
                     {
                        applyTexture(item.@geo3,materialHash,materialLibrary,materialName,material,item.@lightmap3,shared,hashOnly,prop);
                     }
                     if(item.hasOwnProperty("@geo4"))
                     {
                        applyTexture(item.@geo4,materialHash,materialLibrary,materialName,material,item.@lightmap4,shared,hashOnly,prop);
                     }
                  }
               }
            }
         }
         materialHash = null;
      }
      
      public function updateTextures(param1:XML, param2:MediaLibrary) : void
      {
         updateTexturesInternal(param1,param2);
      }
      
      private function hideCullingGroup(param1:XMLList, param2:String) : void
      {
         var cull:XMLList;
         var len:int = 0;
         var c:int = 0;
         var cullGroups:XMLList = param1;
         var groupName:String = param2;
         if(groupName == null || groupName.length < 1)
         {
            return;
         }
         cull = cullGroups.(@name == groupName).region;
         if(cull != null)
         {
            len = int(cull.length());
            c = 0;
            while(c < len)
            {
               cullByName(cull[c].@name);
               c++;
            }
         }
      }
      
      private function onLoadingProgress(param1:ProgressEvent) : void
      {
      }
      
      public function createEmpty() : void
      {
         scene = new Scene();
         scene.children = [];
         scene.nodeMap = new Dictionary();
         context.initScene(scene);
         loaded = true;
      }
      
      public function dispatchEvent(param1:Event) : Boolean
      {
         return dispatcher.dispatchEvent(param1);
      }
      
      public function setVisibleGeometry(param1:XML, param2:Boolean = false) : void
      {
         var sliderSet:XMLList;
         var catCullGroups:*;
         var i:int;
         var visible:Array;
         var catCullOptions:*;
         var numItems:int;
         var anItem:XML = null;
         var optionname:String = null;
         var cullvalue:XMLList = null;
         var catalogXML:XML = param1;
         var hideProps:Boolean = param2;
         var vItems:XMLList = catalogXML.group.categories.itemCategory.item;
         if(vItems.length() == 0)
         {
            return;
         }
         hideAllGeometry();
         resetCulling();
         catCullOptions = catalogXML..cullOption;
         catCullGroups = catalogXML..cullGroup;
         numItems = int(vItems.length());
         visible = new Array();
         i = 0;
         while(i < numItems)
         {
            anItem = vItems[i];
            if(anItem.@visible == "true" || anItem.@alwaysVis == "true")
            {
               if(anItem.hasOwnProperty("@geo1"))
               {
                  visible.push(anItem.@geo1);
               }
               if(anItem.hasOwnProperty("@geo2"))
               {
                  visible.push(anItem.@geo2);
               }
               if(anItem.hasOwnProperty("@geo3"))
               {
                  visible.push(anItem.@geo3);
               }
               if(anItem.hasOwnProperty("@geo4"))
               {
                  visible.push(anItem.@geo4);
               }
               if(anItem.hasOwnProperty("@cull1"))
               {
                  hideCullingGroup(catCullGroups,anItem.@cull1);
               }
               if(anItem.hasOwnProperty("@cull2"))
               {
                  hideCullingGroup(catCullGroups,anItem.@cull2);
               }
               if(anItem.hasOwnProperty("@cull3"))
               {
                  hideCullingGroup(catCullGroups,anItem.@cull3);
               }
               if(anItem.hasOwnProperty("@cullOption1"))
               {
                  optionname = anItem.@cullOption1;
                  cullvalue = catCullOptions.(@name == optionname).cullvalue.(@isDefault == "true");
                  if(cullvalue.length() > 0)
                  {
                     hideCullingGroup(catCullGroups,cullvalue[0].@cullGroup);
                  }
               }
               if(anItem.hasOwnProperty("@cullOption2"))
               {
                  optionname = anItem.@cullOption2;
                  cullvalue = catCullOptions.(@name == optionname).cullvalue.(@isDefault == "true");
                  if(cullvalue.length() > 0)
                  {
                     hideCullingGroup(catCullGroups,cullvalue[0].@cullGroup);
                  }
               }
               if(anItem.hasOwnProperty("@cullOption3"))
               {
                  optionname = anItem.@cullOption3;
                  cullvalue = catCullOptions.(@name == optionname).cullvalue.(@isDefault == "true");
                  if(cullvalue.length() > 0)
                  {
                     hideCullingGroup(catCullGroups,cullvalue[0].@cullGroup);
                  }
               }
            }
            if(anItem.@forceCulling == "true")
            {
               if(anItem.hasOwnProperty("@cull1"))
               {
                  hideCullingGroup(catCullGroups,anItem.@cull1);
               }
               if(anItem.hasOwnProperty("@cull2"))
               {
                  hideCullingGroup(catCullGroups,anItem.@cull2);
               }
               if(anItem.hasOwnProperty("@cull3"))
               {
                  hideCullingGroup(catCullGroups,anItem.@cull3);
               }
               if(anItem.hasOwnProperty("@cullOption1"))
               {
                  optionname = anItem.@cullOption1;
                  cullvalue = catCullOptions.(@name == optionname).cullvalue.(@isDefault == "true");
                  if(cullvalue.length() > 0)
                  {
                     hideCullingGroup(catCullGroups,cullvalue[0].@cullGroup);
                  }
               }
               if(anItem.hasOwnProperty("@cullOption2"))
               {
                  optionname = anItem.@cullOption2;
                  cullvalue = catCullOptions.(@name == optionname).cullvalue.(@isDefault == "true");
                  if(cullvalue.length() > 0)
                  {
                     hideCullingGroup(catCullGroups,cullvalue[0].@cullGroup);
                  }
               }
               if(anItem.hasOwnProperty("@cullOption3"))
               {
                  optionname = anItem.@cullOption3;
                  cullvalue = catCullOptions.(@name == optionname).cullvalue.(@isDefault == "true");
                  if(cullvalue.length() > 0)
                  {
                     hideCullingGroup(catCullGroups,cullvalue[0].@cullGroup);
                  }
               }
            }
            i++;
         }
         sliderSet = catalogXML.sliderSet;
         if(sliderSet.length() > 0)
         {
            SceneUtil.setSliders(sliderSet[0].slider,scene);
         }
         showGeometry(visible);
         if(hideProps)
         {
            scene.hideProps();
         }
      }
      
      protected function onLoaded(param1:Event) : void
      {
         if(loadingState == LOADING_MODEL)
         {
            if(modelLoader.object == null)
            {
               return;
            }
            trace("onLoaded");
            scene = Scene(modelLoader.object);
            scene.nodeMap = new Dictionary();
            tracker.removeEventListener(Event.COMPLETE,onLoaded);
            tracker.removeEventListener(ProgressEvent.PROGRESS,onLoadingProgress);
            tracker.clearAll();
            if(buddyConfigMedia != null)
            {
               scene.config = BinBuddy(buddyConfigMedia.object);
               scene.config.init();
            }
            context.initScene(scene);
            fpsLabel.visible = false;
            fpsLabel.autoSize = TextFieldAutoSize.LEFT;
            fpsLabel.background = true;
            fpsLabel.border = true;
            if(LOAD_STANDARD_TEXTURES)
            {
               loadingState = LOADING_TEXTURES;
               context.imageTracker.addEventListener(Event.COMPLETE,onLoaded);
               context.imageTracker.addEventListener(ProgressEvent.PROGRESS,onLoadingProgress);
               context.imageTracker.checkAll(true);
            }
            this.dispatchEvent(new PlayerEvent(PlayerEvent.GEOMETRY_LOADED,false,false));
            loaded = true;
         }
         else if(loadingState == LOADING_TEXTURES)
         {
            context.imageTracker.removeEventListener(Event.COMPLETE,onLoaded);
            context.imageTracker.removeEventListener(ProgressEvent.PROGRESS,onLoadingProgress);
            context.imageTracker.clearAll();
            this.dispatchEvent(new PlayerEvent(PlayerEvent.MATERIALS_LOADED,false,false));
         }
      }
      
      public function loadObject(param1:String, param2:Object) : void
      {
         registerClassAlias("AL",AnimLibrary);
         registerClassAlias("An",Anim);
         registerClassAlias("BB",BinBuddy);
         registerClassAlias("Bo",Bone);
         registerClassAlias("Ca",Camera);
         registerClassAlias("Co",Controller);
         registerClassAlias("Ma",Map);
         registerClassAlias("Me",Mesh);
         registerClassAlias("MeC",MeshEBC);
         registerClassAlias("Mo",Modifier);
         registerClassAlias("MoC",ModifierEBC);
         registerClassAlias("No",Node);
         registerClassAlias("Sc",Scene);
         registerClassAlias("SM",StandardMaterial);
         registerClassAlias("WD",Wv);
         context.rootPath = param1;
         scene = Scene(param2);
         scene.nodeMap = new Dictionary();
         context.initScene(scene);
         loaded = true;
         if(LOAD_STANDARD_TEXTURES)
         {
            loadingState = LOADING_TEXTURES;
            context.imageTracker.addEventListener(Event.COMPLETE,onLoaded);
            context.imageTracker.checkAll(true);
         }
      }
      
      public function loadScene(param1:String, param2:String, param3:String = null) : void
      {
         context.rootPath = param1;
         tracker.addEventListener(Event.COMPLETE,onLoaded);
         tracker.addEventListener(ProgressEvent.PROGRESS,onLoadingProgress);
         modelLoader.url = param1 + "/" + param2;
         tracker.addMedia(modelLoader);
         if(param3 != null)
         {
            buddyConfigMedia = new MediaObject();
            buddyConfigMedia.url = param1 + "/" + param3;
            tracker.addMedia(buddyConfigMedia);
         }
         tracker.checkAll(true);
      }
      
      public function removeEventListener(param1:String, param2:Function, param3:Boolean = false) : void
      {
         dispatcher.removeEventListener(param1,param2,param3);
      }
      
      public function addEventListener(param1:String, param2:Function, param3:Boolean = false, param4:int = 0, param5:Boolean = false) : void
      {
         dispatcher.addEventListener(param1,param2,param3,param4);
      }
      
      public function hideGeometry(param1:Array) : void
      {
         var _loc4_:String = null;
         var _loc5_:BaseObj = null;
         if(scene == null || scene.nodeMap == null || param1 == null)
         {
            return;
         }
         var _loc2_:int = int(param1.length);
         var _loc3_:int = 0;
         while(_loc3_ < _loc2_)
         {
            _loc4_ = param1[_loc3_];
            _loc5_ = BaseObj(scene.nodeMap[_loc4_]);
            if(_loc5_ != null && _loc5_ is Node)
            {
               Node(_loc5_).visible = false;
            }
            _loc3_++;
         }
      }
      
      private function applyTexture(param1:String, param2:Dictionary, param3:MediaLibrary, param4:String, param5:XML, param6:String, param7:Boolean = false, param8:Boolean = false, param9:Boolean = false) : void
      {
         var _loc11_:Node = null;
         var _loc12_:Mesh = null;
         var _loc13_:BaseMaterial = null;
         if(param1 == null || param1.length < 1)
         {
            return;
         }
         var _loc10_:BaseObj = BaseObj(scene.nodeMap[param1]);
         if(_loc10_ != null && _loc10_ is Node)
         {
            _loc11_ = Node(_loc10_);
            _loc12_ = _loc11_.mesh;
            if(_loc12_ != null)
            {
               if(param7 && param2[param4] != null)
               {
                  _loc12_.material = param2[param4];
                  _loc12_.updateTextures();
               }
               else if(param8)
               {
                  if(param7)
                  {
                     param2[param4] = _loc13_;
                  }
               }
               else
               {
                  if(_loc12_.material != null)
                  {
                     _loc12_.material.dispose();
                     _loc12_.material = null;
                  }
                  _loc13_ = new BaseMaterial();
                  if(!param9)
                  {
                     _loc13_.bmd = param3.createMaterial(param5,param6);
                  }
                  _loc13_.desc = param5;
                  _loc13_.lightmap = param6;
                  _loc13_.materialLibrary = param3;
                  _loc12_.material = _loc13_;
                  _loc12_.updateTextures();
                  if(param7)
                  {
                     param2[param4] = _loc13_;
                  }
               }
            }
         }
      }
      
      public function resetCulling() : void
      {
         if(scene == null)
         {
            return;
         }
         scene.resetCulling();
      }
      
      public function renderFrame(param1:Graphics) : void
      {
         if(scene != null)
         {
            context.scene = scene;
            context.draw(param1,scene);
         }
      }
      
      public function hasEventListener(param1:String) : Boolean
      {
         return dispatcher.hasEventListener(param1);
      }
   }
}

