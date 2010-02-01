package Collage.Clip
{
	import mx.containers.Canvas;
	import mx.events.*;
	import mx.controls.Alert;

	public class ClipEditor extends Canvas
	{
		protected var _Model:Clip;
		
		public function get model():Clip {return _Model;}
		public function set model(clip:Clip):void {_Model = clip;}
		
		public function ClipEditor()
		{
			
		}
	}
}