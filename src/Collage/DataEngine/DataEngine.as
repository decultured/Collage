package Collage.DataEngine
{
	import flash.net.*;
	import flash.events.*;
	import mx.controls.Alert;
	import com.adobe.serialization.json.JSON;
	import flash.filesystem.*;
	import Collage.Logger.*;
	
	public class DataEngine extends EventDispatcher
	{
		/*public static var baseUrl:String = "http://dataengine.local/";*/
		public static var baseUrl:String = "http://dataengine.endlesspaths.com/";
		public static var COMPLETE:String = "complete";
		
		public static var datasets:Object = new Object();
		public static var numDataSets:Number = 0;
		
		public static var events:EventDispatcher = new EventDispatcher();

		[Bindable]public static var loaded:Boolean = false;
		[Bindable]public static var loading:Boolean = false;

		public function DataEngine():void
		{
			
		}
		
		public static function getUrl(urlStr:String):String {
			if(urlStr.charAt(0) == '/') {
				urlStr = urlStr.substr(1, urlStr.length);
			}
			
			return baseUrl + urlStr;
		}
		
		public static function GetDataSetByID(id:String):DataSet
		{
			if (datasets[id])
				return datasets[id];
			return null;
		}

		// TODO : Implement Params
		public static function GetDataSetsComboBox(allowedTypes:Array = null, minAllowedColumns:uint = 0, minAllowedRows:uint = 0):Array
		{
			var dataSetSelections:Array = new Array();

			for (var key:String in datasets) {
				if (datasets[key].GetNumColumnsOfType(allowedTypes) < minAllowedColumns)
					continue;
				
				var newObject:Object = new Object;
				newObject["label"] = datasets[key].title;
				newObject["data"] = datasets[key].id;
				dataSetSelections.push(newObject);
			}

			dataSetSelections.sortOn("label", Array.CASEINSENSITIVE);

			var firstObject:Object = new Object;
			firstObject["label"] = "Please Select a Dataset...";
			firstObject["data"] = "";
			dataSetSelections.unshift(firstObject);
			
			return dataSetSelections;
		}
		
		public static function get DataSetsLoaded():Boolean
		{
			for each (var dataSet:DataSet in datasets)
			{
				if (!dataSet.loaded)
					return false;
			}
			return true;
		}
		
		public static function LoadAllDataSets():void
		{
			// http://dataengine.local/api/v1/dataset/list
			
			loading = true;
			
			var request:URLRequest = new URLRequest(DataEngine.getUrl("/api/v1/dataset/list"));
			var loader:URLLoader = new URLLoader();
			var params:URLVariables = new URLVariables();
			params.auth_token = Session.AuthToken;
			request.data = params;
			request.method = URLRequestMethod.GET;
			loader.addEventListener(Event.COMPLETE, CompleteHandler);
            loader.addEventListener(SecurityErrorEvent.SECURITY_ERROR, SecurityErrorHandler);
            loader.addEventListener(IOErrorEvent.IO_ERROR, IOErrorHandler);
			
			loader.load(request);
		}
		
		private static function IOErrorHandler(event:IOErrorEvent):void
		{
            event.target.removeEventListener(IOErrorEvent.IO_ERROR, IOErrorHandler);
			Logger.Log("Data Engine IO Error: " + event, LogEntry.ERROR);
		}
		
        private static function SecurityErrorHandler(event:SecurityErrorEvent):void
		{
            event.target.removeEventListener(SecurityErrorEvent.SECURITY_ERROR, SecurityErrorHandler);
			Logger.Log("Data Engine Security Error: " + event, LogEntry.ERROR);
        }

		private static function CompleteHandler(event:Event):void
		{
			event.target.removeEventListener(Event.COMPLETE, CompleteHandler);
			var results:Object = JSON.decode(event.target.data);

			for (var key:String in results)
			{
				if (!results[key]["id"])
					continue;
				
				if (!datasets[results[key]["id"]]) {
					datasets[results[key]["id"]] = new DataSet();
					numDataSets++;
				}
				var newDataSet:DataSet = datasets[results[key]["id"]];

				for (var dataSetKey:String in results[key]) {
					if (dataSetKey == "uploaded" || dataSetKey == "processed") {
						(results[key][dataSetKey] == "true") ? newDataSet[dataSetKey] = true : newDataSet[dataSetKey] = false;
					} else {
						newDataSet[dataSetKey] = results[key][dataSetKey];
					}
				}
				
				newDataSet.addEventListener(DataSet.COMPLETE, DataSetFinishedLoading);
				newDataSet.LoadColumns();
			}
		}
		
		public static function DataSetFinishedLoading(event:Event):void
		{
			if (DataSetsLoaded) {
				events.dispatchEvent(new Event(COMPLETE));
				loading = false;
				loaded = true;
				Logger.Log("Data Load Complete", LogEntry.INFO);
			}
		}
		
		public static function UploadCSV(file:File):void {
			var request:URLRequest = new URLRequest(DataEngine.getUrl("/api/v1/dataset/upload"));
			var loader:URLLoader = new URLLoader();
			var header:URLRequestHeader = new URLRequestHeader("X-Requested-With", "XMLHttpRequest");
			request.method = URLRequestMethod.POST;
            request.requestHeaders.push(header);
			
			var params:URLVariables = new URLVariables();
			params.auth_token = Session.AuthToken;
			request.data = params;

			file.addEventListener(Event.COMPLETE, FileUploadCompleteHandler);
            file.addEventListener(SecurityErrorEvent.SECURITY_ERROR, FileUploadSecurityErrorHandler);
            file.addEventListener(IOErrorEvent.IO_ERROR, FileUploadIOErrorHandler);
            file.addEventListener(HTTPStatusEvent.HTTP_STATUS, FileUploadHttpStatusHandler);
			file.upload(request,"datafile");
		}
		
        private static function FileUploadHttpStatusHandler(event:HTTPStatusEvent):void {
			Logger.Log("Data Engine File Upload HTTP Status: " + event, LogEntry.DEBUG);
        }

		private static function FileUploadIOErrorHandler(event:IOErrorEvent):void
		{
            event.target.removeEventListener(IOErrorEvent.IO_ERROR, IOErrorHandler);
			Logger.Log("Data Engine File Upload IO Error: " + event, LogEntry.ERROR);
		}

        private static function FileUploadSecurityErrorHandler(event:SecurityErrorEvent):void
		{
            event.target.removeEventListener(SecurityErrorEvent.SECURITY_ERROR, SecurityErrorHandler);
			Logger.Log("Data Engine File Upload Security Error: " + event, LogEntry.ERROR);
        }

		private static function FileUploadCompleteHandler(event:Event):void
		{
			event.target.removeEventListener(Event.COMPLETE, CompleteHandler);
            DataEngine.LoadAllDataSets();
			Logger.Log("File Upload Complete!", LogEntry.INFO);
		}
	}
}