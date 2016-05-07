package com.aquigorka.component{
	
	import com.aquigorka.model.Tweener;
	import flash.display.Sprite;
	import flash.events.Event;
	
	public class ComponentLoader extends Sprite{
	
		// ------- Constructor -------
		public function ComponentLoader(elem_color:Number = 0xFFFFFF, bg:Boolean = false, bg_color:Number = 0x000000, bg_alpha:Number = 1){
			// destroy
			addEventListener(Event.REMOVED_FROM_STAGE, destroy, false, 0, true);
			// super
			super();
			// declaraciones
			cacheAsBitmap = true;
			element_color = elem_color;
			num_index = 0;
			num_interval = 100;
			num_elementos = 8;
			// instancias
			sprite_background = new Sprite();
			tween = new Tweener();
			vector_elementos = new Vector.<Sprite>;
			// dibujamos
			draw_elements();
			draw_background(bg, bg_color, bg_alpha);
			// agregamos
			addChild(sprite_background);
			for(var i:int = 0; i < num_elementos; i++){
				addChild(vector_elementos[i]);
			}
			// iniciamos
			draw_animation(num_index);
			tween.timer(num_interval,handler_timer);
		}
		
		//------- Properties --------
		protected var vector_elementos:Vector.<Sprite>;
		protected var sprite_background:Sprite;
		protected var num_elementos:int;
		private var element_color:Number;
		private var num_index:Number;
		private var tween:Tweener;
		private var num_interval:int;
		
		// ------- Methods -------
		// Protected
		protected function draw_animation(num:Number):void{
			var num_alpha:Number;
			var num_elementos_mueve:int = 4;
			num_elementos_mueve = num_elementos - num_elementos_mueve;
			for (var i:int = 0; i < num_elementos; i++) {
				num_alpha = .3;
				if ((i >= num && i <= (num + (num_elementos / num_elementos_mueve)))) {
					num_alpha += ((i - num) * .2) + .4;
				} else {
					if (i <= (num - (num_elementos-(num_elementos/num_elementos_mueve))) && num >= (num_elementos-(num_elementos/num_elementos_mueve))) {
						num_alpha += ((num_elementos - num + i) * .2) + .3;
					}
				}
				vector_elementos[i].alpha = num_alpha;
			}
		}
		
		protected function draw_background(bg:Boolean, bg_color:Number, bg_alpha:Number):void{
			if(bg){
				sprite_background.graphics.beginFill(bg_color,bg_alpha);
				sprite_background.graphics.drawRoundRect(0, 0, 100, 100, 25);
				sprite_background.graphics.endFill();
			}
		}
		
		protected function draw_elements():void{
			var cuadrante:int = 0;
			var x_base:Number = 50;
			var y_base:Number = 50;
			var porcentaje:Number = 1;
			var variacion:Number = 40;
			var correccion:int = 12;
			for(var i:int = 0; i < num_elementos; i++){
				vector_elementos[i] = new Sprite();
				vector_elementos[i].graphics.beginFill(element_color);
				vector_elementos[i].graphics.drawCircle(0, 0, 8);
				vector_elementos[i].graphics.endFill();
				cuadrante = (i / (num_elementos/4)) % 4;
				porcentaje = (i % (num_elementos/4)) / (num_elementos/4);
				switch(cuadrante){
					case 0:
						vector_elementos[i].x = x_base - (variacion * porcentaje);
						vector_elementos[i].y = y_base + variacion - (variacion * porcentaje);
						if(porcentaje == 0){
							vector_elementos[i].y -= correccion;
						}
						break;
					case 1:
						vector_elementos[i].x = x_base - variacion + (variacion * porcentaje);
						vector_elementos[i].y = y_base - (variacion * porcentaje);
						if(porcentaje == 0){
							vector_elementos[i].x += correccion;
						}
						break;
					case 2:
						vector_elementos[i].x = x_base + (variacion * porcentaje);
						vector_elementos[i].y = y_base - variacion + (variacion * porcentaje);
						if(porcentaje == 0){
							vector_elementos[i].y += correccion;
						}
						break;
					case 3:
						vector_elementos[i].x = x_base + variacion - (variacion * porcentaje);
						vector_elementos[i].y = y_base + (variacion * porcentaje);
						if(porcentaje == 0){
							vector_elementos[i].x -= correccion;
						}
						break;
				}
				vector_elementos[i].rotation = i * 360 / num_elementos;
				vector_elementos[i].alpha = .5;
			}	
		}
		
		// Private
		private function destroy(evt:Event):void{
			// listeners
			removeEventListener(Event.REMOVED_FROM_STAGE, destroy);
			// alto
			tween.stop_timer();
			// stage
			removeChild(sprite_background);
			for(var i:int = 0; i < num_elementos; i++){
				removeChild(vector_elementos[i]);
			}
			// referencias
			sprite_background = null;
			vector_elementos = null;
		}
		
		private function handler_timer():void{
			num_index++;
			if(num_index>(num_elementos-1)){
				num_index = 0;
			}
			draw_animation(num_index);
			tween = new Tweener();
			tween.timer(num_interval,handler_timer);
		}
	}
}