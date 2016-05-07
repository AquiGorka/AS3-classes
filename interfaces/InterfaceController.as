package com.aquigorka.interfaces{
	
	public interface InterfaceController{
		function init():void;
		function manage_async_petition(str_seccion:String, params:Array = null):Array;
		function manage_petition(str_seccion:String, params:Array = null):void;
	}
}