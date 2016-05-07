package com.aquigorka.component{

	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.geom.Rectangle;

	public class ComponentVerticalScrollDrag extends Sprite{

		// ------- Constructor -------
		public function ComponentVerticalScrollDrag(sprite_obj:Sprite, num_start_x:Number, num_start_viewport:Number, num_end_viewport:Number, w:Number = 320){
			// destroy
			addEventListener(Event.REMOVED_FROM_STAGE, destroy, false, 0, true);
			// super
			super();
			// declaraciones
			bool_enabled = true;
			boolean_click = true;
			number_end_viewport = num_end_viewport;
			number_start_viewport = num_start_viewport;
			sprite_object = sprite_obj;
			number_diferencia_viewport = number_end_viewport - number_start_viewport;
			number_width_final = w;
			number_start_x = num_start_x;
			// instancias
			// scrollbar
			scrollbar = new Sprite();
			scrollbar.alpha = 0;
			// agregamos
			addChild(scrollbar);
		}

		// ------- Properties -------
		public var boolean_click:Boolean;
		public var bool_enabled:Boolean;
		protected var scrollbar:Sprite;
		protected var number_width_final:Number;
		protected var number_diferencia_viewport:Number;
		protected var number_sprite_final_height:Number;
		private var sprite_object:Sprite;
		private var number_start_viewport:Number;
		private var number_end_viewport:Number;
		private var number_start_x:Number;
		
		// ------- Methods -------
		// Public
		public function start():void{
			number_sprite_final_height = sprite_object.height;
			if(number_sprite_final_height > number_diferencia_viewport){
				draw_scrollbar();
				sprite_object.addEventListener(MouseEvent.MOUSE_DOWN, handler_mousedown, false, 0, true);
			}
		}
		
		// Protected
		protected function draw_scrollbar():void{
			scrollbar.x = number_width_final - 7;
			scrollbar.alpha = 0;
			scrollbar.graphics.clear();
			scrollbar.graphics.beginFill(0x505050);
			scrollbar.graphics.drawRoundRect(0, 0, 5, (number_diferencia_viewport * (number_diferencia_viewport / number_sprite_final_height)), 5, 5);
			scrollbar.graphics.endFill();
		}
		
		// Private
		private function destroy(evt:Event):void{
			// listeners
			removeEventListener(Event.REMOVED_FROM_STAGE, destroy);
			sprite_object.removeEventListener(MouseEvent.MOUSE_DOWN, handler_mousedown);
			// graphics
			graphics.clear();
			// stage
			removeChild(scrollbar);
			// referencias
			scrollbar = null;
		}
		
		private function handler_mousedown(e:MouseEvent):void{
			if(bool_enabled){
				sprite_object.removeEventListener(MouseEvent.MOUSE_DOWN, handler_mousedown);
				sprite_object.addEventListener(MouseEvent.MOUSE_MOVE, handler_mousemove, false, 0, true);
				sprite_object.addEventListener(MouseEvent.ROLL_OUT, handler_mouseup,false,0,true);
				sprite_object.addEventListener(MouseEvent.MOUSE_UP, handler_mouseup,false,0,true);
				boolean_click = true;
				sprite_object.startDrag(false, new Rectangle(number_start_x, (number_start_viewport - (number_sprite_final_height - number_diferencia_viewport)), 0, ((number_sprite_final_height - number_diferencia_viewport))));
			}
		}
		
		private function handler_mousemove(e:MouseEvent):void{
			boolean_click = false;
			var porcentaje:Number = -(sprite_object.y - number_start_viewport) / (number_sprite_final_height - number_diferencia_viewport);
			scrollbar.y = (sprite_object.height - scrollbar.height) * porcentaje;
			if(scrollbar.alpha < 1){
				scrollbar.alpha = Math.min(1, scrollbar.alpha + 0.1);
			}
		}
		
		private function handler_mouseup(e:MouseEvent):void{
			sprite_object.removeEventListener(MouseEvent.MOUSE_MOVE, handler_mousemove);
			sprite_object.removeEventListener(MouseEvent.ROLL_OUT, handler_mouseup);
			sprite_object.removeEventListener(MouseEvent.MOUSE_UP, handler_mouseup);
			sprite_object.addEventListener(MouseEvent.MOUSE_DOWN, handler_mousedown,false,0,true);
			sprite_object.stopDrag();
			scrollbar.alpha = 0;
		}
	}
}