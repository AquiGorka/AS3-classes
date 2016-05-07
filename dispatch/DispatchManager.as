package com.aquigorka.dispatch{

	import com.aquigorka.interfaces.InterfaceController;
	import com.aquigorka.interfaces.InterfaceDispatchManager;
	import com.aquigorka.model.Section;
	import com.aquigorka.model.Tweener;
	import com.aquigorka.model.TemplateManager;
	import com.aquigorka.model.Section;
	import flash.display.Sprite;
	import flash.display.StageQuality;
	import flash.events.Event;
	import flash.utils.getDefinitionByName;
	import flash.system.System;
	
	public class DispatchManager extends Sprite implements InterfaceDispatchManager{

		// ------- Constructor -------
		public function DispatchManager(obj_home:InterfaceController, arr_dimensiones:Array){
			bool_loaded = false;
			dimensiones = arr_dimensiones;
			string_seccion_actual = 'default';
			string_seccion_anterior = 'default';
			string_seccion_siguiente = 'default';
			bool_gc_show = false;
			bool_gc_hide = false;
			bool_gc_start = false;
			referencia_parent = obj_home;
		}

		// ------- Properties -------
		public var bool_loaded:Boolean;
		protected var template_superior_manager:TemplateManager;
		protected var template_inferior_manager:TemplateManager;
		protected var ref_seccion_actual:Section;
		protected var ref_seccion_siguiente:Section;
		protected var ref_seccion_anterior:Section;
		protected var referencia_parent:InterfaceController;
		protected var string_seccion_anterior:String;
		private var bool_gc_show:Boolean;
		private var bool_gc_hide:Boolean;
		private var bool_gc_start:Boolean;
		private var dimensiones:Array;
		private var bool_dispatch:Boolean;
		private var string_seccion_actual:String;
		private var string_seccion_siguiente:String;

		// ------- Methods -------
		// Public
		public function dispatch(str_seccion:String, params:Array=null):void{
			if(str_seccion != string_seccion_actual){
				
				bool_gc_show = false;
				bool_gc_hide = false;
				bool_dispatch = false;
				
				string_seccion_siguiente = str_seccion;
				hide_modulos();
				ref_seccion_actual = null;
				string_seccion_actual = '';
				show_modulos(str_seccion, params);
			}
		}
		
		public function handler_manage_petition(str_seccion:String, params:Array):void{
			if(bool_dispatch){
				referencia_parent.manage_petition(str_seccion, params);
			}
		}
		
		public function handler_manage_async_petition(str_seccion:String, params:Array):Array{
			return referencia_parent.manage_async_petition(str_seccion, params);
		}
		
		public function hide_modulos_complete_handler():void {
			bool_gc_hide = true;
			garbage_collect();
		}
		
		public function show_modulos_complete_handler():void {
			ref_seccion_actual = ref_seccion_siguiente;
			string_seccion_actual = string_seccion_siguiente;
			bool_gc_show = true;
			garbage_collect();
		}
		
		public function parent_init():void{
			if(template_inferior_manager.bool_loaded && template_superior_manager.bool_loaded){
				bool_loaded = true;
				referencia_parent.init();
			}
		}
		
		// Protected
		protected function show_modulos_do(str_seccion:String, params:Array=null):void{
			template_superior_manager.dispatch(str_seccion,params);
			template_inferior_manager.dispatch(str_seccion, params);
			ref_seccion_siguiente.show_all(string_seccion_anterior);
		}
		
		// Private
		private function garbage_collect():void{
			if(bool_gc_hide && bool_gc_show){
				bool_dispatch = true;
			}
			if(bool_gc_show && bool_gc_hide) {
				//trace('Garbage Collect - sólo funciona en Air Debugger - creo que ya funciona siempre - igual por ahora no lo uso porque todo falla')
				//System.gc();
				//System.gc();
				//System.pauseForGCIFCollectionImminent(.99);
				
				bool_gc_show = false;
				bool_gc_hide = false;
				
				ref_seccion_siguiente = null;
				removeChild(ref_seccion_anterior);
				ref_seccion_anterior = null;
			}
		}
		
		private function hide_modulos():void{
			ref_seccion_anterior = ref_seccion_actual;
			string_seccion_anterior = string_seccion_actual;
			ref_seccion_anterior.hide_all(string_seccion_siguiente);
		}
		
		private function show_modulos(str_seccion:String, params:Array=null):void{
			var clase_seccion_siguiente:Class = getDefinitionByName(str_seccion) as Class;
			params['dimensiones'] = dimensiones;
			ref_seccion_siguiente = new clase_seccion_siguiente(this, params);
			addChild(ref_seccion_siguiente);
			addChild(template_superior_manager);
			if((ref_seccion_anterior && ref_seccion_anterior.show_next_delay == 0) || !(ref_seccion_anterior)){
				show_modulos_do(str_seccion, params);
			} else{
				var timer:Tweener = new Tweener();
				timer.timer(ref_seccion_anterior.show_next_delay,function(){show_modulos_do(str_seccion,params)});
			}
		}
	}
}