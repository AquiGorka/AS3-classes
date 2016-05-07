package com.aquigorka.component{

	import com.aquigorka.component.ComponentSimboloBoton;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.filters.DropShadowFilter;
	import flash.geom.Matrix;
	import flash.geom.Rectangle;
	import flash.text.TextField;
	
	public class ComponentVerticalSliderNumberChooser extends Sprite{

		// ------- Constructor -------
		public function ComponentVerticalSliderNumberChooser(w:Number, h:Number, val:Number, i_val:Number, f_val:Number, prec:int, cf_change:Function, cf_up:Function, dir_down:Boolean=true){
			// destroy
			addEventListener(Event.REMOVED_FROM_STAGE, destroy, false, 0, true);
			// super
			super();
			// declaraciones
			_width = w;
			_height = h;
			valor = val;
			inicial_value = i_val;
			final_value = f_val;
			precision = prec;
			direction_down = dir_down;
			diferencia_absoluta = Math.abs(final_value-inicial_value);
			callback_function_change = cf_change;
			callback_function_up = cf_up;
			// instancias
			// fondo barra
			fondo = new Sprite();
			draw_fondo();
			// slider
			slider = new Sprite();
			draw_slider();
			// set slider
			set_slider();
			// invisible
			invisible = new Sprite();
			invisible.graphics.beginFill(0x00FF00,0);
			invisible.graphics.drawRect(0, 0, _width, _height + slider.height);
			invisible.graphics.endFill();
			invisible.y = -slider.height/2;
			// listeners
			create_listeners();
			// agregamos
			addChild(fondo);
			addChild(slider);
			addChild(invisible);
		}
		
		// ------- Properties -------
		public var valor:Number;
		protected var fondo:Sprite;
		protected var slider:Sprite;
		protected var _width:Number;
		protected var _height:Number;
		protected var inicial_value:Number;
		protected var final_value:Number;
		protected var precision:int;
		protected var diferencia_absoluta:Number;
		protected var direction_down:Boolean;
		protected var invisible:Sprite;
		private var callback_function_change:Function;
		private var callback_function_up:Function;
		
		// ------- Methods -------
		// Public
		public function set_value(num:Number):void{
			valor = Math.min(final_value, Math.max(inicial_value, num));
			set_slider();
		}
		
		// Protected
		protected function draw_fondo():void{
			// fondo
			fondo.graphics.beginFill(0xEEEEEE);
			fondo.graphics.drawRect(0, 0, 10, _height);
			fondo.graphics.endFill();
			fondo.x = (_width - fondo.width) / 2;
			fondo.filters = [new DropShadowFilter(4,45,0,1,4,4,1,1,true)];
		}
		
		protected function draw_slider():void{
			// MI RECOMENDACIÓN: este dibujo ponga el centro del slider en su centro de altura
			slider.graphics.beginFill(0xDDDDDD);
			slider.graphics.drawRoundRect(0, -5, _width, 10, 2);
			slider.graphics.endFill();
			slider.x = (_width - slider.width) / 2;
			set_slider();
		}
		
		protected function handler_move(e:Event):void{
			slider.y = Math.min(_height, Math.max(0, mouseY));
			var porcentaje:Number = slider.y / _height;
			if(direction_down){
				valor = inicial_value + diferencia_absoluta * porcentaje;
			}else{
				valor = inicial_value + diferencia_absoluta * (1-porcentaje);
			}
			valor = Math.round(valor * Math.pow(10, precision));
			valor = valor / Math.pow(10, precision);
			callback_function_change();
		}
		
		protected function set_slider():void{
			var porcentaje:Number = (valor-inicial_value) / diferencia_absoluta;
			if(direction_down){
				slider.y = _height * porcentaje;
			}else{
				slider.y = _height * (1-porcentaje);
			}	
		}
		
		// Private
		private function create_listeners():void{
			invisible.addEventListener(MouseEvent.MOUSE_DOWN, handler_down, false, 0, true);
		}
		
		private function destroy(evt:Event):void{
			// listeners
			removeEventListener(Event.REMOVED_FROM_STAGE, destroy);
			remove_listeners();
			// graphics
			fondo.graphics.clear();
			slider.graphics.clear();
			// stage
			removeChild(fondo);
			removeChild(slider);
			// referencias
			fondo = null;
			slider = null;
		}
		
		private function handler_down(e:Event):void{
			invisible.removeEventListener(MouseEvent.MOUSE_DOWN, handler_down);
			invisible.addEventListener(MouseEvent.MOUSE_MOVE, handler_move, false, 0, true);
			invisible.addEventListener(MouseEvent.ROLL_OUT, handler_out, false, 0, true);
			invisible.addEventListener(MouseEvent.MOUSE_UP, handler_out, false, 0, true);
		}
		
		private function handler_out(e:Event):void{
			invisible.removeEventListener(MouseEvent.MOUSE_MOVE, handler_move);
			invisible.removeEventListener(MouseEvent.MOUSE_UP, handler_out);
			invisible.removeEventListener(MouseEvent.ROLL_OUT, handler_out);
			invisible.addEventListener(MouseEvent.MOUSE_DOWN, handler_down, false, 0, true);
			callback_function_up();
		}
		
		private function remove_listeners():void{
			invisible.removeEventListener(MouseEvent.MOUSE_DOWN, handler_down);
			invisible.removeEventListener(MouseEvent.MOUSE_MOVE, handler_move);
			invisible.removeEventListener(MouseEvent.ROLL_OUT, handler_out);
			invisible.removeEventListener(MouseEvent.MOUSE_UP, handler_out);
		}
	}
}