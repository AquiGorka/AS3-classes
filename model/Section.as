package com.aquigorka.model{
	
	import com.aquigorka.interfaces.InterfaceDispatchManager
	import com.aquigorka.interfaces.InterfaceSection;
	import com.aquigorka.model.Tweener;
	import flash.display.DisplayObject;
	import flash.display.Sprite;
	import flash.events.Event;

	public class Section extends Sprite implements InterfaceSection{

		// ------- Constructor -------
		public function Section(ref_parent:InterfaceDispatchManager, arr_dimensiones:Array):void{
			// destroy
			addEventListener(Event.REMOVED_FROM_STAGE, destroy, false, 0, true);
			// super
			super();
			// declaraciones
			referencia_padre = ref_parent;
			dimensiones = arr_dimensiones;
			show_next_delay = 0;
			section_tweener = new Tweener();
		}
		
		// ------- Properties -------
		public var show_next_delay:Number;
		protected var dimensiones:Array;
		protected var section_tweener:Tweener;
		private var referencia_padre:InterfaceDispatchManager;
		
		// ------- Methods -------
		// Public
		public function hide_all(str_seccion_siguiente:String):void{
			hide_fade();
		}
		
		public function show_all(str_seccion:String):void{
			show_fade();
		}
		
		// Protected
		protected function handler_hide_modulos_complete():void{
			referencia_padre.hide_modulos_complete_handler();
		}
		
		protected function handler_manage_async_petition(str_seccion:String, params:Array):Array{
			if(referencia_padre){
				return referencia_padre.handler_manage_async_petition(str_seccion, params);
			}
			return [];
		}
		
		protected function handler_manage_petition(str_seccion:String, params:Array):void{
			referencia_padre.handler_manage_petition(str_seccion, params);
		}
		
		protected function handler_show_modulos_complete():void{
			referencia_padre.show_modulos_complete_handler();
		}
		
		protected function hide_fade(num_tiempo:Number=250):void{
			tween_do('alpha', 1, 0,'hide',num_tiempo);
		}
		
		protected function hide_left(num_tiempo:Number=250):void{
			tween_do('x', 0, -dimensiones['stage']['width'], 'hide',num_tiempo);
		}
		
		protected function hide_right(num_tiempo:Number=250):void{
			tween_do('x', 0, dimensiones['stage']['width'], 'hide',num_tiempo);
		}
		
		protected function show_down(num_tiempo:Number=250):void{
			tween_do('y', dimensiones['stage']['height'], 0, 'show',num_tiempo);
		}
		
		protected function show_fade(num_tiempo:Number=250):void{
			tween_do('alpha', 0, 1, 'show',num_tiempo);
		}
		
		protected function show_left(num_tiempo:Number=250):void{
			tween_do('x', -dimensiones['stage']['width'], 0, 'show',num_tiempo);
		}
		
		protected function show_right(num_tiempo:Number=250):void{
			tween_do('x', dimensiones['stage']['width'], 0, 'show',num_tiempo);
		}
		
		protected function show_up(num_tiempo:Number=250):void{
			tween_do('y', 0, dimensiones['stage']['height'], 'show',num_tiempo);
		}
			
		// Private
		private function destroy(evt:Event):void{
			// listeners
			removeEventListener(Event.REMOVED_FROM_STAGE, destroy);
			// referencias
			referencia_padre = null;
			// instancias de font a null
			section_tweener = null;
		}
		
		private function tween_do(str_property:String, num_initial:Number, num_final:Number, str_caller:String, num_tiempo:int = 250):void{
			var DO:DisplayObject = this;
			section_tweener.linear_tween(DO, str_property, num_initial, num_final, num_tiempo, function():void{
				switch(str_caller){
					case 'hide':
						handler_hide_modulos_complete();
						break;
					case 'show':
						handler_show_modulos_complete();
						break;
				}
			});
		}
	}
}