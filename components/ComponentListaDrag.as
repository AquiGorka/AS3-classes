package com.aquigorka.component{
	
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.geom.Rectangle;
	import flash.text.TextField;
	import flash.text.TextFormat;
	import flash.text.TextFormatAlign;
	
	public class ComponentListaDrag extends Sprite{
	
		// ------- Constructor -------
		public function ComponentListaDrag(w:Number, h:Number, cf:Function){
			// destroy
			addEventListener(Event.REMOVED_FROM_STAGE, destroy, false, 0, true);
			// declaraciones
			_width = w; 
			_height = h;
			bool_click_lista_enabled = false;
			bool_drag_enabled = true;
			callback_function_click_lista = cf;
			item_click = null;
			// instancias
			// mascara
			mascara = new Sprite();
			mascara.graphics.beginFill(0x000000);
			mascara.graphics.drawRect(0, 0, w, h);
			mascara.graphics.endFill();
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
			lista.addEventListener(MouseEvent.MOUSE_DOWN, handler_mousedown, false, 0, true);
			// agregamos
			addChild(aviso);
			addChild(lista);
			addChild(scrollbar);
			addChild(mascara);
			// mascara
			lista.mask = mascara;
		}
		
		//------- Properties --------
		public var lista:Sprite;
		public var bool_drag_enabled:Boolean;
		public var item_click:ComponentItemLista;
		protected var _height:Number;
		protected var _width:Number;
		protected var scrollbar:Sprite;
		protected var bool_click_lista_enabled:Boolean;
		protected var callback_function_click_lista:Function;
		protected var mascara:Sprite;
		private var aviso:TextField;
		
		// ------- Methods -------
		// Public
		public function add_item(item:ComponentItemLista):void{
			item.y = lista.height;
			item.addEventListener(MouseEvent.CLICK, handler_mouseclick, false, 0, true);
			lista.addChild(item);
			draw_scrollbar();
		}
		
		public function avisa(str:String):void{
			draw_aviso();
			aviso.text = str;
		}
		
		public function remove_all():void{
			item_click = null;
			aviso.text = '';
			while(lista.numChildren > 0){
				var item_remove:ComponentItemLista = lista.getChildAt(0) as ComponentItemLista;
				item_remove.removeEventListener(MouseEvent.CLICK, handler_mouseclick);
				lista.removeChild(item_remove);
				item_remove = null;
			}
			lista.y = 0;
			draw_scrollbar();
		}
		
		public function remove_item(index:int):void {
			if(lista.numChildren > index){
				var item_remove:ComponentItemLista = lista.getChildAt(index) as ComponentItemLista;
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
			scrollbar.graphics.clear();
			if(_height < lista.height){
				scrollbar.graphics.beginFill(0x505050);
				scrollbar.graphics.drawRoundRect(0, 0, 5, (_height/lista.height*_height), 5, 5);
				scrollbar.graphics.endFill();
				scrollbar.alpha = 0;
			}
		}
		
		protected function handler_mouseclick(e:Event){
			//trace('bool_click_lista_enabled: '+bool_click_lista_enabled)
			if(bool_click_lista_enabled){
				item_click = e.currentTarget as ComponentItemLista;
				callback_function_click_lista();
			}
		}
		
		// Private
		private function destroy(e:Event):void{
			// listeners
			removeEventListener(Event.REMOVED_FROM_STAGE, destroy);
			removeEventListener(MouseEvent.MOUSE_DOWN, handler_mousedown);
			// graphics
			mascara.graphics.clear();
			// items
			remove_all();
			// stage
			removeChild(aviso);
			removeChild(lista);
			removeChild(scrollbar);
			removeChild(mascara);
			// referencias
			aviso = null;
			lista = null;
			scrollbar = null;
			mascara = null;
		}
		
		private function handler_mousedown(e:MouseEvent):void{
			//trace('handler_mousedown componentlista: '+bool_drag_enabled)
			item_click = null;
			if(bool_drag_enabled){
				bool_click_lista_enabled = true;
				lista.addEventListener(MouseEvent.MOUSE_MOVE, handler_mousemove,false,0,true);
				lista.addEventListener(MouseEvent.ROLL_OUT, handler_mouseup,false,0,true);
				lista.addEventListener(MouseEvent.MOUSE_UP, handler_mouseup ,false,0,true);
				if(lista.height > _height){
					lista.startDrag(false, new Rectangle(lista.x, ( -(lista.height - _height)), 0, ((lista.height - _height))));
				}else{
					if(lista.y != 0){
						lista.y = 0;
					}
				}
			}
		}
		
		private function handler_mousemove(e:MouseEvent):void{
			bool_click_lista_enabled = false;
			scrollbar.y = _height * Math.min(1,(-lista.y/lista.height));
			if(scrollbar.alpha < 1)
				scrollbar.alpha = Math.min(1, scrollbar.alpha + 0.1);
		}
		
		private function handler_mouseup(e:MouseEvent):void{
			//trace('handler_up componentlista: '+bool_drag_enabled)
			lista.removeEventListener(MouseEvent.MOUSE_MOVE, handler_mousemove);
			lista.removeEventListener(MouseEvent.ROLL_OUT, handler_mouseup);
			lista.removeEventListener(MouseEvent.MOUSE_UP, handler_mouseup);
			lista.stopDrag();
			scrollbar.alpha = 0;
		}
	}
}