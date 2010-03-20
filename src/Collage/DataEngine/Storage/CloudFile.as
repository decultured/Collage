package Collage.DataEngine.Storage
{
	import flash.net.*;
	import flash.events.*;
	import flash.data.*;
	import flash.utils.*;
	import com.dynamicflash.util.Base64;
	import com.adobe.serialization.json.JSON;
	import Collage.DataEngine.*;
	import Collage.Logger.*;

	public class CloudFile extends EventDispatcher
	{
		protected var _Content:String;
		protected var _ByteData:ByteArray;



		public function get Filedata():ByteArray {
			return this._ByteData;
		}

		public function set Filedata(datar:ByteArray):void {
			this._ByteData = datar;
		}

		/* Events */
		public static const OPEN_SUCCESS:String = "CloudFileOpenSuccessful";
		public static const OPEN_FAILURE:String = "CloudFileOpenFailure";
		public static const SAVE_SUCCESS:String = "CloudFileSaveSuccessful";
		public static const SAVE_FAILURE:String = "CloudFileSaveFailure";

		/* Operations */
		public static const OPERATION_OPEN:String = "OperationOpenFile";
		public static const OPERATION_SAVE:String = "OperationSaveFile";

		protected var lastResult:Object;

		public function CloudFile():void {

		}

		protected function GetOpenUrl():String {
			throw new Error("Need to override CloudFile::GetOpenUrl() in your class.");
		}

		protected function GetSaveUrl():String {
			throw new Error("Need to override CloudFile::GetSaveUrl() in your class.");
		}

		protected function GenerateEnvelope():Object {
			throw new Error("Need to override CloudFile::GenerateEnvelope() in your class.");
		}

		protected function OpenFile():void {
			try {
				var loader:URLLoader = new URLLoader();

				loader.addEventListener(Event.COMPLETE, Open_CompleteHandler);
				loader.addEventListener(SecurityErrorEvent.SECURITY_ERROR, Open_ErrorHandler);
				loader.addEventListener(IOErrorEvent.IO_ERROR, Open_ErrorHandler);

				loader.load( CreateRequest( URLRequestMethod.GET, OPERATION_OPEN ) );
			} catch(error:Error) {
				Logger.Log("CloudFile Open: " + error, LogEntry.DEBUG);
			}
		}

		protected function SaveFile():void {
			try {
				var loader:URLLoader = new URLLoader();

				loader.addEventListener(Event.COMPLETE, Save_CompleteHandler);
				loader.addEventListener(SecurityErrorEvent.SECURITY_ERROR, Save_ErrorHandler);
				loader.addEventListener(IOErrorEvent.IO_ERROR, Save_ErrorHandler);

				loader.load( CreateRequest( URLRequestMethod.POST, OPERATION_SAVE ) );
			} catch(error:Error) {
				Logger.Log("CloudFile Save: " + error, LogEntry.DEBUG);
			}
		}

		protected function CreateRequest(method:String, operation:String):URLRequest {
			var requestUrl:String = null;

			if(operation == OPERATION_OPEN) {
				requestUrl = GetOpenUrl();
			} else if(operation == OPERATION_SAVE) {
				requestUrl = GetSaveUrl();
			} else {
				throw new Error("Cannot continue, unsupported operation!");
			}

			var request:URLRequest = new URLRequest( requestUrl );

			var params:URLVariables = new URLVariables();
			params.auth_token = Session.AuthToken;
			params.content = this._Content;

			if(this._ByteData != null) {
				params.filedata = Base64.encodeByteArray( this._ByteData );
			}

			/* Copy the envelope in */
			var envelope:Object = GenerateEnvelope();
			for(var k:String in envelope) {
				params[k] = envelope[k];
			}

			request.data = params;
            request.requestHeaders.push(new URLRequestHeader("X-Requested-With", "XMLHttpRequest"));
			request.method = method;

			return request;
		}

		private function Open_CompleteHandler(event:Event):void
		{
			event.target.removeEventListener(Event.COMPLETE, Open_CompleteHandler);
			var results:Object = JSON.decode(event.target.data);
			lastResult = results;

			if(results.hasOwnProperty("content")) {
				_Content = results["content"];

				this.dispatchEvent(new Event(OPEN_SUCCESS));
			} else {
				this.dispatchEvent(new Event(OPEN_FAILURE));
			}
		}

		private function Open_ErrorHandler(event:Event):void {
			event.target.removeEventListener(IOErrorEvent.IO_ERROR, Open_ErrorHandler);
			event.target.removeEventListener(SecurityErrorEvent.SECURITY_ERROR, Open_ErrorHandler);

			this.dispatchEvent(new Event(OPEN_FAILURE));
		}

		private function Save_CompleteHandler(event:Event):void
		{
			event.target.removeEventListener(Event.COMPLETE, Save_CompleteHandler);
			var results:Object = JSON.decode(event.target.data);
			lastResult = results;
			if(results.hasOwnProperty('success') && results['success'] == true) {
				this.dispatchEvent(new Event(SAVE_SUCCESS));
			} else {
				this.dispatchEvent(new Event(SAVE_FAILURE));
			}
		}

		private function Save_ErrorHandler(event:Event):void {
			event.target.removeEventListener(IOErrorEvent.IO_ERROR, Save_ErrorHandler);
			event.target.removeEventListener(SecurityErrorEvent.SECURITY_ERROR, Save_ErrorHandler);

			this.dispatchEvent(new Event(SAVE_FAILURE));
		}
	}
}