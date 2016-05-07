package com.aquigorka.controller{

	import com.aquigorka.interfaces.InterfaceController;
	import com.aquigorka.interfaces.InterfaceRequestHandler;
	import com.aquigorka.dispatch.DispatchManager;
	import flash.display.MovieClip;
	import flash.events.Event;

	public class Controller extends MovieClip implements InterfaceController{
	
		// ------- Constructor -------
		public function Controller(){
			// init
			addEventListener(Event.ADDED_TO_STAGE, handler_added_to_stage, false, 0, true);
		}
		
		// ------- Properties -------
		protected var objRH:InterfaceRequestHandler;
		protected var objDM:DispatchManager;
		protected var dimensiones:Array;
		
		// ------- Methods -------
		// Public
		public function init():void{
			if(objDM.bool_loaded){
				// Empezamos
				manage_petition('proceso.inicio');
			}
		}
		
		public function manage_async_petition(str_seccion:String, params:Array=null):Array{
			return objRH.prepare_dispatch(str_seccion, params);
		}
		
		public function manage_petition(str_seccion:String, params:Array=null):void{
			var arreglo_parametros:Array = objRH.prepare_dispatch(str_seccion, params);
			if (arreglo_parametros['reenvio']['status'] == '1'){
				manage_petition(arreglo_parametros['reenvio']['seccion'], arreglo_parametros['reenvio']['parametros']);
			} else {
				objDM.dispatch(str_seccion, arreglo_parametros);
			}
		}
		
		// Protected
		protected function handler_added_to_stage(e:Event):void{
			removeEventListener(Event.ADDED_TO_STAGE, handler_added_to_stage);
			// agregamos
			addChild(objDM);
		}
	}
}