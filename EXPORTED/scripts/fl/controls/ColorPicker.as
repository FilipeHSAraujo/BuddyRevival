package fl.controls
{
   import fl.core.InvalidationType;
   import fl.core.UIComponent;
   import fl.events.ColorPickerEvent;
   import fl.managers.IFocusManager;
   import fl.managers.IFocusManagerComponent;
   import flash.display.DisplayObject;
   import flash.display.Graphics;
   import flash.display.Sprite;
   import flash.events.Event;
   import flash.events.FocusEvent;
   import flash.events.MouseEvent;
   import flash.geom.ColorTransform;
   import flash.geom.Point;
   
   [Embed(source="/_assets/assets.swf", symbol="symbol162")]
   public class ColorPicker extends UIComponent implements IFocusManagerComponent
   {
      
      public static var defaultColors:Array;
      
      private static var defaultStyles:Object = {
         "upSkin":"ColorPicker_upSkin",
         "disabledSkin":"ColorPicker_disabledSkin",
         "overSkin":"ColorPicker_overSkin",
         "downSkin":"ColorPicker_downSkin",
         "colorWell":"ColorPicker_colorWell",
         "swatchSkin":"ColorPicker_swatchSkin",
         "swatchSelectedSkin":"ColorPicker_swatchSelectedSkin",
         "swatchWidth":10,
         "swatchHeight":10,
         "columnCount":18,
         "swatchPadding":1,
         "background":"ColorPicker_backgroundSkin",
         "backgroundPadding":5,
         "textFormat":null,
         "focusRectSkin":null,
         "focusRectPadding":null,
         "embedFonts":false
      };
      
      protected static const POPUP_BUTTON_STYLES:Object = {
         "disabledSkin":"disabledSkin",
         "downSkin":"downSkin",
         "overSkin":"overSkin",
         "upSkin":"upSkin"
      };
      
      protected static const SWATCH_STYLES:Object = {
         "disabledSkin":"swatchSkin",
         "downSkin":"swatchSkin",
         "overSkin":"swatchSkin",
         "upSkin":"swatchSkin"
      };
      
      protected var paletteBG:DisplayObject;
      
      protected var customColors:Array;
      
      protected var palette:Sprite;
      
      private var redrawPalette:Boolean = false;
      
      protected var isOpen:Boolean = false;
      
      protected var swatchButton:BaseButton;
      
      protected var selectedSwatch:Sprite;
      
      protected var colorWell:DisplayObject;
      
      protected var rollOverColor:int = -1;
      
      protected var colorHash:Object;
      
      protected var swatchSelectedSkin:DisplayObject;
      
      protected var currRowIndex:int;
      
      protected var doOpen:Boolean = false;
      
      protected var currColIndex:int;
      
      protected var swatchMap:Array;
      
      protected var _selectedColor:uint;
      
      protected var _editable:Boolean = true;
      
      protected var swatches:Sprite;
      
      public function ColorPicker()
      {
         super();
      }
      
      public static function getStyleDefinition() : Object
      {
         return defaultStyles;
      }
      
      public function set imeMode(param1:String) : void
      {
         _imeMode = param1;
      }
      
      protected function drawSwatchHighlight() : void
      {
         var _loc1_:Object = null;
         var _loc2_:Number = NaN;
         cleanUpSelected();
         _loc1_ = getStyleValue("swatchSelectedSkin");
         _loc2_ = getStyleValue("swatchPadding") as Number;
         if(_loc1_ != null)
         {
            swatchSelectedSkin = getDisplayObjectInstance(_loc1_);
            swatchSelectedSkin.x = 0;
            swatchSelectedSkin.y = 0;
            swatchSelectedSkin.width = (getStyleValue("swatchWidth") as Number) + 2;
            swatchSelectedSkin.height = (getStyleValue("swatchHeight") as Number) + 2;
         }
      }
      
      protected function setColorWellColor(param1:ColorTransform) : void
      {
         var _loc2_:Object = null;
         if(!colorWell)
         {
            _loc2_ = getStyleValue("colorWell");
            if(_loc2_ != null)
            {
               colorWell = getDisplayObjectInstance(_loc2_) as DisplayObject;
            }
         }
         colorWell.transform.colorTransform = param1;
      }
      
      public function open() : void
      {
         var _loc1_:IFocusManager = null;
         if(!_enabled)
         {
            return;
         }
         doOpen = true;
         _loc1_ = focusManager;
         if(_loc1_)
         {
            _loc1_.defaultButtonEnabled = false;
         }
         invalidate(InvalidationType.STATE);
      }
      
      protected function createSwatch(param1:uint) : Sprite
      {
         var _loc2_:Sprite = null;
         var _loc3_:BaseButton = null;
         var _loc4_:Number = NaN;
         var _loc5_:Number = NaN;
         var _loc6_:Number = NaN;
         var _loc7_:Graphics = null;
         _loc2_ = new Sprite();
         _loc2_.useHandCursor = true;
         _loc2_.buttonMode = true;
         _loc3_ = new BaseButton();
         _loc3_.focusEnabled = false;
         _loc4_ = getStyleValue("swatchWidth") as Number;
         _loc5_ = getStyleValue("swatchHeight") as Number;
         _loc3_.setSize(_loc4_,_loc5_);
         _loc3_.transform.colorTransform = new ColorTransform(0,0,0,1,param1 >> 16,param1 >> 8 & 0xFF,param1 & 0xFF,0);
         copyStylesToChild(_loc3_,SWATCH_STYLES);
         _loc3_.mouseEnabled = false;
         _loc3_.drawNow();
         _loc3_.name = "color";
         _loc2_.addChild(_loc3_);
         _loc6_ = getStyleValue("swatchPadding") as Number;
         _loc7_ = _loc2_.graphics;
         _loc7_.beginFill(0);
         _loc7_.drawRect(-_loc6_,-_loc6_,_loc4_ + _loc6_ * 2,_loc5_ + _loc6_ * 2);
         _loc7_.endFill();
         _loc2_.addEventListener(MouseEvent.CLICK,onSwatchClick,false,0,true);
         _loc2_.addEventListener(MouseEvent.MOUSE_OVER,onSwatchOver,false,0,true);
         _loc2_.addEventListener(MouseEvent.MOUSE_OUT,onSwatchOut,false,0,true);
         return _loc2_;
      }
      
      protected function onSwatchOut(param1:MouseEvent) : void
      {
         var _loc2_:ColorTransform = null;
         _loc2_ = param1.target.transform.colorTransform;
         dispatchEvent(new ColorPickerEvent(ColorPickerEvent.ITEM_ROLL_OUT,_loc2_.color));
      }
      
      public function get editable() : Boolean
      {
         return _editable;
      }
      
      override protected function focusInHandler(param1:FocusEvent) : void
      {
         super.focusInHandler(param1);
         setIMEMode(true);
      }
      
      protected function onStageClick(param1:MouseEvent) : void
      {
         if(!contains(param1.target as DisplayObject) && !palette.contains(param1.target as DisplayObject))
         {
            selectedColor = _selectedColor;
            close();
         }
      }
      
      protected function onSwatchOver(param1:MouseEvent) : void
      {
         var _loc2_:BaseButton = null;
         var _loc3_:ColorTransform = null;
         _loc2_ = param1.target.getChildByName("color") as BaseButton;
         _loc3_ = _loc2_.transform.colorTransform;
         setColorWellColor(_loc3_);
         setSwatchHighlight(param1.target as Sprite);
         dispatchEvent(new ColorPickerEvent(ColorPickerEvent.ITEM_ROLL_OVER,_loc3_.color));
      }
      
      override public function set enabled(param1:Boolean) : void
      {
         super.enabled = param1;
         if(!param1)
         {
            close();
         }
         swatchButton.enabled = param1;
      }
      
      protected function drawBG() : void
      {
         var bg:Object = null;
         var padding:Number = NaN;
         bg = getStyleValue("background");
         if(bg != null)
         {
            paletteBG = getDisplayObjectInstance(bg) as Sprite;
         }
         if(paletteBG == null)
         {
            return;
         }
         padding = Number(getStyleValue("backgroundPadding"));
         try
         {
            paletteBG.width = swatches.width + padding * 2;
            paletteBG.height = swatches.y + swatches.height + padding;
         }
         catch(e:*)
         {
            paletteBG.width = getStyleValue("swatchWidth") as Number;
            paletteBG.height = getStyleValue("swatchHeight") as Number;
         }
         palette.addChildAt(paletteBG,0);
      }
      
      protected function drawPalette() : void
      {
         if(isOpen)
         {
            stage.removeChild(palette);
         }
         palette = new Sprite();
         drawSwatches();
         drawBG();
      }
      
      protected function addStageListener(param1:Event = null) : void
      {
         stage.addEventListener(MouseEvent.MOUSE_DOWN,onStageClick,false,0,true);
      }
      
      protected function showPalette() : void
      {
         var _loc1_:Sprite = null;
         if(isOpen)
         {
            positionPalette();
            return;
         }
         if(redrawPalette)
         {
            redrawPalette = false;
            this.drawPalette();
         }
         addEventListener(Event.ENTER_FRAME,addCloseListener,false,0,true);
         stage.addChild(palette);
         isOpen = true;
         positionPalette();
         dispatchEvent(new Event(Event.OPEN));
         _loc1_ = selectedSwatch;
         if(_loc1_ == null)
         {
            _loc1_ = findSwatch(_selectedColor);
         }
         setSwatchHighlight(_loc1_);
      }
      
      public function set editable(param1:Boolean) : void
      {
         _editable = param1;
         invalidate(InvalidationType.STATE);
      }
      
      public function set colors(param1:Array) : void
      {
         customColors = param1;
         invalidate(InvalidationType.DATA);
      }
      
      public function get imeMode() : String
      {
         return _imeMode;
      }
      
      public function set selectedColor(param1:uint) : void
      {
         var _loc2_:ColorTransform = null;
         if(!_enabled)
         {
            return;
         }
         _selectedColor = param1;
         rollOverColor = -1;
         currColIndex = currRowIndex = 0;
         _loc2_ = new ColorTransform();
         _loc2_.color = param1;
         setColorWellColor(_loc2_);
         invalidate(InvalidationType.DATA);
      }
      
      override protected function focusOutHandler(param1:FocusEvent) : void
      {
         if(isOpen)
         {
            close();
         }
         super.focusOutHandler(param1);
         setIMEMode(false);
      }
      
      protected function onPopupButtonClick(param1:MouseEvent) : void
      {
         if(isOpen)
         {
            close();
         }
         else
         {
            open();
         }
      }
      
      protected function positionPalette() : void
      {
         var _loc1_:Point = null;
         var _loc2_:Number = NaN;
         _loc1_ = swatchButton.localToGlobal(new Point(0,0));
         _loc2_ = getStyleValue("backgroundPadding") as Number;
         if(_loc1_.x + palette.width > stage.stageWidth)
         {
            palette.x = _loc1_.x - palette.width << 0;
         }
         else
         {
            palette.x = _loc1_.x + swatchButton.width + _loc2_ << 0;
         }
         palette.y = Math.max(0,Math.min(_loc1_.y,stage.stageHeight - palette.height)) << 0;
      }
      
      protected function setSwatchHighlight(param1:Sprite) : void
      {
         var _loc2_:Number = NaN;
         var _loc3_:* = undefined;
         if(param1 == null)
         {
            if(palette.contains(swatchSelectedSkin))
            {
               palette.removeChild(swatchSelectedSkin);
            }
            return;
         }
         if(!palette.contains(swatchSelectedSkin) && colors.length > 0)
         {
            palette.addChild(swatchSelectedSkin);
         }
         else if(!colors.length)
         {
            return;
         }
         _loc2_ = getStyleValue("swatchPadding") as Number;
         palette.setChildIndex(swatchSelectedSkin,palette.numChildren - 1);
         swatchSelectedSkin.x = swatches.x + param1.x - 1;
         swatchSelectedSkin.y = swatches.y + param1.y - 1;
         _loc3_ = param1.getChildByName("color").transform.colorTransform.color;
         currColIndex = colorHash[_loc3_].col;
         currRowIndex = colorHash[_loc3_].row;
      }
      
      override public function get enabled() : Boolean
      {
         return super.enabled;
      }
      
      protected function onSwatchClick(param1:MouseEvent) : void
      {
         var _loc2_:ColorTransform = null;
         _loc2_ = param1.target.getChildByName("color").transform.colorTransform;
         _selectedColor = _loc2_.color;
         dispatchEvent(new ColorPickerEvent(ColorPickerEvent.CHANGE,selectedColor));
         close();
      }
      
      override protected function draw() : void
      {
         if(isInvalid(InvalidationType.STYLES,InvalidationType.DATA))
         {
            setStyles();
            redrawPalette = true;
            if(isOpen && palette != null)
            {
               stage.removeChild(palette);
            }
            drawBG();
            invalidate(InvalidationType.DATA,false);
            invalidate(InvalidationType.STYLES,false);
         }
         if(isInvalid(InvalidationType.DATA))
         {
            drawSwatchHighlight();
            setColorDisplay();
         }
         if(isInvalid(InvalidationType.STATE))
         {
            if(doOpen)
            {
               doOpen = false;
               showPalette();
            }
            colorWell.visible = enabled;
         }
         if(isInvalid(InvalidationType.SIZE,InvalidationType.STYLES))
         {
            swatchButton.setSize(width,height);
            swatchButton.drawNow();
            colorWell.width = width;
            colorWell.height = height;
         }
         super.draw();
      }
      
      protected function drawSwatches() : void
      {
         var _loc1_:Number = NaN;
         var _loc2_:Number = NaN;
         var _loc3_:uint = 0;
         var _loc4_:uint = 0;
         var _loc5_:Number = NaN;
         var _loc6_:Number = NaN;
         var _loc7_:uint = 0;
         var _loc8_:int = 0;
         var _loc9_:uint = 0;
         var _loc10_:Sprite = null;
         _loc1_ = getStyleValue("backgroundPadding") as Number;
         _loc2_ = _loc1_;
         swatches = new Sprite();
         palette.addChild(swatches);
         swatches.x = _loc1_;
         swatches.y = _loc2_;
         _loc3_ = getStyleValue("columnCount") as uint;
         _loc4_ = getStyleValue("swatchPadding") as uint;
         _loc5_ = getStyleValue("swatchWidth") as Number;
         _loc6_ = getStyleValue("swatchHeight") as Number;
         colorHash = {};
         swatchMap = [];
         _loc7_ = Math.min(1024,colors.length);
         _loc8_ = -1;
         _loc9_ = 0;
         while(_loc9_ < _loc7_)
         {
            _loc10_ = createSwatch(colors[_loc9_]);
            _loc10_.x = (_loc5_ + _loc4_) * (_loc9_ % _loc3_);
            if(_loc10_.x == 0)
            {
               swatchMap.push([_loc10_]);
               _loc8_++;
            }
            else
            {
               swatchMap[_loc8_].push(_loc10_);
            }
            colorHash[colors[_loc9_]] = {
               "swatch":_loc10_,
               "row":_loc8_,
               "col":swatchMap[_loc8_].length - 1
            };
            _loc10_.y = Math.floor(_loc9_ / _loc3_) * (_loc6_ + _loc4_);
            swatches.addChild(_loc10_);
            _loc9_++;
         }
      }
      
      override protected function configUI() : void
      {
         var _loc1_:uint = 0;
         super.configUI();
         tabChildren = false;
         if(ColorPicker.defaultColors == null)
         {
            ColorPicker.defaultColors = [];
            _loc1_ = 0;
            while(_loc1_ < 216)
            {
               ColorPicker.defaultColors.push(((_loc1_ / 6 % 3 << 0) + (_loc1_ / 108 << 0) * 3) * 51 << 16 | _loc1_ % 6 * 51 << 8 | (_loc1_ / 18 << 0) % 6 * 51);
               _loc1_++;
            }
         }
         colorHash = {};
         swatchMap = [];
         swatchButton = new BaseButton();
         swatchButton.focusEnabled = false;
         swatchButton.useHandCursor = true;
         swatchButton.buttonMode = true;
         swatchButton.autoRepeat = false;
         swatchButton.setSize(25,25);
         swatchButton.addEventListener(MouseEvent.CLICK,onPopupButtonClick,false,0,true);
         addChild(swatchButton);
         palette = new Sprite();
         palette.tabChildren = false;
         palette.cacheAsBitmap = true;
      }
      
      public function get colors() : Array
      {
         return customColors != null ? customColors : ColorPicker.defaultColors;
      }
      
      protected function findSwatch(param1:uint) : Sprite
      {
         var _loc2_:Object = null;
         if(!swatchMap.length)
         {
            return null;
         }
         _loc2_ = colorHash[param1];
         if(_loc2_ != null)
         {
            return _loc2_.swatch;
         }
         return null;
      }
      
      protected function setColorDisplay() : void
      {
         var _loc1_:ColorTransform = null;
         var _loc2_:Sprite = null;
         _loc1_ = new ColorTransform(0,0,0,1,_selectedColor >> 16,_selectedColor >> 8 & 0xFF,_selectedColor & 0xFF,0);
         setColorWellColor(_loc1_);
         if(!swatchMap.length)
         {
            return;
         }
         _loc2_ = findSwatch(_selectedColor);
         setSwatchHighlight(_loc2_);
         if(Boolean(swatchMap.length) && colorHash[_selectedColor] == undefined)
         {
            cleanUpSelected();
         }
      }
      
      protected function cleanUpSelected() : void
      {
         if(Boolean(swatchSelectedSkin) && palette.contains(swatchSelectedSkin))
         {
            palette.removeChild(swatchSelectedSkin);
         }
      }
      
      public function get selectedColor() : uint
      {
         if(colorWell == null)
         {
            return 0;
         }
         return colorWell.transform.colorTransform.color;
      }
      
      private function addCloseListener(param1:Event) : *
      {
         removeEventListener(Event.ENTER_FRAME,addCloseListener);
         if(!isOpen)
         {
            return;
         }
         addStageListener();
      }
      
      protected function removeStageListener(param1:Event = null) : void
      {
         if(stage != null)
         {
            stage.removeEventListener(MouseEvent.MOUSE_DOWN,onStageClick,false);
         }
      }
      
      protected function setStyles() : void
      {
         var _loc1_:DisplayObject = null;
         var _loc2_:Object = null;
         _loc1_ = colorWell;
         _loc2_ = getStyleValue("colorWell");
         if(_loc2_ != null)
         {
            colorWell = getDisplayObjectInstance(_loc2_) as DisplayObject;
         }
         addChildAt(colorWell,getChildIndex(swatchButton));
         copyStylesToChild(swatchButton,POPUP_BUTTON_STYLES);
         swatchButton.drawNow();
         if(_loc1_ != null && contains(_loc1_) && _loc1_ != colorWell)
         {
            removeChild(_loc1_);
         }
      }
      
      public function close() : void
      {
         var _loc1_:IFocusManager = null;
         if(isOpen)
         {
            stage.removeChild(palette);
            isOpen = false;
            dispatchEvent(new Event(Event.CLOSE));
         }
         _loc1_ = focusManager;
         if(_loc1_)
         {
            _loc1_.defaultButtonEnabled = true;
         }
         removeStageListener();
         cleanUpSelected();
      }
   }
}

