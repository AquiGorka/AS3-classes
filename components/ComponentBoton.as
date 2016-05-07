package com.aquigorka.component{
	
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.filters.BitmapFilterQuality;
	import flash.filters.BlurFilter;
	import flash.filters.GlowFilter;
	
	public class ComponentBoton extends Sprite{
	
		// ------- Constructor -------
		public function ComponentBoton(col:Number=0xFFFFFF){
			// destroy
			addEventListener(Event.REMOVED_FROM_STAGE, destroy, false, 0, true);
			// super
			super();
			// declaraciones
			arreglo_filters = [new GlowFilter(col, .5, 8, 8, 3, BitmapFilterQuality.HIGH), new BlurFilter(2,2,1)];
			// listener
			addEventListener(MouseEvent.MOUSE_DOWN, handler_press, false, 0, true);
		}
		
		//------- Properties --------
		private var arreglo_filters:Array;
		
		// ------- Methods -------
		// Private
		private function destroy(evt:Event):void{
			// listeners
			removeEventListener(Event.REMOVED_FROM_STAGE, destroy);
			removeEventListener(MouseEvent.MOUSE_DOWN, handler_press);
			// stage
			arreglo_filters = [];
			filters = [];
			// referencias
			arreglo_filters = null;
		}
		
		private function handler_press(evt:MouseEvent):void{
			addEventListener(MouseEvent.MOUSE_UP, handler_up, false, 0, true);
			addEventListener(MouseEvent.ROLL_OUT, handler_up, false, 0, true);
			addEventListener(MouseEvent.MOUSE_MOVE, handler_up, false, 0, true);
			removeEventListener(MouseEvent.MOUSE_DOWN, handler_press);
			filters = arreglo_filters;
		}
		
		private function handler_up(evt:MouseEvent):void{
			removeEventListener(MouseEvent.MOUSE_UP, handler_up);
			removeEventListener(MouseEvent.ROLL_OUT, handler_up);
			removeEventListener(MouseEvent.MOUSE_MOVE, handler_up);
			addEventListener(MouseEvent.MOUSE_DOWN, handler_press, false, 0, true);
			filters = [];
		}
	}
}