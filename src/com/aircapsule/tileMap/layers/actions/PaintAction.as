package com.aircapsule.tileMap.layers.actions
{
	import com.aircapsule.tileMap.TilesetManager;
	import com.aircapsule.tileMap.auxiliary.Selections;
	import com.aircapsule.tileMap.display.Tile;
	import com.aircapsule.tileMap.history.HistoryManager;
	import com.aircapsule.tileMap.history.PaintHistory;
	import com.aircapsule.tileMap.layers.Layer;
	import com.aircapsule.tileMap.layers.LayerManager;
	
	import flash.display.Sprite;
	import flash.events.EventDispatcher;
	import flash.events.MouseEvent;
	import flash.geom.ColorTransform;
	
	import nl.demonsters.debugger.MonsterDebugger;

	public class PaintAction extends EventDispatcher implements IAction
	{
		protected var _mouseIn:Boolean = false;
		
		/**
		 * Indicator??? probably I need a better name... Basically it is a sprite which contains the selected thumbnail, for indication only. 
		 */		
		protected var _indicator:Sprite;
		
		protected var _oRowIndex:uint = 0;
		protected var _oColIndex:uint = 0;
		
		protected var _history:PaintHistory;
		
		protected var _mouseDown:Boolean = false;
		
		public function PaintAction()
		{
			_indicator = new Sprite();
			
		}
		
		/**
		 * Paint a tile into a specific position. 
		 * @param startRowIndex The index in the layer tiles, represent the start row of the paint tiles(selected tiles).
		 * @param startColIndex The index in the layer tiles, represent the start column of the paint tiles(selected tiles).
		 * 
		 */		
		protected function paint(startRowIndex:uint, startColIndex:uint):void{
			var tileSize:uint = TilesetManager.getInstace().tileSize;
			var selectedLayer:Layer = LayerManager.getInstace().selectedLayer();
			
			var selections:Selections = TilesetManager.getInstace().selectedTileset.selections;
			var selectedTiles:Vector.<Vector.<Tile>> = selections.tiles;
			
			var rows:uint = selectedTiles.length;
			var cols:uint = selectedTiles[0].length;
			
			// scan row
			for(var i=startRowIndex; i<startRowIndex+rows; ++i){
				// restrict the paint row index to the max layer rows
				if(i > selectedLayer.rows-1)
					break;
				// scan column
				for(var j=startColIndex; j<startColIndex+cols; ++j){
					// restrict the paint column index to max layer columns
					if(j > selectedLayer.cols-1)
						continue;
					
					if(selectedTiles[i-startRowIndex][j-startColIndex] != null){
						if(selectedLayer.tiles[i][j] != null){
							selectedLayer.removeChild(selectedLayer.tiles[i][j]);
						}
						
						var newTile:Tile = selectedTiles[i-startRowIndex][j-startColIndex].clone();
						// add the new tile to the history
						_history.recordTile(selectedLayer.tiles[i][j], newTile, i, j);
						
						selectedLayer.tiles[i][j] = newTile;
						selectedLayer.tiles[i][j].x = j * tileSize;
						selectedLayer.tiles[i][j].y = i * tileSize;
						selectedLayer.addChild(selectedLayer.tiles[i][j]);
					}
				}
			}
			selectedLayer.addChild(_indicator);
		}
		
		/**
		 * 
		 * @param $layer
		 * 
		 */		
		public function enableEvents($layer:Layer):void{
			$layer.addEventListener(MouseEvent.MOUSE_DOWN, mouseDownHandler, false, 0, true);
			$layer.addEventListener(MouseEvent.MOUSE_UP, mouseUpHandler, false, 0, true);
			$layer.addEventListener(MouseEvent.MOUSE_MOVE, mouseMoveHandler, false, 0, true);
			$layer.addEventListener(MouseEvent.ROLL_OVER, mouseInHandler, false, 0, true);
			$layer.addEventListener(MouseEvent.ROLL_OUT, mouseOutHandler, false, 0, true);
			$layer.addEventListener(MouseEvent.RIGHT_CLICK, rightMouseClickHandler, false, 0, true);
		}
		
		/**
		 * 
		 * @param $layer
		 * 
		 */		
		public function disableEvents($layer:Layer):void{
			$layer.removeEventListener(MouseEvent.MOUSE_DOWN, mouseDownHandler);
			$layer.removeEventListener(MouseEvent.MOUSE_UP, mouseUpHandler);
			$layer.removeEventListener(MouseEvent.MOUSE_MOVE, mouseMoveHandler);
			$layer.removeEventListener(MouseEvent.ROLL_OVER, mouseInHandler);
			$layer.removeEventListener(MouseEvent.ROLL_OUT, mouseOutHandler);
			$layer.removeEventListener(MouseEvent.RIGHT_CLICK, rightMouseClickHandler);
		}
		
		public function mouseUpHandler($e:MouseEvent):void{
			// push the history to the history
			HistoryManager.getInstance().push(_history);
			
			_mouseDown = false;
		}
		
		public function mouseDownHandler($e:MouseEvent):void{
			if(!_mouseDown){
				_mouseDown = true;
				
				var selectedLayer:Layer = LayerManager.getInstace().selectedLayer();
				
				var tileSize:uint = TilesetManager.getInstace().tileSize;
				_oColIndex = selectedLayer.mouseX/tileSize;
				_oRowIndex = selectedLayer.mouseY/tileSize;
				
				_history = new PaintHistory(selectedLayer);
				
				paint(_oRowIndex, _oColIndex);
			}
		}
		
		public function mouseInHandler($e:MouseEvent):void{
			MonsterDebugger.trace(this, "in");
			if(!_mouseIn && TilesetManager.getInstace().selectedTileset != null){
				var selections:Selections = TilesetManager.getInstace().selectedTileset.selections;
				for(var i:uint=0; i<selections.tiles.length; ++i){
					for(var j:uint=0; j<selections.tiles[i].length; ++j){
						if(selections.tiles[i][j] != null){
							var tile:Tile = selections.tiles[i][j].clone();
							tile.y = i*TilesetManager.getInstace().tileSize;
							tile.x = j*TilesetManager.getInstace().tileSize;
							tile.alpha = 0.5;
							
							var ct:ColorTransform = new ColorTransform(1,1,1,1, 100, 100, 100, -125);
							tile.transform.colorTransform = ct;
							_indicator.addChild(tile);
						}
					}
				}
				_mouseIn = true;
			}
		}
		
		public function mouseOutHandler($e:MouseEvent):void{
			_mouseIn = false;
			for(var i:uint=_indicator.numChildren; i>0; --i){
				_indicator.removeChildAt(i-1);
			}
		}
		
		public function mouseMoveHandler($e:MouseEvent):void{
			if(_mouseIn){
				var selectedLayer:Layer = LayerManager.getInstace().selectedLayer();
				
				var tileSize:uint = TilesetManager.getInstace().tileSize;
				var colIndex:uint = selectedLayer.mouseX/tileSize;
				var rowIndex:uint = selectedLayer.mouseY/tileSize;
				
				_indicator.x = colIndex * tileSize;
				_indicator.y = rowIndex * tileSize;
				
				
				if(_mouseDown){
					if(_oColIndex != colIndex || _oRowIndex != rowIndex){
						// paint the tiles onto the selected layer
						paint(rowIndex, colIndex);
						// update old row and column index
						_oRowIndex = rowIndex;
						_oColIndex = colIndex;
					}
				}
			}
		}
		
		public function rightMouseClickHandler($e:MouseEvent):void{
			var selectedLayer:Layer = LayerManager.getInstace().selectedLayer();
			
			var tileSize:uint = TilesetManager.getInstace().tileSize;
			var colIndex:uint = selectedLayer.mouseX/tileSize;
			var rowIndex:uint = selectedLayer.mouseY/tileSize;
			if(selectedLayer.tiles[rowIndex][colIndex] != null){
				selectedLayer.removeChild(selectedLayer.tiles[rowIndex][colIndex]);
				selectedLayer.tiles[rowIndex][colIndex] = null;
			}
		}
		
		public function get indicator():Sprite{
			return _indicator;
		}
	}
}