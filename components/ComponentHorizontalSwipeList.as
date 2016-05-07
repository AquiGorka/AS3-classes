package com.aquigorka.component{
	
	import com.aquigorka.model.Tweener;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.ui.Multitouch;
	import flash.ui.MultitouchInputMode;
	import flash.events.TransformGestureEvent;
	
	public final class ComponentHorizontalSwipeList extends Sprite{
	
		// ------- Constructor -------
		public function ComponentHorizontalSwipeList(w:Number, h:Number, func:Function){
			// destroy
			addEventListener(Event.REMOVED_FROM_STAGE, destroy,false,0,true);
			boolean_click = false;
			num_width = w;
			num_height = h;
			index = 0;
			boolean_click = false;
			func_click = func;
			
			// mascara
			sprite_mascara = new Sprite();
			sprite_mascara.graphics.beginFill(0x000000);
			sprite_mascara.graphics.drawRect(0,0,w,h);
			sprite_mascara.graphics.endFill();
			
			// lista
			elementos = new Vector.<ComponentItemLista>;
			
			// listeners
			addEventListener(MouseEvent.MOUSE_DOWN, handler_mousedown, false, 0, true);
			Multitouch.inputMode = MultitouchInputMode.GESTURE;
			addEventListener(TransformGestureEvent.GESTURE_SWIPE, handler_swipe, false, 0, true);
			
			// agregamos
			addChild(sprite_mascara);
			
			// mascara
			mask = sprite_mascara;
			
			// hitArea
			graphics.beginFill(0x000000,0);
			graphics.drawRect(0,0,w,h);
			graphics.endFill();
		}
		
		//------- Properties --------
		public var item_click:ComponentItemLista;
		private var index:int;
		private var num_width:Number;
		private var num_height:Number;
		private var sprite_mascara:Sprite;
		private var elementos:Vector.<ComponentItemLista>;
		private var boolean_click:Boolean;
		private var func_click:Function;
		
		// ------- Methods -------
		// Public
		public function add_item(item:ComponentItemLista):void{
			item.visible = false;
			if(elementos.length == 0){
				item.x = (num_width - item.width) / 2;
				item.visible = true;
			}
			item.addEventListener(MouseEvent.CLICK, handler_mouseclick, false, 0, true);
			addChild(item);
			elementos[elementos.length] = item;
		}
		
		public function remove_all():void{
			for(var i:int = 0; i < elementos.length; i++){
				elementos[i].removeEventListener(MouseEvent.CLICK, handler_mouseclick);
				removeChild(elementos[i]);
			}
		}
		
		// Private
		private function destroy(e:Event):void{
			// listeners
			removeEventListener(Event.REMOVED_FROM_STAGE, destroy);
			removeEventListener(MouseEvent.MOUSE_DOWN, handler_mousedown);
			// items
			remove_all();
			// stage
			removeChild(sprite_mascara);
			// referencias
			sprite_mascara = null;
			elementos = null;
		}
		
		private function handler_mouseclick(e:Event){
			if(boolean_click){
				item_click = ComponentItemLista(e.currentTarget);
				func_click();
			}
		}
		
		private function handler_mousedown(e:Event):void{
			boolean_click = true;
			addEventListener(MouseEvent.MOUSE_MOVE, handler_mousemove,false,0,true);
			addEventListener(MouseEvent.ROLL_OUT, handler_mouseup,false,0,true);
			addEventListener(MouseEvent.MOUSE_UP, handler_mouseup ,false,0,true);
		}
		
		private function handler_mousemove(e:MouseEvent):void{
			boolean_click = false;
		}
		
		private function handler_mouseup(e:MouseEvent):void{
			removeEventListener(MouseEvent.MOUSE_MOVE, handler_mousemove);
			removeEventListener(MouseEvent.ROLL_OUT, handler_mouseup);
			removeEventListener(MouseEvent.MOUSE_UP, handler_mouseup);
		}
		
		private function handler_swipe(event:TransformGestureEvent):void{
			boolean_click = false;
			if(event.offsetX == 1){
				show_anterior();
			} else if(event.offsetX == -1){
				show_siguiente();
			}
		}
		
		private function show_anterior():void {
			if(elementos.length > 1){
				var index_sigue = index-1;
				if(index_sigue == -1){
					index_sigue = elementos.length-1;
				}
				elementos[index_sigue].x = -num_width;
				elementos[index_sigue].visible = true;
				var tween_sig:Tweener = new Tweener();
				var tween_ant:Tweener = new Tweener();
				tween_sig.linear_tween(elementos[index_sigue], 'x', elementos[index_sigue].x, (num_width - elementos[index_sigue].width) / 2, 300,function(){});
				tween_ant.linear_tween(elementos[index], 'x', elementos[index].x, num_width + (num_width - elementos[index].width), 300,function(){});
				index = index_sigue;
			}
		}
		
		private function show_siguiente():void{
			if (elementos.length > 1) {
				var index_sigue = index + 1;
				if(index_sigue == elementos.length){
					index_sigue = 0;
				}
				elementos[index_sigue].x = num_width + (num_width - elementos[index_sigue].width) / 2;
				elementos[index_sigue].visible = true;
				var tween_sig:Tweener = new Tweener();
				var tween_ant:Tweener = new Tweener();
				tween_sig.linear_tween(elementos[index_sigue], 'x', elementos[index_sigue].x, (num_width - elementos[index_sigue].width) / 2, 300,function(){});
				tween_ant.linear_tween(elementos[index], 'x', elementos[index].x, -num_width, 300,function(){});
				index = index_sigue;
			}
		}
	}
}