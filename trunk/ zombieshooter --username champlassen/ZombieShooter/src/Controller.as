package{
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.KeyboardEvent;
	import flash.ui.Keyboard;
	public class Controller extends EventDispatcher{
		private var _forward:Boolean = false;
		private var _back:Boolean = false;
		private var _left:Boolean = false;
		private var _right:Boolean = false;
	
		private var _player:Player;
		
		public function Controller(p:Player):void{
			trace("Controller oprettet");
			_player = p;
			_player.addEventListener(Event.ENTER_FRAME, updatePlayer);
			}
		private function updatePlayer(e:Event):void{
			if(_forward == true) {
			_player.forward(this);}
			if(_back == true){
			_player.back(this);}
			if(_right == true){
			_player.turn(this, 5);}
			if(_left == true){
			_player.turn(this, -5);}
			_player.dispatchEvent(new Event("updatePlayer"));
			
		}
	
		public function keyPressed(k:KeyboardEvent):void{
			switch (k.keyCode) {
				case Keyboard.UP:
				_forward = true;
				break;
				
				case Keyboard.DOWN:
				_back = true;
				break;
				
				case Keyboard.LEFT:
				_left = true;
				break;
				
				case Keyboard.RIGHT:
				_right = true;
				break;
				
			}		
		}
		
		public function keyReleased(k:KeyboardEvent):void{
			switch (k.keyCode) {
				
				case Keyboard.UP:
				_forward = false;
				break;
				
				case Keyboard.DOWN:
				_back = false;
				break;
				
				case Keyboard.LEFT:
				_left = false;
				break;
				
				case Keyboard.RIGHT:
				_right = false;
				break;
				
				case Keyboard.SPACE:
				_player.fire(this);
				break;
			}		
		}
	}
}