package{
	import flash.display.Graphics;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.TimerEvent;
	import flash.utils.Timer;
	public class Bullet extends Sprite{
		private var bulletTime:Timer = new Timer(1500)
		private var _direction:Number;
		private var _xCoordinate:Number;
		private var _yCoordinate:Number;
		private var _player:Player;
		private var _zombieArray:Array;
		private var _level:Level;
		private var bulletCanvas:Graphics;
		private var killed:Boolean = false;
	
		public function Bullet(l:Level, p:Player, a:Array, d:Number){
			bulletTime.start();
			bulletTime.addEventListener(TimerEvent.TIMER, timeIsUp);
			addEventListener(Event.ENTER_FRAME, updatePosition);
			bulletCanvas = this.graphics;
			_level = l;
			_player = p;
			_zombieArray = a;
			_direction = d;
			_level.addEventListener("levelCleared", newLevel);
			bulletCanvas.lineStyle(2, 0xFFFFFF)
			bulletCanvas.beginFill(0xFFFFFF);
			bulletCanvas.drawCircle(0, 0, 2);
			
			_xCoordinate = _player.x - 19*(Math.cos((_direction+90) * Math.PI / 180))
			_yCoordinate = _player.y - 19*(Math.sin((_direction+90) * Math.PI / 180))
			this.x = _xCoordinate;
			this.y = _yCoordinate;
					
			
			
		}
		
		private function newLevel(e:Event):void{
		removeEventListener(Event.ENTER_FRAME, updatePosition);
		}
		
		private function updatePosition(e:Event):void{
			_xCoordinate = _xCoordinate - 10*(Math.cos((_direction+90) * Math.PI / 180));
			_yCoordinate = _yCoordinate - 10*(Math.sin((_direction+90) * Math.PI / 180));
			this.x = _xCoordinate;
			this.y = _yCoordinate;
					
			checkImpact();	
						
		}
		

		private function timeIsUp(e:TimerEvent):void{
			
			killBullet();
		}
		
		public function killBullet():void{
			
			if(killed == false){	
			removeEventListener(Event.ENTER_FRAME, updatePosition);
			bulletTime.stop();
			_level.removeChild(this);
			killed = true;
			} else{} 
		}
		
		private function checkImpact():void{
			if(_xCoordinate < 8) {
			killBullet();}
			else if(_xCoordinate > 592){
			killBullet();}
			else if(_yCoordinate < 8){
			killBullet();}
			else if(_yCoordinate > 512){
			killBullet();}
			for(var i:int = 0; i < _level.boxesXArray.length; i++){
			var xcoor:Number = _level.boxesXArray[i];
			var ycoor:Number = _level.boxesYArray[i];
			var h:Number = _level.boxesHeightArray[i];
			var w:Number = _level.boxesWidthArray[i];
	
			//venstre side
			if(xcoor < _xCoordinate && _xCoordinate  < xcoor + w / 2 && ycoor < _yCoordinate && _yCoordinate < ycoor + h){
			killBullet();}
			
			//højre side
			else if(xcoor + w / 2 < _xCoordinate && _xCoordinate  < xcoor + w && ycoor < _yCoordinate && _yCoordinate < ycoor + h){
			killBullet();}
			
			//øverste side
			else if(xcoor  < _xCoordinate && _xCoordinate  < xcoor + w && ycoor < _yCoordinate && _yCoordinate < ycoor + h / 2){
			killBullet();}
			
			//nederste side
			else if(xcoor < _xCoordinate && _xCoordinate  < xcoor + w && ycoor + h / 2 < _yCoordinate && _yCoordinate < ycoor + h){
			killBullet();}
			
			for(var z:int = 0; z < _zombieArray.length; z++){
				if(hitTestObject(_zombieArray[z]) == true){
					
					killBullet();
					_zombieArray[z].hit(this, z);
					
					}
				}
			}
		}
	}
}
