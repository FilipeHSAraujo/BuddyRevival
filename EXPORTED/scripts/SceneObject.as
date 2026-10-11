package
{
   import com.buddylabs.app.*;
   import com.buddylabs.player.*;
   import flash.display.*;
   import flash.events.*;
   import flash.filters.*;
   import flash.geom.*;
   import flash.net.registerClassAlias;
   import flash.system.*;
   import flash.text.*;
   import flash.utils.*;
   
   public class SceneObject extends EventDispatcher
   {
      
      private var anims:Array = new Array();
      
      private var buddyPanelWidth:uint = 370;
      
      private var runtimeLoopTimer:Timer;
      
      private var animNameToAnim:Dictionary = new Dictionary();
      
      internal var materialLibrary:MediaLibrary;
      
      protected var animFPS:Number;
      
      private var buddyPackage:MediaBinary;
      
      private var buddyPanelHeight:uint = 240;
      
      protected var currentAnim:Anim;
      
      private var buddyObject:Object;
      
      private var animLib:AnimLibrary;
      
      private var buddyMedia:MediaObject;
      
      internal var catalogXML:XML;
      
      private var descXML:XML;
      
      private var animToPlay:String;
      
      protected var foregroundMatName:String;
      
      protected var animDuration:Number;
      
      protected var _background:DisplayObject;
      
      private var origCatalogBin:ByteArray;
      
      protected var currentAnimIndex:int = 0;
      
      internal var player:Player;
      
      protected var _foreground:DisplayObject;
      
      private var buddyDir:String;
      
      private var initTextures:Boolean = true;
      
      protected var backgroundMatName:String;
      
      private var stage:Stage;
      
      public function SceneObject(param1:Stage)
      {
         super();
         this.stage = param1;
      }
      
      public function setCurrentFrame(param1:uint) : void
      {
         if(currentAnim != null)
         {
            currentAnim.drawFrame(player.context,param1);
         }
      }
      
      private function initPlayer(param1:Event = null) : void
      {
         var animBin:ByteArray;
         var bkg:XMLList = null;
         var fkg:XMLList = null;
         var event:Event = param1;
         var geoBin:ByteArray = buddyObject["g"];
         geoBin.uncompress();
         geoBin.position = 0;
         Context.SMOOTH_TEXTURES = true;
         player = new Player(stage,buddyPanelWidth,buddyPanelHeight);
         player.loadObject(buddyDir,geoBin.readObject());
         if(materialLibrary != null && initTextures)
         {
            player.updateTextures(catalogXML,materialLibrary);
            player.setVisibleGeometry(catalogXML);
            if(backgroundMatName != null)
            {
               bkg = catalogXML.materialOptions.materialOption.(@name == backgroundMatName);
               if(bkg.length() > 0)
               {
                  _background = materialLibrary.createMaterialMovieClip(stage,bkg[0].material[0]);
               }
            }
            if(foregroundMatName != null)
            {
               fkg = catalogXML.materialOptions.materialOption.(@name == foregroundMatName);
               if(fkg.length() > 0)
               {
                  _foreground = materialLibrary.createMaterialMovieClip(stage,fkg[0].material[0]);
               }
            }
         }
         animBin = buddyObject["a"];
         if(animBin != null)
         {
            initAnim(animBin);
         }
         else
         {
            this.dispatchEvent(new Event("BUDDY_LOADED"));
         }
      }
      
      public function get animation() : Anim
      {
         return currentAnim;
      }
      
      private function parseData(param1:ByteArray, param2:Boolean, param3:MediaLibrary) : void
      {
         var _loc6_:ByteArray = null;
         var _loc7_:MediaTracker = null;
         this.initTextures = param2;
         param1.readBytes(new ByteArray(),0,9);
         buddyObject = param1.readObject();
         var _loc4_:ByteArray = buddyObject["d"];
         _loc4_.uncompress();
         descXML = XML(_loc4_);
         var _loc5_:ByteArray = buddyObject["c"];
         origCatalogBin = new ByteArray();
         origCatalogBin.writeBytes(_loc5_,0,_loc5_.length);
         _loc5_.uncompress();
         catalogXML = XML(_loc5_);
         if(param3 != null)
         {
            materialLibrary = param3;
            initPlayer();
         }
         else
         {
            _loc6_ = buddyObject["m"];
            if(_loc6_ != null)
            {
               materialLibrary = new MediaLibrary(stage);
               _loc7_ = new MediaTracker();
               _loc7_.addEventListener(Event.COMPLETE,initPlayer);
               _loc7_.addMedia(materialLibrary);
               _loc7_.checkAll(true);
               materialLibrary.initData(_loc6_);
            }
            else
            {
               initPlayer();
            }
         }
      }
      
      public function resetMaterials() : void
      {
         resetNonBackgroundMaterialOptions();
         resetItemVisibility();
         player.updateTextures(catalogXML,materialLibrary);
         player.setVisibleGeometry(catalogXML);
      }
      
      public function drawFrame(param1:Graphics, param2:uint) : void
      {
         if(player == null || param1 == null)
         {
            return;
         }
         if(currentAnim != null)
         {
            currentAnim.drawFrame(player.context,param2);
         }
         player.renderFrame(param1);
      }
      
      public function resetNonBackgroundMaterialOptions() : void
      {
         var backgrounds:XMLList;
         var numBackgrounds:int;
         var i:int;
         var xml:XML;
         var allMatOptions:XMLList;
         var testMat:XML = null;
         var testMatName:String = null;
         var keep:Boolean = false;
         var j:int = 0;
         var bkgName:String = null;
         var replacement:XML = null;
         var temp:ByteArray = new ByteArray();
         temp.writeBytes(origCatalogBin,0,origCatalogBin.length);
         temp.position = 0;
         temp.uncompress();
         temp.position = 0;
         xml = XML(temp);
         backgrounds = catalogXML.background;
         numBackgrounds = int(backgrounds.length());
         allMatOptions = catalogXML.materialOptions[0].materialOption;
         i = int(allMatOptions.length());
         while(--i >= 0)
         {
            testMat = allMatOptions[i];
            testMatName = testMat.@name;
            keep = false;
            j = 0;
            while(j < numBackgrounds)
            {
               bkgName = backgrounds[j].@materialOption;
               if(testMatName == bkgName)
               {
                  keep = true;
                  break;
               }
               j++;
            }
            if(!keep)
            {
               replacement = xml.materialOptions[0].materialOption.(@name == testMatName)[0];
               catalogXML.materialOptions[0].materialOption[i] = replacement;
            }
         }
         xml = null;
         temp = null;
      }
      
      private function loadBuddyPackage(param1:String) : void
      {
         while(param1.indexOf("\\") >= 0)
         {
            param1 = param1.replace("\\","/");
         }
         buddyDir = param1.substring(0,param1.lastIndexOf("/") + 1);
         var _loc2_:MediaTracker = new MediaTracker();
         _loc2_.addEventListener(Event.COMPLETE,onLoadedPackage);
         buddyPackage = new MediaBinary(param1);
         _loc2_.addMedia(buddyPackage);
         _loc2_.checkAll(true);
      }
      
      public function set selectedAnim(param1:String) : void
      {
         if(param1 == null)
         {
            return;
         }
         var _loc2_:Anim = animNameToAnim[param1];
         if(_loc2_ != null)
         {
            _loc2_.decode(animLib);
            currentAnim = _loc2_;
            _loc2_.reset();
         }
      }
      
      public function get background() : DisplayObject
      {
         return _background;
      }
      
      public function get context() : Context
      {
         return player.context;
      }
      
      internal function loadRandomPreset() : void
      {
         var _loc1_:XMLList = catalogXML.presets.materialPresetSet.materialPreset;
         var _loc2_:int = int(_loc1_.length());
         if(_loc2_ == 0)
         {
            return;
         }
         var _loc3_:int = 0;
         trace(_loc3_ + " " + _loc2_);
         var _loc4_:XML = _loc1_[_loc3_];
         var _loc5_:ByteArray = Base64.decodeToByteArray(_loc4_.@data);
         registerClassAlias("desc",BuddyDesc);
         _loc5_.uncompress();
         _loc5_.position = 0;
         var _loc6_:BuddyDesc = _loc5_.readObject();
         resetNonBackgroundMaterialOptions();
         resetItemVisibility();
         BuddyMaker.loadBinaryDesc(_loc6_,catalogXML,context.scene,materialLibrary);
         player.updateTextures(catalogXML,materialLibrary);
         player.setVisibleGeometry(catalogXML);
      }
      
      internal function stepAnimation(param1:Boolean) : void
      {
         if(currentAnim != null && player != null)
         {
            currentAnim.step(player.context,param1);
         }
      }
      
      private function resetItemVisibility() : void
      {
         var _loc5_:int = 0;
         var _loc6_:int = 0;
         var _loc1_:ByteArray = new ByteArray();
         _loc1_.writeBytes(origCatalogBin,0,origCatalogBin.length);
         _loc1_.position = 0;
         _loc1_.uncompress();
         _loc1_.position = 0;
         var _loc2_:XML = XML(_loc1_);
         var _loc3_:XMLList = _loc2_.group.categories.itemCategory.item;
         var _loc4_:XMLList = catalogXML.group.categories.itemCategory.item;
         if(_loc3_ != null && _loc3_.length() > 0)
         {
            _loc5_ = int(_loc3_.length());
            _loc6_ = 0;
            while(_loc6_ < _loc5_)
            {
               _loc4_[_loc6_].@visible = _loc3_[_loc6_].@visible;
               _loc6_++;
            }
         }
         _loc2_ = null;
         _loc1_ = null;
      }
      
      public function loadBin(param1:ByteArray, param2:String, param3:uint, param4:uint, param5:Boolean = true, param6:String = null, param7:String = null, param8:MediaLibrary = null) : void
      {
         buddyPanelWidth = param3;
         buddyPanelHeight = param4;
         backgroundMatName = param6;
         foregroundMatName = param7;
         animToPlay = param2;
         parseData(param1,param5,param8);
      }
      
      public function get foreground() : DisplayObject
      {
         return _foreground;
      }
      
      public function draw(param1:Graphics, param2:Boolean) : void
      {
         if(player == null || param1 == null)
         {
            return;
         }
         if(currentAnim != null)
         {
            currentAnim.step(player.context,param2);
         }
         player.renderFrame(param1);
      }
      
      public function get selectedAnim() : String
      {
         if(currentAnim == null)
         {
            return null;
         }
         return currentAnim.name;
      }
      
      public function hasSwitchableItems() : Boolean
      {
         var _loc2_:XML = null;
         var _loc3_:* = false;
         var _loc1_:XMLList = catalogXML.group.categories.itemCategory.item;
         for each(_loc2_ in _loc1_)
         {
            _loc3_ = _loc2_.@alwaysVis == "true";
            if(!_loc3_)
            {
               return true;
            }
         }
         return false;
      }
      
      private function initAnim(param1:ByteArray) : void
      {
         var _loc2_:uint = 0;
         var _loc4_:Anim = null;
         if(param1 == null)
         {
            this.dispatchEvent(new Event("BUDDY_LOADED"));
            return;
         }
         param1.uncompress();
         param1.position = 0;
         animLib = param1.readObject();
         var _loc3_:int = animLib.numAnim;
         _loc2_ = 0;
         while(_loc2_ < _loc3_)
         {
            _loc4_ = param1.readObject();
            if(animToPlay == _loc4_.name)
            {
               _loc4_.decode(animLib);
               currentAnim = _loc4_;
               animFPS = _loc4_.fps;
               animDuration = _loc4_.length;
            }
            anims.push(_loc4_);
            animNameToAnim[_loc4_.name] = _loc4_;
            _loc2_++;
         }
         this.dispatchEvent(new Event("BUDDY_LOADED"));
      }
      
      public function randomizeSliders() : void
      {
         var _loc2_:XML = null;
         var _loc1_:XMLList = catalogXML.sliderSet.slider;
         for each(_loc2_ in _loc1_)
         {
            _loc2_.@value = SceneUtil.randomInt(200) - 100;
         }
         player.setVisibleGeometry(catalogXML);
      }
      
      public function get animationsDictionary() : Dictionary
      {
         return animNameToAnim;
      }
      
      public function load(param1:String, param2:String, param3:uint, param4:uint, param5:String = null, param6:String = null) : void
      {
         buddyPanelWidth = param3;
         buddyPanelHeight = param4;
         backgroundMatName = param5;
         foregroundMatName = param6;
         animToPlay = param2;
         loadBuddyPackage(param1);
      }
      
      private function onLoadedPackage(param1:Event) : void
      {
         if(buddyPackage.check(false) != Media.COMPLETE)
         {
            return;
         }
         parseData(buddyPackage.data,true,null);
      }
      
      public function get animations() : Array
      {
         return anims;
      }
   }
}

