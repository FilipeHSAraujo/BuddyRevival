package fl.controls
{
   import fl.core.InvalidationType;
   import fl.core.UIComponent;
   import fl.events.TexturePickerEvent;
   import fl.managers.IFocusManager;
   import fl.managers.IFocusManagerComponent;
   import flash.display.Bitmap;
   import flash.display.BitmapData;
   import flash.display.DisplayObject;
   import flash.display.DisplayObjectContainer;
   import flash.display.Graphics;
   import flash.display.Sprite;
   import flash.events.Event;
   import flash.events.FocusEvent;
   import flash.events.MouseEvent;
   import flash.geom.ColorTransform;
   import flash.geom.Matrix;
   import flash.geom.Point;
   import flash.geom.Rectangle;
   
   [Embed(source="/_assets/assets.swf", symbol="symbol47")]
   public class TexturePicker extends UIComponent implements IFocusManagerComponent
   {
      
      private static var defaultStyles:Object = {
         "upSkin":"TexturePicker_upSkin",
         "disabledSkin":"TexturePicker_disabledSkin",
         "overSkin":"TexturePicker_overSkin",
         "downSkin":"TexturePicker_downSkin",
         "colorWell":"TexturePicker_colorWell",
         "swatchSkin":"TexturePicker_swatchSkin",
         "swatchSelectedSkin":"TexturePicker_swatchSelectedSkin",
         "swatchWidth":36,
         "swatchHeight":36,
         "columnCount":4,
         "swatchPadding":1,
         "background":"TexturePicker_backgroundSkin",
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
      
      protected var customBitmaps:Array;
      
      protected var palette:Sprite;
      
      protected var isOpen:Boolean = false;
      
      protected var _colorWellIndex:uint;
      
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
      
      protected var _selectedBitmap:uint;
      
      protected var swatches:Sprite;
      
      public function TexturePicker()
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
      
      protected function setColorWellColor(param1:ColorTransform, param2:uint, param3:Bitmap = null) : void
      {
         var _loc4_:DisplayObjectContainer = null;
         var _loc5_:int = 0;
         var _loc6_:int = 0;
         var _loc7_:Number = NaN;
         var _loc8_:Number = NaN;
         var _loc9_:BitmapData = null;
         var _loc10_:Matrix = null;
         var _loc11_:Bitmap = null;
         var _loc12_:DisplayObject = null;
         if(!colorWell)
         {
            return;
         }
         _colorWellIndex = param2;
         _selectedBitmap = param2;
         if(param3 != null)
         {
            _loc4_ = DisplayObjectContainer(colorWell);
            _loc6_ = _loc5_ = _loc4_.numChildren;
            while(--_loc6_ >= 0)
            {
               _loc12_ = _loc4_.getChildAt(_loc6_);
               if(_loc12_ is Bitmap)
               {
                  _loc4_.removeChildAt(_loc6_);
                  Bitmap(_loc12_).bitmapData.dispose();
               }
            }
            _loc7_ = width - 3;
            _loc8_ = height - 3;
            _loc9_ = new BitmapData(_loc7_,_loc8_,false,16777215);
            _loc10_ = new Matrix();
            _loc10_.scale(_loc7_ / param3.width,_loc8_ / param3.height);
            _loc9_.draw(param3.bitmapData,_loc10_,null,null,null,true);
            _loc11_ = new Bitmap(_loc9_);
            _loc11_.smoothing = true;
            _loc11_.x = 1;
            _loc11_.y = 1;
            _loc4_.addChild(_loc11_);
         }
      }
      
      public function set bitmaps(param1:Array) : void
      {
         var _loc2_:int = 0;
         var _loc3_:Array = null;
         var _loc4_:int = 0;
         customBitmaps = param1;
         _loc2_ = int(param1.length);
         _loc3_ = new Array(_loc2_);
         _loc4_ = 0;
         while(_loc4_ < _loc2_)
         {
            _loc3_[_loc4_] = _loc4_;
            _loc4_++;
         }
         colors = _loc3_;
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
         _loc7_.beginFill(14803425);
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
         dispatchEvent(new TexturePickerEvent(TexturePickerEvent.ITEM_ROLL_OUT,_loc2_.color));
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
         var _loc4_:Bitmap = null;
         _loc2_ = param1.target.getChildByName("color") as BaseButton;
         _loc3_ = _loc2_.transform.colorTransform;
         _loc4_ = customBitmaps == null ? null : customBitmaps[_loc3_.color];
         setColorWellColor(_loc3_,_loc3_.color,_loc4_);
         setSwatchHighlight(param1.target as Sprite);
         dispatchEvent(new TexturePickerEvent(TexturePickerEvent.ITEM_ROLL_OVER,_loc3_.color));
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
         var _loc1_:Object = null;
         var _loc2_:Number = NaN;
         _loc1_ = getStyleValue("background");
         if(_loc1_ != null)
         {
            paletteBG = getDisplayObjectInstance(_loc1_) as Sprite;
         }
         if(paletteBG == null)
         {
            return;
         }
         _loc2_ = Number(getStyleValue("backgroundPadding"));
         paletteBG.width = Math.max(0,swatches.width) + _loc2_ * 2;
         paletteBG.height = swatches.y + swatches.height + _loc2_;
         palette.addChildAt(paletteBG,0);
      }
      
      protected function addStageListener(param1:Event = null) : void
      {
         stage.addEventListener(MouseEvent.MOUSE_DOWN,onStageClick,false,0,true);
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
      
      protected function showPalette() : void
      {
         var _loc1_:Sprite = null;
         if(isOpen)
         {
            positionPalette();
            return;
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
         var _loc2_:Bitmap = null;
         var _loc3_:ColorTransform = null;
         if(!_enabled)
         {
            return;
         }
         _selectedColor = param1;
         rollOverColor = -1;
         currColIndex = currRowIndex = 0;
         _loc2_ = customBitmaps == null ? null : customBitmaps[_selectedColor];
         _loc3_ = new ColorTransform();
         _loc3_.color = param1;
         setColorWellColor(_loc3_,_selectedColor,_loc2_);
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
         var _loc3_:Rectangle = null;
         _loc1_ = swatchButton.localToGlobal(new Point(0,0));
         _loc2_ = getStyleValue("backgroundPadding") as Number;
         _loc3_ = palette.getBounds(palette);
         if(_loc1_.x + _loc3_.width + 15 > stage.stageWidth)
         {
            palette.x = _loc1_.x - _loc3_.width << 0;
         }
         else
         {
            palette.x = _loc1_.x + swatchButton.width + _loc2_ << 0;
         }
         palette.y = Math.max(0,Math.min(_loc1_.y,stage.stageHeight - _loc3_.height)) << 0;
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
         dispatchEvent(new TexturePickerEvent(TexturePickerEvent.CHANGE,selectedColor));
         close();
      }
      
      override protected function draw() : void
      {
         if(isInvalid(InvalidationType.STYLES,InvalidationType.DATA))
         {
            setStyles();
            drawPalette();
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
         var _loc11_:Bitmap = null;
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
            if(customBitmaps != null)
            {
               _loc11_ = customBitmaps[_loc9_];
               _loc10_.addChild(_loc11_);
            }
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
         super.configUI();
         tabChildren = false;
         colorHash = {};
         swatchMap = [];
         swatchButton = new BaseButton();
         swatchButton.focusEnabled = false;
         swatchButton.useHandCursor = true;
         swatchButton.buttonMode = true;
         swatchButton.autoRepeat = false;
         swatchButton.setSize(37,37);
         swatchButton.addEventListener(MouseEvent.CLICK,onPopupButtonClick,false,0,true);
         addChild(swatchButton);
         palette = new Sprite();
         palette.tabChildren = false;
         palette.cacheAsBitmap = true;
      }
      
      public function get colors() : Array
      {
         return customColors;
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
         var _loc2_:Bitmap = null;
         var _loc3_:Sprite = null;
         if(!swatchMap.length)
         {
            return;
         }
         _loc1_ = new ColorTransform(0,0,0,1,_selectedColor >> 16,_selectedColor >> 8 & 0xFF,_selectedColor & 0xFF,0);
         _loc2_ = customBitmaps == null ? null : customBitmaps[_selectedColor];
         setColorWellColor(_loc1_,_selectedColor,_loc2_);
         _loc3_ = findSwatch(_selectedColor);
         setSwatchHighlight(_loc3_);
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
         return _colorWellIndex;
      }
      
      public function get selectedBitmap() : uint
      {
         if(colorWell == null)
         {
            return 0;
         }
         return _selectedBitmap;
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
         var _loc3_:Sprite = null;
         _loc1_ = colorWell;
         _loc2_ = getStyleValue("colorWell");
         if(_loc2_ != null)
         {
            colorWell = getDisplayObjectInstance(_loc2_) as DisplayObject;
         }
         addChildAt(colorWell,getChildIndex(swatchButton));
         _loc3_ = new Sprite();
         _loc3_.graphics.beginFill(16777215);
         _loc3_.graphics.drawRect(0,0,width,height);
         addChild(_loc3_);
         colorWell.mask = _loc3_;
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

