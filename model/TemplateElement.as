package com.aquigorka.model{

	import flash.display.Sprite;
	
	public class TemplateElement extends Sprite{

		// ------- Constructor -------
		public function TemplateElement(ref_par:TemplateManager, arr_dimensiones:Array=null){
			referencia_parent = ref_par;
			bool_loaded = false;
			dimensiones = arr_dimensiones;
			cacheAsBitmap = true;
		}

		// ------- Properties -------
		public var bool_loaded:Boolean;
		protected var referencia_parent:TemplateManager;
		protected var dimensiones:Array;
		
		// ------- Methods -------
		// Public
		public function dispatch(str:String,params:Array=null):void{}
		
		// Protected
		protected function template_element_loaded():void {
			bool_loaded = true;
			referencia_parent.parent_init();
		}
	}
}