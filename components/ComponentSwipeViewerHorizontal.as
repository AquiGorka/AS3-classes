package com.aquigorka.component{
	
	import com.aquigorka.component.ComponentSwipeViewer;
	import flash.events.Event;
	import flash.events.TransformGestureEvent;

	public class ComponentSwipeViewerHorizontal extends ComponentSwipeViewer{

		// ------- Constructor -------
		public function ComponentSwipeViewerHorizontal(data:Array, w:Number, h:Number, cf:Function){
			// super
			super(data, w, h, cf);
		}
		
		// ------- Methods -------
		// Protected
		override protected function handler_swipe(event:TransformGestureEvent):void{
			var valid_swipe:Boolean = false;
			var indice_matriz_futuro:int = indice_matriz;
			if(event.offsetX == -1){
				indice_matriz_futuro = indice_matriz + 1;
				if(indice_matriz_futuro < arr_data.length){
					valid_swipe = true;
				}
			}else if(event.offsetX == 1){
				indice_matriz_futuro = indice_matriz - 1;
				if(indice_matriz_futuro >= 0){
					valid_swipe = true;
				}
			}
			if(valid_swipe){
				remove_listeners();
				callback_function_swipe(indice_matriz_futuro);
				render_x(indice_matriz_futuro, 0);
			}
		}
	}
}