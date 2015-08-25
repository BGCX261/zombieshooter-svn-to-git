package{
	import flash.display.BitmapData;
	import flash.display.Graphics;
	import flash.display.Loader;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.geom.Matrix;
	import flash.net.URLRequest;
	
	public class PowerUp extends Sprite{

		private var powerUpLoader:Loader = new Loader();
		private var powerUpBitmap:BitmapData;
		private var powerUpCanvas:Graphics;
		private var _player:Player;
		private var _type:int;
		private var pickedUp:Boolean = false;
		public function PowerUp(zx:Number, zy:Number, t:int, p:Player){
			_player = p;
			this.x = zx;
			this.y = zy;
			_type = t;
			powerUpCanvas = this.graphics;
			powerUpLoader.contentLoaderInfo.addEventListener(Event.COMPLETE, bitmapLoaded, false, 0, true);
			powerUpLoader.load(getBitmap());
			addEventListener(Event.ENTER_FRAME, checkPlayerImpact, false, 0, true);
			}
		
		private function getBitmap():URLRequest{
		
			if(_type == 1){
				return new URLRequest("KlausPowerUp.png");
			}
			else if(_type == 2){				
				return new URLRequest("MattiPowerUp.png");
			}
			else{
				return new URLRequest("AndersPowerUp.png");
			}
		}
		
		private function bitmapLoaded(e:Event):void{
		var powerUpBitmap:BitmapData = new BitmapData(20, 20, true, 0x000000)
		powerUpBitmap.draw(powerUpLoader, new Matrix());
		var matrix:Matrix = new Matrix();
		matrix.translate(-10, -15)
		powerUpCanvas.beginBitmapFill(powerUpBitmap, matrix, false, true);
		powerUpCanvas.drawRect(-10, -15, 20, 20);
		parent.addEventListener("NewLevel", levelClear, false, 0, true)
		}
		
		private function checkPlayerImpact(e:Event):void{
			if(this.hitTestObject(_player)){
				if(_type == 1){
					_player.dispatchEvent(new Event("addedLife"));
				} 
				else if(_type == 2){
					_player.dispatchEvent(new Event("speedBoost"));
				} 
				else if( _type == 3){
					_player.dispatchEvent(new Event("gunBoost"));
				}
				if(!pickedUp){
					parent.removeChild(this);
					pickedUp = true;
				}
			}
		}
		
		private function levelClear(e:Event):void{
			if(!pickedUp){
				parent.removeChild(this);
				pickedUp = true;
		

		}
		} 
	}
}