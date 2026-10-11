package fl.core
{
   import fl.events.ComponentEvent;
   import fl.managers.FocusManager;
   import fl.managers.IFocusManager;
   import fl.managers.IFocusManagerComponent;
   import fl.managers.StyleManager;
   import flash.display.DisplayObject;
   import flash.display.InteractiveObject;
   import flash.display.Sprite;
   import flash.events.Event;
   import flash.events.FocusEvent;
   import flash.events.KeyboardEvent;
   import flash.system.IME;
   import flash.system.IMEConversionMode;
   import flash.text.TextField;
   import flash.text.TextFormat;
   import flash.text.TextFormatAlign;
   import flash.utils.Dictionary;
   import flash.utils.getDefinitionByName;
   import flash.utils.getQualifiedClassName;
   
   public class UIComponent extends Sprite
   {
      
      public static var createAccessibilityImplementation:Function;
      
      public static var inCallLaterPhase:Boolean = false;
      
      private static var defaultStyles:Object = {
         "focusRectSkin":"focusRectSkin",
         "focusRectPadding":2,
         "textFormat":new TextFormat("_sans",11,0,false,false,false,"","",TextFormatAlign.LEFT,0,0,0,0),
         "disabledTextFormat":new TextFormat("_sans",11,10066329,false,false,false,"","",TextFormatAlign.LEFT,0,0,0,0),
         "defaultTextFormat":new TextFormat("_sans",11,0,false,false,false,"","",TextFormatAlign.LEFT,0,0,0,0),
         "defaultDisabledTextFormat":new TextFormat("_sans",11,10066329,false,false,false,"","",TextFormatAlign.LEFT,0,0,0,0)
      };
      
      private static var focusManagers:Dictionary = new Dictionary(false);
      
      protected var _enabled:Boolean = true;
      
      private var _mouseFocusEnabled:Boolean = true;
      
      protected var startHeight:Number;
      
      protected var _height:Number;
      
      protected var _oldIMEMode:String = null;
      
      protected var startWidth:Number;
      
      public var focusTarget:IFocusManagerComponent;
      
      protected var errorCaught:Boolean = false;
      
      protected var uiFocusRect:DisplayObject;
      
      protected var _width:Number;
      
      public var version:String = "3.0.0.15";
      
      protected var isFocused:Boolean = false;
      
      protected var callLaterMethods:Dictionary;
      
      private var _focusEnabled:Boolean = true;
      
      private var tempText:TextField;
      
      protected var invalidateFlag:Boolean = false;
      
      protected var _inspector:Boolean = false;
      
      protected var sharedStyles:Object;
      
      protected var invalidHash:Object;
      
      protected var isLivePreview:Boolean = false;
      
      protected var _imeMode:String = null;
      
      protected var instanceStyles:Object;
      
      protected var _x:Number;
      
      protected var _y:Number;
      
      public function UIComponent()
      {
         super();
         instanceStyles = {};
         sharedStyles = {};
         invalidHash = {};
         callLaterMethods = new Dictionary();
         StyleManager.registerInstance(this);
         configUI();
         invalidate(InvalidationType.ALL);
         tabEnabled = this is IFocusManagerComponent;
         focusRect = false;
         if(tabEnabled)
         {
            addEventListener(FocusEvent.FOCUS_IN,focusInHandler);
            addEventListener(FocusEvent.FOCUS_OUT,focusOutHandler);
            addEventListener(KeyboardEvent.KEY_DOWN,keyDownHandler);
            addEventListener(KeyboardEvent.KEY_UP,keyUpHandler);
         }
         initializeFocusManager();
         addEventListener(Event.ENTER_FRAME,hookAccessibility,false,0,true);
      }
      
      public static function getStyleDefinition() : Object
      {
         return defaultStyles;
      }
      
      public static function mergeStyles(... rest) : Object
      {
         var _loc2_:Object = null;
         var _loc3_:uint = 0;
         var _loc4_:uint = 0;
         var _loc5_:Object = null;
         var _loc6_:String = null;
         _loc2_ = {};
         _loc3_ = uint(rest.length);
         _loc4_ = 0;
         while(_loc4_ < _loc3_)
         {
            _loc5_ = rest[_loc4_];
            for(_loc6_ in _loc5_)
            {
               if(_loc2_[_loc6_] == null)
               {
                  _loc2_[_loc6_] = rest[_loc4_][_loc6_];
               }
            }
            _loc4_++;
         }
         return _loc2_;
      }
      
      public function drawFocus(param1:Boolean) : void
      {
         var _loc2_:Number = NaN;
         isFocused = param1;
         if(uiFocusRect != null && contains(uiFocusRect))
         {
            removeChild(uiFocusRect);
            uiFocusRect = null;
         }
         if(param1)
         {
            uiFocusRect = getDisplayObjectInstance(getStyleValue("focusRectSkin")) as Sprite;
            if(uiFocusRect == null)
            {
               return;
            }
            _loc2_ = Number(getStyleValue("focusRectPadding"));
            uiFocusRect.x = -_loc2_;
            uiFocusRect.y = -_loc2_;
            uiFocusRect.width = width + _loc2_ * 2;
            uiFocusRect.height = height + _loc2_ * 2;
            addChildAt(uiFocusRect,0);
         }
      }
      
      private function callLaterDispatcher(param1:Event) : void
      {
         var _loc2_:Dictionary = null;
         var _loc3_:Object = null;
         if(param1.type == Event.ADDED_TO_STAGE)
         {
            removeEventListener(Event.ADDED_TO_STAGE,callLaterDispatcher);
            stage.addEventListener(Event.ENTER_FRAME,callLaterDispatcher,false,0,true);
            stage.invalidate();
            return;
         }
         param1.target.removeEventListener(Event.ENTER_FRAME,callLaterDispatcher);
         if(stage == null)
         {
            addEventListener(Event.ADDED_TO_STAGE,callLaterDispatcher,false,0,true);
            return;
         }
         inCallLaterPhase = true;
         _loc2_ = callLaterMethods;
         for(_loc3_ in _loc2_)
         {
            _loc3_();
            delete _loc2_[_loc3_];
         }
         inCallLaterPhase = false;
      }
      
      private function addedHandler(param1:Event) : void
      {
         removeEventListener("addedToStage",addedHandler);
         initializeFocusManager();
      }
      
      protected function getStyleValue(param1:String) : Object
      {
         return instanceStyles[param1] == null ? sharedStyles[param1] : instanceStyles[param1];
      }
      
      protected function isOurFocus(param1:DisplayObject) : Boolean
      {
         return param1 == this;
      }
      
      override public function get scaleX() : Number
      {
         return width / startWidth;
      }
      
      override public function get scaleY() : Number
      {
         return height / startHeight;
      }
      
      override public function set height(param1:Number) : void
      {
         if(_height == param1)
         {
            return;
         }
         setSize(width,param1);
      }
      
      protected function keyDownHandler(param1:KeyboardEvent) : void
      {
      }
      
      protected function focusInHandler(param1:FocusEvent) : void
      {
         var _loc2_:IFocusManager = null;
         if(isOurFocus(param1.target as DisplayObject))
         {
            _loc2_ = focusManager;
            if(Boolean(_loc2_) && _loc2_.showFocusIndicator)
            {
               drawFocus(true);
               isFocused = true;
            }
         }
      }
      
      public function setStyle(param1:String, param2:Object) : void
      {
         if(instanceStyles[param1] === param2 && !(param2 is TextFormat))
         {
            return;
         }
         instanceStyles[param1] = param2;
         invalidate(InvalidationType.STYLES);
      }
      
      override public function get visible() : Boolean
      {
         return super.visible;
      }
      
      public function get componentInspectorSetting() : Boolean
      {
         return _inspector;
      }
      
      override public function get x() : Number
      {
         return isNaN(_x) ? super.x : _x;
      }
      
      override public function get y() : Number
      {
         return isNaN(_y) ? super.y : _y;
      }
      
      protected function setIMEMode(param1:Boolean) : *
      {
         var enabled:Boolean = param1;
         if(_imeMode != null)
         {
            if(enabled)
            {
               IME.enabled = true;
               _oldIMEMode = IME.conversionMode;
               try
               {
                  if(!errorCaught && IME.conversionMode != IMEConversionMode.UNKNOWN)
                  {
                     IME.conversionMode = _imeMode;
                  }
                  errorCaught = false;
               }
               catch(e:Error)
               {
                  errorCaught = true;
                  throw new Error("IME mode not supported: " + _imeMode);
               }
            }
            else
            {
               if(IME.conversionMode != IMEConversionMode.UNKNOWN && _oldIMEMode != IMEConversionMode.UNKNOWN)
               {
                  IME.conversionMode = _oldIMEMode;
               }
               IME.enabled = false;
            }
         }
      }
      
      public function set enabled(param1:Boolean) : void
      {
         if(param1 == _enabled)
         {
            return;
         }
         _enabled = param1;
         invalidate(InvalidationType.STATE);
      }
      
      public function setSharedStyle(param1:String, param2:Object) : void
      {
         if(sharedStyles[param1] === param2 && !(param2 is TextFormat))
         {
            return;
         }
         sharedStyles[param1] = param2;
         if(instanceStyles[param1] == null)
         {
            invalidate(InvalidationType.STYLES);
         }
      }
      
      protected function keyUpHandler(param1:KeyboardEvent) : void
      {
      }
      
      public function set focusEnabled(param1:Boolean) : void
      {
         _focusEnabled = param1;
      }
      
      override public function set scaleX(param1:Number) : void
      {
         setSize(startWidth * param1,height);
      }
      
      public function get mouseFocusEnabled() : Boolean
      {
         return _mouseFocusEnabled;
      }
      
      override public function set scaleY(param1:Number) : void
      {
         setSize(width,startHeight * param1);
      }
      
      protected function getDisplayObjectInstance(param1:Object) : DisplayObject
      {
         var classDef:Object = null;
         var skin:Object = param1;
         classDef = null;
         if(skin is Class)
         {
            return new skin() as DisplayObject;
         }
         if(skin is DisplayObject)
         {
            (skin as DisplayObject).x = 0;
            (skin as DisplayObject).y = 0;
            return skin as DisplayObject;
         }
         try
         {
            classDef = getDefinitionByName(skin.toString());
         }
         catch(e:Error)
         {
            try
            {
               classDef = loaderInfo.applicationDomain.getDefinition(skin.toString()) as Object;
            }
            catch(e:Error)
            {
            }
         }
         if(classDef == null)
         {
            return null;
         }
         return new classDef() as DisplayObject;
      }
      
      protected function copyStylesToChild(param1:UIComponent, param2:Object) : void
      {
         var _loc3_:String = null;
         for(_loc3_ in param2)
         {
            param1.setStyle(_loc3_,getStyleValue(param2[_loc3_]));
         }
      }
      
      protected function beforeComponentParameters() : void
      {
      }
      
      protected function callLater(param1:Function) : void
      {
         if(inCallLaterPhase)
         {
            return;
         }
         callLaterMethods[param1] = true;
         if(stage != null)
         {
            stage.addEventListener(Event.ENTER_FRAME,callLaterDispatcher,false,0,true);
            stage.invalidate();
         }
         else
         {
            addEventListener(Event.ADDED_TO_STAGE,callLaterDispatcher,false,0,true);
         }
      }
      
      protected function createFocusManager() : void
      {
         if(focusManagers[stage] == null)
         {
            focusManagers[stage] = new FocusManager(stage);
         }
      }
      
      override public function set visible(param1:Boolean) : void
      {
         var _loc2_:String = null;
         if(super.visible == param1)
         {
            return;
         }
         super.visible = param1;
         _loc2_ = param1 ? ComponentEvent.SHOW : ComponentEvent.HIDE;
         dispatchEvent(new ComponentEvent(_loc2_,true));
      }
      
      protected function hookAccessibility(param1:Event) : void
      {
         removeEventListener(Event.ENTER_FRAME,hookAccessibility);
         initializeAccessibility();
      }
      
      public function set componentInspectorSetting(param1:Boolean) : void
      {
         _inspector = param1;
         if(_inspector)
         {
            beforeComponentParameters();
         }
         else
         {
            afterComponentParameters();
         }
      }
      
      override public function set x(param1:Number) : void
      {
         move(param1,_y);
      }
      
      public function drawNow() : void
      {
         draw();
      }
      
      override public function set y(param1:Number) : void
      {
         move(_x,param1);
      }
      
      protected function checkLivePreview() : Boolean
      {
         var className:String = null;
         if(parent == null)
         {
            return false;
         }
         try
         {
            className = getQualifiedClassName(parent);
         }
         catch(e:Error)
         {
         }
         return className == "fl.livepreview::LivePreviewParent";
      }
      
      protected function focusOutHandler(param1:FocusEvent) : void
      {
         if(isOurFocus(param1.target as DisplayObject))
         {
            drawFocus(false);
            isFocused = false;
         }
      }
      
      public function set mouseFocusEnabled(param1:Boolean) : void
      {
         _mouseFocusEnabled = param1;
      }
      
      public function getFocus() : InteractiveObject
      {
         if(stage)
         {
            return stage.focus;
         }
         return null;
      }
      
      protected function validate() : void
      {
         invalidHash = {};
      }
      
      override public function get height() : Number
      {
         return _height;
      }
      
      public function invalidate(param1:String = "all", param2:Boolean = true) : void
      {
         invalidHash[param1] = true;
         if(param2)
         {
            this.callLater(draw);
         }
      }
      
      public function get enabled() : Boolean
      {
         return _enabled;
      }
      
      protected function getScaleX() : Number
      {
         return super.scaleX;
      }
      
      protected function getScaleY() : Number
      {
         return super.scaleY;
      }
      
      public function get focusEnabled() : Boolean
      {
         return _focusEnabled;
      }
      
      protected function afterComponentParameters() : void
      {
      }
      
      protected function draw() : void
      {
         if(isInvalid(InvalidationType.SIZE,InvalidationType.STYLES))
         {
            if(isFocused && focusManager.showFocusIndicator)
            {
               drawFocus(true);
            }
         }
         validate();
      }
      
      protected function configUI() : void
      {
         var _loc1_:Number = NaN;
         var _loc2_:Number = NaN;
         var _loc3_:Number = NaN;
         isLivePreview = checkLivePreview();
         _loc1_ = rotation;
         rotation = 0;
         _loc2_ = super.width;
         _loc3_ = super.height;
         super.scaleX = super.scaleY = 1;
         setSize(_loc2_,_loc3_);
         move(super.x,super.y);
         rotation = _loc1_;
         startWidth = _loc2_;
         startHeight = _loc3_;
         if(numChildren > 0)
         {
            removeChildAt(0);
         }
      }
      
      protected function setScaleX(param1:Number) : void
      {
         super.scaleX = param1;
      }
      
      protected function setScaleY(param1:Number) : void
      {
         super.scaleY = param1;
      }
      
      private function initializeFocusManager() : void
      {
         if(stage == null)
         {
            addEventListener(Event.ADDED_TO_STAGE,addedHandler,false,0,true);
         }
         else
         {
            createFocusManager();
         }
      }
      
      public function set focusManager(param1:IFocusManager) : void
      {
         UIComponent.focusManagers[this] = param1;
      }
      
      public function clearStyle(param1:String) : void
      {
         setStyle(param1,null);
      }
      
      protected function isInvalid(param1:String, ... rest) : Boolean
      {
         if(Boolean(invalidHash[param1]) || Boolean(invalidHash[InvalidationType.ALL]))
         {
            return true;
         }
         while(rest.length > 0)
         {
            if(invalidHash[rest.pop()])
            {
               return true;
            }
         }
         return false;
      }
      
      public function setSize(param1:Number, param2:Number) : void
      {
         _width = param1;
         _height = param2;
         invalidate(InvalidationType.SIZE);
         dispatchEvent(new ComponentEvent(ComponentEvent.RESIZE,false));
      }
      
      override public function set width(param1:Number) : void
      {
         if(_width == param1)
         {
            return;
         }
         setSize(param1,height);
      }
      
      public function setFocus() : void
      {
         if(stage)
         {
            stage.focus = this;
         }
      }
      
      protected function initializeAccessibility() : void
      {
         if(UIComponent.createAccessibilityImplementation != null)
         {
            UIComponent.createAccessibilityImplementation(this);
         }
      }
      
      public function get focusManager() : IFocusManager
      {
         var _loc1_:DisplayObject = null;
         _loc1_ = this;
         while(_loc1_)
         {
            if(UIComponent.focusManagers[_loc1_] != null)
            {
               return IFocusManager(UIComponent.focusManagers[_loc1_]);
            }
            _loc1_ = _loc1_.parent;
         }
         return null;
      }
      
      override public function get width() : Number
      {
         return _width;
      }
      
      public function move(param1:Number, param2:Number) : void
      {
         _x = param1;
         _y = param2;
         super.x = Math.round(param1);
         super.y = Math.round(param2);
         dispatchEvent(new ComponentEvent(ComponentEvent.MOVE));
      }
      
      public function validateNow() : void
      {
         invalidate(InvalidationType.ALL,false);
         draw();
      }
      
      public function getStyle(param1:String) : Object
      {
         return instanceStyles[param1];
      }
   }
}

