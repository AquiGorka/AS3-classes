package com.aquigorka.model{

	import flash.display.DisplayObject;
	import flash.display.Sprite;	
	import flash.events.Event;
	
	public final class TweenerDispatch extends Sprite{
		
		// ------- Constructor -------
		public function TweenerDispatch(){
			stop();
		}
		
		// ------- Properties -------
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
		private static const NUMBER_FRAMERATE:int = 30;
		public static const EVENT_TWEENER_TIMER_FINISH:String = 'finish_tweener_timer_FINISH';
		public static const EVENT_TWEENER_FINISH:String = 'finish_tweener_FINISH';
		public static const EVENT_TWEENER_CHANGE:String = 'change_tweener_CHANGE';
		
		// ------- Methods -------
		// Public
		public function linear_tween_func(func:Function):void {
			func();
		}
		
		public function linear_tween(rf_obj:DisplayObject, str_pro:String, num_i:Number, num_f:Number, num_t:Number):void {
			trace('ref_obj: '+rf_obj)
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
		
		public function timer(int_timer:int):void{
			num_timer = 0;
			duration = int_timer * .001 * NUMBER_FRAMERATE;
			addEventListener(Event.ENTER_FRAME,timer_do,false,0,true);
		}
		
		// Private
		private function linear_tween_do(e:Event):void{
			trace('ref_obj: ' + ref_obj)
			trace('str_property: ' + str_property)
			trace('ref_obj[str_property]: ' + ref_obj[str_property])
			trace('num_timer: '+num_timer+'; duration: '+duration)
			if(num_timer > 100000){
				stop_tween();
			}
			num_timer++;
			porcentaje = num_timer / duration;
			if(num_final > num_initial){
				ref_obj[str_property] = num_initial +(diferencia_abs_total * porcentaje);
			}else{
				ref_obj[str_property] = num_initial -(diferencia_abs_total * porcentaje);
			}
			if(num_timer >= duration){
				trace('entré y mandé Event')
				ref_obj[str_property] = num_final;
				trace('ref_obj: ' + ref_obj)
				trace('str_property: ' + str_property)
				trace('ref_obj[str_property]: ' + ref_obj[str_property])
				trace('num_timer: '+num_timer+'; duration: '+duration)
				dispatchEvent(new Event(EVENT_TWEENER_FINISH));
				stop_tween();
			}
		}
		
		private function timer_do(e:Event):void{
			if(num_timer > 100000){
				stop_timer();
			}
			num_timer++;
			if(num_timer >= duration){
				stop_timer();
				dispatchEvent(new Event(EVENT_TWEENER_TIMER_FINISH));
			}
		}
		
		private function stop():void{
			ref_obj = null;
			str_property = '';
		}
	}
}