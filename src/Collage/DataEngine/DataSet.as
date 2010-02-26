package Collage.DataEngine
{
	import flash.net.*;
	import flash.events.*;
	import mx.controls.Alert;
	import com.adobe.serialization.json.JSON;

	public class DataSet extends EventDispatcher
	{
		public static var COMPLETE:String = "complete";

		[Bindable] public var loaded:Boolean = false;
		[Bindable] public var loading:Boolean = false;

		[Bindable] public var id:String = "";
		[Bindable] public var title:String = "";

		[Bindable] public var totalRows:Number = 0;

		[Bindable] public var uploaded:Boolean = false;
		[Bindable] public var processed:Boolean = false;

		[Bindable] public var created:String = "";
		[Bindable] public var changed:String = "";
		[Bindable] public var accessed:String = "";
		
		public var columns:Object = new Object();

		public function DataSet():void
		{
			
		}

		public function GetColumnByID(id:String):DataSetColumn
		{
			if (columns[id])
				return columns[id];
			return null;
		}
		
		public function GetColumnsComboBox():Array
		{
			var columnSelections:Array = new Array();

			var firstObject:Object = new Object;
			firstObject["label"] = "Please Select a Data Column...";
			firstObject["data"] = "";
			columnSelections.push(firstObject);

			for (var key:String in columns) {
				var newObject:Object = new Object;
				newObject["label"] = columns[key].label;
				newObject["data"] = columns[key].internalLabel;
				columnSelections.push(newObject);
			}
			return columnSelections;
		}

		public function LoadColumns():void
		{
			loading = true;

			if (!id || id.length < 5)
				return;
			
			var request:URLRequest = new URLRequest("http://dataengine.endlesspaths.com/api/v1/dataset/" + id + "/metadata");
			var loader:URLLoader = new URLLoader();
			var params:URLVariables = new URLVariables();
			//params.WHATEVER = WHATEVER YOU WANT IT TO BE;
			request.data = params;
			request.method = URLRequestMethod.GET;
			loader.addEventListener(Event.COMPLETE, CompleteHandler);
            loader.addEventListener(SecurityErrorEvent.SECURITY_ERROR, SecurityErrorHandler);
            loader.addEventListener(IOErrorEvent.IO_ERROR, IOErrorHandler);
			
			loader.load(request);
		}
		
		private function IOErrorHandler(event:IOErrorEvent):void
		{
            event.target.removeEventListener(IOErrorEvent.IO_ERROR, IOErrorHandler);
			Alert.show("ioErrorHandler: " + event);
		}
		
        private function SecurityErrorHandler(event:SecurityErrorEvent):void
		{
            event.target.removeEventListener(SecurityErrorEvent.SECURITY_ERROR, SecurityErrorHandler);
            Alert.show("securityErrorHandler: " + event);
        }

		private function CompleteHandler(event:Event):void
		{
			event.target.removeEventListener(Event.COMPLETE, CompleteHandler);
			var results:Object = JSON.decode(event.target.data);

			for (var key:String in results)
			{
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
			}
			
			dispatchEvent(new Event(COMPLETE));
			loading = false;
			loaded = true;
		}

	}
}