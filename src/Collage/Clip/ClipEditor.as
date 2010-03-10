package Collage.Clip
{
	import mx.containers.Box;
	import mx.events.*;
	import mx.controls.Alert;

	public class ClipEditor extends Box
	{
		protected var _Model:Object;
		
		[Bindable]
		public function get model():Object {return _Model;}
		public function set model(clip:Object):void {_Model = clip;}
		
		public function ClipEditor()
		{
		}
	}
}