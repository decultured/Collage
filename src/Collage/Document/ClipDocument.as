package Collage.Document
{
	import mx.controls.Alert;
	import flash.utils.*;
	import flash.geom.*;
	import Collage.Clip.*;
	import mx.core.UIComponent;

	public class ClipDocument
	{
		protected var _Clips:Array;
		protected var _ViewPane:UIComponent;
		
		public function set viewPane(viewPane:UIComponent):void {_ViewPane = viewPane;}
		public function get viewPane():UIComponent {return _ViewPane;}
		
		public function ClipDocument(newViewPane:UIComponent)
		{
			_ViewPane = newViewPane;
			ClipFactory.RegisterClipDefinitions();
			_Clips = new Array();
		}
		
		public function ViewResized():void
		{
			// TODO : Reposition all objects to fit in new size
		}
		
		public function AddClip(newClip:Clip):Boolean
		{
			if (_ViewPane && newClip && !_Clips[newClip.uid]) {
				_Clips[newClip.uid] = newClip;
				_ViewPane.addChild(newClip.view);
				Alert.show("Clip Type: " + flash.utils.getQualifiedClassName(newClip.view));
				return true;
			}
			return false;
		}

		public function AddClipByType(clipType:String, position:Rectangle = null):Clip
		{
			var newClip:Clip = ClipFactory.CreateByType(clipType);
			AddClip(newClip);
			
			if (position) {
				newClip.x = position.x;
				newClip.y = position.y;
				newClip.width = position.width;
				newClip.height = position.height;
			}
			
			return newClip;
		}
	}
}