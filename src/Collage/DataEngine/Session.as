package Collage.DataEngine
{
	import flash.net.*;
	import flash.events.*;
	import flash.data.*;
	import flash.utils.ByteArray;
	import mx.controls.Alert;
	import com.adobe.serialization.json.JSON;
	import com.adobe.crypto.*;
	
	public class Session extends EventDispatcher
	{
		public static var TOKEN_EXPIRED:String = "TokenExpired";
		public static var TOKEN_VALID:String = "TokenValid";
		
		public static var LOGIN_SUCCESS:String = "LoginSuccessful";
		public static var LOGIN_FAILURE:String = "LoginFailure";
		
		public static var COMPLETE:String = "complete";
		
		private static var authToken:String = null;
		public static function get AuthToken():String {
			return authToken;
		}
		
		
		public static var events:EventDispatcher = new EventDispatcher();
		
		[Bindable]public static var loaded:Boolean = false;
		[Bindable]public static var loading:Boolean = false;
		
		public function Session():void
		{
			
		}
		
		public static function CheckToken():void {
			var token:ByteArray = EncryptedLocalStore.getItem('apiAuthToken');
			if(token == null) {
				events.dispatchEvent(new Event(TOKEN_EXPIRED));
				return;
			}
			// convert to a string
			authToken = token.readUTFBytes(token.length);
			
			var request:URLRequest = new URLRequest(DataEngine.getUrl("/api/v1/auth/check-token"));
			var loader:URLLoader = new URLLoader();
			
			var params:URLVariables = new URLVariables();
			params.auth_token = authToken;
			
			request.data = params;
            request.requestHeaders.push(new URLRequestHeader("X-Requested-With", "XMLHttpRequest"));
			request.method = URLRequestMethod.POST;
			loader.addEventListener(Event.COMPLETE, CheckToken_CompleteHandler);
			loader.addEventListener(SecurityErrorEvent.SECURITY_ERROR, CheckToken_ErrorHandler);
			loader.addEventListener(IOErrorEvent.IO_ERROR, CheckToken_ErrorHandler);
			
			loader.load(request);
		}
		
		private static function CheckToken_CompleteHandler(event:Event):void
		{
			event.target.removeEventListener(Event.COMPLETE, CheckToken_CompleteHandler);
			var results:Object = JSON.decode(event.target.data);
			
			if(results.hasOwnProperty('valid')) {
				events.dispatchEvent(new Event(TOKEN_VALID));
			} else {
				EncryptedLocalStore.removeItem('apiAuthToken');
				events.dispatchEvent(new Event(TOKEN_EXPIRED));
			}
		}
		
		private static function CheckToken_ErrorHandler(event:Event):void {
			event.target.removeEventListener(IOErrorEvent.IO_ERROR, CheckToken_ErrorHandler);
			event.target.removeEventListener(SecurityErrorEvent.SECURITY_ERROR, CheckToken_ErrorHandler);
			
			events.dispatchEvent(new Event(TOKEN_EXPIRED));
		}
		
		public static function Login(email_address:String, password:String):void {
			var request:URLRequest = new URLRequest(DataEngine.getUrl("/api/v1/auth/login"));
			var loader:URLLoader = new URLLoader();
			
			
			var params:URLVariables = new URLVariables();
			params.email_address = email_address;
			params.password = MD5.hash(password);
			
			request.data = params;
            request.requestHeaders.push(new URLRequestHeader("X-Requested-With", "XMLHttpRequest"));
			request.method = URLRequestMethod.POST;
			loader.addEventListener(Event.COMPLETE, Login_CompleteHandler);
			loader.addEventListener(SecurityErrorEvent.SECURITY_ERROR, Login_ErrorHandler);
			loader.addEventListener(IOErrorEvent.IO_ERROR, Login_ErrorHandler);
			
			loader.load(request);
		}
		
		private static function Login_CompleteHandler(event:Event):void
		{
			event.target.removeEventListener(Event.COMPLETE, Login_CompleteHandler);
			var results:Object = JSON.decode(event.target.data);
			
			if(results.hasOwnProperty('auth_token')) {
				authToken = results['auth_token'];
			}
			
			if(authToken != null) {
				var bytes:ByteArray = new ByteArray();
				bytes.writeUTFBytes(authToken);
				EncryptedLocalStore.setItem('apiAuthToken', bytes);
				events.dispatchEvent(new Event(LOGIN_SUCCESS));
			}
		}
		
		private static function Login_ErrorHandler(event:IOErrorEvent):void
		{
			event.target.removeEventListener(IOErrorEvent.IO_ERROR, Login_ErrorHandler);
			event.target.removeEventListener(SecurityErrorEvent.SECURITY_ERROR, Login_ErrorHandler);
			
			Alert.show("LoginError: " + event);
			
			events.dispatchEvent(new Event(LOGIN_FAILURE));
		}
		
		public static function Logout():void {
			EncryptedLocalStore.removeItem('apiAuthToken');
			events.dispatchEvent(new Event(TOKEN_EXPIRED));
		}
	}
}