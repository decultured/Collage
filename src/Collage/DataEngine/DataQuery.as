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

			var request:URLRequest = new URLRequest("http://dataengine.endlesspaths.com/api/v1/dataset/" + dataset + "/query?rand=" + (Math.random() * 100000).toString());
			var loader:URLLoader = new URLLoader();
			request.method = URLRequestMethod.POST;
			var header:URLRequestHeader = new URLRequestHeader("X-Requested-With", "XMLHttpRequest");
            request.requestHeaders.push(header);
			var params:URLVariables = new URLVariables();
			params['q'] = BuildQueryString();
			request.data = params;
			loader.addEventListener(Event.COMPLETE, CompleteHandler);
            loader.addEventListener(SecurityErrorEvent.SECURITY_ERROR, SecurityErrorHandler);
            loader.addEventListener(IOErrorEvent.IO_ERROR, IOErrorHandler);
            loader.addEventListener(Event.OPEN, OpenHandler);
            loader.addEventListener(ProgressEvent.PROGRESS, ProgressHandler);
            loader.addEventListener(HTTPStatusEvent.HTTP_STATUS, HttpStatusHandler);

			loader.load(request);
		}
		
        private function OpenHandler(event:Event):void {
            Alert.show("openHandler: " + event);
        }

        private function ProgressHandler(event:ProgressEvent):void {
            Alert.show("progressHandler loaded:" + event.bytesLoaded + " total: " + event.bytesTotal);
        }

        private function HttpStatusHandler(event:HTTPStatusEvent):void {
            if (event.target
			Alert.show("httpStatusHandler: " + event);
        }

		private function IOErrorHandler(event:IOErrorEvent):void
		{
            event.target.removeEventListener(IOErrorEvent.IO_ERROR, IOErrorHandler);
			Alert.show("ioErrorHandler: \n" + "http://dataengine.endlesspaths.com/api/v1/dataset/" + dataset + "/query \n" + queryString);
		}
		
        private function SecurityErrorHandler(event:SecurityErrorEvent):void
		{
            event.target.removeEventListener(SecurityErrorEvent.SECURITY_ERROR, SecurityErrorHandler);
            Alert.show("securityErrorHandler: " + "http://dataengine.endlesspaths.com/api/v1/dataset/" + dataset + "/query \n" + queryString);
        }

		private function CompleteHandler(event:Event):void
		{
			event.target.removeEventListener(Event.COMPLETE, CompleteHandler);

            Alert.show("http://dataengine.endlesspaths.com/api/v1/dataset/" + dataset + "/query \n" + event.target.data);

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
			
//			result.AdjustRowFieldTypes();
			dispatchEvent(new Event(COMPLETE));
			loading = false;
			loaded = true;

		}

	}
}