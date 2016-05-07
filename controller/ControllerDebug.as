package com.aquigorka.controller{

	import com.aquigorka.interfaces.InterfaceController;
	import com.aquigorka.interfaces.InterfaceRequestHandler;
	import com.aquigorka.dispatch.DispatchManager;
	import com.aquigorka.component.ComponentLoader;
	import com.aquigorka.model.Tweener;
	import flash.system.Capabilities;
	import flash.events.Event;
	import flash.display.Sprite;
	import flash.display.MovieClip;
	import flash.display.StageQuality;
	import flash.display.StageAlign;
	import flash.display.StageScaleMode;

	public class ControllerDebug extends MovieClip implements InterfaceController{
	
		// ------- Constructor -------
		public function ControllerDebug() {
			// ------- DEBUG -------
			// ------- SWF Profiler
			//import SWFProfiler;
			//SWFProfiler.init(this.stage, this);
			// ------- Movie Monitor
			//import movieMonitor;
			//stage.addChild(new movieMonitor());
			// ------- versión SDK Air
			//import flash.desktop.NativeApplication;
			//trace('Adobe Air SDK version: ' + NativeApplication.nativeApplication.runtimeVersion);
			// ------- DocStats
			//import flash.desktop.NativeApplication;
			//NativeApplication.nativeApplication.addEventListener(Event.EXITING, function(){import net.boyblack.tools.docstats.DocStats;trace(new DocStats(stage));}, false, 0, true);
			// ------- Monster Debugger
			//import com.demonsters.debugger.MonsterDebugger;
			//MonsterDebugger.initialize(this);
			//MonsterDebugger.trace(this, 'algo y hasta objetos, clases, arrays, etc');
			// Mi idea es que algunas de las anteriores se puedan aqui mismo recalcular para no tener que usar FrontControllers para cada plataforma
			// pero bueno, tampoco está mal usar diferentes controladores - o este mismo modificado para cada plataforma
			/*
			trace("Capabilities.screenResolutionX : " + Capabilities.screenResolutionX);
			trace("Capabilities.screenResolutionY : " + Capabilities.screenResolutionY);
			trace("Capabilities.screenDPI : " + Capabilities.screenDPI );
			trace('fsw: '+stage.fullScreenWidth)
			trace('fsh: '+stage.fullScreenHeight)
			trace('w: '+stage.stageWidth)
			trace('h: ' + stage.stageHeight)
			*/
			// iOS
			/*
			Capabilities.screenResolutionX :
			Capabilities.screenResolutionY :
			Capabilities.screenDPI :
			fsw: 640
			fsh: 960
			w: 320
			h: 480
			*/
			// Samsung SII
			/* 
			Capabilities.screenResolutionX : 480
			Capabilities.screenResolutionY : 800
			Capabilities.screenDPI : 240
			fsw: 480
			fsh: 800
			w: 320
			h: 480
			*/
			// ------- FIN DEBUG -------
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