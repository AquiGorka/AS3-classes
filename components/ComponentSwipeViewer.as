package com.aquigorka.component{

	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.Loader;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.events.IOErrorEvent;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import flash.net.URLRequest;
	import flash.ui.Multitouch;
	import flash.ui.MultitouchInputMode;
	import flash.events.TransformGestureEvent;

	public class ComponentSwipeViewer extends Sprite{

		// ------- Constructor -------
		public function ComponentSwipeViewer(data:Array, w:Number, h:Number, cf:Function){
			// destroy
			addEventListener(Event.REMOVED_FROM_STAGE, destroy, false, 0, true);
			// super
			super();
			// declaraciones
			duration = 10;
			bool_continue_load = false;
			point = new Point();
			_width = w;
			_height = h;
			arr_data = data;
			point = new Point();
			indice_archivo = 0;
			indice_matriz = 0;
			total_archivos_cargados = 0;
			total_archivos = 0;
			callback_function_swipe = cf;
			for(var i:int = 0; i < arr_data.length; i++ ){
				total_archivos += arr_data[i].length;
			}
			matriz_archivos = new Vector.<Vector.<BitmapData>>;
			for(i=0; i<arr_data.length; i++){
				matriz_archivos[i] = new Vector.<BitmapData>;
			}
			// instancias
			// referencia
			referencia = new Sprite();
			draw_reference();
			// canvas
			bitmapdata_canvas = new BitmapData(_width, _height, true, 0x00000000);
			bitmap_canvas = new Bitmap(bitmapdata_canvas);
			bitmap_canvas.smoothing = true;
			// listeners
			Multitouch.inputMode = MultitouchInputMode.GESTURE;
			// agregamos
			addChild(bitmap_canvas);
			addChild(referencia);
			// init
			init();
		}

		// ------- Properties -------
		protected var duration:int;
		protected var referencia:Sprite;
		protected var _height:Number;
		protected var _width:Number;
		protected var arr_data:Array;
		protected var indice_matriz:int;
		protected var indice_archivo:int;
		protected var callback_function_swipe:Function;
		protected var bool_continue_load:Boolean;
		protected var bitmap_canvas:Bitmap;
		protected var bitmapdata_canvas:BitmapData;
		protected var matriz_archivos:Vector.<Vector.<BitmapData>>;
		protected var point:Point;
		protected var rectangle:Rectangle;
		private var total_archivos:Number;
		private var total_archivos_cargados:Number;
		private var loader_obj:Loader
		
		// ------- Methods -------
		// Public
		public function set bool_referencia_visible(bool:Boolean):void {
			referencia.visible = bool;
		}
		
		public function get bool_referencia_visible():Boolean{
			return referencia.visible;
		}
		
		public function continue_load():void{
			bool_continue_load = true;
			if(total_archivos_cargados == 1){
				carga_archivo(arr_data[indice_matriz][indice_archivo]);
			}
		}
		
		// Protected
		protected function create_listeners():void{
			addEventListener(TransformGestureEvent.GESTURE_SWIPE, handler_swipe, false, 0, true);
		}
		
		protected function draw_reference():void { }
		
		protected function handler_swipe(event:TransformGestureEvent):void{
			var valid_swipe:Boolean = false;
			var indice_matriz_futuro:int = indice_matriz;
			var indice_archivo_futuro:int = indice_archivo;
			var render_function:Function = function(){};
			if(event.offsetY == -1){
				indice_matriz_futuro = indice_matriz + 1;
				if(indice_matriz_futuro < arr_data.length){
					valid_swipe = true;
					indice_archivo_futuro = 0;
					render_function = render_x;
				}
			}else if(event.offsetY == 1){
				indice_matriz_futuro = indice_matriz - 1;
				if(indice_matriz_futuro >= 0){
					valid_swipe = true;
					indice_archivo_futuro = 0;
					render_function = render_x;
				}
			}else if(event.offsetX == 1){
				indice_archivo_futuro = indice_archivo + 1;
				if(indice_archivo_futuro < arr_data[indice_matriz].length){
					valid_swipe = true;
					render_function = render_y;
				}
			}else if(event.offsetX == -1){
				indice_archivo_futuro = indice_archivo - 1;
				if(indice_archivo_futuro >= 0){
					valid_swipe = true;
					render_function = render_y;
				}
			}
			if(valid_swipe){
				remove_listeners();
				callback_function_swipe(indice_matriz, indice_archivo, indice_matriz_futuro, indice_archivo_futuro);
				render_function(indice_matriz_futuro, indice_archivo_futuro);
			}
		}
		
		protected function render_y(indice_matriz_siguiente:int, indice_archivo_siguiente:int):void{
			var timer:int = 0;
			var destination:int = indice_archivo_siguiente * _height;
			var current:int = indice_archivo * _height; 
			var num_offset:int;
			var index_archivo_seva:int = indice_archivo;
			var index_archivo_sequeda:int = indice_archivo_siguiente;
			if(indice_archivo_siguiente < indice_archivo){
				index_archivo_seva = indice_archivo_siguiente;
				index_archivo_sequeda = indice_archivo;
			}
			addEventListener(Event.ENTER_FRAME, function event_render(event:Event):void{
				timer++;
				current += (destination - current) * (timer / duration);
				num_offset = current % _height;
				rectangle = new Rectangle(0, num_offset, _width, (_height - num_offset));
				bitmapdata_canvas.copyPixels(matriz_archivos[indice_matriz][index_archivo_seva], rectangle, point);
				if(current < ((arr_data[indice_matriz].length - 1) * _height)){
					bitmapdata_canvas.copyPixels(matriz_archivos[indice_matriz][index_archivo_sequeda], bitmapdata_canvas.rect, new Point(0, _height - num_offset));
				}
				if(timer == duration){
					removeEventListener(Event.ENTER_FRAME,event_render);
					indice_archivo = indice_archivo_siguiente;
					bitmapdata_canvas.copyPixels(matriz_archivos[indice_matriz][indice_archivo], bitmapdata_canvas.rect, point);
					draw_reference();
					create_listeners();
				}
			},false, 0, true);
		}
		
		protected function render_x(indice_matriz_siguiente:int, indice_archivo_siguiente:int):void{
			var timer:int = 0;
			var destination:int = indice_matriz_siguiente * _width;
			var current:int = indice_matriz * _width; 
			var num_offset:int;
			var index_matriz_seva:int = indice_matriz;
			var index_matriz_sequeda:int = indice_matriz_siguiente;
			var index_archivo_seva:int = indice_archivo;
			var index_archivo_sequeda:int = indice_archivo_siguiente;
			if(indice_matriz_siguiente < indice_matriz){
				index_matriz_seva = indice_matriz_siguiente;
				index_matriz_sequeda = indice_matriz;
				index_archivo_seva = indice_archivo_siguiente;
				index_archivo_sequeda = indice_archivo;
			}
			addEventListener(Event.ENTER_FRAME, function event_render(event:Event):void{
				timer++;
				current += (destination - current) * (timer / duration);
				num_offset = current % _width;
				rectangle = new Rectangle(num_offset, 0, (_width-num_offset), _height);
				bitmapdata_canvas.copyPixels(matriz_archivos[index_matriz_seva][index_archivo_seva], rectangle, point);
				if(current < ((arr_data.length - 1) * _width)){
					bitmapdata_canvas.copyPixels(matriz_archivos[index_matriz_sequeda][index_archivo_sequeda], bitmapdata_canvas.rect, new Point(_width - num_offset, 0));
				}
				if(timer == duration){
					removeEventListener(Event.ENTER_FRAME,event_render);
					indice_matriz = indice_matriz_siguiente;
					indice_archivo = 0;
					bitmapdata_canvas.copyPixels(matriz_archivos[indice_matriz][indice_archivo], bitmapdata_canvas.rect, point);
					draw_reference();
					create_listeners();
				}
			},false, 0, true);
		}
		
		protected function remove_listeners():void{
			removeEventListener(TransformGestureEvent.GESTURE_SWIPE, handler_swipe);
		}
		
		// Private
		private function carga_archivo(archivo:String):void {
			loader_obj = new Loader();
			loader_obj.load(new URLRequest(archivo));
			loader_obj.contentLoaderInfo.addEventListener(IOErrorEvent.IO_ERROR, function(event:Event){},false,0,true);
			loader_obj.contentLoaderInfo.addEventListener(Event.COMPLETE, handler_image_load, false, 0, true);
		}
			
		private function carga_bitmap_en_memoria():void{	
			for(var i:int=0; i<matriz_archivos.length;i++){
				for(var j:int = 0; j < matriz_archivos[i].length; j++){
					bitmapdata_canvas.copyPixels(matriz_archivos[i][j], new Rectangle(0, 0, 1, 1), point);
				}
			}
			// regresamos los indices a ceros - los usamos para cargar, ahora los vamos a usar para desplegar
			indice_matriz = 0;
			indice_archivo = 0;
			create_listeners();
		}
		
		private function destroy(evt:Event):void{
			// listeners
			removeEventListener(Event.REMOVED_FROM_STAGE, destroy);
			remove_listeners();
			// graphics
			graphics.clear();
			referencia.graphics.clear();
			// stage
			removeChild(bitmap_canvas);
			removeChild(referencia);
			// referencias
			bitmap_canvas = null;
			matriz_archivos = null;
			referencia = null;
		}
		
		private function handler_image_load(evt:Event):void{
			var aux_bitmapdata:BitmapData = new BitmapData(_width, _height, true, 0x00000000);
			aux_bitmapdata.draw(loader_obj);
			matriz_archivos[indice_matriz][indice_archivo] = aux_bitmapdata;
			total_archivos_cargados++;
			// si es el primero mando que se vea
			if(total_archivos_cargados == 1){
				bitmapdata_canvas.copyPixels(matriz_archivos[indice_matriz][indice_archivo], bitmapdata_canvas.rect, point);
			}
			// sigo con la carga de los demás
			if(total_archivos_cargados == total_archivos){
				carga_bitmap_en_memoria();
			}else{
				indice_archivo++;
				if(indice_archivo >= arr_data[indice_matriz].length){
					indice_archivo = 0;
					indice_matriz++;
				}
				if(bool_continue_load){
					carga_archivo(arr_data[indice_matriz][indice_archivo]);
				}
			}
		}
		
		private function init():void{
			if(total_archivos > 0){
				carga_archivo(arr_data[indice_matriz][indice_archivo]);
			}
		}
	}
}