package com.aquigorka.component{
	
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	
	public class ComponentItemListaDelete extends ComponentItemLista{
	
		// ------- Constructor -------
		public function ComponentItemListaDelete(sid:String, w:Number = 320, h:Number = 100){
			// destroy
			addEventListener(Event.REMOVED_FROM_STAGE, destroy, false, 0, true);
			// super
			super(sid);
			// instancias
			btn_delete = new Sprite();
			draw_btn_delete(w, h);
			//hide_delete();
			// agregamos
			addChild(btn_delete);
		}
		
		//------- Properties --------
		protected var btn_delete:Sprite;
		protected var callback_function_delete:Function;
		
		// ------- Methods -------
		// Public
		public function hide_delete():void{
			if(btn_delete){
				btn_delete.visible = false;
				btn_delete.removeEventListener(MouseEvent.CLICK, handler_click);
			}
		}
		
		public function set_callback_function_delete(cf:Function):void{
			callback_function_delete = cf;
		}
		
		public function show_delete():void{
			if(btn_delete){
				btn_delete.visible = true;
				btn_delete.addEventListener(MouseEvent.CLICK, handler_click, false, 0, true);
			}
		}
		
		// Protected
		protected function draw_btn_delete(w:Number,h:Number):void {
			btn_delete.graphics.clear();
			btn_delete.graphics.beginFill(0xFF0000);
			btn_delete.graphics.drawRect(0, 0, 25, h);
			btn_delete.graphics.endFill();
			btn_delete.graphics.beginFill(0x00FF00);
			btn_delete.graphics.drawCircle(10, 10, 10);
			btn_delete.graphics.endFill();
			btn_delete.x = w - btn_delete.width;
			btn_delete.visible = false;
		}
		
		protected function handler_click(e:Event):void{
			callback_function_delete();
		}
		
		// Private
		private function destroy(evt:Event):void{
			// listeners
			removeEventListener(Event.REMOVED_FROM_STAGE, destroy);
			btn_delete.removeEventListener(MouseEvent.CLICK, handler_click);
			// grapchics
			btn_delete.graphics.clear();
			// stage
			removeChild(btn_delete);
			// referencias
			btn_delete = null;
		}
	}
}