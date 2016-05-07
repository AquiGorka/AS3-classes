package com.aquigorka.component{
	
	import com.aquigorka.model.Tweener;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.text.TextField;
	
	public class ComponentComboBox extends ComponentLista{
	
		// ------- Constructor -------
		public function ComponentComboBox(w:Number, h:Number, myh:Number, colorborde:Number, func:Function){
			// destroy
			addEventListener(Event.REMOVED_FROM_STAGE, destroy, false, 0, true);
			// super
			super(w - NUM_BORDE, h + myh, local_callback_function_click_cmb);
			// declaraciones
			cmb_height = myh;
			callback_function_click_cmb = func;
			bool_estado_cmb = false;
			bool_position_fix = false;
			// instancias
			// fondo
			graphics.beginFill(colorborde)
			graphics.drawRect(-NUM_BORDE/2, 0, w, h+myh+NUM_BORDE/2);
			graphics.endFill();
			// mascara_cmb
			mascara_cmb = new Sprite();
			mascara_cmb.graphics.beginFill(0x00FF00)
			mascara_cmb.graphics.drawRect(0, 0, w, myh);
			mascara_cmb.graphics.endFill();
			mascara_cmb.x = -NUM_BORDE / 2;
			// selected
			txt_label = new TextField();
			txt_label.width = w;
			txt_label.height = myh;
			txt_label.text = '';
			txt_label.selectable = false;
			txt_label.y = - myh;
			txt_label.x = -NUM_BORDE / 2;
			// btn
			btn_invisible = new Sprite();
			btn_invisible.graphics.beginFill(0x000000, 0);
			btn_invisible.graphics.drawRect(0, 0, w, myh);
			btn_invisible.graphics.endFill();
			btn_invisible.y = -myh;
			btn_invisible.x = -NUM_BORDE / 2;
			// listeners
			btn_invisible.addEventListener(MouseEvent.CLICK, handler_click_btn, false, 0, true);
			// agregamos
			addChild(txt_label);
			addChild(btn_invisible);
			addChild(mascara_cmb);
			// mascara_cmb
			mask = mascara_cmb;
		}
		
		//------- Properties --------
		public var selected_index:int=-1;
		protected var txt_label:TextField;
		protected static const NUM_BORDE:int = 1;
		protected var bool_estado_cmb:Boolean;
		private var mascara_cmb:Sprite;
		private var callback_function_click_cmb:Function;
		private var bool_position_fix:Boolean;
		private var cmb_height:Number
		private var btn_invisible:Sprite;
		
		// ------- Methods -------
		public function get selected_item():ComponentItemComboBox{
			return (lista.getChildAt(selected_index)) as ComponentItemComboBox;
		}
		
		// Public
		override public function add_item(item:ComponentItemLista):void{
			super.add_item(item);
			if(lista.numChildren == 1){
				set_selected_index(0);
				if(!bool_position_fix){
					fix_y_x();
				}
			}
		}
		
		public function set_selected_index(num:int):void{
			if(lista.numChildren > (num-1)){
				selected_index = num;
				txt_label.text = (lista.getChildAt(num) as ComponentItemComboBox).string;
			}
		}
		
		// Protected
		protected function handler_click_btn(e:Event):void{
			btn_invisible.removeEventListener(MouseEvent.CLICK, handler_click_btn);
			bool_click_lista_enabled = false;
			var height_final = cmb_height;
			var tw_mk:Tweener = new Tweener();
			if(!bool_estado_cmb){
				height_final = lista.height + cmb_height + NUM_BORDE/2;
			}
			tw_mk.linear_tween(mascara_cmb, 'height', mascara_cmb.height, height_final, 200, function() { bool_estado_cmb = !bool_estado_cmb; btn_invisible.addEventListener(MouseEvent.CLICK, handler_click_btn, false, 0, true); bool_click_lista_enabled = true; } );
		}
		
		protected function local_callback_function_click_cmb():void{
			if(bool_estado_cmb){
				if(selected_index != (item_click as ComponentItemComboBox).index){
					set_selected_index((item_click as ComponentItemComboBox).index);
					mascara_cmb.height = cmb_height;
					bool_estado_cmb = false;
					callback_function_click_cmb();
				}
			}
		}
		
		// Private
		private function destroy(e:Event):void{
			// listeners
			removeEventListener(Event.REMOVED_FROM_STAGE, destroy);
			// graphics
			graphics.clear();
			mascara_cmb.graphics.clear();
			btn_invisible.graphics.clear();
			// stage
			removeChild(txt_label);
			removeChild(mascara_cmb);
			removeChild(btn_invisible);
			// referencias
			txt_label = null;
			mascara_cmb = null;
			btn_invisible = null;
		}
		
		private function fix_y_x():void {
			bool_position_fix = true;
			txt_label.y += -cmb_height;
			mascara_cmb.y  += -cmb_height;
			y += cmb_height;
			x += NUM_BORDE/2;
		}
	}
}