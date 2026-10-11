package fl.controls
{
   import fl.managers.IFocusManager;
   import fl.managers.IFocusManagerGroup;
   import flash.display.DisplayObject;
   import flash.display.Graphics;
   import flash.display.Shape;
   import flash.events.Event;
   import flash.events.KeyboardEvent;
   import flash.events.MouseEvent;
   import flash.ui.Keyboard;
   
   [Embed(source="/_assets/assets.swf", symbol="symbol151")]
   public class RadioButton extends LabelButton implements IFocusManagerGroup
   {
      
      public static var createAccessibilityImplementation:Function;
      
      private static var defaultStyles:Object = {
         "icon":null,
         "upIcon":"RadioButton_upIcon",
         "downIcon":"RadioButton_downIcon",
         "overIcon":"RadioButton_overIcon",
         "disabledIcon":"RadioButton_disabledIcon",
         "selectedDisabledIcon":"RadioButton_selectedDisabledIcon",
         "selectedUpIcon":"RadioButton_selectedUpIcon",
         "selectedDownIcon":"RadioButton_selectedDownIcon",
         "selectedOverIcon":"RadioButton_selectedOverIcon",
         "focusRectSkin":null,
         "focusRectPadding":null,
         "textFormat":null,
         "disabledTextFormat":null,
         "embedFonts":null,
         "textPadding":5
      };
      
      protected var _value:Object;
      
      protected var defaultGroupName:String = "RadioButtonGroup";
      
      protected var _group:RadioButtonGroup;
      
      public function RadioButton()
      {
         super();
         mode = "border";
         groupName = defaultGroupName;
      }
      
      public static function getStyleDefinition() : Object
      {
         return defaultStyles;
      }
      
      override public function drawFocus(param1:Boolean) : void
      {
         var _loc2_:Number = NaN;
         super.drawFocus(param1);
         if(param1)
         {
            _loc2_ = Number(getStyleValue("focusRectPadding"));
            uiFocusRect.x = background.x - _loc2_;
            uiFocusRect.y = background.y - _loc2_;
            uiFocusRect.width = background.width + _loc2_ * 2;
            uiFocusRect.height = background.height + _loc2_ * 2;
         }
      }
      
      private function setThis() : void
      {
         var _loc1_:RadioButtonGroup = null;
         _loc1_ = _group;
         if(_loc1_ != null)
         {
            if(_loc1_.selection != this)
            {
               _loc1_.selection = this;
            }
         }
         else
         {
            super.selected = true;
         }
      }
      
      override public function get autoRepeat() : Boolean
      {
         return false;
      }
      
      override public function set autoRepeat(param1:Boolean) : void
      {
      }
      
      protected function handleClick(param1:MouseEvent) : void
      {
         if(_group == null)
         {
            return;
         }
         _group.dispatchEvent(new MouseEvent(MouseEvent.CLICK,true));
      }
      
      override protected function keyDownHandler(param1:KeyboardEvent) : void
      {
         switch(param1.keyCode)
         {
            case Keyboard.DOWN:
               setNext(!param1.ctrlKey);
               param1.stopPropagation();
               break;
            case Keyboard.UP:
               setPrev(!param1.ctrlKey);
               param1.stopPropagation();
               break;
            case Keyboard.LEFT:
               setPrev(!param1.ctrlKey);
               param1.stopPropagation();
               break;
            case Keyboard.RIGHT:
               setNext(!param1.ctrlKey);
               param1.stopPropagation();
               break;
            case Keyboard.SPACE:
               setThis();
               _toggle = false;
            default:
               super.keyDownHandler(param1);
         }
      }
      
      private function setNext(param1:Boolean = true) : void
      {
         var _loc2_:RadioButtonGroup = null;
         var _loc3_:IFocusManager = null;
         var _loc4_:int = 0;
         var _loc5_:Number = NaN;
         var _loc6_:int = 0;
         var _loc7_:* = undefined;
         _loc2_ = _group;
         if(_loc2_ == null)
         {
            return;
         }
         _loc3_ = focusManager;
         if(_loc3_)
         {
            _loc3_.showFocusIndicator = true;
         }
         _loc4_ = _loc2_.getRadioButtonIndex(this);
         _loc5_ = _loc2_.numRadioButtons;
         _loc6_ = _loc4_;
         if(_loc4_ != -1)
         {
            do
            {
               _loc6_ = ++_loc6_ > _loc2_.numRadioButtons - 1 ? 0 : int(_loc6_);
               _loc7_ = _loc2_.getRadioButtonAt(_loc6_);
               if((_loc7_) && Boolean(_loc7_.enabled))
               {
                  if(param1)
                  {
                     _loc2_.selection = _loc7_;
                  }
                  _loc7_.setFocus();
                  return;
               }
               if(param1 && _loc2_.getRadioButtonAt(_loc6_) != _loc2_.selection)
               {
                  _loc2_.selection = this;
               }
               this.drawFocus(true);
            }
            while(_loc6_ != _loc4_);
            
         }
      }
      
      public function get group() : RadioButtonGroup
      {
         return _group;
      }
      
      override protected function keyUpHandler(param1:KeyboardEvent) : void
      {
         super.keyUpHandler(param1);
         if(param1.keyCode == Keyboard.SPACE && !_toggle)
         {
            _toggle = true;
         }
      }
      
      override public function get selected() : Boolean
      {
         return super.selected;
      }
      
      override public function set toggle(param1:Boolean) : void
      {
         throw new Error("Warning: You cannot change a RadioButtons toggle.");
      }
      
      public function set value(param1:Object) : void
      {
         _value = param1;
      }
      
      public function set group(param1:RadioButtonGroup) : void
      {
         groupName = param1.name;
      }
      
      override public function set selected(param1:Boolean) : void
      {
         if(param1 == false || selected)
         {
            return;
         }
         if(_group != null)
         {
            _group.selection = this;
         }
         else
         {
            super.selected = param1;
         }
      }
      
      override protected function draw() : void
      {
         super.draw();
      }
      
      override public function get toggle() : Boolean
      {
         return true;
      }
      
      override protected function configUI() : void
      {
         var _loc1_:Shape = null;
         var _loc2_:Graphics = null;
         super.configUI();
         super.toggle = true;
         _loc1_ = new Shape();
         _loc2_ = _loc1_.graphics;
         _loc2_.beginFill(0,0);
         _loc2_.drawRect(0,0,100,100);
         _loc2_.endFill();
         background = _loc1_ as DisplayObject;
         addChildAt(background,0);
         addEventListener(MouseEvent.CLICK,handleClick,false,0,true);
      }
      
      public function set groupName(param1:String) : void
      {
         if(_group != null)
         {
            _group.removeRadioButton(this);
            _group.removeEventListener(Event.CHANGE,handleChange);
         }
         _group = param1 == null ? null : RadioButtonGroup.getGroup(param1);
         if(_group != null)
         {
            _group.addRadioButton(this);
            _group.addEventListener(Event.CHANGE,handleChange,false,0,true);
         }
      }
      
      public function get value() : Object
      {
         return _value;
      }
      
      override protected function drawLayout() : void
      {
         var _loc1_:Number = NaN;
         super.drawLayout();
         _loc1_ = Number(getStyleValue("textPadding"));
         switch(_labelPlacement)
         {
            case ButtonLabelPlacement.RIGHT:
               icon.x = _loc1_;
               textField.x = icon.x + (icon.width + _loc1_);
               background.width = textField.x + textField.width + _loc1_;
               background.height = Math.max(textField.height,icon.height) + _loc1_ * 2;
               break;
            case ButtonLabelPlacement.LEFT:
               icon.x = width - icon.width - _loc1_;
               textField.x = width - icon.width - _loc1_ * 2 - textField.width;
               background.width = textField.width + icon.width + _loc1_ * 3;
               background.height = Math.max(textField.height,icon.height) + _loc1_ * 2;
               break;
            case ButtonLabelPlacement.TOP:
            case ButtonLabelPlacement.BOTTOM:
               background.width = Math.max(textField.width,icon.width) + _loc1_ * 2;
               background.height = textField.height + icon.height + _loc1_ * 3;
         }
         background.x = Math.min(icon.x - _loc1_,textField.x - _loc1_);
         background.y = Math.min(icon.y - _loc1_,textField.y - _loc1_);
      }
      
      override protected function drawBackground() : void
      {
      }
      
      override protected function initializeAccessibility() : void
      {
         if(RadioButton.createAccessibilityImplementation != null)
         {
            RadioButton.createAccessibilityImplementation(this);
         }
      }
      
      public function get groupName() : String
      {
         return _group == null ? null : _group.name;
      }
      
      private function setPrev(param1:Boolean = true) : void
      {
         var _loc2_:RadioButtonGroup = null;
         var _loc3_:IFocusManager = null;
         var _loc4_:int = 0;
         var _loc5_:int = 0;
         var _loc6_:* = undefined;
         _loc2_ = _group;
         if(_loc2_ == null)
         {
            return;
         }
         _loc3_ = focusManager;
         if(_loc3_)
         {
            _loc3_.showFocusIndicator = true;
         }
         _loc5_ = _loc4_ = _loc2_.getRadioButtonIndex(this);
         if(_loc4_ != -1)
         {
            do
            {
               _loc5_ = --_loc5_ == -1 ? int(_loc2_.numRadioButtons - 1) : int(_loc5_);
               _loc6_ = _loc2_.getRadioButtonAt(_loc5_);
               if((_loc6_) && Boolean(_loc6_.enabled))
               {
                  if(param1)
                  {
                     _loc2_.selection = _loc6_;
                  }
                  _loc6_.setFocus();
                  return;
               }
               if(param1 && _loc2_.getRadioButtonAt(_loc5_) != _loc2_.selection)
               {
                  _loc2_.selection = this;
               }
               this.drawFocus(true);
            }
            while(_loc5_ != _loc4_);
            
         }
      }
      
      protected function handleChange(param1:Event) : void
      {
         super.selected = _group.selection == this;
         dispatchEvent(new Event(Event.CHANGE,true));
      }
   }
}

