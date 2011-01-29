package com.aircapsule.tileMap.history
{
	import com.aircapsule.tileMap.TilesetManager;
	import com.aircapsule.tileMap.display.Tile;
	import com.aircapsule.tileMap.layers.Layer;
	import com.aircapsule.tileMap.layers.actions.Actions;
	
	import nl.demonsters.debugger.MonsterDebugger;
	
	/**
	 * Paint undo and redo history logic 
	 * @author Liy
	 * 
	 */	
	public class PaintHistory implements IHistory
	{
		private var _oldTiles:Vector.<Tile>;
		
		private var _newTiles:Vector.<Tile>;
		
		private var _rowIndices:Vector.<uint>;
		
		private var _colIndices:Vector.<uint>;
		
		private var _layer:Layer;
		
		public function PaintHistory($layer:Layer)
		{
			_layer = $layer;
			_oldTiles = new Vector.<Tile>();
			_newTiles = new Vector.<Tile>();
			_rowIndices = new Vector.<uint>();
			_colIndices = new Vector.<uint>();
		}
		
		public function destroy():void{
			for(var i:uint=0; i<_oldTiles.length; ++i){
				// ********Should not destroy any OLD TILES in the _oldTiles list, they should be destroyed by other PaintHistory
				// Only new tiles should be destroyed.
				if(_newTiles[i] != null)
					_newTiles[i].destroy();
			}
			_newTiles = null;
			_oldTiles = null;
			
			_layer = null;
			
			_rowIndices = null;
			_colIndices = null;
		}
		
		/**
		 * Record every paint action into this history object.
		 *  
		 * @param $oldTile The old tile reference before paint action happened
		 * @param $newTile The new tile reference after paint action
		 * @param $rowIndex The row index specify the row position in Layer's tiles set.
		 * @param $colIndex the column index specify the column position in the layer's tiles
		 * 
		 */		
		public function recordTile($oldTile:Tile, $newTile:Tile, $rowIndex:uint, $colIndex:uint):void{
			if($oldTile != null){
				_oldTiles.push($oldTile);
			}
			else{
				_oldTiles.push(null);
			}
			if($newTile != null){
				_newTiles.push($newTile);
			}
			else{
				_newTiles.push(null);
			}
			_rowIndices.push($rowIndex);
			_colIndices.push($colIndex);
		}
		
		public function undo():void{
			var tileSize:uint = TilesetManager.getInstace().tileSize;
			
			for(var i:uint=_oldTiles.length; i>0; --i){
				var rowIndex:uint = _rowIndices[i-1];
				var colIndex:uint = _colIndices[i-1];
				
				if(_newTiles[i-1] != null){
					_layer.removeChild(_newTiles[i-1]);
					_layer.tiles[rowIndex][colIndex] = null;
				}
				if(_oldTiles[i-1] != null){
					_oldTiles[i-1].x = colIndex * tileSize;
					_oldTiles[i-1].y = rowIndex * tileSize;
					_layer.tiles[rowIndex][colIndex] = _oldTiles[i-1];
					_layer.addChild(_oldTiles[i-1]);
				}
			}
			_layer.addChild(Actions.PAINT_ACTION.indicator);
		}
		
		public function redo():void{
			var tileSize:uint = TilesetManager.getInstace().tileSize;
			
			for(var i:uint=0; i<_newTiles.length; ++i){
				var rowIndex:uint = _rowIndices[i];
				var colIndex:uint = _colIndices[i];
				
				if(_oldTiles[i] != null){
					_layer.removeChild(_oldTiles[i]);
					_layer.tiles[rowIndex][colIndex] = null;
				}
				if(_newTiles[i] != null){
					_newTiles[i].x = colIndex * tileSize;
					_newTiles[i].y = rowIndex * tileSize;
					_layer.tiles[rowIndex][colIndex] = _newTiles[i];
					_layer.addChild(_newTiles[i]);
				}
			}
			_layer.addChild(Actions.PAINT_ACTION.indicator);
		}
	}
}