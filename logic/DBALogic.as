package com.aquigorka.logic{

	import flash.data.SQLConnection;
	import flash.data.SQLMode;
	import flash.errors.SQLError;
	import flash.data.SQLStatement;
	import flash.filesystem.File;

	public class DBALogic{

		// ------- Constructor -------
		public function DBALogic(str_folder:String){
			db_connection = new SQLConnection();
			var db_file:File = new File(str_folder).resolvePath(DB_FILE_NAME);
			var bool_existe:Boolean = db_file.exists;
			var modo:String = SQLMode.UPDATE;
			if(!bool_existe){
				var db_folder:File = new File(str_folder);
				db_folder.createDirectory();
				modo = SQLMode.CREATE;
			}
			try{db_connection.open(db_file, modo);}catch(error:SQLError){trace('- Connection Error');trace("Message: "+error.message);trace("Details: "+error.details);}
			if(!bool_existe){
				create_tables();
			}
		}

		// ------- Properties -------
		private var db_connection;
		private const DB_FILE_NAME:String = 'db.sqlite';
		
		// ------- Methods -------
		// Public
		public function execute_query(query_string:String, query_debug:Boolean=false, query_result_debug:Boolean=false):Array{
			var result:Array = [];
			if(query_debug){trace('query_string: '+query_string);}
			var statement:SQLStatement = new SQLStatement();
			statement.sqlConnection = db_connection;
			statement.text = query_string;
			try{statement.execute();result=statement.getResult().data;}catch(error:SQLError){trace('- Query Error: '+query_string);trace('Message: '+error.message);trace('Details: '+error.details);}
			if(result == null){
				result = [];
			}
			if(query_result_debug){
				import com.demonsters.debugger.MonsterDebugger;
				MonsterDebugger.initialize(this);
				MonsterDebugger.trace(this, query_string);
				MonsterDebugger.trace(this, result);
			}
			return result;
		}
		
		// Protected
		protected function create_tables():void{}
		
		protected function create_sql_create_statement(str_table:String,params:Array):String{
			var sql:String = "";
			sql += 'CREATE TABLE IF NOT EXISTS '+str_table+' (';
			sql += "	Id	INTEGER PRIMARY KEY AUTOINCREMENT,";
			for(var i:int = 0; i < params.length; i++){
				sql += '	'+params[i][0]+'	'+params[i][1]+'';
				if(i<params.length-1){
					sql += ',';
				}
			}
			sql += ')';
			return sql;
		}
	}
}