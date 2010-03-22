package Collage.DataEngine
{
	import flash.net.*;
	import flash.events.*;
	import flash.data.*;
	import flash.utils.ByteArray;
	import mx.controls.Alert;
	import com.adobe.serialization.json.JSON;
	import com.adobe.crypto.*;
	
	public class AIRSecureStorage
	{
		public function AIRSecureStorage():void
		{
			
		}
		
		/* TODO: Fix this, i know its bad. */
		public static function getItem(strKey:String):String {
			try {
				var bytes:ByteArray = EncryptedLocalStore.getItem(strKey);
				return bytes.readUTFBytes(bytes.length);
			} catch(e:Error) { }
			
			return null;
		}
		
		public static function setItem(strKey:String, val:String):void {
			var bytes:ByteArray = new ByteArray();
			bytes.writeUTFBytes(val);
			
			EncryptedLocalStore.setItem(strKey, bytes);
		}
		
		public static function removeItem(strKey:String):void {
			EncryptedLocalStore.removeItem(strKey);
		}
	}
}