package com.aquigorka.component{
	
	import flash.display.Bitmap;
	import flash.display.BitmapData; 
	import flash.display.DisplayObject; 
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.geom.Matrix;
	import flash.media.Camera;
	import flash.media.Video;
	import flash.media.Sound;
	import flash.net.URLRequest;
	import flash.text.TextField;
	import flash.text.TextFormat;
	import flash.text.TextFormatAlign;
	
	public class ComponentPicTaker extends Sprite{
	
		// ------- Constructor -------
		public function ComponentPicTaker(cf:Function, camw:Number, camh:Number, camx:Number, camy:Number, w:Number, h:Number, scale:Number=1, str_sonido:String = ''){
			// destroy
			addEventListener(Event.REMOVED_FROM_STAGE, destroy, false, 0, true);
			// super
			super();
			//declaraciones
			preview_x = camx;
			preview_y = camy;
			bool_image = false;
			_width = w;
			_height = h;
			width_real_sin_hack = camw;
			height_real_sin_hack = camh;
			escala = scale;
			callback_function = cf;
			// instancias
			// camara
			camara = Camera.getCamera();
			camara.setQuality(0, 100);
			// aqui hay un más 1 porque por alguna rara razón no ajustaba bien, esto lo arregla en PicTaker y PortraitPicTaker (es decir lo que recibe no debe venir con hack)
			// si falla algo en skins o así, empieza por revisar esto.
			prepare_camera(camw, camh+1);
			// sonido
			string_sonido = str_sonido;
			if(string_sonido != ''){
				sonido = new Sound(new URLRequest(string_sonido));
			}
			// fondo
			fondo = new Sprite();
			draw_fondo();
			// preview
			preview = new Bitmap();
			preview.x = camx;
			preview.y = camy;
			preview.width = camw;
			preview.height = camh;
			preview.visible = false;
			// botones
			btn_tomar = new Sprite();
			btn_use = new Sprite();
			btn_retake = new Sprite();
			btn_cancel = new Sprite();
			draw_btns();
			// video
			video_container = new Sprite();
			video_container.graphics.beginFill(0x000000);
			video_container.graphics.drawRect(0, 0, camw, camh);
			video_container.graphics.endFill();
			video_container.addChild(video);
			video_container.scaleX = escala;
			video_container.scaleY = escala;
			video_container.x = camx;
			video_container.y = camy;
			// listeners
			create_listeners();
			// agregamos
			addChild(fondo);
			addChild(btn_tomar);
			addChild(btn_use);
			addChild(btn_retake);
			addChild(btn_cancel);
			addChild(video_container);
			addChild(preview);
			// iniciamos
			show_take();
		}
		
		//------- Properties --------
		public var final_image:Bitmap;
		public var bool_image:Boolean;
		protected var video:Video;
		protected var video_container:Sprite;
		protected var camara:Camera;
		protected var sonido:Sound;
		protected var string_sonido:String;
		protected var preview:Bitmap;
		protected var fondo:Sprite;
		protected var _width:Number;
		protected var _height:Number;
		protected static const VIDEO_FRAME_RATE:int = 21;
		protected var btn_tomar:Sprite;
		protected var btn_use:Sprite;
		protected var btn_retake:Sprite;
		protected var btn_cancel:Sprite;
		protected var width_real_sin_hack:Number;
		protected var height_real_sin_hack:Number;
		protected var preview_x:Number;
		protected var preview_y:Number;
		protected var escala:Number;
		private var callback_function:Function;
		private var sprite_cancel:Sprite;
		private var txt_cancel:TextField;
		private var c_btn_tomar:ComponentSimboloBoton;
		private var c_btn_use:ComponentSimboloBoton;
		private var c_btn_retake:ComponentSimboloBoton;
		private var c_btn_cancel:ComponentBoton;
		
		// ------- Methods -------
		// Public
		public function clean_up(){
			preview.visible = false;
			video.attachCamera(null);
			visible = false;
		}
		
		public function start():void{
			preview = new Bitmap();
			visible = true;
			video.attachCamera(camara);
		}
		
		// Protected
		protected function draw_fondo():void{
			fondo.graphics.beginFill(0x000000, .95);
			fondo.graphics.drawRect(0, 0, _width, _height);
			fondo.graphics.endFill();
		}
		
		protected function draw_btns():void{
			// btn_tomar
			c_btn_tomar = new ComponentSimboloBoton('c', 0xFFFFFF, 0x000000, 0x000000, _width/3, 40, 0x00FF00, .5, 35);
			// btn_use
			c_btn_use = new ComponentSimboloBoton('Q', 0xFFFFFF, 0x000000, 0x000000, 100, 40, 0xDDDDDD, .5, 35);
			// btn_retake
			c_btn_retake = new ComponentSimboloBoton('G', 0xFFFFFF, 0x000000, 0x000000, 100, 40, 0xDDDDDD, .5, 35);
			// btn_cancel
			c_btn_cancel = new ComponentBoton(0xFFFFFF);
			sprite_cancel = new Sprite();
			sprite_cancel.graphics.beginFill(0xFF0000);
			sprite_cancel.graphics.drawRoundRect(0, 0, 100, 40, 20);
			sprite_cancel.graphics.endFill();
			txt_cancel = new TextField();
			txt_cancel.text = 'CANCEL';
			txt_cancel.width = 100;
			txt_cancel.height = 40;
			txt_cancel.y = 10;
			txt_cancel.selectable = false;
			var format_cancel:TextFormat = new TextFormat();
			format_cancel.align = TextFormatAlign.CENTER;
			format_cancel.size = 18;
			format_cancel.bold = true;
			format_cancel.color = 0xFFFFFF;
			txt_cancel.setTextFormat(format_cancel);
			sprite_cancel.addChild(txt_cancel);
			c_btn_cancel.addChild(sprite_cancel);
			// agregamos
			btn_tomar.addChild(c_btn_tomar);
			btn_use.addChild(c_btn_use);
			btn_retake.addChild(c_btn_retake);
			btn_cancel.addChild(c_btn_cancel);
		}
		
		protected function handler_click(e:Event):void{
			if(string_sonido != ''){
				sonido.play();
			}
			video.attachCamera(null);
			preview.visible = true;
			var bitmapdata_video:BitmapData = new BitmapData(width_real_sin_hack, height_real_sin_hack); 
			preview = new Bitmap(bitmapdata_video);
			final_image = new Bitmap(bitmapdata_video);
			bitmapdata_video.draw(video);
			show_decide();
		}
		
		protected function handler_use(e:Event):void{
			bool_image = true;
			hide_btns();
			callback_function();
		}
		
		protected function handler_retake(e:Event):void{
			video.attachCamera(camara);
			final_image = null;
			bool_image = false;
			preview.visible = false;
			show_take();
		}
		
		protected function handler_cancel(e:Event):void{
			final_image = null;
			bool_image = false;
			show_take();
			clean_up();
			callback_function();
		}
		
		protected function prepare_camera(camw:Number, camh:Number):void{
			camara.setMode(camw, camh, VIDEO_FRAME_RATE);
			video = new Video(camara.width, camara.height);
		}
		
		protected function show_decide():void{
			btn_tomar.x = -100;
			btn_cancel.x = 2*_width/3+(_width/3 - btn_use.width)/2;
			btn_cancel.y = btn_tomar.y;
			btn_use.x = (_width/3 - btn_use.width)/2;
			btn_use.y = btn_tomar.y;
			btn_retake.x = _width/3+(_width/3 - btn_use.width)/2;
			btn_retake.y = btn_tomar.y;
			btn_tomar.y = -100;
		}
		
		protected function show_take():void{
			btn_tomar.y = preview.y + video_container.height + 15;
			btn_tomar.x = (_width/2 - btn_tomar.width) / 2;
			btn_cancel.x = _width/2+(_width/2 - btn_cancel.width)/2;
			btn_cancel.y = btn_tomar.y;
			btn_use.x = -100;
			btn_use.y = -100;
			btn_retake.x = -100;
			btn_retake.y = -100;
		}
		
		// Private
		private function create_listeners():void{
			btn_tomar.addEventListener(MouseEvent.CLICK, handler_click, false, 0, true);
			btn_use.addEventListener(MouseEvent.CLICK, handler_use, false, 0, true);
			btn_retake.addEventListener(MouseEvent.CLICK, handler_retake, false, 0, true);
			btn_cancel.addEventListener(MouseEvent.CLICK, handler_cancel, false, 0, true);
		}
		
		private function destroy(e:Event):void{
			clean_up();
			// listeners
			removeEventListener(Event.REMOVED_FROM_STAGE, destroy);
			remove_listeners();
			// stage
			removeChild(fondo);
			addChild(preview);
			removeChild(preview);
			video_container.removeChild(video);
			removeChild(video_container);
			if(c_btn_tomar){
				btn_tomar.removeChild(c_btn_tomar);
				btn_use.removeChild(c_btn_use);
				btn_retake.removeChild(c_btn_retake);
				btn_cancel.removeChild(c_btn_cancel);
				sprite_cancel.removeChild(txt_cancel);
				btn_cancel.removeChild(sprite_cancel);
			}
			removeChild(btn_tomar);
			removeChild(btn_use);
			removeChild(btn_retake);
			removeChild(btn_cancel);
			// referencias
			fondo = null;
			preview = null;
			video = null;
			video_container = null;
			btn_tomar = null;
			btn_use = null;
			btn_retake = null;
			txt_cancel = null;
			sprite_cancel = null;
			btn_cancel = null;
		}
		
		private function hide_btns():void{
			btn_tomar.x = -100;
			btn_tomar.y = -100;
			btn_retake.x = -100;
			btn_retake.y = -100;
			btn_use.x = -100;
			btn_use.y = -100;
			btn_cancel.x = -100;
			btn_cancel.y = -100;
		}
		
		private function remove_listeners():void{
			btn_tomar.removeEventListener(MouseEvent.CLICK, handler_click);
			btn_use.removeEventListener(MouseEvent.CLICK, handler_use);
			btn_retake.removeEventListener(MouseEvent.CLICK, handler_retake);
			btn_cancel.removeEventListener(MouseEvent.CLICK, handler_cancel);
		}
	}
}