package com.aquigorka.component{
	
	import com.shinedraw.controls.IPhoneScroll;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.geom.Rectangle;
	import flash.text.TextField;
	import flash.text.TextFormat;
	import flash.text.TextFormatAlign;
	
	public class ComponentLista extends Sprite{
	
		// ------- Constructor -------
		public function ComponentLista(w:Number, h:Number, cf:Function){
			// destroy
			addEventListener(Event.REMOVED_FROM_STAGE, destroy, false, 0, true);
			// super
			super();
			// declaraciones
			_width = w; 
			_height = h;
			bool_click_lista_enabled = false;
			_bool_drag_enabled = true;
			callback_function_click_lista = cf;
			item_click = null;
			callback_function_show_complete = null;
			// instancias
			// mascara
			mascara = new Sprite();
			mascara.graphics.beginFill(0x000000);
			mascara.graphics.drawRect(0, 0, w, h);
			mascara.graphics.endFill();
			// mascara_scrollbar
			mascara_scrollbar = new Sprite();
			mascara_scrollbar.graphics.beginFill(0x000000);
			mascara_scrollbar.graphics.drawRect(0, 0, w, h);
			mascara_scrollbar.graphics.endFill();
			// formato aviso
			aviso = new TextField();
			aviso.x = 0;
			aviso.y = 0;
			aviso.height = 0;
			aviso.width = 0;
			aviso.selectable = false;
			// lista
			lista = new Sprite();
			lista.y = 0;
			lista.x = 0;
			// scrollbar
			scrollbar = new Sprite();
			// listeners
			create_listeners();
			// agregamos
			addChild(aviso);
			addChild(lista);
			addChild(scrollbar);
			addChild(mascara);
			addChild(mascara_scrollbar);
			// mascara
			lista.mask = mascara;
			scrollbar.mask = mascara_scrollbar;
			// init
			addEventListener(Event.ADDED_TO_STAGE, init);
		}
		
		private function init(e:Event = null):void{
			removeEventListener(Event.ADDED_TO_STAGE, init);
			_scroller = new IPhoneScroll(lista, stage);
			_scroller.canvasHeight = _height;
		}
		
		//------- Properties --------
		public var lista:Sprite;
		public var item_click:ComponentItemLista;
		public var callback_function_show_complete:Function;
		protected var _height:Number;
		protected var _width:Number;
		protected var mascara:Sprite;
		protected var mascara_scrollbar:Sprite;
		protected var scrollbar:Sprite;
		protected var aviso:TextField;
		protected var bool_click_lista_enabled:Boolean;
		protected var callback_function_click_lista:Function;
		protected var _bool_drag_enabled:Boolean;
		protected var _scroller:IPhoneScroll;
		
		// ------- Methods -------
		// Public
		public function set bool_drag_enabled(bool:Boolean):void { _bool_drag_enabled = bool; if(_scroller){_scroller.started = bool;} }
		public function get bool_drag_enabled():Boolean { return _bool_drag_enabled; }
		
		public function add_item(item:ComponentItemLista):void{
			item.index = lista.numChildren;
			item.y = lista.height;
			item.addEventListener(MouseEvent.CLICK, handler_mouseclick, false, 0, true);
			item.callback_function_show_complete = local_callback_item_show_complete;
			lista.addChild(item);
			draw_scrollbar();
		}
		
		public function avisa(str:String):void{
			draw_aviso();
			aviso.text = str.toUpperCase();
		}
		
		public function remove_all():void{
			if(lista.numChildren  > 0){
				item_click = null;
				aviso.text = '';
				while(lista.numChildren > 0){
					var item_remove:ComponentItemLista = lista.getChildAt(0) as ComponentItemLista;
					item_remove.removeEventListener(MouseEvent.CLICK, handler_mouseclick);
					item_remove.callback_function_show_complete = null;
					lista.removeChild(item_remove);
					item_remove = null;
				}
				lista.y = 0;
				// scroller
				if(_scroller){
					_scroller = new IPhoneScroll(lista, stage);
					_scroller.canvasHeight = _height;
				}
			}
		}
		
		public function remove_item(index:int):void {
			if(lista.numChildren > index){
				var item_remove:ComponentItemLista = lista.getChildAt(index) as ComponentItemLista;
				item_remove.callback_function_show_complete = null;
				item_remove.visible = false;
				var aux_h:Number = item_remove.height;
				for(var i:int = index; i < lista.numChildren; i++){
					lista.getChildAt(i).y -= (aux_h);
				}
				lista.removeChild(item_remove);
				item_remove = null;
				// aqui faltaría revisar si el scroll está hasta abajo y si al quitar un elemento se ve espacio en blanco y recorrer acorde
				draw_scrollbar();
			}
		}
		
		public function remove_item_id(id:String):void{
			for(var i:int = 0; i < lista.numChildren; i++){
				if(id == ComponentItemLista(lista.getChildAt(i)).id){
					remove_item(i);
					break;
				}
			}
		}
		
		public function set_item_click_id(id:String):void{
			for(var i:int = 0; i < lista.numChildren; i++){
				if(id == ComponentItemLista(lista.getChildAt(i)).id){
					item_click = ComponentItemLista(lista.getChildAt(i));
				}
			}
		}
		
		public function set_item_click_index(index:int):void{
			if(lista.numChildren > index){
				item_click = ComponentItemLista(lista.getChildAt(index));
			}
		}
		
		public function start_show():void {
			if(lista.numChildren > 0){
				(lista.getChildAt(0) as ComponentItemLista).show();
			}
		}
		
		// Protected
		protected function draw_aviso():void{
			aviso.x = 0;
			aviso.y = 0;
			aviso.height = 20;
			aviso.selectable = false;
			aviso.width = _width;
			var textformat_aviso:TextFormat = new TextFormat();
			textformat_aviso.size = 14;
			textformat_aviso.align = TextFormatAlign.CENTER;
			textformat_aviso.color = 0x000000;
			aviso.setTextFormat(textformat_aviso);
			aviso.defaultTextFormat = textformat_aviso;
		}
		
		protected function draw_scrollbar():void{
			scrollbar.x = _width - 5;
			scrollbar.y = 0;
			scrollbar.graphics.clear();
			if(_height < lista.height){
				scrollbar.graphics.beginFill(0x505050);
				scrollbar.graphics.drawRoundRect(0, 0, 5, (_height/lista.height*_height), 5, 5);
				scrollbar.graphics.endFill();
				scrollbar.alpha = 0;
			}
		}
		
		protected function handler_mouseclick(e:Event){
			if(bool_click_lista_enabled){
				item_click = e.currentTarget as ComponentItemLista;
				callback_function_click_lista();
			}
		}
		
		protected function handler_move_follow(e:Event):void{
			scrollbar.y = _height * -lista.y / lista.height;
			if(scrollbar.alpha < 1){
				scrollbar.alpha = Math.min(1, scrollbar.alpha + 0.1);
			}
		}
		
		protected function local_callback_item_show_complete(item:ComponentItemLista):void{
			if(item.index < (lista.numChildren-1)){
				(lista.getChildAt(item.index + 1) as ComponentItemLista).show();
			}else{
				if(callback_function_show_complete != null){
					callback_function_show_complete();
				}
			}
		}
		
		// Private
		private function create_listeners():void{
			lista.addEventListener(MouseEvent.MOUSE_DOWN, handler_mousedown, false, 0, true);
			lista.addEventListener('MOVE_FOLLOW', handler_move_follow, false, 0, true);
			lista.addEventListener('INACTIVITY_STOP', handler_inactivity_stop, false, 0, true);
		}
		
		private function destroy(e:Event):void{
			// listeners
			removeEventListener(Event.REMOVED_FROM_STAGE, destroy);
			remove_listeners();
			// graphics
			mascara.graphics.clear();
			mascara_scrollbar.graphics.clear();
			scrollbar.graphics.clear();
			// items
			remove_all();
			// stage
			_scroller.release();
			removeChild(aviso);
			removeChild(lista);
			removeChild(scrollbar);
			removeChild(mascara);
			removeChild(mascara_scrollbar);
			// referencias
			aviso = null;
			lista = null;
			scrollbar = null;
			mascara = null;
			mascara_scrollbar = null;
			_scroller = null;
		}
		
		private function handler_mousedown(e:MouseEvent):void{
			item_click = null;
			if(_bool_drag_enabled){
				if(!_scroller.started){
					_scroller.start();
				}
				bool_click_lista_enabled = true;
				lista.addEventListener(MouseEvent.MOUSE_MOVE, handler_mousemove, false, 0, true);
				lista.addEventListener(MouseEvent.ROLL_OUT, handler_mouseup, false, 0, true);
				lista.addEventListener(MouseEvent.MOUSE_UP, handler_mouseup , false, 0, true);
			}
		}
		
		private function handler_mousemove(e:MouseEvent):void{
			bool_click_lista_enabled = false;
		}
		
		private function handler_mouseup(e:MouseEvent):void {
			lista.removeEventListener(MouseEvent.MOUSE_MOVE, handler_mousemove);
			lista.removeEventListener(MouseEvent.MOUSE_UP, handler_mouseup);
			lista.removeEventListener(MouseEvent.ROLL_OUT, handler_mouseup);
		}
		
		private function handler_inactivity_stop(e:Event):void{
			scrollbar.alpha = 0;
		}
		
		private function remove_listeners():void {
			lista.removeEventListener(MouseEvent.MOUSE_DOWN, handler_mousedown);
			lista.removeEventListener(MouseEvent.MOUSE_MOVE, handler_mousemove);
			lista.removeEventListener(MouseEvent.MOUSE_UP, handler_mouseup);
			lista.removeEventListener(MouseEvent.ROLL_OUT, handler_mouseup);
			lista.removeEventListener('MOVE_FOLLOW', handler_move_follow);
			lista.removeEventListener('INACTIVITY_STOP', handler_inactivity_stop);
		}
	}
}