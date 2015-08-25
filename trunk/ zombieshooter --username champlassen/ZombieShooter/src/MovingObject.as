package{
	import flash.display.Sprite;
	import flash.events.Event;
	public class MovingObject extends Sprite{
		private var _xCoordinate:Number;
		private var _yCoordinate:Number;
		private var _direction:Number;
		private var _level:Level;
		public function MovingObject(l:Level){
			_level = l;
			
		}
		
		public function updatePosition(e:Event):void{
		
		}
		
		protected function updatexPosition(xCoor:Number):Number{
			_xCoordinate = xCoor;
			if(_xCoordinate < 16) {
			_xCoordinate = 16}
			if(_xCoordinate > 584){
			_xCoordinate = 584}
			for(var i:int = 0; i < _level.boxesXArray.length; i++){
			var xcoor:Number = _level.boxesXArray[i];
			var ycoor:Number = _level.boxesYArray[i];
			var h:Number = _level.boxesHeightArray[i];
			var w:Number = _level.boxesWidthArray[i];
			//venstre side
			if(xcoor - 11 < _xCoordinate && _xCoordinate  < xcoor + w / 2 && ycoor < _yCoordinate && _yCoordinate < ycoor + h){
			_xCoordinate = xcoor - 11;}
			//højre side
			if(xcoor + w / 2 < _xCoordinate && _xCoordinate  < xcoor + w + 11 && ycoor < _yCoordinate && _yCoordinate < ycoor + h){
			_xCoordinate = xcoor + w + 11;}
			
			 }
			return(_xCoordinate);		
		}
		
		protected function updateyPosition(yCoor:Number):Number{
			_yCoordinate = yCoor;
			if(_yCoordinate < 16){
			_yCoordinate = 16}
			if(_yCoordinate > 504){
			_yCoordinate = 504}
			for(var i:int = 0; i < _level.boxesXArray.length; i++){
			var xcoor:Number = _level.boxesXArray[i];
			var ycoor:Number = _level.boxesYArray[i];
			var h:Number = _level.boxesHeightArray[i];
			var w:Number = _level.boxesWidthArray[i];
			//øverste side
			if(xcoor  < _xCoordinate && _xCoordinate  < xcoor + w && ycoor - 11 < _yCoordinate && _yCoordinate < ycoor + h / 2){
			_yCoordinate = ycoor - 11;}
			//nederste side
			if(xcoor < _xCoordinate && _xCoordinate  < xcoor + w && ycoor + h / 2 < _yCoordinate && _yCoordinate < ycoor + h + 11){
			_yCoordinate = ycoor + h + 11;}
			
			 }
		
			return(_yCoordinate);
			}

	}
}