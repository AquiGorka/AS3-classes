package com.aquigorka.component{

	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.Loader;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.events.IOErrorEvent;
	import flash.filters.BitmapFilterQuality;
	import flash.filters.GlowFilter;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import flash.net.URLRequest;
	import flash.ui.Multitouch;
	import flash.ui.MultitouchInputMode;
	import flash.events.TransformGestureEvent;

	public class ComponentImageViewer extends Sprite{

		// ------- Constructor -------
		public function ComponentImageViewer(url_folder:String, num_archivos:int,w:Number=290, h:Number=160, tipo:String='.jpg'){
			// destroy
			addEventListener(Event.REMOVED_FROM_STAGE, destroy, false, 0, true);
			// super
			super();
			// declaraciones
			width_final = w;
			height_final = h;
			tipo_archivo = tipo;
			point_zero = new Point();
			string_folder = 'assets/'+url_folder+'/';
			continuar_carga_1 = false;
			continuar_carga_2 = false;
			// instancias
			bitmapdata_canvas = new BitmapData(w, h,true,0x00000000);
			bitmap_canvas = new Bitmap(bitmapdata_canvas);
			bitmap_canvas.smoothing = true;
			// agregamos
			addChild(bitmap_canvas);
			// revisiones
			if(num_archivos > 0){
				number_archivos = num_archivos;
				num_current_x = 0;
				number_index = 0;
				draw_reference();
				point_zero = new Point();
				photos = new Vector.<BitmapData>();
				number_index_loaded = 0;
				loader_obj = new Loader();
				urlrequest_obj = new URLRequest(string_folder+'1'+tipo_archivo);
				loader_obj.load(urlrequest_obj);
				loader_obj.contentLoaderInfo.addEventListener(IOErrorEvent.IO_ERROR, function(event:Event){},false,0,true);
				loader_obj.contentLoaderInfo.addEventListener(Event.COMPLETE, handler_image_load, false, 0, true);
			}
		}

		// ------- Properties -------
		protected var height_final:Number;
		protected var bitmap_canvas:Bitmap;
		protected var number_archivos:int;
		protected var number_index:int;
		private var string_folder:String;
		private var loader_obj:Loader
		private var urlrequest_obj:URLRequest;
		private var number_index_loaded:int;
		private var bitmapdata_canvas:BitmapData;
		private var photos:Vector.<BitmapData>;
		private var point_zero:Point;
		private var rectangle_rect:Rectangle;
		private var num_current_x:Number;
		private var continuar_carga_1:Boolean;
		private var continuar_carga_2:Boolean;
		private var tipo_archivo:String;
		private var width_final:Number;
		
		// ------- Methods -------
		// Public
		public function continue_load():void {
			continuar_carga_2 = true;
			draw_effects();
			if(number_archivos > 1 && continuar_carga_1){
				loader_obj = new Loader();
				urlrequest_obj = new URLRequest(string_folder+ (number_index_loaded + 1) + tipo_archivo);
				loader_obj.load(urlrequest_obj);
				loader_obj.contentLoaderInfo.addEventListener(IOErrorEvent.IO_ERROR, function(event:Event){},false,0,true);
				loader_obj.contentLoaderInfo.addEventListener(Event.COMPLETE, handler_image_load, false, 0, true);
			}
		}
		
		public function loading_out():void{
			bitmap_canvas.filters = [];
		}
		
		// Protected
		protected function draw_effects():void{
			// efecto
			bitmap_canvas.filters = [new GlowFilter(0x000000, .3, 8, 8, 2, BitmapFilterQuality.HIGH)];
		}
		
		protected function draw_reference():void{
			graphics.clear();
			graphics.beginFill(0x333333, 1);
			for(var i:int=0; i<number_archivos;i++){
				graphics.drawCircle(10 + (i * 20), height_final+20, 3);
				if(i == number_index){
					graphics.beginFill(0xCCCCCC, 1);
				}
			}
			graphics.endFill();
		}
		
		// Private
		private function create_listeners():void{
			addEventListener(TransformGestureEvent.GESTURE_SWIPE, handler_swipe, false, 0, true);
		}
		
		private function destroy(evt:Event):void{
			// listeners
			removeEventListener(Event.REMOVED_FROM_STAGE, destroy);
			remove_listeners();
			
			// stage
			graphics.clear();
			removeChild(bitmap_canvas);
			
			// referencias
			bitmap_canvas = null;
			photos = null;
		}
		
		private function handler_image_load(evt:Event):void{
			var aux_bitmapdata:BitmapData = new BitmapData(width_final, height_final, true, 0x00000000);
			aux_bitmapdata.draw(loader_obj);
			photos[number_index_loaded] = aux_bitmapdata;
			number_index_loaded++;
			
			if(number_index_loaded == 1){
				addChild(bitmap_canvas);
				bitmapdata_canvas.copyPixels(aux_bitmapdata, bitmapdata_canvas.rect, point_zero);
				continuar_carga_1 = true;
			}
			
			if(number_index_loaded == number_archivos){
				init();
			} else {
				if(number_index_loaded > 1 || (continuar_carga_1 && continuar_carga_2)){
					loader_obj = new Loader();
					urlrequest_obj = new URLRequest(string_folder + (number_index_loaded + 1) + tipo_archivo);
					loader_obj.load(urlrequest_obj);
					loader_obj.contentLoaderInfo.addEventListener(IOErrorEvent.IO_ERROR, function(event:Event){},false,0,true);
					loader_obj.contentLoaderInfo.addEventListener(Event.COMPLETE, handler_image_load, false, 0, true);
				}
			}
		}
		
		private function handler_swipe(event:TransformGestureEvent):void{
			if(event.offsetX == 1){
				if(number_index > 0){
					remove_listeners();
					number_index--;
					render();
				}
			} else if(event.offsetX == -1){
				if(number_index < (number_archivos - 1)){
					remove_listeners();
					number_index++;
					render();
				}
			}
		}
		
		private function init():void{
			for(var i:int=0; i<number_archivos;i++){
				bitmapdata_canvas.copyPixels(photos[i], new Rectangle(0, 0, 1, 1), point_zero);
			}
			Multitouch.inputMode = MultitouchInputMode.GESTURE;
			create_listeners();
		}
		
		private function remove_listeners():void{
			removeEventListener(TransformGestureEvent.GESTURE_SWIPE, handler_swipe);
		}
		
		private function render():void{
			var destination_x:int = number_index * width_final;
			var current_x:int = num_current_x; 
			var num_offset:int = current_x % width_final;
			var num_internal_ind:int = 0;
			
			if(destination_x != current_x){
				var timer:int = 0;
				var duration:int = 10;
				
				addEventListener(Event.ENTER_FRAME, function(event:Event):void{
					timer++;
					current_x += (destination_x - current_x) * (timer/duration);
					num_internal_ind = current_x / width_final;
					num_offset = current_x % width_final;
					rectangle_rect = new Rectangle(num_offset, 0, (width_final - num_offset), height_final);
					bitmapdata_canvas.copyPixels(photos[num_internal_ind], rectangle_rect, point_zero);
					if(num_internal_ind < number_archivos && current_x < ((number_archivos - 1) * width_final)){
						bitmapdata_canvas.copyPixels(photos[num_internal_ind + 1], bitmapdata_canvas.rect, new Point(width_final - num_offset, 0));
					}
					if(timer == duration){
						// fin
						removeEventListener(event.type, arguments.callee);
						num_current_x = destination_x;
						bitmapdata_canvas.copyPixels(photos[number_index], bitmapdata_canvas.rect, point_zero);
						
						draw_reference();
						create_listeners();
					}
				},false, 0, true);
			}			
		}
	}
}