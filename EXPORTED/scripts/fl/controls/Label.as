package fl.controls
{
   import fl.core.InvalidationType;
   import fl.core.UIComponent;
   import fl.events.ComponentEvent;
   import flash.text.TextField;
   import flash.text.TextFieldAutoSize;
   import flash.text.TextFieldType;
   import flash.text.TextFormat;
   
   [Embed(source="/_assets/assets.swf", symbol="symbol135")]
   public class Label extends UIComponent
   {
      
      private static var defaultStyles:Object = {
         "textFormat":null,
         "embedFonts":false
      };
      
      protected var actualHeight:Number;
      
      protected var _html:Boolean = false;
      
      protected var actualWidth:Number;
      
      protected var defaultLabel:String = "Label";
      
      protected var _savedHTML:String;
      
      public var textField:TextField;
      
      public function Label()
      {
         super();
         text = defaultLabel;
         actualWidth = _width;
         actualHeight = _height;
      }
      
      public static function getStyleDefinition() : Object
      {
         return defaultStyles;
      }
      
      public function get autoSize() : String
      {
         return textField.autoSize;
      }
      
      public function get selectable() : Boolean
      {
         return textField.selectable;
      }
      
      public function set text(param1:String) : void
      {
         if(param1 == text)
         {
            return;
         }
         if(componentInspectorSetting && param1 == defaultLabel)
         {
            return;
         }
         _html = false;
         textField.text = param1;
         if(textField.autoSize != TextFieldAutoSize.NONE)
         {
            invalidate(InvalidationType.SIZE);
         }
      }
      
      public function get wordWrap() : Boolean
      {
         return textField.wordWrap;
      }
      
      public function set condenseWhite(param1:Boolean) : void
      {
         textField.condenseWhite = param1;
         if(textField.autoSize != TextFieldAutoSize.NONE)
         {
            invalidate(InvalidationType.SIZE);
         }
      }
      
      public function set selectable(param1:Boolean) : void
      {
         textField.selectable = param1;
      }
      
      public function set autoSize(param1:String) : void
      {
         textField.autoSize = param1;
         invalidate(InvalidationType.SIZE);
      }
      
      public function set wordWrap(param1:Boolean) : void
      {
         textField.wordWrap = param1;
         if(textField.autoSize != TextFieldAutoSize.NONE)
         {
            invalidate(InvalidationType.SIZE);
         }
      }
      
      override public function get height() : Number
      {
         if(textField.autoSize != TextFieldAutoSize.NONE && wordWrap)
         {
            return _height;
         }
         return actualHeight;
      }
      
      public function set htmlText(param1:String) : void
      {
         if(param1 == htmlText)
         {
            return;
         }
         if(componentInspectorSetting && param1 == "")
         {
            return;
         }
         _html = true;
         _savedHTML = param1;
         textField.htmlText = param1;
         if(textField.autoSize != TextFieldAutoSize.NONE)
         {
            invalidate(InvalidationType.SIZE);
         }
      }
      
      public function get text() : String
      {
         return textField.text;
      }
      
      public function get condenseWhite() : Boolean
      {
         return textField.condenseWhite;
      }
      
      override protected function draw() : void
      {
         var _loc1_:Object = null;
         if(isInvalid(InvalidationType.STYLES,InvalidationType.STATE))
         {
            drawTextFormat();
            _loc1_ = getStyleValue("embedFonts");
            if(_loc1_ != null)
            {
               textField.embedFonts = _loc1_;
            }
            if(textField.autoSize != TextFieldAutoSize.NONE)
            {
               invalidate(InvalidationType.SIZE,false);
            }
         }
         if(isInvalid(InvalidationType.SIZE))
         {
            drawLayout();
         }
         super.draw();
      }
      
      override protected function configUI() : void
      {
         super.configUI();
         textField = new TextField();
         addChild(textField);
         textField.type = TextFieldType.DYNAMIC;
         textField.selectable = false;
         textField.wordWrap = false;
      }
      
      public function get htmlText() : String
      {
         return textField.htmlText;
      }
      
      override public function setSize(param1:Number, param2:Number) : void
      {
         actualWidth = param1;
         actualHeight = param2;
         super.setSize(param1,param2);
      }
      
      override public function set width(param1:Number) : void
      {
         actualWidth = param1;
         super.width = param1;
      }
      
      protected function drawLayout() : void
      {
         var _loc1_:Boolean = false;
         var _loc2_:Number = NaN;
         var _loc3_:Number = NaN;
         _loc1_ = false;
         textField.width = width;
         textField.height = height;
         if(textField.autoSize != TextFieldAutoSize.NONE)
         {
            _loc2_ = textField.width;
            _loc3_ = textField.height;
            _loc1_ = _width != _loc2_ || _height != _loc3_;
            _width = _loc2_;
            _height = _loc3_;
            switch(textField.autoSize)
            {
               case TextFieldAutoSize.CENTER:
                  textField.x = actualWidth / 2 - textField.width / 2;
                  break;
               case TextFieldAutoSize.LEFT:
                  textField.x = 0;
                  break;
               case TextFieldAutoSize.RIGHT:
                  textField.x = -(textField.width - actualWidth);
            }
         }
         else
         {
            textField.width = actualWidth;
            textField.height = actualHeight;
            textField.x = 0;
         }
         if(_loc1_)
         {
            dispatchEvent(new ComponentEvent(ComponentEvent.RESIZE,true));
         }
      }
      
      override public function get width() : Number
      {
         if(textField.autoSize != TextFieldAutoSize.NONE && !wordWrap)
         {
            return _width;
         }
         return actualWidth;
      }
      
      protected function drawTextFormat() : void
      {
         var _loc1_:TextFormat = null;
         var _loc2_:Object = null;
         _loc1_ = getStyleValue("textFormat") as TextFormat;
         if(_loc1_ == null)
         {
            _loc2_ = UIComponent.getStyleDefinition();
            _loc1_ = enabled ? _loc2_.defaultTextFormat as TextFormat : _loc2_.defaultDisabledTextFormat as TextFormat;
         }
         textField.defaultTextFormat = _loc1_;
         textField.setTextFormat(_loc1_);
         if(_html && _savedHTML != null)
         {
            htmlText = _savedHTML;
         }
      }
   }
}

