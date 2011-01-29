package com.aircapsule.tileMap.layers
{
	import com.aircapsule.tileMap.ui.LayerContainer;
	import com.aircapsule.tileMap.ui.LayerInfoPanel;
	
	import flash.events.KeyboardEvent;
	import flash.ui.Keyboard;

	public class LayerManager
	{
		private static var INSTANCE:LayerManager;
		
		protected var _layers:Vector.<Layer>;
		
		protected var _selectedLayer:Layer;
		
		protected var _rows:uint;
		
		protected var _cols:uint;
		
		protected var _layerContainer:LayerContainer;
		
		protected var _infoPanel:LayerInfoPanel;
		
		public function LayerManager()
		{
			_layers = new Vector.<Layer>();
		}
		
		public static function getInstace():LayerManager{
			if(INSTANCE == null){
				INSTANCE = new LayerManager();
			}
			return INSTANCE;
		}
		
		public function init($layerContainer:LayerContainer, $infoPanel:LayerInfoPanel, $rows:uint, $cols:uint):void{
			_rows = $rows;
			_cols = $cols;
			_layerContainer = $layerContainer;
			_infoPanel = $infoPanel;
			
			_layerContainer.stage.addEventListener(KeyboardEvent.KEY_DOWN, keyDownHandler);
		}
		
		private function keyDownHandler($e:KeyboardEvent):void{
			if($e.keyCode == Keyboard.NUMBER_1){
				this.selectLayerByIndex(0);
			}
			else if($e.keyCode == Keyboard.NUMBER_2){
				this.selectLayerByIndex(1);
			}
			else if($e.keyCode == Keyboard.NUMBER_3){
				this.selectLayerByIndex(2);
			}
		}
		
		public function resize($rows:uint, $cols:uint):void{
			_rows = $rows;
			_cols = $cols;
			
			for(var i:uint=0; i<_layers.length; ++i){
				_layers[i].resize(_rows, _cols);
			}
		}
		
		public function createLayer($label:String="default"):Layer{
			var layer:Layer = new Layer(_rows, _cols);
			_layerContainer.addChild(layer);
			_layers.push(layer);
			
			var infoBlock:LayerInfoBlock = new LayerInfoBlock(layer);
			infoBlock.index = _layers.length-1;
			infoBlock.label = $label;
			_infoPanel.addElement(infoBlock);
			
			return layer;
		}
		
		public function removeLayer($layer:Layer):Boolean{
			if($layer.lock){
				return false;
			}
			var index:int = _layers.indexOf($layer);
			if(index != -1){
				$layer.destroy();
				_layers.splice(index, 1);
				
				_layerContainer.removeChild($layer);
				return true;
			}
			return false;
		}
		
		public function getLayers():Vector.<Layer>{
			return _layers;
		}
		
		public function selectLayerByIndex($index:uint):void{
			_selectedLayer = _layers[$index];
		}
		
		public function selectedLayer():Layer{
			return _selectedLayer;
		}
	}
}