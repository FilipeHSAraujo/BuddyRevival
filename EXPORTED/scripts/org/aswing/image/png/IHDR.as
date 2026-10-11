package org.aswing.image.png
{
   import flash.utils.ByteArray;
   
   public class IHDR implements Chunk
   {
      
      public static const CT_GreyScale:int = 0;
      
      public static const CT_TrueColor:int = 2;
      
      public static const CT_IndexedColor:int = 3;
      
      public static const CT_GreyScale_Alpha:int = 4;
      
      public static const CT_TrueColor_Alpha:int = 6;
      
      public static const ByteDepth_1:int = 1;
      
      public static const ByteDepth_2:int = 2;
      
      public static const ByteDepth_4:int = 4;
      
      public static const ByteDepth_8:int = 8;
      
      public static const ByteDepth_16:int = 16;
      
      public var width:int;
      
      public var height:int;
      
      public var interlaceMethod:int = 0;
      
      public var bitDepth:int;
      
      public var filterMethod:int = 0;
      
      public var colorType:int;
      
      public var compressionMethod:int = 0;
      
      public function IHDR(param1:int, param2:int, param3:int = 8, param4:int = 6)
      {
         super();
         this.width = param1;
         this.height = param2;
         this.bitDepth = param3;
         this.colorType = param4;
         this.compressionMethod = 0;
         this.filterMethod = 0;
         this.interlaceMethod = 0;
      }
      
      public function getData() : ByteArray
      {
         if(bitDepth == ByteDepth_1 || bitDepth == ByteDepth_2 || bitDepth == ByteDepth_4)
         {
            if(colorType != CT_GreyScale && colorType != CT_IndexedColor)
            {
               throw new PngError("BitDepth 1, 2 or 4 only can be used for GreyScale and IndexedColor!");
            }
         }
         else if(bitDepth == ByteDepth_16)
         {
            if(colorType == CT_IndexedColor)
            {
               throw new PngError("BitDepth 16 can\'t be used for IndexedColor!");
            }
         }
         var _loc1_:ByteArray = new ByteArray();
         _loc1_.writeInt(width);
         _loc1_.writeInt(height);
         _loc1_.writeByte(bitDepth);
         _loc1_.writeByte(colorType);
         _loc1_.writeByte(compressionMethod);
         _loc1_.writeByte(filterMethod);
         _loc1_.writeByte(interlaceMethod);
         return _loc1_;
      }
      
      public function getType() : uint
      {
         return 1229472850;
      }
   }
}

