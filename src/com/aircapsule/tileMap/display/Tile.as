package com.aircapsule.tileMap.display
{
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.Shape;
	import flash.display.Sprite;
	import flash.geom.Rectangle;
	
	/**
	 * 
	 * @author Liy
	 * 
	 */	
	public class Tile extends Sprite
	{
		protected var _bmd:BitmapData;
		
		protected var _bmp:Bitmap;
		
		protected var _rect:Rectangle;
		
		protected var _selected:Boolean = false;
		
		protected var _shape:Shape;
		
		protected var _refCount:int=0;
		
		/**
		 * Reference 
		 * @param $bmd
		 * 
		 */		
		public function Tile($bmd:BitmapData, $rect:Rectangle)
		{
			_bmd = $bmd;
			_bmp = new Bitmap(_bmd);
			this.addChild(_bmp);
			
			_rect = $rect;
			
			_shape = new Shape();
			this.addChild(_shape);
		}
		
		/**
		 * Call it carefully!!!! 
		 * 
		 */		
		public function destroy():void{
			// do nothing if the reference count is not 0 yet
			// but reduce the reference count
			if(_refCount > 0){
				--_refCount;
				return;
			}
			
			// bitmap data should not be disposed, since it is just a reference
			_bmd = null;
			_rect = null;
			
			// TODO: SHOULD NOT NEED TO CHECK NULL OR NOT, SINCE THE REFERENCE COUNT WILL BE ENOUGHT
			// when redo list is destroyed, all the related old tiles will be destroyed
			// the PaintHistory can have same tile reference in the old tile vector several times
			// and destroy several times, therefore we have to check whether the shape is null or not.
			if(_shape != null){
				this.removeChild(_shape);
				_shape = null;
			}
			if(_bmp != null){
				this.removeChild(_bmp);
				_bmp = null;
			}
			_refCount = 0;
		}
		
		public function set selected($flag):void{
			_selected = $flag;
			
			// FIXME: Remove this
			_shape.graphics.clear();
			if(_selected){
				_shape.graphics.lineStyle(1, 0xFFFFFF);
				_shape.graphics.beginFill(0xFFFFFF, 0.3);
				_shape.graphics.drawRect(0, 0, _bmd.width, _bmd.height);
				_shape.graphics.endFill();
			}
		}
		
		public function get selected():Boolean{
			return _selected;
		}
		
		public function get rect():Rectangle{
			return _rect;
		}
		
		/**
		 * Normally you should not call this!!! Call it carefully!!!!! 
		 * @return 
		 * 
		 */		
		public function clone():Tile{
			 var tile:Tile = new Tile(_bmd, _rect);
			 return tile;
		}
		
		/**
		 * Only call it  
		 * @return 
		 * 
		 */		
		public function get reference():Tile{
			++_refCount;
			return this;
		}
	}
}