package com.aquigorka.component{
	
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.events.Event;
	import flash.geom.Matrix;
	import flash.media.Video;
	
	public class ComponentPortraitPicTaker extends ComponentPicTaker{
	
		// ------- Constructor -------
		public function ComponentPortraitPicTaker(cf:Function, camw:Number, camh:Number, camx:Number, camy:Number, w:Number, h:Number, scale:Number=1, str_sonido:String = ''){
			super(cf, camw, camh, camx, camy, w, h, scale, str_sonido);
		}
		
		// ------- Methods -------
		// Protected
		override protected function handler_click(e:Event):void {
			if(string_sonido != ''){
				sonido.play();
			}
			video.attachCamera(null);
			preview.visible = true;
			var bitmapdata_video:BitmapData = new BitmapData(width_real_sin_hack, height_real_sin_hack); 
			preview = new Bitmap(bitmapdata_video);
			final_image = new Bitmap(bitmapdata_video);
			var m:Matrix = new Matrix();
			m.translate(-height_real_sin_hack / 2, -width_real_sin_hack / 2);
			m.rotate(Math.PI / 2);
			m.translate(width_real_sin_hack / 2, height_real_sin_hack / 2);
			bitmapdata_video.draw(video, m, null, null, null, true);
			show_decide();
		}
		
		override protected function prepare_camera(camw:Number, camh:Number):void{
			video = new Video(camh, camw);
			var m:Matrix = new Matrix();
			m.rotate(Math.PI/2);
			video.transform.matrix = m;
			video.x += video.width;
			camara.setMode(video.height,video.width,VIDEO_FRAME_RATE);
		}
	}
}