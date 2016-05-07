package com.aquigorka.component{

	import com.shinedraw.controls.IPhoneScroll;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.geom.Rectangle;

	public class ComponentVerticalScroll extends Sprite{

		// ------- Constructor -------
		public function ComponentVerticalScroll(sprite_obj:Sprite, w:Number, h:Number, o:Number=0){
			// destroy
			addEventListener(Event.REMOVED_FROM_STAGE, destroy, false, 0, true);
			// super
			super();
			// declaraciones
			bool_enabled = true;
			boolean_click = true;
			sprite_object = sprite_obj;
			_width = w;
			_height = h;
			_offset = o;
			// instancias
			// scrollbar
			scrollbar = new Sprite();
			// listeners
			sprite_object.addEventListener(MouseEvent.MOUSE_DOWN, handler_mousedown, false, 0, true);
			sprite_object.addEventListener('MOVE_FOLLOW', handler_move_follow, false, 0, true);
			sprite_object.addEventListener('INACTIVITY_STOP', handler_inactivity_stop, false, 0, true);
			// agregamos
			addChild(scrollbar);
			// init
			addEventListener(Event.ADDED_TO_STAGE, init);
		}
		
		private function init(e:Event = null):void{
			removeEventListener(Event.ADDED_TO_STAGE, init);
			_scroller = new IPhoneScroll(sprite_object, stage);
			_scroller.canvasHeight = _height;
			draw_scrollbar();
		}

		// ------- Properties -------
		public var boolean_click:Boolean;
		public var bool_enabled:Boolean;
		protected var scrollbar:Sprite;
		protected var _width:Number;
		protected var _height:Number;
		protected var _offset:Number;
		protected var sprite_object:Sprite;
		private var _scroller:IPhoneScroll;
		
		// ------- Methods -------
		// Public
		public function draw_scrollbar():void{
			scrollbar.x = _width - 7;
			scrollbar.alpha = 0;
			scrollbar.graphics.clear();
			scrollbar.graphics.beginFill(0x505050);
			scrollbar.graphics.drawRoundRect(0, _offset, 5, (_height * (_height / sprite_object.height)), 5, 5);
			scrollbar.graphics.endFill();
		}
		
		// Private
		private function destroy(evt:Event):void{
			// listeners
			removeEventListener(Event.REMOVED_FROM_STAGE, destroy);
			sprite_object.removeEventListener(MouseEvent.MOUSE_DOWN, handler_mousedown);
			sprite_object.removeEventListener(MouseEvent.MOUSE_MOVE, handler_mousemove);
			sprite_object.removeEventListener(MouseEvent.MOUSE_UP, handler_mouseup);
			sprite_object.removeEventListener('MOVE_FOLLOW', handler_move_follow);
			sprite_object.removeEventListener('INACTIVITY_STOP', handler_inactivity_stop);
			// graphics
			graphics.clear();
			// stage
			_scroller.release();
			removeChild(scrollbar);
			// referencias
			scrollbar = null;
			_scroller = null;
		}
		
		private function handler_move_follow(e:Event):void{
			scrollbar.y = (_height - scrollbar.height) * _scroller.percPosition;
			if(scrollbar.alpha < 1){
				scrollbar.alpha = Math.min(1, scrollbar.alpha + 0.1);
			}
		}
		
		private function handler_mousedown(e:MouseEvent):void{
			if(bool_enabled){
				if(!_scroller.started){
					_scroller.start();
				}
				boolean_click = true;
				sprite_object.addEventListener(MouseEvent.MOUSE_MOVE, handler_mousemove, false, 0, true);
				sprite_object.addEventListener(MouseEvent.ROLL_OUT, handler_mouseup, false, 0, true);
				sprite_object.addEventListener(MouseEvent.MOUSE_UP, handler_mouseup , false, 0, true);
			}
		}
		
		private function handler_mousemove(e:MouseEvent):void{
			boolean_click = false;
		}
		
		private function handler_mouseup(e:MouseEvent):void{
			sprite_object.removeEventListener(MouseEvent.ROLL_OUT, handler_mouseup);
			sprite_object.removeEventListener(MouseEvent.MOUSE_MOVE, handler_mousemove);
			sprite_object.removeEventListener(MouseEvent.MOUSE_UP, handler_mouseup);
		}
		
		private function handler_inactivity_stop(e:Event):void{
			scrollbar.alpha = 0;
		}
	}
}