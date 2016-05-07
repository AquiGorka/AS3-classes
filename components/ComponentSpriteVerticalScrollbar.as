package com.aquigorka.component{

	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.geom.Rectangle;

	public final class ComponentSpriteVerticalScrollbar extends Sprite{

		// ------- Constructor -------
		public function ComponentSpriteVerticalScrollbar(sprite_obj:Sprite, num_start_viewport:Number, num_end_viewport:Number,w:Number=320){
			addEventListener(Event.REMOVED_FROM_STAGE, destroy, false, 0, true);
			
			bool_enabled = true;
			boolean_click = true;
			number_end_viewport = num_end_viewport;
			number_start_viewport = num_start_viewport;
			sprite_object = sprite_obj;
			number_diferencia_viewport = number_end_viewport - number_start_viewport;
			sprite_y_offset = 0;
			
			// scrollbar
			sprite_scrollbar = new Sprite();
			sprite_scrollbar.x = w-7;
			sprite_scrollbar.visible = false;
			
			// agregamos
			addChild(sprite_scrollbar);
		}

		// ------- Properties -------
		public var boolean_click:Boolean;
		private var sprite_scrollbar:Sprite;
		private var sprite_object:Sprite;
		private var sprite_final_height:Number;
		private var sprite_y_offset:Number;
		private var number_start_viewport:Number;
		private var number_end_viewport:Number;
		private var number_diferencia_viewport:Number;
		public var bool_enabled:Boolean;
		
		// ------- Methods -------
		// Public
		public function start():void{
			sprite_final_height = sprite_object.height;
			
			if (sprite_final_height > number_diferencia_viewport){
				sprite_scrollbar.visible = true;
				sprite_scrollbar.alpha = 0;
				sprite_y_offset = sprite_object.y;
				
				graphics.clear();
				graphics.beginFill(0x00FF00, 0);
				graphics.drawRect(0, number_start_viewport, 320, sprite_final_height);
				graphics.endFill();
				
				sprite_scrollbar.graphics.clear();
				sprite_scrollbar.graphics.beginFill(0x505050, .8);
				sprite_scrollbar.graphics.lineStyle(0, 0x5C5C5C,0,false);
				sprite_scrollbar.graphics.drawRoundRect(0, 0, 5, (number_diferencia_viewport * (number_diferencia_viewport / sprite_final_height)), 5, 5);
				sprite_scrollbar.graphics.endFill();
				
				sprite_object.addEventListener(MouseEvent.MOUSE_DOWN, handler_mousedown, false, 0, true);
			}
		}
		
		// Private
		private function destroy(evt:Event):void{
			// listeners
			removeEventListener(Event.REMOVED_FROM_STAGE, destroy);
			sprite_object.removeEventListener(MouseEvent.MOUSE_DOWN, handler_mousedown);
			
			// stage
			graphics.clear();
			removeChild(sprite_scrollbar);
			
			// referencias
			sprite_scrollbar = null;
		}
		
		private function handler_mousedown(e:MouseEvent):void{
			if(bool_enabled){
				sprite_object.removeEventListener(MouseEvent.MOUSE_DOWN, handler_mousedown);
				sprite_object.addEventListener(MouseEvent.MOUSE_MOVE, handler_mousemove, false, 0, true);
				sprite_object.addEventListener(MouseEvent.ROLL_OUT, handler_mouseup,false,0,true);
				sprite_object.addEventListener(MouseEvent.MOUSE_UP, handler_mouseup,false,0,true);
				boolean_click = true;
				sprite_object.startDrag(false, new Rectangle(0, ( -(sprite_final_height - number_diferencia_viewport)), 0, ((sprite_final_height - number_diferencia_viewport))));
			}
		}
		
		private function handler_mousemove(e:MouseEvent):void{
			boolean_click = false;
			sprite_scrollbar.y = (number_diferencia_viewport - sprite_scrollbar.height) * ( (sprite_object.y - sprite_y_offset) / -((sprite_final_height - sprite_y_offset) - number_diferencia_viewport));
			sprite_scrollbar.y -= sprite_object.y;
			sprite_scrollbar.y += number_start_viewport;
			if(sprite_scrollbar.alpha < 1 )
				sprite_scrollbar.alpha = Math.min(1, sprite_scrollbar.alpha + 0.1);
		}
		
		private function handler_mouseup(e:MouseEvent):void{
			sprite_object.removeEventListener(MouseEvent.MOUSE_MOVE, handler_mousemove);
			sprite_object.removeEventListener(MouseEvent.ROLL_OUT, handler_mouseup);
			sprite_object.removeEventListener(MouseEvent.MOUSE_UP, handler_mouseup);
			sprite_object.addEventListener(MouseEvent.MOUSE_DOWN, handler_mousedown,false,0,true);
			sprite_object.stopDrag();
			sprite_scrollbar.alpha = 0;
		}
	}
}