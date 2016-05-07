package com.aquigorka.component{
	
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.ui.Multitouch;
	import flash.ui.MultitouchInputMode;
	import flash.events.TransformGestureEvent;
	
	public class ComponentListaDelete extends ComponentLista{
	
		// ------- Constructor -------
		public function ComponentListaDelete(w:Number, h:Number, cf_click:Function, cf_delete:Function){
			// destroy
			addEventListener(Event.REMOVED_FROM_STAGE, destroy, false, 0, true);
			// super
			super(w, h, local_callback_item_click);
			// declaraciones
			callback_function_click = cf_click;
			callback_function_delete = cf_delete;
			item_delete = null;
			Multitouch.inputMode = MultitouchInputMode.GESTURE;
			bool_delete_activo = true;
		}
		
		//------- Properties --------
		public var item_delete:ComponentItemListaDelete;
		private var bool_delete_activo:Boolean;
		private var callback_function_click:Function;
		private var callback_function_delete:Function;
		
		// ------- Methods -------
		// Public
		override public function add_item(item:ComponentItemLista):void{
			var aux_item:ComponentItemListaDelete = item as ComponentItemListaDelete;
			aux_item.set_callback_function_delete(local_callback_item_delete);
			aux_item.addEventListener(TransformGestureEvent.GESTURE_SWIPE, handler_swipe_item_delete, false, 0, true);
			super.add_item(aux_item);
		}
		
		public function add_item_undeletable(item:ComponentItemLista):void {
			super.add_item(item);
		}
		
		override public function remove_all():void{
			item_delete = null;
			bool_delete_activo = true;
			bool_drag_enabled = true;
			super.remove_all();
		}
		
		// Protected
		protected function local_callback_item_delete():void{
			callback_function_delete();
			bool_delete_activo = true;
			bool_drag_enabled = true;
			if(lista.height < _height){
				lista.y = 0;
			}else{
				if(lista.y <(_height-lista.height)){
					lista.y = _height - lista.height;
				}
			}
		}
		
		// Private
		private function despliega_delete(item:ComponentItemListaDelete):void{
			if(bool_delete_activo){
				bool_drag_enabled = false;
				bool_delete_activo = false;
				item_delete = item;
				item.show_delete();
			}else{
				remove_delete();
			}
		}
		
		private function destroy(evt:Event):void{
			// listeners
			removeEventListener(Event.REMOVED_FROM_STAGE, destroy);
			for(var i:int = 0; i < lista.numChildren; i++){
				lista.getChildAt(i).removeEventListener(TransformGestureEvent.GESTURE_SWIPE, handler_swipe_item_delete);
			}
			// referencias
			item_delete = null;
		}
		
		private function handler_swipe_item_delete(e:TransformGestureEvent):void{
			if(e.offsetX == 1){
				despliega_delete(e.currentTarget as ComponentItemListaDelete);
			}else{
				if(e.offsetX == -1 && !bool_delete_activo){
					despliega_delete(e.currentTarget as ComponentItemListaDelete);
				}
			}
		}
		
		private function local_callback_item_click():void{
			if(bool_delete_activo){
				callback_function_click();
			}
		}
		
		private function remove_delete():void{
			if(item_delete){
				item_delete.hide_delete();
				item_delete.set_callback_function_delete(null);
				item_delete = null;
				bool_delete_activo = true;
				bool_drag_enabled = true;
			}
		}
	}
}