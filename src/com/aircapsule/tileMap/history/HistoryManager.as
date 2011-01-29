package com.aircapsule.tileMap.history
{
	import flash.display.Stage;
	import flash.events.KeyboardEvent;
	import flash.ui.Keyboard;
	
	import nl.demonsters.debugger.MonsterDebugger;

	public class HistoryManager
	{
		private static var INSTANCE:HistoryManager;
		
		private var _redos:Vector.<IHistory>;
		
		private var _undos:Vector.<IHistory>;
		
		public function HistoryManager()
		{
			_redos = new Vector.<IHistory>();
			_undos = new Vector.<IHistory>();
		}
		
		public static function getInstance():HistoryManager{
			if(INSTANCE == null){
				INSTANCE = new HistoryManager();
			}
			return INSTANCE;
		}
		
		public function init($stage:Stage):void{
			$stage.addEventListener(KeyboardEvent.KEY_DOWN, keyDownHandler);
		}
		
		public function push($history:IHistory):void{
			_undos.push($history);
			
			// clear redo list
			var len:uint = _redos.length;
			while(_redos.length != 0){
				_redos.pop().destroy();
			}
		}
		
		public function undo():Boolean{
			MonsterDebugger.trace(this, "_undos.length: "+_undos.length);
			if(_undos.length == 0){
				return false;
			}
			
			var history:IHistory = _undos.pop();
			history.undo();
			_redos.push(history);
			return true;
		}
		
		public function redo():Boolean{
			MonsterDebugger.trace(this, "redo");
			if(_redos.length == 0){
				return false;
			}
			
			var history:IHistory = _redos.pop();
			history.redo();
			_undos.push(history);
			return true;
		}
		
		private function keyDownHandler($e:KeyboardEvent):void{
			if($e.keyCode == Keyboard.Z && $e.ctrlKey){
				this.undo();
			}
			else if($e.keyCode == Keyboard.Y && $e.ctrlKey){
				this.redo();
			}
		}
	}
}