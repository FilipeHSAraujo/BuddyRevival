package
{
   import com.buddylabs.player.*;
   import fl.controls.*;
   import fl.events.*;
   import flash.display.*;
   import flash.events.*;
   import flash.geom.*;
   import flash.net.*;
   import flash.text.*;
   import flash.ui.Mouse;
   import flash.utils.*;
   
   public class BuddyPoke extends Sprite
   {
      
      protected static const backgroundClass:Class = BuddyPoke_backgroundClass;
      
      internal static const chickClass:Class = BuddyPoke_chickClass;
      
      protected var savingChangesLink:Sprite;
      
      protected var genImagesOnSave:Boolean = false;
      
      protected var STAGE_WIDTH:Number = 290;
      
      protected var buddyPanelPicker:Sprite = new Sprite();
      
      protected var onHomePage:Boolean = false;
      
      private var examineCursor:Sprite;
      
      protected var randomAppearanceLink:Sprite;
      
      protected var sceneSetting:SceneSetting;
      
      private var examineCameraVec3:Vector3 = new Vector3(0,0,10);
      
      protected var pokeAnim0:String = "standBreathe";
      
      protected var pokeAnim1:String = "standBreathe";
      
      private var examineRootBoneVec3:Vector3 = new Vector3();
      
      protected var buddyPanelHolder:Sprite = new Sprite();
      
      protected var buddy1:Buddy;
      
      protected var buddy2:Buddy;
      
      protected var paused:Boolean = false;
      
      protected var viewerIsOwner:Boolean = false;
      
      protected var customizing:Boolean = false;
      
      protected var timer:Timer = new Timer(60,0);
      
      protected var console:TextField = new TextField();
      
      protected var showingMood:Boolean = false;
      
      private var startTime:int;
      
      protected var buddyPanelShape:Sprite;
      
      protected var onProfilePage:Boolean = false;
      
      protected var randomRevertLinkSet:Sprite;
      
      protected var revertAppearanceLink:Sprite;
      
      protected var cancelChangesLink:Sprite;
      
      protected var buddyPanelWidth:uint = 328;
      
      protected var viewerAndOwnerAreFriends:Boolean = false;
      
      private var lastX:Number;
      
      protected var runLocal:Boolean = false;
      
      protected var buddyPanelHeight:uint = 266;
      
      protected var saveChangesLink:Sprite;
      
      protected var moodSelectionPanel:MoodSelectionPanel;
      
      protected var saveCancelLinkSet:Sprite;
      
      protected var pokeSelectionPanel:PokeSelectionPanel;
      
      protected var viewerHasApp:Boolean = false;
      
      protected var buddyDescToLoad2:String = null;
      
      protected var customizeLink:Sprite;
      
      protected var buddyDescToLoad1:String = null;
      
      private var mouseDown:Boolean = false;
      
      protected var customizationPanel:CustomizationPanel;
      
      protected var isBulletin:Boolean = false;
      
      private var uploadProgressDummy:UploadProgress;
      
      public function BuddyPoke()
      {
         super();
      }
      
      public static function timeStamp() : uint
      {
         var _loc1_:Date = new Date();
         var _loc2_:Number = Date.UTC(_loc1_.getUTCFullYear(),_loc1_.getUTCMonth(),_loc1_.getUTCDate(),_loc1_.getUTCHours(),_loc1_.getUTCMinutes(),_loc1_.getSeconds());
         return uint(Math.floor(_loc2_ / 1000));
      }
      
      public static function timeStampToLocalDate(param1:uint) : Date
      {
         var _loc2_:Number = Number(param1) * 1000;
         return new Date(_loc2_);
      }
      
      protected function createLink(param1:String, param2:uint, param3:int, param4:Boolean = false, param5:String = "left", param6:Boolean = false, param7:Boolean = false) : Sprite
      {
         var _loc11_:Rectangle = null;
         var _loc8_:Sprite = new Sprite();
         var _loc9_:TextField = new TextField();
         _loc9_.autoSize = param5;
         _loc9_.htmlText = param1;
         _loc9_.selectable = false;
         var _loc10_:TextFormat = new TextFormat();
         _loc10_.font = "tahoma,verdana,arial,sans-serif";
         _loc10_.bold = param7;
         _loc10_.size = param3;
         _loc10_.color = param2;
         _loc10_.underline = param6;
         _loc9_.defaultTextFormat = _loc10_;
         _loc9_.setTextFormat(_loc10_);
         _loc8_.addChild(_loc9_);
         _loc8_.mouseChildren = false;
         if(param4)
         {
            _loc8_.useHandCursor = true;
            _loc8_.buttonMode = true;
         }
         if(param5 == TextFieldAutoSize.CENTER)
         {
            _loc11_ = _loc8_.getBounds(_loc8_);
            _loc9_.x = -_loc11_.width * 0.5;
         }
         return _loc8_;
      }
      
      protected function onExamineMouseLeave(param1:MouseEvent) : void
      {
         mouseDown = false;
         if(stage != null && examineCursor != null && stage.contains(examineCursor))
         {
            stage.removeChild(examineCursor);
         }
         Mouse.show();
      }
      
      protected function showPoke(param1:String, param2:String, param3:String) : void
      {
         var anims:XML = null;
         var anim:XML = null;
         var pokeId:String = param1;
         var fromId:String = param2;
         var toId:String = param3;
         this.showingMood = false;
         this.customizing = false;
         anims = PokeSelectionPanel.Anims;
         anim = anims.anim.(@id == pokeId)[0];
         if(anim != null)
         {
            showPokeAnim(anim.@a0,anim.@a1);
         }
      }
      
      protected function onExamineMouseUp(param1:MouseEvent) : void
      {
         mouseDown = false;
      }
      
      public function loadBlankSetting() : void
      {
         startTime = getTimer();
         console.appendText("\n---------loadBlankSetting--------\n");
         console.appendText("\ntime " + (getTimer() - startTime) + "\n");
         sceneSetting = new SceneSetting(stage);
         sceneSetting.addEventListener("BUDDY_LOADED",onLoadedBlankSetting);
         sceneSetting.loadBin(new backgroundClass() as ByteArray,null,buddyPanelWidth,buddyPanelHeight,true,"Bkg","Fkg");
      }
      
      protected function onLoadedBuddy(param1:Event) : void
      {
         console.appendText("\n-------onLoadedBuddy----------\n");
         console.appendText("\ntime " + (getTimer() - startTime) + "\n");
         sceneSetting.addSceneObject(buddy1,"Buddy1");
         if(buddy2 != null && buddy2.player != null)
         {
            sceneSetting.addSceneObject(buddy2,"Buddy2");
         }
         onPreFirstRender();
         stage.frameRate = 12;
         stage.quality = StageQuality.HIGH;
         timer.addEventListener(TimerEvent.TIMER,onEnterFrame,false,-10000,false);
         timer.start();
      }
      
      protected function createLinkSet(param1:Array, param2:Number, param3:Boolean) : Sprite
      {
         var _loc8_:int = 0;
         var _loc9_:Rectangle = null;
         var _loc4_:Sprite = new Sprite();
         if(param1 == null || param1.length < 1)
         {
            return _loc4_;
         }
         var _loc5_:int = int(param1.length);
         _loc4_.addChild(param1[0]);
         var _loc6_:int = 1;
         while(_loc6_ < _loc5_)
         {
            _loc8_ = _loc4_.getBounds(_loc4_).width + param2;
            param1[_loc6_].x = _loc8_;
            _loc4_.addChild(param1[_loc6_]);
            _loc6_++;
         }
         var _loc7_:Sprite = new Sprite();
         _loc7_.addChild(_loc4_);
         if(param3)
         {
            _loc9_ = _loc4_.getBounds(_loc4_);
            _loc4_.x = -_loc9_.width * 0.5;
         }
         return _loc7_;
      }
      
      protected function onLoadedBlankSetting(param1:Event) : void
      {
         console.appendText("\n---------onLoadedBlankSetting--------\n");
         console.appendText("\ntime " + (getTimer() - startTime) + "\n");
         if(sceneSetting != null && sceneSetting.background != null)
         {
            buddyPanelHolder.addChildAt(sceneSetting.background,0);
         }
         if(sceneSetting != null && sceneSetting.foreground != null)
         {
            buddyPanelHolder.addChildAt(sceneSetting.foreground,2);
         }
         loadBuddy1();
      }
      
      protected function showPokeAnim(param1:String, param2:String) : void
      {
         pokeAnim0 = param1;
         pokeAnim1 = param2;
         this.showingMood = false;
         if(buddy1 != null && pokeAnim0 != null && pokeAnim0.length > 0)
         {
            buddy1.selectedAnim = pokeAnim0;
         }
         if(buddy2 != null && pokeAnim1 != null && pokeAnim1.length > 0)
         {
            buddy2.selectedAnim = pokeAnim1;
         }
         if(buddy1 != null && buddy1.animation != null)
         {
            buddy1.animation.loop = true;
            buddy1.animation.reset();
         }
         if(buddy2 != null && buddy2.animation != null)
         {
            buddy2.animation.loop = true;
            buddy2.animation.reset();
         }
         this.paused = false;
      }
      
      protected function onExamineMouseDown(param1:MouseEvent) : void
      {
         var _loc2_:Camera = Camera(buddy1.context.camera);
         if(_loc2_.name != "Camera_Long2")
         {
            _loc2_ = Camera(buddy1.context.scene.getNodeByName("Camera_Long2"));
            buddy1.context.camera = _loc2_;
         }
         var _loc3_:Node = Node(buddy1.context.scene.getNodeByName("IG_Root"));
         if(_loc2_ != null)
         {
            _loc2_.lookAt = _loc3_;
            _loc2_.centerOffset = new Point(0,14);
         }
         mouseDown = true;
         lastX = param1.stageX;
      }
      
      protected function onPreFirstRender() : void
      {
      }
      
      protected function showMood(param1:String) : void
      {
         var moods:XML = null;
         var mood:XML = null;
         var moodAnim:String = null;
         var anim:Anim = null;
         var moodId:String = param1;
         this.showingMood = true;
         moods = MoodSelectionPanel.Moods;
         mood = moods.mood.(@id == moodId)[0];
         if(mood != null)
         {
            moodAnim = mood.@a0;
            if(buddy1 != null && moodAnim != null && moodAnim.length > 0)
            {
               this.showingMood = true;
               buddy1.selectedAnim = moodAnim;
               anim = buddy1.animation;
               if(anim != null)
               {
                  anim.loop = true;
               }
            }
         }
         this.paused = false;
      }
      
      public function initStageConsole() : *
      {
         stage.quality = StageQuality.BEST;
         stage.align = StageAlign.TOP_LEFT;
         stage.scaleMode = StageScaleMode.NO_SCALE;
         console.y = 70;
         console.width = 200;
         console.height = 200;
         console.background = true;
         console.backgroundColor = 16777215;
         console.wordWrap = true;
         console.multiline = true;
         console.text = "";
         console.textColor = 0;
      }
      
      protected function initExamineCamera() : void
      {
         if(buddyPanelHolder != null && buddyPanelPicker != null && !buddyPanelHolder.contains(buddyPanelPicker))
         {
            buddyPanelHolder.addChild(buddyPanelPicker);
         }
         var _loc1_:Camera = Camera(buddy1.context.camera);
         if(_loc1_.name != "Camera_Long2")
         {
            _loc1_ = Camera(buddy1.context.scene.getNodeByName("Camera_Long2"));
            buddy1.context.camera = _loc1_;
         }
      }
      
      protected function onEnterFrame(param1:TimerEvent) : void
      {
         var _loc3_:Number = NaN;
         if(paused)
         {
            return;
         }
         if(buddy1 == null)
         {
            return;
         }
         var _loc2_:int = getTimer();
         buddyPanelShape.graphics.clear();
         if(customizing)
         {
            if(customizationPanel != null)
            {
               customizationPanel.updateAnim(buddy1);
            }
            buddy1.player.renderFrame(buddyPanelShape.graphics);
         }
         else if(showingMood)
         {
            buddy1.draw(buddyPanelShape.graphics,true);
         }
         else
         {
            sceneSetting.draw(buddyPanelShape.graphics,true);
         }
         param1.updateAfterEvent();
      }
      
      protected function loadBuddy1() : void
      {
         console.appendText("\n---------loadBuddy1--------\n");
         console.appendText("\ntime " + (getTimer() - startTime) + "\n");
         buddy1 = new Buddy(stage);
         buddy1.addEventListener("BUDDY_LOADED",loadBuddy2);
         buddy1.loadBin(new chickClass() as ByteArray,null,buddyPanelWidth,buddyPanelHeight,false);
      }
      
      protected function loadBuddy2(param1:Event) : void
      {
         console.appendText("\n---------loadBuddy2--------\n");
         console.appendText("\ntime " + (getTimer() - startTime) + "\n");
         buddy2 = new Buddy(stage);
         buddy2.addEventListener("BUDDY_LOADED",onLoadedBuddy);
         buddy2.loadBin(new chickClass() as ByteArray,null,buddyPanelWidth,buddyPanelHeight,false,null,null,buddy1.materialLibrary);
      }
      
      protected function onExamineMouseMove(param1:MouseEvent) : void
      {
         var _loc2_:Camera = null;
         var _loc3_:Node = null;
         var _loc4_:Number = NaN;
         var _loc5_:Number = NaN;
         var _loc6_:Number = NaN;
         var _loc7_:Number = NaN;
         var _loc8_:Number = NaN;
         var _loc9_:Number = NaN;
         var _loc10_:Number = NaN;
         var _loc11_:Number = NaN;
         var _loc12_:Number = NaN;
         var _loc13_:Number = NaN;
         var _loc14_:Number = NaN;
         if(examineCursor == null)
         {
            examineCursor = new Sprite();
            examineCursor.addChild(new Icons.manipulateClass());
            examineCursor.mouseEnabled = false;
         }
         if(examineCursor != null)
         {
            if(!stage.contains(examineCursor))
            {
               Mouse.hide();
               examineCursor.x = param1.stageX;
               examineCursor.y = param1.stageY;
               stage.addChild(examineCursor);
            }
            examineCursor.x = param1.stageX;
            examineCursor.y = param1.stageY;
         }
         if(mouseDown && buddy1 != null)
         {
            _loc2_ = Camera(buddy1.context.camera);
            _loc3_ = Node(buddy1.context.scene.getNodeByName("IG_Root"));
            _loc3_.getWorldPosition(examineRootBoneVec3);
            _loc2_.getWorldPosition(examineCameraVec3);
            _loc4_ = examineCameraVec3.x;
            _loc5_ = examineCameraVec3.z;
            _loc6_ = examineRootBoneVec3.x;
            _loc7_ = examineRootBoneVec3.z;
            _loc8_ = Math.atan2(_loc5_ - _loc7_,_loc4_ - _loc6_);
            _loc9_ = param1.stageX;
            _loc10_ = _loc9_ - lastX;
            lastX = _loc9_;
            _loc11_ = _loc8_ + _loc10_ / this.buddyPanelWidth * 2 * Math.PI;
            _loc12_ = Math.sqrt((_loc5_ - _loc7_) * (_loc5_ - _loc7_) + (_loc4_ - _loc6_) * (_loc4_ - _loc6_));
            _loc13_ = _loc6_ + _loc12_ * Math.cos(_loc11_);
            _loc14_ = _loc7_ + _loc12_ * Math.sin(_loc11_);
            _loc2_.pos.x = _loc13_;
            _loc2_.pos.z = _loc14_;
         }
      }
   }
}

