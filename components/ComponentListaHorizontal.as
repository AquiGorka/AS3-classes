package com.aquigorka.component{
	
	import com.aquigorka.component.ComponentIPhoneScrollHorizontal;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	
	public class ComponentListaHorizontal extends ComponentLista{
	
		// ------- Constructor -------
		public function ComponentListaHorizontal(w:Number, h:Number, cf:Function){
			// destroy
			addEventListener(Event.REMOVED_FROM_STAGE, destroy, false, 0, true);
			// super
			super(w,h,cf);
			// init
			addEventListener(Event.ADDED_TO_STAGE, init);
		}
		
		private function init(e:Event = null):void{
			removeEventListener(Event.ADDED_TO_STAGE, init);
			_scroller = new ComponentIPhoneScrollHorizontal(lista, stage);
			(_scroller as ComponentIPhoneScrollHorizontal).canvasWidth = _width;
		}
		
		// ------- Methods -------
		// Public
		override public function add_item(item:ComponentItemLista):void{
			item.index = lista.numChildren;
			item.x = lista.width;
			item.addEventListener(MouseEvent.CLICK, handler_mouseclick, false, 0, true);
			item.callback_function_show_complete = local_callback_item_show_complete;
			lista.addChild(item);
			draw_scrollbar();
		}
		
		override public function remove_item(index:int):void {
			if(lista.numChildren > index){
				var item_remove:ComponentItemLista = lista.getChildAt(index) as ComponentItemLista;
				item_remove.callback_function_show_complete = null;
				item_remove.visible = false;
				var aux_w:Number = item_remove.width;
				for(var i:int = index; i < lista.numChildren; i++){
					lista.getChildAt(i).x -= (aux_w);
				}
				lista.removeChild(item_remove);
				item_remove = null;
				// aqui faltaría revisar si el scroll está hasta abajo y si al quitar un elemento se ve espacio en blanco y recorrer acorde
				draw_scrollbar();
			}
		}
		
		// Protected
		override protected function draw_scrollbar():void{
			scrollbar.x = _width - 5;
			scrollbar.y = 0;
			scrollbar.graphics.clear();
			if(_height < lista.height){
				scrollbar.graphics.beginFill(0x505050);
				scrollbar.graphics.drawRoundRect(0, 0, (_width/lista.width*_width), 5, 5, 5);
				scrollbar.graphics.endFill();
				scrollbar.alpha = 0;
			}
		}
		
		override protected function handler_move_follow(e:Event):void{
			scrollbar.y = _width * -lista.x / lista.width;
			if(scrollbar.alpha < 1){
				scrollbar.alpha = Math.min(1, scrollbar.alpha + 0.1);
			}
		}
		
		// Private
		private function destroy(e:Event):void{
			// listeners
			removeEventListener(Event.REMOVED_FROM_STAGE, destroy);
			// graphics
			scrollbar.graphics.clear();
		}
	}
}