package com.aquigorka.model{

	import flash.display.DisplayObject;
	import flash.display.Sprite;	
	import flash.events.Event;
	
	public final class Tweener extends Sprite{
		
		// ------- Constructor -------
		public function Tweener(){
			stop();
		}
		
		// ------- Properties -------
		private var return_func:Function;
		private var num_timer:int;
		private var delta:Number;
		private var duration:Number;
		private var diferencia_abs_total:Number;
		private var porcentaje:Number;
		private var ref_obj:DisplayObject;
		private var str_property:String;
		private var num_initial:Number;
		private var num_final:Number;
		private var num_time:Number;
		//private static const NUMBER_FRAMERATE:int = 21;
		private static const NUMBER_FRAMERATE:int = 40;
		
		// ------- Methods -------
		// Public
		public function linear_tween(rf_obj:DisplayObject, str_pro:String, num_i:Number, num_f:Number, num_t:Number,func:Function):void {
			return_func = func;
			ref_obj = rf_obj;
			str_property = str_pro;
			num_initial = num_i;
			num_final = num_f;
			num_time = num_t;
			num_timer = 0;
			delta = 0;
			duration = num_time * .001 * NUMBER_FRAMERATE;
			diferencia_abs_total = Math.abs(num_initial - num_final);
			porcentaje = 1;
			if(ref_obj){
				addEventListener(Event.ENTER_FRAME, linear_tween_do, false, 0, true);
			}
		}
		
		public function stop_tween():void{
			removeEventListener(Event.ENTER_FRAME, linear_tween_do);
			stop();
		}
		
		public function stop_timer():void{
			removeEventListener(Event.ENTER_FRAME, timer_do);
			stop();
		}
		
		public function timer(int_timer:int, func:Function):void{
			return_func = func;
			num_timer = 0;
			duration = int_timer * .001 * NUMBER_FRAMERATE;
			addEventListener(Event.ENTER_FRAME, timer_do, false, 0, true);
		}
		
		// Private
		private function linear_tween_do(e:Event):void{
			if(num_timer > 100000 || ref_obj == null){
				stop_tween();
			}else{
				num_timer++;
				porcentaje = num_timer / duration;
				if(num_final > num_initial){
					ref_obj[str_property] = num_initial + (diferencia_abs_total * porcentaje);
				}else{
					ref_obj[str_property] = num_initial - (diferencia_abs_total * porcentaje);
				}
				if(num_timer >= duration){
					ref_obj[str_property] = num_final;
					return_func();
					stop_tween();
				}
				/*
				estaba tratando de ver si podía cambiar la funcion de tween
				ref_obj[str_property] += (num_final - ref_obj[str_property]) * .15;
				var punto_flotante:int = 100;
				if(Math.abs( Math.floor(num_final * punto_flotante) - Math.floor(ref_obj[str_property] * punto_flotante) ) == 0){
					ref_obj[str_property] = num_final;
					return_func();
					stop_tween();
				}
				*/
			}
		}
		
		private function timer_do(e:Event):void{
			if(num_timer > 100000){
				stop_timer();
			}
			num_timer++;
			if(num_timer >= duration){
				return_func();
				stop_timer();
			}
		}
		
		private function stop():void{
			if(ref_obj) ref_obj = null;
			return_func = null;
			str_property = '';
		}
	}
}