package com.aquigorka.component{
	
	import flash.events.Event;
	import flash.events.MouseEvent;
	
	public class ComponentListaGrid extends ComponentLista{
	
		// ------- Constructor -------
		public function ComponentListaGrid(w:Number, h:Number, cf:Function, cols:int){
			// declaraciones
			super(w, h, cf);
			// instancias
			columnas = cols;
		}
		
		//------- Properties --------
		public var columnas:int;
		
		// ------- Methods -------
		// Public
		override public function add_item(item:ComponentItemLista):void{
			item.index = lista.numChildren;
			item.y = 0;
			item.x = 0;
			if(lista.numChildren > 0){
				var columna_item_anterior:Number = Math.round(lista.getChildAt(lista.numChildren - 1).x / lista.getChildAt(lista.numChildren - 1).width);
				item.y = lista.getChildAt(lista.numChildren - 1).y;
				if(columna_item_anterior < (columnas-1)){
					item.x = (columna_item_anterior + 1) * item.width;
				}else{
					item.y += item.height;
				}
			}
			item.addEventListener(MouseEvent.CLICK, handler_mouseclick, false, 0, true);
			item.callback_function_show_complete = local_callback_item_show_complete;
			lista.addChild(item);
			draw_scrollbar();
		}
		
		override public function remove_item(index:int):void {
			if(lista.numChildren > index){
				var item_remove:ComponentItemLista = lista.getChildAt(index) as ComponentItemLista;
				item_remove.visible = false;
				for(var i:int = index; i < lista.numChildren; i++){
					var columna_item_anterior:int = lista.getChildAt(index).x / lista.getChildAt(index).width;
					lista.getChildAt(i).y = lista.getChildAt(index).y;
					if(columna_item_anterior != columnas){
						lista.getChildAt(i).x = (columna_item_anterior + 1) * lista.getChildAt(index).width;
						lista.getChildAt(i).y += lista.getChildAt(index).height;
					}else{
						lista.getChildAt(i).x = 0;
					}
				}
				lista.removeChild(item_remove);
				item_remove = null;
				// aqui faltaría revisar si el scroll está hasta abajo y si al quitar un elemento se ve espacio en blanco y recorrer acorde
				draw_scrollbar();
			}
		}
	}
}