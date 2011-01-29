package com.aircapsule.tileMap.auxiliary
{
	import com.aircapsule.tileMap.display.Tile;

	public class Selections
	{
		protected var _tiles:Vector.<Vector.<Tile>>;
		
		protected var _startRowIndex:uint;
		
		protected var _startColIndex:uint;
		
		protected var _endRowIndex:uint;
		
		protected var _endColIndex:uint;
		
		public function Selections($startRowIndex:uint, $startColIndex:uint, $endRowIndex:uint, $endColIndex:uint, $tiles:Vector.<Vector.<Tile>>=null)
		{
			_tiles = $tiles;
			
			_startRowIndex = $startRowIndex;
			_startColIndex = $startColIndex;
			_endRowIndex = $endRowIndex;
			_endColIndex = $endColIndex;
		}
		
		public function destroy():void{
			_tiles = null;
		}
		
		public function set tiles($tiles:Vector.<Vector.<Tile>>):void{
			_tiles = $tiles;
		}
		
		public function get tiles():Vector.<Vector.<Tile>>{
			return _tiles;
		}
		
		public function get startRowIndex():uint{
			return _startRowIndex;
		}
		
		public function get startColIndex():uint{
			return _startColIndex;
		}
		
		public function get endRowIndex():uint{
			return _endRowIndex;
		}
		
		public function get endColIndex():uint{
			return _endColIndex;
		}
		
		
		public function set startRowIndex($value:uint):void{
			_startRowIndex = $value;
		}
		
		public function set startColIndex($value:uint):void{
			_startColIndex = $value;
		}
		
		public function set endRowIndex($value:uint):void{
			_endRowIndex = $value;
		}
		
		public function set endColIndex($value:uint):void{
			_endColIndex = $value;
		}
	}
}