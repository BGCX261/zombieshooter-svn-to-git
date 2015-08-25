package{
	import flash.display.BitmapData;
	import flash.display.Graphics;
	import flash.display.Loader;
	import flash.events.Event;
	import flash.events.TimerEvent;
	import flash.geom.Matrix;
	import flash.net.URLRequest;
	import flash.utils.Timer;

	public class Zombie extends MovingObject{
		
		
		private var zombieCanvas:Graphics;
		private var _xCoordinate:Number;
		private var _yCoordinate:Number;
		private var _direction:Number;
		private var _speed:Number;
		private var _player:Player;
		private var _level:Level;
		private var _zombieArray:Array;
		private var health:int;
		private var spottedPlayer:Boolean = false;
		private var forgetTimer:Timer = new Timer(6000);
		private var directionChange:int = 0;
		private var idleDirectionChange:Number;
		private var _type:int;
		private var _bitmapURL1:URLRequest;
		private var _bitmapURL2:URLRequest;
		private var _bitmapURL3:URLRequest;1
		private var loader1:Loader = new Loader();
		private var loader2:Loader = new Loader();
		private var loader3:Loader = new Loader();
		private var zombieState:int = 1;
		private var zombieStep:int = 20;
		private var startDelay:Timer = new Timer(1000);
		public function Zombie(l:Level, p:Player, a:Array, t:int){
		_type = t;
		_level = l;
		_player = p;
		_zombieArray = a;
		zombieCanvas = this.graphics;
		ZombieAddedToStage();
		_direction = 360*Math.random();
		startDelay.start();
		startDelay.addEventListener(TimerEvent.TIMER, startZombie, false, 0, true);
		_player.addEventListener("manDown", killedPlayer);
		super(l);
		}

		private function startZombie(te:TimerEvent):void{
		startDelay.stop();
		addEventListener(Event.ENTER_FRAME, updatePosition, false, 0, true);
		}
		 
		private function ZombieAddedToStage():void{
			switch (_type) {
				case 1:
					_bitmapURL1 = new URLRequest("RedZombieStanding.png")
					_bitmapURL2 = new URLRequest("RedZombieLeftLeg.png")
					_bitmapURL3 = new URLRequest("RedZombieRightLeg.png")
					_speed = 2;
					health = 4;
				break;
			
				case 2:
					_bitmapURL1 = new URLRequest("YellowZombieStanding.png")
					_bitmapURL2 = new URLRequest("YellowZombieLeftLeg.png")
					_bitmapURL3 = new URLRequest("YellowZombieRightLeg.png")
					_speed = 3;
					health = 2;
				break;
			
				case 3:
					_bitmapURL1 = new URLRequest("PinkZombieStanding.png")
					_bitmapURL2 = new URLRequest("PinkZombieLeftLeg.png")
					_bitmapURL3 = new URLRequest("PinkZombieRightLeg.png")
					_speed = 4;
					health = 1;
				break;
			}
			loader1.load(_bitmapURL1);
			loader2.load(_bitmapURL2);
			loader3.load(_bitmapURL3);
			loader3.contentLoaderInfo.addEventListener(Event.COMPLETE, bitmapsLoaded, false, 0, true);
			
			}
		private function bitmapsLoaded(e:Event):void{
			randomPosition();			
			this.x = _xCoordinate;
			this.y = _yCoordinate;
			this.rotation = _direction;	
			zombieMovement();
			}
		
		private function randomPosition():void{
			_xCoordinate = Math.random()* 600;
			_yCoordinate = Math.random()* 260;
		
		}
		
		private function zombieMovement():void{
			if(zombieStep > 20){
				zombieCanvas.clear();
				var zombieGFX:BitmapData = new BitmapData(20, 30, true, 0x000000);

				if(zombieState == 1){
					zombieGFX.draw(loader1, new Matrix());
					zombieState = 2;
				}
				else if(zombieState == 2){
					zombieGFX.draw(loader2, new Matrix());
					zombieState = 3;
				}
				else if(zombieState == 3){
					zombieGFX.draw(loader1, new Matrix());
					zombieState = 4;
				}
				else if(zombieState == 4){
					zombieGFX.draw(loader3, new Matrix());
					zombieState = 1;
				}
				var matrix:Matrix = new Matrix();
				matrix.translate(-10, -15);
				zombieCanvas.beginBitmapFill(zombieGFX, matrix, false, true);
				zombieCanvas.drawRect(-10, -15, 20, 30);
				zombieStep = 0;
							
				}
			}
			
		override public function updatePosition(e:Event):void{
			_direction = getAngle();
			_xCoordinate = _xCoordinate- _speed*(Math.cos((_direction)* Math.PI / 180));
			_yCoordinate = _yCoordinate- _speed*(Math.sin((_direction)* Math.PI / 180));
			_xCoordinate = super.updatexPosition(_xCoordinate);
			_yCoordinate = super.updateyPosition(_yCoordinate);
				
		for(var z:int = 0; z < _zombieArray.length; z++){
			if(_zombieArray[z] == this){}
			else if(hitTestObject(_zombieArray[z]) == true){
				_xCoordinate = _xCoordinate + _speed*Math.cos(Math.atan2(this.y-_zombieArray[z].y, this.x-_zombieArray[z].x));
				_yCoordinate = _yCoordinate + _speed*Math.sin(Math.atan2(this.y-_zombieArray[z].y, this.x-_zombieArray[z].x));
			}
		}
		
		this.x = _xCoordinate;
		this.y = _yCoordinate;
		this.rotation = _direction-90;
		zombieStep += _speed;
		zombieMovement();
		if(this.hitTestObject(_player)){
			_player.dispatchEvent(new Event("hitByZombie"));
			}
		}

		private function getAngle():Number{
		if(lineOfSight()){
			if(!spottedPlayer){
				trace("true spottedPlayer")
				_speed*=1.5;
			}
			spottedPlayer = true;
			forgetTimer.start();
			
			
			forgetTimer.addEventListener(TimerEvent.TIMER, forgetPlayer, false, 0, true);
					
			return playerToZombieDirection();
			}
			
			else{
				
				
				return _direction - idleDirection();
			}
		}
		
		private function playerToZombieDirection():Number{
		return	Math.atan2(this.y-_player.yCoordinate, this.x-_player.xCoordinate)*180/Math.PI;
		}
		
		private function idleDirection():Number{
		var coinflip:Number = Math.random();
				if(directionChange == 0 && coinflip > 0.5){
					idleDirectionChange = Math.random()*10;
					directionChange = 15;
					}
				else if(directionChange == 0 && coinflip < 0.5){
					idleDirectionChange = Math.random()*-10;
					directionChange = 15;
					}
				directionChange--;
			return(idleDirectionChange);
		}
	
		private function forgetPlayer(te:TimerEvent):void{
			trace("haps");
			_speed/=1.5;
			spottedPlayer = false;
			forgetTimer.stop();
			forgetTimer.removeEventListener(TimerEvent.TIMER, forgetPlayer);
			
		}
		
		private function lineOfSight():Boolean{
			
			if(!spottedPlayer){
				var distance:Number = Math.sqrt((_player.xCoordinate-this.x)*(_player.xCoordinate-this.x)+(_player.yCoordinate-this.y)*(_player.yCoordinate-this.y))
				trace(distance);
				for(var d:int = 0; d < distance; d+=5){
					var testX:Number = _xCoordinate - d * (Math.cos(playerToZombieDirection()));
					var testY:Number = _yCoordinate - d * (Math.sin(playerToZombieDirection()));
						for(var i:int = 0; i < _level.boxes; i++){
							if(_level.boxesXArray[i]  < testX && testX  < _level.boxesXArray[i] + _level.boxesWidthArray[i] && _level.boxesXArray[i] < testY && testY < _level.boxesXArray[i] + _level.boxesHeightArray[i]){
								trace("Boxes in: " + testX + ", " + testY);
								return false;
							}
						}
					}
				}
			
			return true;
		
		}
		
		public function hit(b:Bullet, z:int):void{
			health--
			if(health == 0){
			var powerUpRoll:Number = Math.random();
				if(powerUpRoll < 0.075){
					var pu1:PowerUp = new PowerUp(this.x, this.y, 1, _player)
					parent.addChild(pu1);
				} 
				else if(powerUpRoll > 0.075 && powerUpRoll < 0.15){
					var pu2:PowerUp = new PowerUp(this.x, this.y, 2, _player)
					parent.addChild(pu2);
				}
				else if(powerUpRoll > 0.15 && powerUpRoll < 0.225){
					var pu3:PowerUp = new PowerUp(this.x, this.y, 3, _player)
					parent.addChild(pu3);
				}
				else {
				var zombieSplat:Blood = new Blood(this.x, this.y);
				parent.addChild(zombieSplat);
				}
			
			parent.removeChild(this);
			_zombieArray.splice(z, 1);
			_level.dispatchEvent(new Event("deadZombie"));
			}
		}
		
		private function killedPlayer(e:Event):void{
		randomPosition();	
		}
	}
}