package com.aircapsule.tileMap.ui
{
	import com.aircapsule.tileMap.TilesetManager;
	import com.aircapsule.tileMap.auxiliary.Selections;
	import com.aircapsule.tileMap.auxiliary.Utils;
	import com.aircapsule.tileMap.display.Tile;
	import com.aircapsule.tileMap.display.Tileset;
	import com.aircapsule.tileMap.layers.Layer;
	import com.aircapsule.tileMap.layers.LayerManager;
	
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	
	import mx.core.UIComponent;
	
	import nl.demonsters.debugger.MonsterDebugger;
	
	import spark.core.IViewport;
	import spark.primitives.Rect;

	public class LayerContainer extends UIComponent
	{
		protected var _width:uint;
		protected var _height:uint;
		
		protected var _rows:uint;
		protected var _cols:uint;
		
		private var _fillRect:Rect;
		
		protected var _layers:Vector.<Layer> = new Vector.<Layer>();
		
		public function LayerContainer($fillRect:Rect, $w:uint=1024, $h:uint=768)
		{
			var mon:MonsterDebugger = new MonsterDebugger(this);
			
			_width = Utils.nextPowerOf2($w);
			_height = Utils.nextPowerOf2($h);
			
			var tileSize:uint = TilesetManager.getInstace().tileSize;
			_rows = Math.ceil(_height/tileSize);
			_cols = Math.ceil(_width/tileSize);
			
			_fillRect = $fillRect;
			
			drawGrid();
		}
		
		public function drawGrid():void{
			// draw background
			this.graphics.lineStyle(1, 0xCCCCCC, 1);
			for(var i:uint=0; i<_cols+1; ++i){
				this.graphics.moveTo(i*32, 0);
				this.graphics.lineTo(i*32, _height);
			}
			//draw grids
			for(var i:uint=0; i<_rows+1; ++i){
				this.graphics.moveTo(0, i*32);
				this.graphics.lineTo(_width, i*32);
			}
			this.graphics.endFill();
			
			// TODO:: update fillRect instance in order to update scrollbar
			_fillRect.width = _width;
			_fillRect.height = _height;
			
			this.graphics.beginFill(0xFF9900, 0.6);
			this.graphics.drawRect(0,0,_width, _height);
			this.graphics.endFill();
		}
		
		public override function set width(value:Number):void{
			_width = Utils.nextPowerOf2(value);
			_cols = Math.ceil(_width/32);
		}
		
		public override function set height(value:Number):void{
			_height = Utils.nextPowerOf2(value);
			_rows = Math.ceil(_height/32);
		}
		
		public function get rows():uint{
			return _rows;
		}
		
		public function get cols():uint{
			return _cols;
		}
	}
}