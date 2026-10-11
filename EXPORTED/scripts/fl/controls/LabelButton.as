package fl.controls
{
   import fl.core.InvalidationType;
   import fl.core.UIComponent;
   import fl.events.ComponentEvent;
   import fl.managers.IFocusManagerComponent;
   import flash.display.DisplayObject;
   import flash.events.Event;
   import flash.events.KeyboardEvent;
   import flash.events.MouseEvent;
   import flash.text.TextField;
   import flash.text.TextFieldType;
   import flash.text.TextFormat;
   import flash.ui.Keyboard;
   
   public class LabelButton extends BaseButton implements IFocusManagerComponent
   {
      
      public static var createAccessibilityImplementation:Function;
      
      private static var defaultStyles:Object = {
         "icon":null,
         "upIcon":null,
         "downIcon":null,
         "overIcon":null,
         "disabledIcon":null,
         "selectedDisabledIcon":null,
         "selectedUpIcon":null,
         "selectedDownIcon":null,
         "selectedOverIcon":null,
         "textFormat":null,
         "disabledTextFormat":null,
         "textPadding":5,
         "embedFonts":false
      };
      
      protected var _labelPlacement:String = ButtonLabelPlacement.RIGHT;
      
      protected var _toggle:Boolean = false;
      
      protected var icon:DisplayObject;
      
      protected var oldMouseState:String;
      
      protected var mode:String = "center";
      
      public var textField:TextField;
      
      protected var _label:String = "Label";
      
      public function LabelButton()
      {
         super();
      }
      
      public static function getStyleDefinition() : Object
      {
         return mergeStyles(defaultStyles,BaseButton.getStyleDefinition());
      }
      
      protected function toggleSelected(param1:MouseEvent) : void
      {
         selected = !selected;
         dispatchEvent(new Event(Event.CHANGE,true));
      }
      
      public function get labelPlacement() : String
      {
         return _labelPlacement;
      }
      
      override protected function keyDownHandler(param1:KeyboardEvent) : void
      {
         if(!enabled)
         {
            return;
         }
         if(param1.keyCode == Keyboard.SPACE)
         {
            if(oldMouseState == null)
            {
               oldMouseState = mouseState;
            }
            setMouseState("down");
            startPress();
         }
      }
      
      protected function setEmbedFont() : *
      {
         var _loc1_:Object = null;
         _loc1_ = getStyleValue("embedFonts");
         if(_loc1_ != null)
         {
            textField.embedFonts = _loc1_;
         }
      }
      
      override protected function keyUpHandler(param1:KeyboardEvent) : void
      {
         if(!enabled)
         {
            return;
         }
         if(param1.keyCode == Keyboard.SPACE)
         {
            setMouseState(oldMouseState);
            oldMouseState = null;
            endPress();
            dispatchEvent(new MouseEvent(MouseEvent.CLICK));
         }
      }
      
      override public function get selected() : Boolean
      {
         return _toggle ? _selected : false;
      }
      
      public function set labelPlacement(param1:String) : void
      {
         _labelPlacement = param1;
         invalidate(InvalidationType.SIZE);
      }
      
      public function set toggle(param1:Boolean) : void
      {
         if(!param1 && super.selected)
         {
            selected = false;
         }
         _toggle = param1;
         if(_toggle)
         {
            addEventListener(MouseEvent.CLICK,toggleSelected,false,0,true);
         }
         else
         {
            removeEventListener(MouseEvent.CLICK,toggleSelected);
         }
         invalidate(InvalidationType.STATE);
      }
      
      public function get label() : String
      {
         return _label;
      }
      
      override public function set selected(param1:Boolean) : void
      {
         _selected = param1;
         if(_toggle)
         {
            invalidate(InvalidationType.STATE);
         }
      }
      
      override protected function draw() : void
      {
         if(textField.text != _label)
         {
            label = _label;
         }
         if(isInvalid(InvalidationType.STYLES,InvalidationType.STATE))
         {
            drawBackground();
            drawIcon();
            drawTextFormat();
            invalidate(InvalidationType.SIZE,false);
         }
         if(isInvalid(InvalidationType.SIZE))
         {
            drawLayout();
         }
         if(isInvalid(InvalidationType.SIZE,InvalidationType.STYLES))
         {
            if(isFocused && focusManager.showFocusIndicator)
            {
               drawFocus(true);
            }
         }
         validate();
      }
      
      public function get toggle() : Boolean
      {
         return _toggle;
      }
      
      override protected function configUI() : void
      {
         super.configUI();
         textField = new TextField();
         textField.type = TextFieldType.DYNAMIC;
         textField.selectable = false;
         addChild(textField);
      }
      
      override protected function drawLayout() : void
      {
         var _loc1_:Number = NaN;
         var _loc2_:String = null;
         var _loc3_:Number = NaN;
         var _loc4_:Number = NaN;
         var _loc5_:Number = NaN;
         var _loc6_:Number = NaN;
         var _loc7_:Number = NaN;
         var _loc8_:Number = NaN;
         _loc1_ = Number(getStyleValue("textPadding"));
         _loc2_ = icon == null && mode == "center" ? ButtonLabelPlacement.TOP : _labelPlacement;
         textField.height = textField.textHeight + 4;
         _loc3_ = textField.textWidth + 4;
         _loc4_ = textField.textHeight + 4;
         _loc5_ = icon == null ? 0 : icon.width + _loc1_;
         _loc6_ = icon == null ? 0 : icon.height + _loc1_;
         textField.visible = label.length > 0;
         if(icon != null)
         {
            icon.x = Math.round((width - icon.width) / 2);
            icon.y = Math.round((height - icon.height) / 2);
         }
         if(textField.visible == false)
         {
            textField.width = 0;
            textField.height = 0;
         }
         else if(_loc2_ == ButtonLabelPlacement.BOTTOM || _loc2_ == ButtonLabelPlacement.TOP)
         {
            _loc7_ = Math.max(0,Math.min(_loc3_,width - 2 * _loc1_));
            if(height - 2 > _loc4_)
            {
               _loc8_ = _loc4_;
            }
            else
            {
               _loc8_ = height - 2;
            }
            textField.width = _loc3_ = _loc7_;
            textField.height = _loc4_ = _loc8_;
            textField.x = Math.round((width - _loc3_) / 2);
            textField.y = Math.round((height - textField.height - _loc6_) / 2 + (_loc2_ == ButtonLabelPlacement.BOTTOM ? _loc6_ : 0));
            if(icon != null)
            {
               icon.y = Math.round(_loc2_ == ButtonLabelPlacement.BOTTOM ? textField.y - _loc6_ : textField.y + textField.height + _loc1_);
            }
         }
         else
         {
            _loc7_ = Math.max(0,Math.min(_loc3_,width - _loc5_ - 2 * _loc1_));
            textField.width = _loc3_ = _loc7_;
            textField.x = Math.round((width - _loc3_ - _loc5_) / 2 + (_loc2_ != ButtonLabelPlacement.LEFT ? _loc5_ : 0));
            textField.y = Math.round((height - textField.height) / 2);
            if(icon != null)
            {
               icon.x = Math.round(_loc2_ != ButtonLabelPlacement.LEFT ? textField.x - _loc5_ : textField.x + _loc3_ + _loc1_);
            }
         }
         super.drawLayout();
      }
      
      override protected function initializeAccessibility() : void
      {
         if(LabelButton.createAccessibilityImplementation != null)
         {
            LabelButton.createAccessibilityImplementation(this);
         }
      }
      
      protected function drawIcon() : void
      {
         var _loc1_:DisplayObject = null;
         var _loc2_:* = null;
         var _loc3_:Object = null;
         _loc1_ = icon;
         _loc2_ = enabled ? mouseState : "disabled";
         if(selected)
         {
            _loc2_ = "selected" + _loc2_.substr(0,1).toUpperCase() + _loc2_.substr(1);
         }
         _loc2_ += "Icon";
         _loc3_ = getStyleValue(_loc2_);
         if(_loc3_ == null)
         {
            _loc3_ = getStyleValue("icon");
         }
         if(_loc3_ != null)
         {
            icon = getDisplayObjectInstance(_loc3_);
         }
         if(icon != null)
         {
            addChildAt(icon,1);
         }
         if(_loc1_ != null && _loc1_ != icon)
         {
            removeChild(_loc1_);
         }
      }
      
      public function set label(param1:String) : void
      {
         _label = param1;
         if(textField.text != _label)
         {
            textField.text = _label;
            dispatchEvent(new ComponentEvent(ComponentEvent.LABEL_CHANGE));
         }
         invalidate(InvalidationType.SIZE);
         invalidate(InvalidationType.STYLES);
      }
      
      protected function drawTextFormat() : void
      {
         var _loc1_:Object = null;
         var _loc2_:TextFormat = null;
         var _loc3_:TextFormat = null;
         _loc1_ = UIComponent.getStyleDefinition();
         _loc2_ = enabled ? _loc1_.defaultTextFormat as TextFormat : _loc1_.defaultDisabledTextFormat as TextFormat;
         textField.setTextFormat(_loc2_);
         _loc3_ = getStyleValue(enabled ? "textFormat" : "disabledTextFormat") as TextFormat;
         if(_loc3_ != null)
         {
            textField.setTextFormat(_loc3_);
         }
         else
         {
            _loc3_ = _loc2_;
         }
         textField.defaultTextFormat = _loc3_;
         setEmbedFont();
      }
   }
}

