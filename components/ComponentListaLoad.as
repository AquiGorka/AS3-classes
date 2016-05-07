package com.aquigorka.component{
	
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	
	public class ComponentListaLoad extends ComponentLista{
	
		// ------- Constructor -------
		public function ComponentListaLoad(w:Number, h:Number, func:Function){
			// destroy
			addEventListener(Event.REMOVED_FROM_STAGE, destroy, false, 0, true);
			// super
			super(w, h, local_callback_function_click_listaload);
			// declaraciones
			callback_function_click_listaload = func;
			limit_show = 0;
			load_num = 10;
			_items = [];
			bool_item_load_agregado = false;
		}
		
		//------- Properties --------
		public var limit_show:int;
		public var load_num:int;
		protected var item_load:ComponentItemLista;
		protected var callback_function_click_listaload:Function;
		private var _items:Array;
		private var bool_item_load_agregado:Boolean;
		private var btn_load:ComponentSimboloBoton;
		
		// ------- Methods -------
		// Public
		override public function add_item(item:ComponentItemLista):void{
			_items[_items.length] = item;
			// reviso si tengo cargador y lo quito para seguir normal
			if(bool_item_load_agregado){
				remove_item(lista.numChildren - 1);
				bool_item_load_agregado = false;
			}
			agrega_elemento(item);
		}
		
		public function load():void{
			var num_show:int = load_num;
			var restantes:int = _items.length - lista.numChildren;
			if(restantes < num_show){
				num_show = restantes;
			}
			limit_show += num_show;
			for(var i:int = lista.numChildren; i < limit_show; i++){
				show_item(i);
			}
		}
		
		override public function remove_all():void{
			_items = [];
			bool_item_load_agregado = false;
			super.remove_all();
		}
		
		override public function remove_item_id(id:String):void{
			super.remove_item_id(id);
			for(var i:int = 0; i < _items.length; i++){
				if(id == _items[i].id){
					_items.splice(i, 1);
				}
			}
		}
		
		// Protected
		protected function draw_item_load():void {
			item_load = new ComponentItemLista('item_load');
			btn_load = new ComponentSimboloBoton('V', 0x777777, 0x7777777, 0xAAAAAA, _width - 4 - 20, 40, 0xDDDDDD, .4, 30);
			btn_load.x = (_width - btn_load.width) / 2;
			btn_load.y = (50 - btn_load.height) / 2;
			item_load.addChild(btn_load);
		}
		
		protected function local_callback_function_click_listaload():void{
			if(item_click.id != 'item_load'){
				callback_function_click_listaload();
			}else{
				undraw_item_load();
				remove_item(lista.numChildren - 1);
				bool_item_load_agregado = false;
				load();
			}
		}
		
		protected function undraw_item_load():void{
			item_load.removeChild(btn_load);
			btn_load = null;
			item_load = null;
		}
		
		
		protected function add_cargador():void{
			bool_item_load_agregado = true;
			draw_item_load();
			super.add_item(item_load);
		}
		
		// Private
		private function agrega_elemento(item:ComponentItemLista):void{
			if(!bool_item_load_agregado && limit_show > lista.numChildren || limit_show == 0){
				super.add_item(item);
			}
			if(!bool_item_load_agregado && (_items.length > limit_show) && (limit_show != 0) && (lista.numChildren >= limit_show)){
				add_cargador();
			}
		}
		
		private function destroy(evt:Event):void{
			// listeners
			removeEventListener(Event.REMOVED_FROM_STAGE, destroy);
			// stage
			if(btn_load){
				item_load.removeChild(btn_load);
				btn_load = null;
			}
			// referencias
			_items = null;
			item_load = null;
		}
		
		private function show_item(i:int):void{
			var item:ComponentItemLista = ComponentItemLista(_items[i]);
			agrega_elemento(item);
		}
	}
}