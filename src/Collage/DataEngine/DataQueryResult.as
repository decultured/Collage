package Collage.DataEngine
{
	import mx.controls.Alert;

	public class DataQueryResult
	{
		public var parseTime:Number = 0;
		public var executeTime:Number = 0;
		public var total:Number = 0;
		public var parsedTime:Number = 0;

		public var columns:Array = new Array();
		public var rows:Array = new Array();
		
		public function DataQueryResult():void
		{
			
		}

		// TODO: cleanup this nastiness???
		public function AdjustRowFieldTypes():void
		{
			for (var rowKey:String in rows) {
				for (var rowFieldKey:String in rows[rowKey]) {
					for (var columnKey:String in columns) {
						if (!columns[columnKey]["datatype"] || columns[columnKey]["label"] != rowFieldKey)
							continue;
						// The "type" paramter can be: string, numeric, datetime, boolean, or url
						if (columns[columnKey]["datatype"] == "numeric") {
							rows[rowKey][rowFieldKey] = parseFloat(rows[rowKey][rowFieldKey]);
						} else if (columns[columnKey]["datatype"] == "datetime" && rows[rowKey][rowFieldKey] is String) {
							rows[rowKey][rowFieldKey] = Date.parse(rows[rowKey][rowFieldKey]) * 0.001;
						} else if (columns[columnKey]["datatype"] == "boolean") {
							if (rows[rowKey][rowFieldKey] == "true")
								rows[rowKey][rowFieldKey] = true;
							else
								rows[rowKey][rowFieldKey] = false;
						}
					} 
				}
			} 
		}
	}
}