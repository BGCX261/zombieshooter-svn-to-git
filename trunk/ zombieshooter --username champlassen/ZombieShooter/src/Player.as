package{
	import flash.display.BitmapData;
	import flash.display.Graphics;
	import flash.display.Loader;
	import flash.events.Event;
	import flash.events.TimerEvent;
	import flash.geom.Matrix;
	import flash.net.URLRequest;
	import flash.utils.Timer;
	public class Player extends MovingObject{
		private var _speed:Number = 5;
		private var speedBoostTimer:Timer = new Timer(5000);
		private var _lives:int = 3;
		private var _xCoordinate:Number = 300;
		private var _yCoordinate:Number = 450;
		private var radius:Number = 10;
		public var _direction:Number = 0;
		public var _level:Level;
		public var _controller:Controller;	
		private var _zombieArray:Array;
		private var loader:Loader = new Loader;
		private var loader2:Loader = new Loader;
		private var loader3:Loader = new Loader;
		private var currentState:int = 1
		private var c:Graphics;
		private var stepCount:int = 0;
		private var trippleGun:Boolean = false;
		private var ammo:int;
		public function Player(l:Level, a:Array){
			
			_zombieArray = a;
			_level = l;
			c = this.graphics;
			
			loadImage();
			this.x = 25;
			this.y = 495;
			
			_level.addEventListener("LevelCleared", levelBreak);
			addEventListener("updatePlayer", updatePosition);
			addEventListener("addedLife", lifePowerUp);
			addEventListener("speedBoost", speedPowerUp);
			addEventListener("gunBoost", gunPowerUp);
			addEventListener("hitByZombie", takeHit);
			
			_controller = new Controller(this);
			addEventListener(Event.ENTER_FRAME, updatePosition, false, 0, true);
			super(l);
		}
		
		
		private function loadImage():void{
		var player1:URLRequest = new URLRequest("PlayerRightLeg.png");
		var player2:URLRequest = new URLRequest("PlayerLeftLeg.png");
		var player3:URLRequest = new URLRequest("PlayerStanding.png");
		loader.contentLoaderInfo.addEventListener(Event.COMPLETE, listenerActivator);
		loader.load(player1);
		loader2.load(player2);
		loader3.load(player3);
	
		}

		private function listenerActivator(e:Event):void{
		addEventListener("updatePlayer", drawImage);
		}
		
		private function drawImage(e:Event):void{
			if(stepCount == 0){
			c.clear()
			var playergfx:BitmapData = new BitmapData(20, 30, true, 0x000000);
			
			if(currentState == 1){
			playergfx.draw(loader3, new Matrix());			
			currentState = 2;
			} else if(currentState == 2){
			playergfx.draw(loader2, new Matrix());
			currentState = 3;
			}
	        else if(currentState == 3){
			playergfx.draw(loader3, new Matrix());
			currentState = 4;
			}
			else if(currentState == 4){
			playergfx.draw(loader, new Matrix());
			currentState = 1;
			}
			var matrix:Matrix = new Matrix();
			matrix.translate(-10, -15);
			c.beginBitmapFill(playergfx, matrix, false, true);
			c.drawRect(-10, -15, 20, 30);
			stepCount = 4
			}
		}		
		override public function updatePosition(e:Event):void{
		_xCoordinate = super.updatexPosition(_xCoordinate);
		_yCoordinate = super.updateyPosition(_yCoordinate);
		this.x = _xCoordinate;
		this.y = _yCoordinate;
		this.rotation = _direction;
		}
		
		private function resetPosition(e:Event):void{
		_xCoordinate = 300;
		_yCoordinate = 500;
		}
		
		public function forward(co:Controller):void{
		_xCoordinate = _xCoordinate - _speed*(Math.cos((_direction+90) * Math.PI / 180));
		_yCoordinate = _yCoordinate - _speed*(Math.sin((_direction+90) * Math.PI / 180));
		stepCount--
		}
		public function back(co:Controller):void{
		_xCoordinate = _xCoordinate + _speed*(Math.cos((_direction+90) * Math.PI / 180));
		_yCoordinate = _yCoordinate + _speed*(Math.sin((_direction+90) * Math.PI / 180));
		stepCount--
		}
		public function turn(co:Controller, dir:Number):void{
		
		_direction += dir;
		if(_direction > 360){_direction = 0;}
		else if(_direction < 0){_direction = 360;}
		
		}
		
		public function fire(co:Controller):void{
		var bullet:Bullet = new Bullet(_level, this, _zombieArray, this._direction)
		_level.addChild(bullet);
		if(trippleGun){
			var bullet2:Bullet = new Bullet(_level, this, _zombieArray, this._direction-15)
			_level.addChild(bullet2);
			var bullet3:Bullet = new Bullet(_level, this, _zombieArray, this._direction+15)
			_level.addChild(bullet3);
			ammo--
			ammoCheck();
			}
		}
		
		
		private function levelBreak(e:Event):void{
		addEventListener(Event.ENTER_FRAME, restartPosition);
		}
						
				
		public function restartPosition(e:Event):void{
			if(_xCoordinate > 250 && _xCoordinate < 350 && _yCoordinate > 500){
				removeEventListener(Event.ENTER_FRAME, restartPosition);	
				dispatchEvent(new Event("PlayerInPlace"));		
			}
			else{
				_xCoordinate = _xCoordinate - 10 * (Math.cos(Math.atan2(this.y-500, this.x-300)));
				_yCoordinate = _yCoordinate - 10 * (Math.sin(Math.atan2(this.y-500, this.x-300)));
			}	
		}
		
		private function lifePowerUp(e:Event):void{
		if(_lives < 5){
			_lives++
			}
			dispatchEvent(new Event("livesUpdated"));
		}			
		
		private function speedPowerUp(e:Event):void{
			_speed = 8;
			this.alpha = 0.5;
			speedBoostTimer.addEventListener(TimerEvent.TIMER, speedPowerDown, false, 0, true);
			speedBoostTimer.start();
		}
		
		private function speedPowerDown(te:TimerEvent):void{
		_speed = 5;
		this.alpha = 1;
		speedBoostTimer.stop();
		}
		
		private function gunPowerUp(e:Event):void{
		trippleGun = true
		ammo = 15;
		}
		
		private function ammoCheck():void{
		if(ammo == 0){
		trippleGun = false;
			}
		}
		
		private function takeHit(e:Event):void{
		_lives--
		dispatchEvent(new Event("livesUpdated"));
		if(_lives > 0){
			dispatchEvent(new Event("manDown"));
			}
		}
		
		public function get lives():int{
		return _lives;
		}
		
		public function get xCoordinate():Number{
		return this.x;
		}
		
		public function get yCoordinate():Number{
		return this.y;
		}
	}
}
