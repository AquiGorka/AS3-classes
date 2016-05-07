package com.aquigorka.component{
	
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.ui.Multitouch;
	import flash.ui.MultitouchInputMode;
	import flash.events.TransformGestureEvent;
	
	public class ComponentListaDeleteEdit extends ComponentListaEdit{
	
		// ------- Constructor -------
		public function ComponentListaDeleteEdit(w:Number, h:Number, cf_click:Function, cf_edit:Function, cf_delete:Function){
			// destroy
			addEventListener(Event.REMOVED_FROM_STAGE, destroy, false, 0, true);
			// super
			super(w, h, local_callback_item_click, cf_edit);
			// declaraciones
			callback_function_click_listaeditdelete = cf_click;
			callback_function_delete = cf_delete;
			item_delete = null;
			Multitouch.inputMode = MultitouchInputMode.GESTURE;
			bool_click_delete_edit = true;
		}
		
		//------- Properties --------
		public var item_delete:ComponentItemListaDeleteEdit;
		private var bool_edit_activo:Boolean;
		private var bool_click_delete_edit:Boolean;
		private var callback_function_click_listaeditdelete:Function;
		private var callback_function_delete:Function;
		
		// ------- Methods -------
		// Public
		override public function add_item(item:ComponentItemLista):void{
			var aux_item:ComponentItemListaDeleteEdit = item as ComponentItemListaDeleteEdit;
			aux_item.set_callback_function_delete(local_callback_item_delete);
			aux_item.addEventListener(TransformGestureEvent.GESTURE_SWIPE, handler_swipe, false, 0, true);
			super.add_item(aux_item);
		}
		
		override public function edit_show():void{
			if(bool_click_delete_edit){
				bool_edit_activo = true;
				referencia_nula();
				bool_click_delete_edit = false;
				bool_drag_enabled = false;
				for(var i:int = 0;i < lista.numChildren;i++){
					ComponentItemListaDeleteEdit(lista.getChildAt(i)).show_edit();
					lista.getChildAt(i).addEventListener(MouseEvent.MOUSE_DOWN, handler_mousedown,false,0,true);
				}
			}
		}
		
		override public function edit_hide():void{
			bool_edit_activo = false;
			referencia_nula();
			bool_click_delete_edit = true;
			bool_drag_enabled = true;
			for(var i:int = 0;i < lista.numChildren;i++){
				ComponentItemListaDeleteEdit(lista.getChildAt(i)).hide_edit();
				lista.getChildAt(i).removeEventListener(MouseEvent.MOUSE_DOWN, handler_mousedown);
			}
		}
		
		override public function remove_all():void{
			cuenta_items = 0;
			remove_delete();
			super.remove_all();
		}
		
		override public function remove_item_id(id:String):void{
			super.remove_item_id(id);
			cuenta_items--;
			for(var i:int = 0; i < lista.numChildren; i++){
				ComponentItemListaDeleteEdit(lista.getChildAt(i)).index = i;
				ComponentItemListaDeleteEdit(lista.getChildAt(i)).original_pos_y = ComponentItemListaDeleteEdit(lista.getChildAt(i)).y;
			}
			lista_height = lista.height;
		}
		
		// Protected
		protected function local_callback_item_delete():void{
			callback_function_delete();
			bool_click_delete_edit = true;
			bool_drag_enabled = true;
			if(lista.height < _height){
				lista.y = 0;
			} else {
				if(lista.y <(_height-lista.height)){
					lista.y = _height - lista.height;
				}
			}
		}
		
		// Private
		private function despliega_delete(item:ComponentItemListaDeleteEdit):void{
			if(!bool_edit_activo){
				if (bool_click_delete_edit){
					bool_drag_enabled = false;
					bool_click_delete_edit = false;
					item_delete = item;
					item.show_delete();
				}else{
					remove_delete();
				}
			}
		}
		
		private function destroy(evt:Event):void{
			// listeners
			removeEventListener(Event.REMOVED_FROM_STAGE, destroy);
			for(var i:int = 0; i < lista.numChildren; i++){
				lista.getChildAt(i).removeEventListener(TransformGestureEvent.GESTURE_SWIPE, handler_swipe);
			}
			// referencias
			item_delete = null;
		}
		
		private function local_callback_item_click(){
			if(bool_click_delete_edit){
				callback_function_click_listaeditdelete();
			}
		}
		
		private function handler_swipe(e:TransformGestureEvent):void{
			if(e.offsetX == 1){
				despliega_delete(e.currentTarget as ComponentItemListaDeleteEdit);
			} else{
				if(e.offsetX == -1 && !bool_click_delete_edit && !bool_edit_activo){
					despliega_delete(e.currentTarget as ComponentItemListaDeleteEdit);
				}
			}
		}
		
		private function remove_delete():void{
			if(item_delete){
				item_delete.hide_delete();
				item_delete.set_callback_function_delete(null);
				item_delete = null;
				bool_click_delete_edit = true;
				bool_drag_enabled = true;
			}
		}
	}
}