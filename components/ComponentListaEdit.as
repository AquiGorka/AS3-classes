package com.aquigorka.component{
	
	import com.aquigorka.model.Tweener;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.geom.Rectangle;
	
	public class ComponentListaEdit extends ComponentLista{
	
		// ------- Constructor -------
		public function ComponentListaEdit(w:Number, h:Number, cf_click:Function, cf_edit:Function){
			// destroy
			addEventListener(Event.REMOVED_FROM_STAGE, destroy, false, 0, true);
			// super
			super(w, h, local_callback_click_item);
			// declaraciones
			callback_function_edit = cf_edit;
			callback_function_click_lista_edit = cf_click;
			cuenta_items = 0;
			referencia_nula();
			bool_edit_activo = false;
			bool_click_listaedit_enabled = true;
		}
		
		// ------- Properties --------
		protected var cuenta_items:int;
		protected var lista_height:Number;
		private var bool_click_listaedit_enabled:Boolean;
		private var edit_actual:ComponentItemListaEdit;
		private var edit_siguiente:ComponentItemListaEdit;
		private var edit_anterior:ComponentItemListaEdit;
		private var aux_punto_medio:Number;
		private var bool_edit_activo:Boolean;
		private var callback_function_edit:Function;
		private var callback_function_click_lista_edit:Function;
		
		// ------- Methods -------
		// Public
		override public function add_item(item:ComponentItemLista):void{
			var aux_item:ComponentItemListaEdit = item as ComponentItemListaEdit;
			aux_item.index = cuenta_items;
			super.add_item(item);
			cuenta_items++;
			lista_height = lista.height;
		}
		
		public function edit_show():void{
			referencia_nula();
			bool_click_listaedit_enabled = false;
			bool_drag_enabled = false;
			for(var i:int = 0;i < lista.numChildren;i++){
				ComponentItemListaEdit(lista.getChildAt(i)).show_edit();
				lista.getChildAt(i).addEventListener(MouseEvent.MOUSE_DOWN, handler_mousedown,false,0,true);
			}
		}
		
		public function edit_hide():void{
			referencia_nula();
			bool_click_listaedit_enabled = true;
			bool_drag_enabled = true;
			
			for(var i:int = 0;i < cuenta_items;i++){
				ComponentItemListaEdit(lista.getChildAt(i)).hide_edit();
				lista.getChildAt(i).removeEventListener(MouseEvent.MOUSE_DOWN, handler_mousedown);
			}
		}
		
		override public function remove_all():void{
			edit_hide();
			super.remove_all();
		}
		
		// Protected
		protected function handler_mousedown(e:Event):void{
			referencia_nula();
			edit_actual = e.currentTarget as ComponentItemListaEdit;
			edit_actual.removeEventListener(MouseEvent.MOUSE_DOWN, handler_mousedown);
			edit_actual.addEventListener(MouseEvent.MOUSE_MOVE, handler_mousemove, false, 0, true);
			edit_actual.addEventListener(MouseEvent.ROLL_OUT, handler_mouseup, false, 0, true);
			edit_actual.addEventListener(MouseEvent.MOUSE_UP, handler_mouseup , false, 0, true);
			edit_actual.alpha = .85;
			edit_actual.original_pos_y = edit_actual.y;
			for(var i:int = 0;i < lista.numChildren; i++){
				if(ComponentItemListaEdit(lista.getChildAt(i)).index == edit_actual.index){
					lista.addChild(lista.getChildAt(i));
				}
			}
			referenciar_elementos();
			edit_actual.startDrag(false, new Rectangle(0, 0, 0, lista.height));
		}
		
		protected function referencia_nula():void{
			edit_actual = null;
			edit_siguiente = null;
			edit_anterior = null;
			aux_punto_medio = -1;	
		}
		
		// Private
		private function local_callback_click_item():void {
			if(bool_click_listaedit_enabled){
				callback_function_click_lista_edit();
			}
		}
		
		private function cambio_elementos(elem_1:ComponentItemListaEdit,elem_2:ComponentItemListaEdit):void{
			bool_edit_activo = true;
			// asincrono
			var params:Array = [];
			params['elem_1'] = elem_1.id;
			params['elem_2'] = elem_2.id;
			callback_function_edit(params);
			// indices
			var aux:int = elem_1.index;
			elem_1.index = elem_2.index;
			elem_2.index = aux;
			// lugar
			var tw:Tweener = new Tweener();
			tw.linear_tween(elem_2, 'y', elem_2.y, elem_1.original_pos_y, 100, function():void{
					elem_1.original_pos_y = elem_2.original_pos_y;
					elem_2.original_pos_y = elem_2.y;
					bool_edit_activo = false;
					referenciar_elementos();
				}
			);			
		}
		
		private function destroy(evt:Event):void{
			// listeners
			removeEventListener(Event.REMOVED_FROM_STAGE, destroy);
			// referencias
			referencia_nula();
		}
		
		private function handler_mousemove(e:MouseEvent):void{
			if(edit_anterior){
				aux_punto_medio = edit_anterior.y + (edit_anterior.height) / 2;
				if(aux_punto_medio > edit_actual.y && !bool_edit_activo){
					cambio_elementos(edit_actual, edit_anterior);
				}
			}
			if(edit_siguiente){
				aux_punto_medio = edit_siguiente.y + (edit_siguiente.height)/2
				if((edit_actual.y + edit_actual.height) > aux_punto_medio && !bool_edit_activo){
					cambio_elementos(edit_actual, edit_siguiente);
				}
			}
			addEventListener(Event.ENTER_FRAME, handler_movelista, false, 0, true);
		}
		
		private function handler_mouseup(e:MouseEvent):void{
			removeEventListener(Event.ENTER_FRAME, handler_movelista);
			referencia_nula();
			var aux:ComponentItemListaEdit = ComponentItemListaEdit(e.currentTarget)
			aux.stopDrag();
			aux.alpha = 1;
			aux.removeEventListener(MouseEvent.MOUSE_MOVE, handler_mousemove);
			aux.removeEventListener(MouseEvent.ROLL_OUT, handler_mouseup);
			aux.removeEventListener(MouseEvent.MOUSE_UP, handler_mouseup);
			var pos_y = 0;
			for(var i:int = 0;i < lista.numChildren;i++){
				if(i == aux.index){
					break;
				}else{
					pos_y += lista.getChildAt(i).height;	
				}
			}
			var tw:Tweener = new Tweener();
			tw.linear_tween(aux, 'y', aux.y, pos_y, 200, function(){
					for(var i:int = 0;i < lista.numChildren; i++){
						for(var j:int = 0;j < lista.numChildren; j++){
							if(ComponentItemListaEdit(lista.getChildAt(j)).index == i){
								lista.addChild(lista.getChildAt(j));
							}
						}
					}
					aux.addEventListener(MouseEvent.MOUSE_DOWN, handler_mousedown, false, 0, true);
				}
			);
		}
		
		private function handler_movelista(e:Event):void{
			if((edit_actual.y - lista.y > 0) && (edit_actual.y + lista.y < -1)){
				lista.y += 5;
				edit_actual.y -= 5;
			}
			if((edit_actual.y+lista.y) > (_height - (edit_actual.height - 8)) && (edit_actual.y-8) < (lista_height-edit_actual.height)){
				lista.y -= 5;
				edit_actual.y += 5;
			}
		}
		
		private function referenciar_elementos():void{
			if(edit_actual){
				var i:int;
				edit_anterior = null;
				edit_siguiente = null;
				if(edit_actual.index > 0){
					for(i = 0;i < lista.numChildren;i++){
						if(ComponentItemListaEdit(lista.getChildAt(i)).index == (edit_actual.index-1)){
							edit_anterior = ComponentItemListaEdit(lista.getChildAt(i));
							edit_anterior.original_pos_y = edit_anterior.y;
							break;
						}
					}
				}
				if(edit_actual.index < (cuenta_items-1)){
					for(i= 0;i < lista.numChildren;i++){
						if(ComponentItemListaEdit(lista.getChildAt(i)).index == (edit_actual.index+1)){
							edit_siguiente = ComponentItemListaEdit(lista.getChildAt(i));
							edit_siguiente.original_pos_y = edit_siguiente.y;
							break;
						}
					}
				}
			}
		}
	}
}