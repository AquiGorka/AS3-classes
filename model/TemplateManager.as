package com.aquigorka.model{

	import com.aquigorka.interfaces.InterfaceDispatchManager;
	import flash.display.Sprite;
	
	public class TemplateManager extends Sprite{

		// ------- Constructor -------
		public function TemplateManager(ref_par:InterfaceDispatchManager,arr_dimensiones:Array) {
			referencia_parent = ref_par;
			bool_loaded = false;
			dimensiones = arr_dimensiones;
		}

		// ------- Properties -------
		public var bool_loaded:Boolean;
		protected var referencia_parent:InterfaceDispatchManager;
		protected var dimensiones:Array;
		
		// ------- Methods -------
		// Public
		public function dispatch(str_seccion:String,params:Array=null):void{}
		
		public function handler_manage_petition(str_seccion:String, params:Array):void{
			referencia_parent.handler_manage_petition(str_seccion,params);
		}
		
		public function parent_init():void {
			bool_loaded = true;
			referencia_parent.parent_init();
		}
	}
}