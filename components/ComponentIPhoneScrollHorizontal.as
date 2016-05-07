package com.aquigorka.component{
	
	import com.shinedraw.controls.IPhoneScroll;
	import flash.display.DisplayObjectContainer;
	import flash.display.Stage;
	import flash.geom.Point;
	import flash.events.MouseEvent;
	import flash.events.Event;

	public class ComponentIPhoneScrollHorizontal extends IPhoneScroll{

		// ------- Constructor -------
		public function ComponentIPhoneScrollHorizontal(pContent:DisplayObjectContainer, pStage:Stage){
			// super
			super(pContent, pStage);
			_canvasWidth = _myScrollElement.width;
			_width_enabled = false;
		}
		
		// ------- Properties -------
    	private var _canvasWidth:Number = 0;
		private var _width_enabled:Boolean;
		private var _mouseDownX:Number = 0;
		
		// ------- Methods -------
		// Public
		public function set canvasWidth(pVal:Number):void{_canvasWidth = pVal;}
		public function get canvasWidth():Number{return _canvasWidth;}
		override public function get percPosition():Number{var finalPos:Number = _canvasWidth - _myScrollElement.width; var currentPos:Number = _myScrollElement.x; return currentPos / finalPos;}

		override public function start():void{
			if(_canvasWidth < _myScrollElement.width){
				_width_enabled = true;
				_started = true;
				_myScrollElement.addEventListener(Event.ENTER_FRAME, on_enter_frame);
			}
		}
		
		override public function stop():void{
			_width_enabled = false;
			_started = false;
			_velocity = 0;
			_myScrollElement.removeEventListener(Event.ENTER_FRAME, on_enter_frame);
		}
		
		// Protecetd
		override protected function on_enter_frame(e:Event):void{
			if(started){
				// decay the velocity
				if(_mouseDown){
					_velocity *= MOUSE_DOWN_DECAY;
				}else{
					_velocity *= DECAY;
				}
				// if not mouse down, then move the element with the velocity
				if(!_mouseDown){
					var my_scroll_element_width:Number = _myScrollElement.width;
					var pos_x:Number = _myScrollElement.x;
					var bouncing:Number = 0;
					// calculate a bouncing when _myScrollElement moves over the canvas size
					if(pos_x > 0){
						bouncing = -pos_x * BOUNCING_SPRINGESS;
					}else if(pos_x + my_scroll_element_width < _canvasWidth){
						bouncing = (_canvasWidth - my_scroll_element_width - pos_x) * BOUNCING_SPRINGESS;
					}
					_myScrollElement.x = pos_x + _velocity + bouncing;
				}
				// evento para seguimiento (dibujo del scrollbar en sí)
				_myScrollElement.dispatchEvent(new Event('MOVE_FOLLOW'));
				// HACK para que no detenga inmediatamente
				if(Math.round(_velocity) == 0 && !_mouseDown){
					_inactivity_count++;
				}else{
					_inactivity_count = 0;
				}
				if(_inactivity_count > 12){
					_inactivity_count = 0;
					stop();
					_myScrollElement.dispatchEvent(new Event('INACTIVITY_STOP'));
				}
			}
		}
		
		// when mouse button down
		override protected function on_mouse_down(e:MouseEvent):void{
			if(!_mouseDown && _width_enabled){
				// get some initial properties
				_mouseDownPoint = new Point(e.stageX, e.stageY);
				_lastMouseDownPoint = new Point(e.stageX, e.stageY);
				_mouseDown = true;
				_mouseDownX = _myScrollElement.x;
				// add some more mouse handlers
				_stage.addEventListener(MouseEvent.MOUSE_UP, on_mouse_up);
				_stage.addEventListener(MouseEvent.MOUSE_MOVE, on_mouse_move);
			}
		}

		// when mouse is moving
		override protected function on_mouse_move(e:MouseEvent):void{
			if(_mouseDown){
				// update the element position
				var point:Point = new Point(e.stageX, e.stageY);
				_myScrollElement.x = _mouseDownX + (point.x - _mouseDownPoint.x);
				// bounds
				var cambio:Number = .25
				if(_myScrollElement.x > 0){
					_myScrollElement.x *= cambio;
				}
				if(_myScrollElement.x < (_canvasWidth - _myScrollElement.width)){
					_myScrollElement.x = (_canvasWidth - _myScrollElement.width) + (_myScrollElement.x - (_canvasWidth - _myScrollElement.width)) * cambio;
				}
				// update the velocity
				_velocity += ((point.x - _lastMouseDownPoint.x) * SPEED_SPRINGNESS);
				_lastMouseDownPoint = point;
			}
		}

		// clear everythign when mouse up
		override protected function on_mouse_up(e:MouseEvent):void{
			if(_mouseDown){
				_mouseDown = false;
				_stage.removeEventListener(MouseEvent.MOUSE_UP, on_mouse_up);
				_stage.removeEventListener(MouseEvent.MOUSE_MOVE, on_mouse_move);
			}
		}
	}
}