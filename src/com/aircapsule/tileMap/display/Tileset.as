package com.aircapsule.tileMap.display
{
	import com.aircapsule.tileMap.TilesetManager;
	import com.aircapsule.tileMap.auxiliary.Selections;
	import com.aircapsule.tileMap.auxiliary.Utils;
	
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.Loader;
	import flash.display.LoaderInfo;
	import flash.display.Shape;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import flash.net.URLRequest;
	import flash.system.ApplicationDomain;
	import flash.system.LoaderContext;
	
	import nl.demonsters.debugger.MonsterDebugger;

	public class Tileset extends Sprite
	{
		protected var _url:String;
		
		protected var _rect:Rectangle;
		
		protected var _tiles:Vector.<Vector.<Tile>>;
		
		protected var _rows:uint = 0;
		protected var _cols:uint = 0;
		
		protected var _startColIndex:uint = 0;
		protected var _startRowIndex:uint = 0;
		
		protected var _shape:Shape;
		
		/**
		 * Cannot use mouse event buttonDown property 
		 */		
		protected var _mouseDown:Boolean = false;
		
		protected var _selections:Selections;
		
		public function Tileset($url:String)
		{
			_url = $url;
			this.addEventListener(Event.ADDED_TO_STAGE, onStageHandler, false, 0, true);
		}
		
		public function destroy():void{
			_selections.destroy();
			
			this.stage.removeEventListener(MouseEvent.MOUSE_UP, mouseUpHandler);
			this.stage.removeEventListener(MouseEvent.MOUSE_MOVE, mouseMoveHandler);
		}
		
		protected function onStageHandler($e:Event):void{
			this.stage.addEventListener(MouseEvent.MOUSE_MOVE, mouseMoveHandler, false, 0, true);
			this.stage.addEventListener(MouseEvent.MOUSE_UP, mouseUpHandler, false, 0, true);
		}
		
		public function load($url:String=null):void{
			if($url != null){
				_url = $url;
			}
			
			var loader:Loader = new Loader();
			loader.contentLoaderInfo.addEventListener(Event.COMPLETE, loadedHandler);
			loader.contentLoaderInfo.addEventListener(IOErrorEvent.IO_ERROR, loadFailHandler);
			loader.load(new URLRequest(_url), new LoaderContext(false, ApplicationDomain.currentDomain));
		}
		
		private function loadedHandler($e:Event):void{
			var loaderInfo:LoaderInfo = $e.target as LoaderInfo;
			loaderInfo.removeEventListener(Event.COMPLETE, loadedHandler);
			loaderInfo.removeEventListener(IOErrorEvent.IO_ERROR, loadedHandler);
			
			MonsterDebugger.trace(this, "loadedHandler: "+_url);
			
			// create tiles
			initTiles((loaderInfo.content as Bitmap).bitmapData);
			
			this.dispatchEvent($e);
			
			// destroy the original bitmap data
			(loaderInfo.content as Bitmap).bitmapData.dispose();
			loaderInfo.loader.unload();
		}
		
		private function loadFailHandler($e:IOErrorEvent):void{
			var loaderInfo:LoaderInfo = $e.target as LoaderInfo;
			loaderInfo.removeEventListener(Event.COMPLETE, loadedHandler);
			loaderInfo.removeEventListener(IOErrorEvent.IO_ERROR, loadedHandler);
			
			MonsterDebugger.trace(this, "loadFailHandler: "+ _url);
		}
		
		protected function initTiles($bmd:BitmapData):void{
			var tileSize:uint = TilesetManager.getInstace().tileSize;
			var w:uint = $bmd.width;
			var h:uint = $bmd.height;
			_rows = h/tileSize;
			_cols = w/tileSize;
			
			MonsterDebugger.trace(this, "rows: "+_rows);
			MonsterDebugger.trace(this, "cols: "+_cols);
			MonsterDebugger.trace(this, "tileSize: "+tileSize);
			
			_tiles = new Vector.<Vector.<Tile>>();
			for(var i:uint=0; i<_rows; ++i){
				_tiles[i] = new Vector.<Tile>();
				for(var j:uint=0; j<_cols; ++j){
					var bmd:BitmapData = new BitmapData(tileSize, tileSize, true);
					var rect:Rectangle = new Rectangle(j*tileSize, i*tileSize, tileSize, tileSize);
					bmd.copyPixels($bmd, rect, new Point());
					
					_tiles[i][j] = new Tile(bmd, rect);
					_tiles[i][j].x = j*tileSize;
					_tiles[i][j].y = i*tileSize;
					this.addChild(_tiles[i][j]);
				}
			}
			
			// create selection shape
			_shape = new Shape();
			this.addChild(_shape);
			
			// TODO: have a controller?
			this.addEventListener(MouseEvent.MOUSE_DOWN, mouseDownHandler, false, 0, true);
			
			// by default select the first tile
			var defaultSelectedTiles:Vector.<Vector.<Tile>> = new Vector.<Vector.<Tile>>();
			defaultSelectedTiles[0] = new Vector.<Tile>();
			defaultSelectedTiles[0][0] = _tiles[0][0];
			defaultSelectedTiles[0][0].selected = true;
			_selections = new Selections(0,0,0,0,defaultSelectedTiles);
		}
		
		public function get url():String{
			return _url;
		}
		
		protected function mouseMoveHandler($e:MouseEvent):void{
			if(_mouseDown){
				var tileSize:uint = TilesetManager.getInstace().tileSize;
				// only draw selection box
				var endColIndex:uint = this.mouseX/tileSize;
				var endRowIndex:uint = this.mouseY/tileSize;
				// restrict the end selection point if the user release the mouse outside of the tileset.
				if(endRowIndex > _tiles.length-1){
					endRowIndex = _tiles.length-1
				}
				if(endColIndex > _tiles[0].length-1){
					endColIndex = _tiles[0].length-1;
				}
				
				var startColIndex:uint = _startColIndex;
				var startRowIndex:uint = _startRowIndex;
				
				// find the actual top left point.(start point) cause user can drag from bottom right to top left.
				if(endColIndex < startColIndex){
					var temp:uint = startColIndex;
					startColIndex = endColIndex;
					endColIndex = temp;
				}
				if(endRowIndex < startRowIndex){
					var temp:uint = startRowIndex;
					startRowIndex = endRowIndex;
					endRowIndex = temp;
				}
				
				// calculate how many row and columns are selected.
				var rows:uint = endRowIndex - startRowIndex + 1;
				var cols:uint = endColIndex - startColIndex + 1;
				
				_shape.graphics.clear();
				_shape.graphics.lineStyle(1, 0xFFFFFF);
				_shape.graphics.beginFill(0xFFFFFF, 0.3);
				_shape.graphics.drawRect(_tiles[startRowIndex][startColIndex].x, _tiles[startRowIndex][startColIndex].y, cols*tileSize, rows*tileSize);
				_shape.graphics.endFill();
			}
		}
		
		protected function mouseDownHandler($e:MouseEvent):void{
			_mouseDown = true;
			
			var tileSize:uint = TilesetManager.getInstace().tileSize;
			if(!$e.shiftKey){
				_startColIndex = this.mouseX/tileSize;
				_startRowIndex = this.mouseY/tileSize;
			}
			
			// only draw selection box
			var endColIndex:uint = this.mouseX/tileSize;
			var endRowIndex:uint = this.mouseY/tileSize;
			
			_shape.graphics.clear();
			_shape.graphics.lineStyle(1, 0xFFFFFF);
			_shape.graphics.beginFill(0xFFFFFF, 0.3);
			_shape.graphics.drawRect(_tiles[endRowIndex][endColIndex].x, _tiles[endRowIndex][endColIndex].y, tileSize, tileSize);
			_shape.graphics.endFill();
		}
		
		protected function mouseUpHandler($e:MouseEvent):void{
			if(_mouseDown){
				_shape.graphics.clear();
				doSelection($e.ctrlKey);
				_mouseDown = false;
				
				for(var i:uint=0; i<_selections.tiles.length; ++i){
					for(var j:uint=0; j<_selections.tiles[i].length; ++j){
						if(_selections.tiles[i][j] != null){
							var tile:Tile = _selections.tiles[i][j].clone();
							tile.y = i*TilesetManager.getInstace().tileSize;
							tile.x = j*TilesetManager.getInstace().tileSize;
						}
					}
				}
			}
		}
		
		/**
		 * Logic of scan part of the tileset to make new selection of tiles. 
		 * @param $ctrlDown
		 * 
		 */		
		protected function doSelection($ctrlDown:Boolean = false):void{
			var tileSize:uint = TilesetManager.getInstace().tileSize;
			var endColIndex:uint = this.mouseX/tileSize;
			var endRowIndex:uint = this.mouseY/tileSize;
			
			// never directly modify the start position index, cause holding down shift will never update start position
			var startColIndex:uint = _startColIndex;
			var startRowIndex:uint = _startRowIndex;
			
			// restrict the end selection point if the user release the mouse outside of the tileset.
			if(endRowIndex > _tiles.length-1){
				endRowIndex = _tiles.length-1
			}
			if(endColIndex > _tiles[0].length-1){
				endColIndex = _tiles[0].length-1;
			}
			
			// find the actual top left point.(start point) cause user can drag from bottom right to top left.
			if(endColIndex < startColIndex){
				var temp:uint = startColIndex;
				startColIndex = endColIndex;
				endColIndex = temp;
			}
			if(endRowIndex < startRowIndex){
				var temp:uint = startRowIndex;
				startRowIndex = endRowIndex;
				endRowIndex = temp;
			}
			
			// if control is down then add tiles into the previous selections
			if($ctrlDown){
				// calculate how many row and columns selected.
				var rows:uint = endRowIndex - startRowIndex + 1;
				var cols:uint = endColIndex - startColIndex + 1;
				
				// scan through the newly select region, make a reverse selection.(true to false, false to true)
				for(var i:uint=startRowIndex; i<startRowIndex + rows; ++i){
					for(var j:uint=startColIndex; j<startColIndex + cols; ++j){
						_tiles[i][j].selected = !_tiles[i][j].selected;
					}
				}
				
				// then we need to update the selected tiles to include all the selected tiles in the tileset
				// Simply scan from top left selection point to bottom right selection point.
				// In order to find those two points, we have to check original selection points and the new selection points.
				// E.g., if new startRowIndex is smaller than the old startRowIndex, then we make the new startRowIndex to be the
				// current startRowIndex. The purpose is to create a "bounding box" to include all the selected tiles in the tileset.
				if(startRowIndex < _selections.startRowIndex){
					_selections.startRowIndex = startRowIndex;
				}
				if(startColIndex < _selections.startColIndex){
					_selections.startColIndex = startColIndex;
				}
				if(endRowIndex > _selections.endRowIndex){
					_selections.endRowIndex = endRowIndex;
				}
				if(endColIndex > _selections.endColIndex){
					_selections.endColIndex = endColIndex;
				}
				
				// how many rows and columns have to be scanned
				rows = _selections.endRowIndex - _selections.startRowIndex + 1;
				cols = _selections.endColIndex - _selections.startColIndex + 1;
				// scan through through the "bouding box" of all the selected tiles
				// make a new selected tiles 2D array
				var selectedTiles:Vector.<Vector.<Tile>> = new Vector.<Vector.<Tile>>();
				for(var i:uint=_selections.startRowIndex; i<_selections.startRowIndex + rows; ++i){
					selectedTiles[i-_selections.startRowIndex] = new Vector.<Tile>();
					for(var j:uint=_selections.startColIndex; j<_selections.startColIndex + cols; ++j){
						if(_tiles[i][j].selected){
							selectedTiles[i-_selections.startRowIndex][j-_selections.startColIndex] = _tiles[i][j];
						}
						else{
							selectedTiles[i-_selections.startRowIndex][j-_selections.startColIndex] = null;
						}
					}
				}
				_selections.tiles = selectedTiles;
			}
			// normal selection
			else{
				// directly update the start and end index to the current selected start and end index
				_selections.startRowIndex = startRowIndex;
				_selections.startColIndex = startColIndex;
				_selections.endRowIndex = endRowIndex;
				_selections.endColIndex = endColIndex;
				
				// calculate how many row and columns selected.
				var rows:uint = _selections.endRowIndex - _selections.startRowIndex + 1;
				var cols:uint = _selections.endColIndex - _selections.startColIndex + 1;
				
				// clear original selections
				for(var i:uint=0; i<_selections.tiles.length; ++i){
					for(var j:uint=0; j<_selections.tiles[i].length; ++j){
						if(_selections.tiles[i][j] != null){
							_selections.tiles[i][j].selected = false;
						}
					}
				}
				
				// select new tiles
				var selectedTiles:Vector.<Vector.<Tile>> = new Vector.<Vector.<Tile>>();
				for(var i:uint=_selections.startRowIndex; i<_selections.startRowIndex + rows; ++i){
					selectedTiles[i-_selections.startRowIndex] = new Vector.<Tile>();
					for(var j:uint=_selections.startColIndex; j<_selections.startColIndex + cols; ++j){
						_tiles[i][j].selected = true;
						selectedTiles[i-_selections.startRowIndex][j-_selections.startColIndex] = _tiles[i][j];
					}
				}
				_selections.tiles = selectedTiles;
			}
		}
		
		public function get selections():Selections{
			return _selections;
		}
	}
}