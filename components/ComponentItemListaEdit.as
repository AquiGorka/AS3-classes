package com.aquigorka.component{
	
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.text.TextField;
	
	public class ComponentItemListaEdit extends ComponentItemLista{
	
		// ------- Constructor -------
		public function ComponentItemListaEdit(sid:String,w:Number=320,h:Number=100){
			// destroy
			addEventListener(Event.REMOVED_FROM_STAGE, destroy, false, 0, true);
			// super
			super(sid);
			//instancias
			// boton
			btn_edit = new Sprite();
			draw_btn_edit(w, h);
			hide_edit();
			// agregamos
			addChild(btn_edit);
		}
		
		//------- Properties --------
		public var original_pos_y:Number;
		protected var btn_edit:Sprite;
		
		// ------- Methods -------
		// Public
		public function hide_edit():void{
			btn_edit.visible = false;
		}
		
		public function show_edit():void{
			btn_edit.visible = true;
		}
		
		// Protected
		protected function draw_btn_edit(w:Number,h:Number):void{
			btn_edit.graphics.beginFill(0xFF0000);
			btn_edit.graphics.drawRect(0, 5, 40, h-10);
			btn_edit.graphics.endFill();
			btn_edit.x = w - btn_edit.width - 5;
		}
		
		// Private
		private function destroy(evt:Event):void{
			// listeners
			removeEventListener(Event.REMOVED_FROM_STAGE, destroy);
			// graphics
			btn_edit.graphics.clear();
			// stage
			removeChild(btn_edit);
			// referencias
			btn_edit = null;
		}
	}
}