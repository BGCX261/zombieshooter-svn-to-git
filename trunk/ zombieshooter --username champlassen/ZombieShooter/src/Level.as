package{
	import flash.display.BitmapData;
	import flash.display.Graphics;
	import flash.display.Loader;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.geom.Matrix;
	import flash.net.URLRequest;
	public class Level extends Sprite{
		public var boxesXArray:Array;
		public var boxesYArray:Array;
		public var boxesWidthArray:Array;
		public var boxesHeightArray:Array;
		private var canvas:Graphics;	
		public var p:Player;
		public var currentLevel:int = 0;
		private var zombieArray:Array = new Array();
		public var scoreCount:int;
		public var score:String;
		private var boxTexture:BitmapData;
		
		private var loader:Loader = new Loader();
		
		
		public function Level(){
			
			var boxTextureFile:URLRequest = new URLRequest("Bricks.png");
			loader.contentLoaderInfo.addEventListener(Event.COMPLETE, textureLoaded);
			loader.load(boxTextureFile);
			
			canvas = this.graphics;
			addEventListener("deadZombie", updateLevel);
			addEventListener("deadZombie", updateScore);

			
			
			}

		private function textureLoaded(e:Event):void{
		boxTexture = new BitmapData(loader.width, loader.height);
		boxTexture.draw(loader, new Matrix());
		p = new Player(this, zombieArray);
		addChild(p);
		drawLevel();
		}

		private function drawLevel():void{
			currentLevel++;
			boxesXArray = [];
			boxesYArray = [];
			boxesWidthArray = [];
			boxesHeightArray = [];
			canvas.beginBitmapFill(boxTexture);
			for (var i:int = 0; i < 15; i++) {
			
				drawBox(i);
				checkBoxes(i);	
				canvas.drawRect(boxesXArray[i], boxesYArray[i], boxesWidthArray[i], boxesHeightArray[i])		
				
				}
				
		
			for(var z:int = 0; z < currentLevel; z++){
				
				var randomZombie:Number = Math.random();
				if(randomZombie < 0.33){
					var zombie:Zombie = new Zombie(this, p, zombieArray, 1);
					}
				else if(0.33 < randomZombie && randomZombie < 0.66){
					var zombie:Zombie = new Zombie(this, p, zombieArray, 2);
					}
				else{
					var zombie:Zombie = new Zombie(this, p, zombieArray, 3);
					}				
				zombieArray[z] = zombie;
				addChild(zombieArray[z]);
					
				}
			}
			
			private function updateScore(e:Event):void{
			scoreCount += currentLevel*5
			score = "SCORE: " + scoreCount;
			dispatchEvent(new Event("ScoreUpdate"));
			}
			
			private function drawBox(i:int):void{
				boxesXArray[i] = Math.random()*440+30;
				boxesYArray[i] = Math.random()*360+30;
				boxesWidthArray[i] = Math.random()*70+30;
				boxesHeightArray[i] = Math.random()*70+30;
			}
			
			private function checkBoxes(i:int):void{
			for (var l:int = 0; l < boxesXArray.length-1; l++){
						
				//Øverste venstre hjørne
				if(boxesXArray[i] > boxesXArray[l]-20 && boxesXArray[i] < boxesXArray[l] + boxesWidthArray[l]+20 && boxesYArray[i] > boxesYArray[l] && boxesYArray[i]-20 < boxesYArray[l] + boxesHeightArray[l]+20){
					drawBox(i);
					checkBoxes(i);
					}
				
				//Nederste højre hjørne
				if(boxesXArray[i] + boxesWidthArray[i] > boxesXArray[l]-20 && boxesXArray[i] + boxesWidthArray[i] < boxesXArray[l] + boxesWidthArray[l]+20 && boxesYArray[i] + boxesHeightArray[i] > boxesYArray[l]-20 && boxesYArray[i] + boxesHeightArray[i] < boxesYArray[l] + boxesHeightArray[l]+20){
					drawBox(i);
					checkBoxes(i);
					}
						
				//Øverste højre hjørne
				if(boxesXArray[i] + boxesWidthArray[i] > boxesXArray[l]-20 && boxesXArray[i] + boxesWidthArray[i] < boxesXArray[l] + boxesWidthArray[l]+20 && boxesYArray[i] > boxesYArray[l]-20 && boxesYArray[i] < boxesYArray[l] + boxesHeightArray[l]+20){
					drawBox(i);
					checkBoxes(i);
					}
						
				//Nederste venstre hjørne
				if(boxesXArray[i] > boxesXArray[l]-20 && boxesXArray[i] < boxesXArray[l] + boxesWidthArray[l]+20 && boxesYArray[i] + boxesHeightArray[i] > boxesYArray[l]-20 && boxesYArray[i] + boxesHeightArray[i] < boxesYArray[l] + boxesHeightArray[l]+20){
					drawBox(i);
					checkBoxes(i);
					}
						
				//Punkt mellem øverste venstre og højre hjørne
				if(boxesXArray[i] + boxesWidthArray[i]/2 > boxesXArray[l]-20 && boxesXArray[i] + boxesWidthArray[i]/2 < boxesXArray[l] + boxesWidthArray[l]+20 && boxesYArray[i] > boxesYArray[l]-20 && boxesYArray[i] < boxesYArray[l] + boxesHeightArray[l]+20){
					drawBox(i);
					checkBoxes(i);
					}
						
				//Punkt mellem øverste og nederste venstre hjørne
				if(boxesXArray[i] > boxesXArray[l]-20 && boxesXArray[i] < boxesXArray[l] + boxesWidthArray[l]+20 && boxesYArray[i] + boxesHeightArray[i]/2 > boxesYArray[l]-20 && boxesYArray[i] + boxesHeightArray[i]/2 < boxesYArray[l] + boxesHeightArray[l]+20){
					drawBox(i);
					checkBoxes(i);
					}
					
				//Punkt mellem øverste og nederste højre hjørne
				if(boxesXArray[i] + boxesWidthArray[i] > boxesXArray[l]-20 && boxesXArray[i] + boxesWidthArray[i] < boxesXArray[l] + boxesWidthArray[l]+20 && boxesYArray[i] + boxesHeightArray[i]/2 > boxesYArray[l]-20 && boxesYArray[i] + boxesHeightArray[i]/2 < boxesYArray[l] + boxesHeightArray[l]+20){
					drawBox(i);
					checkBoxes(i);
					}
						
				//Punkt mellem nederste venstre og højre hjøre
				if(boxesXArray[i] + boxesWidthArray[i]/2 > boxesXArray[l]-20 && boxesXArray[i] + boxesWidthArray[i]/2 < boxesXArray[l] + boxesWidthArray[l]+20 && boxesYArray[i] + boxesHeightArray[i] > boxesYArray[l]-20 && boxesYArray[i] + boxesHeightArray[i] < boxesYArray[l] + boxesHeightArray[l]+20){
					drawBox(i);
					checkBoxes(i);
					}
						
				//Centrum
				if(boxesXArray[i] + boxesWidthArray[i]/2 > boxesXArray[l] && boxesXArray[i] + boxesWidthArray[i]/2 < boxesXArray[l] + boxesWidthArray[l] && boxesYArray[i] + boxesHeightArray[i]/2 > boxesYArray[l] && boxesYArray[i] + boxesHeightArray[i]/2 < boxesYArray[l] + boxesHeightArray[l]){
					drawBox(i);
					checkBoxes(i);
					}
				}
			}
				
			private function updateLevel(e:Event):void{
				if(zombieArray.length == 0){
				dispatchEvent(new Event("LevelCleared"));
				p.addEventListener("PlayerInPlace", endLevel);
				canvas.clear();
				boxesXArray = [];
				boxesYArray = [];
				boxesWidthArray = [];
				boxesHeightArray = [];

				}
			}
			
			private function endLevel(e:Event):void{
				p.removeEventListener("PlayerInPlace", endLevel);
				drawLevel();
				dispatchEvent(new Event("NewLevel"));
		}
		
		public function get boxes():int{
		return boxesXArray.length;
		}
			
	}			
}
