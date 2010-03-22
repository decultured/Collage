package Collage.DataEngine
{
	import flash.net.*;
	import flash.events.*;
	import mx.controls.Alert;
	import com.adobe.serialization.json.JSON;
	import Collage.Logger.*;
	
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
		
		public function AddField(name:String, sort:String = null,  modifier:String = null, group:String = null, alias:String = null):void
		{
			var newDataQueryField:DataQueryField = new DataQueryField(name, sort,  modifier, group, alias);
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

				if (field.sort)
					fieldQuery["sort"] = field.sort;
				if (field.modifier)
					fieldQuery["modifier"] = field.modifier;
				if (field.group)
					fieldQuery["group"] = field.group;
				if (field.alias)
					fieldQuery["alias"] = field.alias;
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

			var request:URLRequest = new URLRequest(DataEngine.getUrl("/api/v1/dataset/" + dataset + "/query?rand=" + (Math.random() * 100000).toString()));
			var loader:URLLoader = new URLLoader();
			request.method = URLRequestMethod.POST;
			var header:URLRequestHeader = new URLRequestHeader("X-Requested-With", "XMLHttpRequest");
            request.requestHeaders.push(header);
			var params:URLVariables = new URLVariables();
			params.aT = Session.AuthToken;
			params['q'] = BuildQueryString();
			request.data = params;
			loader.addEventListener(Event.COMPLETE, CompleteHandler);
            loader.addEventListener(SecurityErrorEvent.SECURITY_ERROR, SecurityErrorHandler);
            loader.addEventListener(IOErrorEvent.IO_ERROR, IOErrorHandler);
            loader.addEventListener(HTTPStatusEvent.HTTP_STATUS, HttpStatusHandler);

			Logger.Log("New query: " + params['q'], LogEntry.DEBUG, this);
			
			loader.load(request);
		}
		
        private function HttpStatusHandler(event:HTTPStatusEvent):void {
			event.target.removeEventListener(HTTPStatusEvent.HTTP_STATUS, HttpStatusHandler);
			Logger.Log("Query Status: " + event, LogEntry.DEBUG, this);
        }

		private function IOErrorHandler(event:IOErrorEvent):void
		{
            event.target.removeEventListener(IOErrorEvent.IO_ERROR, IOErrorHandler);
			Logger.Log("Query IO Error: " + event, LogEntry.ERROR, this);
		}
		
        private function SecurityErrorHandler(event:SecurityErrorEvent):void
		{
            event.target.removeEventListener(SecurityErrorEvent.SECURITY_ERROR, SecurityErrorHandler);
			Logger.Log("Query Security Error: " + event, LogEntry.ERROR, this);
        }

		private function CompleteHandler(event:Event):void
		{
			event.target.removeEventListener(Event.COMPLETE, CompleteHandler);

			var results:Object = JSON.decode(event.target.data);
			result = new DataQueryResult();

			for (var key:String in results)
			{
				if (key == "parse_time") {
					result.parseTime == parseInt(results[key]);
				} else if (key == "execute_time") {
					result.executeTime == parseInt(results[key]);
				} else if (key == "total") {
					result.total == parseInt(results[key]);
				} else if (key == "total_rows") {
					result.parsedTime == parseInt(results[key]);
				} else if (key == "rows") {
					result.rows = new Array();
					for (var rowKey:String in results[key]) {
						var newRow:Object = new Object();
						for (var fieldKey:String in results[key][rowKey]){
							newRow[fieldKey] = results[key][rowKey][fieldKey];
						}
						result.rows.push(newRow);
					}
				} else if (key == "columns") {
					result.columns = new Array();
					for (var columnKey:String in results[key]) {
						var newColumn:Object = new Object();
						for (var columnFieldKey:String in results[key][columnKey]){
							newColumn[columnFieldKey] = results[key][columnKey][columnFieldKey];
						}
						result.columns.push(newColumn);
					}
				}
			}

			Logger.Log("Data Query Loaded Successfully", LogEntry.INFO, this);

			result.AdjustRowFieldTypes();
			dispatchEvent(new Event(COMPLETE));
			loading = false;
			loaded = true;
		}
	}
}