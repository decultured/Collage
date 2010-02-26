package Collage.DataEngine
{
	import flash.net.*;
	import flash.events.*;
	import mx.controls.Alert;
	import com.adobe.serialization.json.JSON;

	public class DataQuery extends EventDispatcher
	{
		public static var COMPLETE:String = "complete";

		public var loaded:Boolean = false;
		public var loading:Boolean = false;
	
		public var limit:Number = 10;
		public var dataset:String = "";
		public var fields:Array = new Array();

		public var queryString:String = "";
		public var result:DataQueryResult = null;
		
		public function DataQuery():void
		{
			
		}
		
		public function ResetFields():void
		{
			fields = new Array();
		}
		
		public function AddField(name:String, sort:Boolean = false,  modifier:String = null, group:Boolean = false):void
		{
			var newDataQueryField:DataQueryField = new DataQueryField(name, sort,  modifier, group);
			fields.push(newDataQueryField);
		}
		
		public function BuildQueryString():String
		{
			var query:Object = new Object();
			
			query["limit"] = limit;
			query["dataset"] = dataset;
			query["fields"] = new Array();
			
			for each (var field:DataQueryField in fields)
			{
				var fieldQuery:Object = new Object();

				fieldQuery["sort"] = field.sort;
				fieldQuery["modifier"] = field.modifier;
				fieldQuery["group"] = field.group;
				fieldQuery["name"] = field.name;
				
				query["fields"].push(fieldQuery);
			}
			
			queryString = JSON.encode(query);
			return queryString;
		}
		
		public function LoadQueryResults():void
		{
			loading = true;

			if (!fields || fields.length < 1 || !dataset || dataset.length < 5 || !limit)
				return;

			var request:URLRequest = new URLRequest("http://dataengine.endlesspaths.com/api/v1/dataset/" + dataset + "/query");
			var loader:URLLoader = new URLLoader();
			var params:URLVariables = new URLVariables();
			params.q = BuildQueryString();
			request.data = params;
			request.method = URLRequestMethod.POST;
			loader.addEventListener(Event.COMPLETE, CompleteHandler);
            loader.addEventListener(SecurityErrorEvent.SECURITY_ERROR, SecurityErrorHandler);
            loader.addEventListener(IOErrorEvent.IO_ERROR, IOErrorHandler);
			
			loader.load(request);
		}
		
		private function IOErrorHandler(event:IOErrorEvent):void
		{
            event.target.removeEventListener(IOErrorEvent.IO_ERROR, IOErrorHandler);
			Alert.show("ioErrorHandler: " + queryString);
		}
		
        private function SecurityErrorHandler(event:SecurityErrorEvent):void
		{
            event.target.removeEventListener(SecurityErrorEvent.SECURITY_ERROR, SecurityErrorHandler);
            Alert.show("securityErrorHandler: " + queryString);
        }

		private function CompleteHandler(event:Event):void
		{
			event.target.removeEventListener(Event.COMPLETE, CompleteHandler);

			var results:Object = JSON.decode(event.target.data);

			for (var key:String in results)
			{
				/*
				if (key == "total_rows") {
					totalRows == parseInt(results[key]);
				} else if (key == "columns") {
					for (var columnKey:String in results[key]) {
						if (!results[key][columnKey]["internal"])
							continue;
						if (!columns[results[key][columnKey]["internal"]])
							columns[results[key][columnKey]["internal"]] = new DataSetColumn();

						var newColumn:DataSetColumn = columns[results[key][columnKey]["internal"]];
						for (var columnDataKey:String in results[key][columnKey])
						{
							if (columnDataKey == "internal")
								newColumn.internalLabel = results[key][columnKey][columnDataKey];
							else if (columnDataKey == "label")
								newColumn.label = results[key][columnKey][columnDataKey];
							else if (columnDataKey == "index")
								newColumn.index = results[key][columnKey][columnDataKey];
							else if (columnDataKey == "datatype")
								newColumn.datatype = results[key][columnKey][columnDataKey];
						}
					}
				}
				*/
			}
			dispatchEvent(new Event(COMPLETE));
			loading = false;
			loaded = true;
		}

	}
}