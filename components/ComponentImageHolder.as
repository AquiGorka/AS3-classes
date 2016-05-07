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
	import flash.utils.ByteArray;

	public final class ComponentImageHolder extends Sprite{

		// ------- Constructor -------
		public function ComponentImageHolder(image_url:String, w:Number, h:Number, dw:Number = 0, dh:Number = 0, bscaleto:Boolean = false){
			// Mi recomendación es que hagas un ImageHolder base y que los que hagan scale y otros lo extiendan
			addEventListener(Event.REMOVED_FROM_STAGE, destroy, false, 0, true);
			bool_scaleTo = bscaleto;
			real_width = dw;
			real_height = dh;
			// preparamos
			holder_width = w;
			holder_height = h;
			bitmapdata_canvas = new BitmapData(w, h, true,0x00000000);
			bitmap_canvas = new Bitmap(bitmapdata_canvas);
			bitmap_canvas.smoothing = true;
			bitmap_canvas.cacheAsBitmap = !bscaleto;
			// pedidmos
			load_image(image_url);
			// agregamos
			addChild(bitmap_canvas);
		}

		// ------- Properties -------
		public var loader_obj:Loader;
		private var holder_width:Number;
		private var holder_height:Number;
		private var real_width:Number;
		private var real_height:Number;
		private var bitmap_canvas:Bitmap;
		private var bitmapdata_canvas:BitmapData;
		private var bool_scaleTo:Boolean;
		
		// ------- Methods -------
		// Public
		public function load_image(image_url:String):void{
			loader_obj = new Loader();
			loader_obj.load(new URLRequest(image_url));
			// quien tenga este objeto puede escuchar este evento para revisar la carga - por eso loader es public
			loader_obj.contentLoaderInfo.addEventListener(Event.COMPLETE, handler_image_load, false, 0, true);
		}
		
		// Private
		private function destroy(evt:Event):void{
			// listeners
			removeEventListener(Event.REMOVED_FROM_STAGE, destroy);
			// stage
			removeChild(bitmap_canvas);
			// referencias
			bitmap_canvas = null;
		}
		
		private function handler_image_load(e:Event):void{
			loader_obj.contentLoaderInfo.removeEventListener(Event.COMPLETE, handler_image_load);
			bitmapdata_canvas.copyPixels((loader_obj.content as Bitmap).bitmapData, bitmapdata_canvas.rect, new Point(0, 0));
			if(bool_scaleTo){
				if(bitmap_canvas.width < real_width){
					bitmap_canvas.scaleX = real_width / bitmap_canvas.width;
					bitmap_canvas.scaleY = real_width / bitmap_canvas.width;
				}
				if(bitmap_canvas.height < real_height){
					var number:Number = real_height / bitmap_canvas.height;
					bitmap_canvas.scaleX = number;
					bitmap_canvas.scaleY = number;
				}
			}
		}
	}
}