package com.aquigorka.interfaces{

	public interface InterfaceDispatchManager{
		function dispatch(str_seccion:String, params:Array = null):void;
		function handler_manage_petition(str_seccion:String, params:Array):void;
		function handler_manage_async_petition(str_seccion:String, params:Array):Array;
		function hide_modulos_complete_handler():void;
		function show_modulos_complete_handler():void;
		function parent_init():void;	
	}
}