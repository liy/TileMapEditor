package com.aircapsule.tileMap.layers
{
	import com.aircapsule.tileMap.TilesetManager;
	import com.aircapsule.tileMap.auxiliary.Selections;
	import com.aircapsule.tileMap.display.Tile;
	import com.aircapsule.tileMap.layers.actions.Actions;
	import com.aircapsule.tileMap.layers.actions.IAction;
	import com.aircapsule.tileMap.ui.LayerContainer;
	
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.geom.ColorTransform;
	
	import nl.demonsters.debugger.MonsterDebugger;

	public class Layer extends Sprite
	{
		protected var _tiles:Vector.<Vector.<Tile>> = new Vector.<Vector.<Tile>>();
		
		protected var _rows:uint;
		
		protected var _cols:uint;
		
		protected var _indicator:Sprite = new Sprite();
		
		public var lock:Boolean = false;
		
		protected var _mouseEnter:Boolean = false;
		
		protected var _action:IAction;
		
		public function Layer($rows:uint, $cols:uint)
		{
			_rows = $rows;
			_cols = $cols;
			
			// initialize tiles in the layer
			for(var i:uint=0; i<_rows; ++i){
				_tiles[i] = new Vector.<Tile>();
				for(var j:uint=0; j<_cols; ++j){
					_tiles[i][j] = null;
				}
			}
			
			drawBackground();
			
			// setup the actions for the first time
			_action = Actions.PAINT_ACTION;
			_action.enableEvents(this);
		}
		
		public function destroy():void{
			for(var i:uint=0; i<_rows; ++i){
				for(var j:uint=0; j<_cols; ++j){
					if(_tiles[i][j] != null){
						_tiles[i][j].destroy();
					}
				}
			}
		}
		
		internal function resize($rows:uint, $cols:uint):void{
			// create new temp tiles vector getting ready for assign original tiles
			var newTiles:Vector.<Vector.<Tile>> = new Vector.<Vector.<Tile>>();
			for(var i:uint=0; i<$rows; ++i){
				newTiles[i] = new Vector.<Tile>();
				for(var j:uint=0; j<$cols; ++j){
					newTiles[i][j] = null;
				}
			}
			
			// scan through the old tiles vector, decide whether to assign or destroy the orignal tiles
			for(var i:uint=0; i<_rows; ++i){
				for(var j:uint=0; j<_cols; ++j){
					// any old tiles which are inside of new tiles vector region shall be assigned to the new tiles vector.
					if(i < $rows && j < $cols){
						newTiles[i][j] = _tiles[i][j];
					}
					// in the opposite, if they are outside of the region, destroy the tile if it is not null
					else{
						if(_tiles[i][j] != null){
							_tiles[i][j].destroy();
						}
					}
				}
			}
			// assign the temp tiles to the real tiles
			_tiles = newTiles;
			
			// update the original rows and columns
			_rows = $rows;
			_cols = $cols;
			
			//drawBackground();
			this.hitArea = this.parent as LayerContainer;
		}
		
		public function setAction($action:IAction):void{
			_action.disableEvents(this);
			_action = $action;
			_action.enableEvents(this);
		}
		
		public function getAction():IAction{
			return _action;
		}
		
		protected function drawBackground():void{
			var tileSize:uint = TilesetManager.getInstace().tileSize;
			this.graphics.beginFill(0xCCCCCC, 0);
			this.graphics.drawRect(0, 0, _cols*tileSize, _rows*tileSize);
			this.graphics.endFill();
		}
		
		public function get tiles():Vector.<Vector.<Tile>>{
			return _tiles;
		}
		
		public function get rows():uint{
			return _rows;
		}
		
		public function get cols():uint{
			return _cols;
		}
	}
}