package com.aquigorka.component{
	
	import com.shinedraw.controls.IPhoneScroll;
	import flash.display.DisplayObject;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	
	public class ComponentDOScroll extends Sprite{
	
		// ------- Constructor -------
		public function ComponentDOScroll(w:Number, h:Number, dobj:DisplayObject){
			// destroy
			addEventListener(Event.REMOVED_FROM_STAGE, destroy, false, 0, true);
			// declaraciones
			_width = w; 
			_height = h;
			referencia_do = dobj;
			bool_click = true;
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
			// holder
			holder = new Sprite();
			// esto hace que al mandar el display object con offset original se mantenga todo bien al enmascarar
			holder.graphics.beginFill(0,0);
			holder.graphics.drawRect(0, 0, referencia_do.x + referencia_do.width, referencia_do.y + referencia_do.height);
			holder.graphics.endFill();
			holder.addChild(referencia_do);
			// scrollbar
			scrollbar = new Sprite();
			draw_scrollbar();
			// listeners
			holder.addEventListener(MouseEvent.MOUSE_DOWN, handler_mousedown, false, 0, true);
			holder.addEventListener('MOVE_FOLLOW', handler_move_follow, false, 0, true);
			holder.addEventListener('INACTIVITY_STOP', handler_inactivity_stop, false, 0, true);
			// agregamos
			addChild(holder);
			addChild(scrollbar);
			addChild(mascara);
			addChild(mascara_scrollbar);
			// mascara
			holder.mask = mascara;
			scrollbar.mask = mascara_scrollbar;
			// init
			addEventListener(Event.ADDED_TO_STAGE, init);
		}
		
		private function init(e:Event = null):void{
			removeEventListener(Event.ADDED_TO_STAGE, init);
			_scroller = new IPhoneScroll(holder, stage);
			_scroller.canvasHeight = _height;
		}
		
		//------- Properties --------
		public var holder:Sprite;
		public var bool_click:Boolean;
		protected var _height:Number;
		protected var _width:Number;
		protected var mascara:Sprite;
		protected var mascara_scrollbar:Sprite;
		protected var scrollbar:Sprite;
		private var _scroller:IPhoneScroll;
		private var referencia_do:DisplayObject;
		
		// ------- Methods -------
		// Protected
		protected function draw_scrollbar():void{
			scrollbar.x = _width - 5;
			scrollbar.graphics.clear();
			if(_height < holder.height){
				scrollbar.graphics.beginFill(0x505050);
				scrollbar.graphics.drawRoundRect(0, 0, 5, (_height/holder.height*_height), 5, 5);
				scrollbar.graphics.endFill();
				scrollbar.alpha = 0;
			}
		}
		
		// Private
		private function destroy(e:Event):void{
			// listeners
			removeEventListener(Event.REMOVED_FROM_STAGE, destroy);
			holder.removeEventListener(MouseEvent.MOUSE_DOWN, handler_mousedown);
			holder.removeEventListener(MouseEvent.MOUSE_UP, handler_mouseup);
			holder.removeEventListener(MouseEvent.ROLL_OUT, handler_mouseup);
			holder.removeEventListener('MOVE_FOLLOW', handler_move_follow);
			holder.removeEventListener('INACTIVITY_STOP', handler_inactivity_stop);
			// graphics
			mascara.graphics.clear();
			mascara_scrollbar.graphics.clear();
			// stage
			_scroller.release();
			holder.removeChild(referencia_do);
			removeChild(holder);
			removeChild(scrollbar);
			removeChild(mascara);
			removeChild(mascara_scrollbar);
			// referencias
			holder = null;
			scrollbar = null;
			mascara = null;
			mascara_scrollbar = null;
			_scroller = null;
		}
		
		private function handler_move_follow(e:Event):void{
			bool_click = false;
			scrollbar.y = _height * -holder.y / holder.height;
			if(scrollbar.alpha < 1){
				scrollbar.alpha = Math.min(1, scrollbar.alpha + 0.1);
			}
		}
		
		private function handler_mousedown(e:MouseEvent):void{
			if(!_scroller.started){
				_scroller.start();
			}
			holder.addEventListener(MouseEvent.ROLL_OUT, handler_mouseup, false, 0, true);
			holder.addEventListener(MouseEvent.MOUSE_UP, handler_mouseup , false, 0, true);
		}
		
		private function handler_mouseup(e:MouseEvent):void{
			bool_click = true;
			holder.removeEventListener(MouseEvent.MOUSE_UP, handler_mouseup);
			holder.removeEventListener(MouseEvent.ROLL_OUT, handler_mouseup);
		}
		
		private function handler_inactivity_stop(e:Event):void{
			scrollbar.alpha = 0;
		}
	}
}