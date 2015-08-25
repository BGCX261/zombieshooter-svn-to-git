package{
	import flash.display.BitmapData;
	import flash.display.Graphics;
	import flash.display.Loader;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.geom.Matrix;
	import flash.net.URLRequest;
	
	public class Blood extends Sprite{
		private var bloodVisibility:Number = 1;
		private var bloodURL:URLRequest = new URLRequest("ZombieBlood.png");
		private var bloodLoader:Loader = new Loader();
		
		private var bloodCanvas:Graphics;
		private var zombieX:Number;
		private var zombieY:Number;
		public function Blood(zx:Number, zy:Number){
		this.x = zx;
		this.y = zy;
		this.rotation = Math.random()*360;
		bloodCanvas = this.graphics
		bloodLoader.load(bloodURL);
		bloodLoader.contentLoaderInfo.addEventListener(Event.COMPLETE, drawBlood, false, 0, true);
		
		}

		private function drawBlood(e:Event):void{
		var bloodBitmap:BitmapData = new BitmapData(20, 20, true, 0x000000)
		bloodBitmap.draw(bloodLoader, new Matrix());
		var matrix:Matrix = new Matrix();
		matrix.translate(-10, -15);
		bloodCanvas.beginBitmapFill(bloodBitmap, matrix, false, true);
		bloodCanvas.drawRect(-10, -15, 20, 20);
		addEventListener(Event.ENTER_FRAME, bloodFade, false, 0, true);	
		parent.addEventListener("NewLevel", levelClear);
				}
	
		private function levelClear(e:Event):void{
		bloodVisibility = 0;
		}
	
		private function bloodFade(e:Event):void{
				if(bloodVisibility == 0){
		parent.removeChild(this)
		removeEventListener(Event.ENTER_FRAME, bloodFade);	
		}
		bloodVisibility = bloodVisibility - 0.01
		this.alpha = bloodVisibility;	
	
		}
	
	
	}
}