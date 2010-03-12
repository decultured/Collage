package Collage.Logger
{
	import mx.collections.ArrayCollection;
	import flash.utils.*;
	import flash.events.*;
	import mx.controls.Alert;
	
	public class Logger
	{
		public static var NEW_LOG_EVENT:String = "new log event";
		public static var events:EventDispatcher = new EventDispatcher();
		
		[Bindable]public static var logEntries:ArrayCollection = new ArrayCollection(); 
		public static var userID:String = "";
		public static var alerts:Boolean = false;
		public static var alertLevel:Number = LogEntry.ERROR;
		
		public static function Log(text:String, level:int = 0, owner:Object = null):LogEntry
		{
			var newLog:LogEntry = new LogEntry(text, level, getQualifiedClassName(owner), userID);
			logEntries.addItemAt(newLog, 0);

			if (alerts && level >= alertLevel)
				Alert.show(newLog.AlertString());

			events.dispatchEvent(new Event(NEW_LOG_EVENT));
			return newLog;
		}
		
		public static function LastLog():LogEntry
		{
			if (logEntries.length)
				return logEntries[0];
			else
				return null;
		}
	}
}