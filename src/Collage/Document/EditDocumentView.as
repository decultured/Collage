package Collage.Document
{
	import flash.geom.*;
	import flash.display.*;
	import Collage.Clip.*;
	import mx.controls.Alert;
	import mx.events.PropertyChangeEvent;
	import flash.events.*;
	import mx.core.UIComponent;
	import com.roguedevelopment.objecthandles.*;
	import com.roguedevelopment.objecthandles.constraints.*;

	public class EditDocumentView extends DocumentView
	{
		protected var _InspectorPane:UIComponent;
		protected var _OptionsBox:UIComponent;
		protected var _SelectionManager:ObjectHandlesSelectionManager;
		protected var _ObjectHandles:ObjectHandles;
		protected var _CurrentlySelected:Clip;
		public function set inspector(inspectorPane:UIComponent):void {_InspectorPane = inspectorPane;}
		public function get inspector():UIComponent {return _InspectorPane;}
		public function set optionsBox(optionsBox:UIComponent):void {_OptionsBox = optionsBox;}
		public function get optionsBox():UIComponent {return _OptionsBox;}

		private var _Grid:Shape = new Shape(); 
		
		public function EditDocumentView()
		{
			super();
			var newModel:Document = new Document();
			newModel.CreateEditView(this);
			model = newModel;
			_Grid.visible = false;
			this.rawChildren.addChild(_Grid);
			DrawGrid();
			
			_BackgroundImage.addEventListener(MouseEvent.CLICK, BackgroundClick);
		}

		public function InitializeForEdit(newInspector:UIComponent, newOptionsBox:UIComponent):void
		{
			_InspectorPane = newInspector;
			_OptionsBox = newOptionsBox;
			InitObjectHandles();
			SelectDocument();
			ViewResized();
		}

		public function InitObjectHandles():void
		{
			_SelectionManager = new ObjectHandlesSelectionManager();
			_ObjectHandles = new ObjectHandles(this, _SelectionManager);
			var sizeConstraint:SizeConstraint = new SizeConstraint();
			sizeConstraint.minWidth = 20;
			sizeConstraint.minHeight = 20;
			sizeConstraint.maxWidth = this.width;
			sizeConstraint.maxHeight = this.height;
			_ObjectHandles.constraints.push(sizeConstraint);							

			_SelectionManager.addEventListener(SelectionEvent.ADDED_TO_SELECTION, ObjectSelected);
			_SelectionManager.addEventListener(SelectionEvent.REMOVED_FROM_SELECTION, ObjectDeselected);
			_SelectionManager.addEventListener(SelectionEvent.SELECTION_CLEARED, ObjectDeselected);

			_ObjectHandles.addEventListener(ObjectChangedEvent.OBJECT_MOVED, ObjectChanged);
			_ObjectHandles.addEventListener(ObjectChangedEvent.OBJECT_MOVING, ObjectChanged);
			_ObjectHandles.addEventListener(ObjectChangedEvent.OBJECT_RESIZED, ObjectChanged);
			_ObjectHandles.addEventListener(ObjectChangedEvent.OBJECT_RESIZING, ObjectChanged);
			_ObjectHandles.addEventListener(ObjectChangedEvent.OBJECT_ROTATED, ObjectChanged);
		}		

		public override function ViewResized():void
		{
			super.ViewResized();
			if (_ObjectHandles) {
				
				_ObjectHandles.constraints = new Array();
				
				var sizeConstraint:SizeConstraint = new SizeConstraint();
				sizeConstraint.minWidth = 20;
				sizeConstraint.minHeight = 20;
				sizeConstraint.maxWidth = this.width;
				sizeConstraint.maxHeight = this.height;
				
				var moveConstraint:MovementConstraint = new MovementConstraint();
				moveConstraint.minX = 0;
				moveConstraint.minY = 0;
				moveConstraint.maxX = this.width;
				moveConstraint.maxY = this.height;
				
				_ObjectHandles.constraints.push(sizeConstraint);							
				_ObjectHandles.constraints.push(moveConstraint);							
			}
		}
		
		public override function AddClip(newClip:Clip):Boolean
		{
			if (!super.AddClip(newClip))
				return false;
			_ObjectHandles.registerComponent(newClip, newClip.view);
			DrawGrid();
			return true;
		}

		public override function AddClipByType(clipType:String, position:Rectangle = null):Clip
		{
			var newClip:Clip = super.AddClipByType(clipType);
			if (newClip)
				_ObjectHandles.registerComponent(newClip, newClip.view);
			DrawGrid();
			return newClip;
		}

		public override function AddClipFromData(data:Object, position:Rectangle = null):Clip
		{
			var newClip:Clip = super.AddClipFromData(data);
			if (newClip)
				_ObjectHandles.registerComponent(newClip, newClip.view);
			DrawGrid();
			return newClip;
		}

		protected function ObjectSelected(event:SelectionEvent):void {
			for each (var clip:Clip in event.targets) {
				clip.selected = true;
				_CurrentlySelected = clip;
				model.selected = false;
				PositionOptionsBox();
				if (_CurrentlySelected) {
					ShowClipEditor();
				}
			}
		}

		protected function ObjectDeselected(event:SelectionEvent):void {
			for each (var clip:Clip in event.targets) {
				_CurrentlySelected = null;
				PositionOptionsBox();
				clip.selected = false;
				HideClipEditor();
			}
		}


		private function ObjectChanged(event:ObjectChangedEvent):void{
			for each (var clip:Clip in event.relatedObjects) {
				if (event.type == ObjectChangedEvent.OBJECT_MOVED) {
					var docModel:Document = _Model as Document;
					if (docModel.snap && docModel.gridSize)
					{
						var num:Number = (clip.x % docModel.gridSize) - (docModel.gridSize * 0.5);
						if (num)
							clip.x = clip.x - (clip.x % docModel.gridSize);
						else
							clip.x = clip.x - (clip.x % docModel.gridSize) + docModel.gridSize;
						
						num = (clip.y % docModel.gridSize) - (docModel.gridSize * 0.5);
						if (num)
							clip.y = clip.y - (clip.y % docModel.gridSize);
						else
							clip.y = clip.y - (clip.y % docModel.gridSize) + docModel.gridSize;
					}
					
					clip.Moved();
				}
				else if (event.type == ObjectChangedEvent.OBJECT_RESIZED) {clip.Resized();}
				else if (event.type == ObjectChangedEvent.OBJECT_ROTATED) {clip.Rotated();}
				PositionOptionsBox();
			}
		}
		
		public function DrawGrid():void
		{
			var docModel:Document = _Model as Document;
			if (!docModel.grid || !docModel.gridSize) {
				_Grid.visible = false;
				return;
			}
			
			_Grid.visible = true;
			_Grid.graphics.clear();
			_Grid.graphics.lineStyle(1, docModel.gridColor);
			
			for (var xPos:Number = docModel.gridSize; xPos < docModel.width; xPos += docModel.gridSize) {
		    	_Grid.graphics.moveTo(xPos, 0); 
		    	_Grid.graphics.lineTo(xPos, docModel.width); 
			}

			for (var yPos:Number = docModel.gridSize; yPos < docModel.height; yPos += docModel.gridSize) {
		    	_Grid.graphics.moveTo(0, yPos); 
		    	_Grid.graphics.lineTo(docModel.height, yPos); 
			}
		} 
		
		protected override function onModelChange( event:PropertyChangeEvent):void
		{
			DrawGrid();
			super.onModelChange(event);
		}

		protected function PositionOptionsBox():void
		{
			if (!_OptionsBox) return;
			if (!_CurrentlySelected) {
				_OptionsBox.visible = false;
				return;
			}
			_OptionsBox.visible = true;
			
			if (getChildIndex(_OptionsBox) < numChildren - 1)
				setChildIndex(_OptionsBox, numChildren - 1);
						
			if (_CurrentlySelected.y < 30) {
				_OptionsBox.y = _CurrentlySelected.y + _CurrentlySelected.height;
				_OptionsBox.x = _CurrentlySelected.x + _CurrentlySelected.width - optionsBox.width;
			} else {
				_OptionsBox.y = _CurrentlySelected.y - optionsBox.height;
				_OptionsBox.x = _CurrentlySelected.x + _CurrentlySelected.width - optionsBox.width;
			}
		}
		
		public function deleteSelected():void
		{
			if (_CurrentlySelected && _CurrentlySelected.view) {
				var view:ClipView = _CurrentlySelected.view;
				_ObjectHandles.unregisterComponent(view);
				removeChild(view);
			}
			
			// TODO : Remove from internal list
		}
		
		public function lockSelected():void
		{
			if (_CurrentlySelected && _CurrentlySelected.view) {
				var view:ClipView = _CurrentlySelected.view;
				_ObjectHandles.unregisterComponent(view);
			}
		}
		
		public function BackgroundClick(event:MouseEvent):void
		{		
			if(event) {
			 	if (!(event.target is ClipView) || event.target is DocumentView) {
					ClearSelection();
				}
			} else {
				ClearSelection();
			}
		}
		
		public function ClearSelection():void {
			_ObjectHandles.selectionManager.clearSelection();
			SelectDocument();
		}
		
		public function SelectDocument():void
		{
			if (!_InspectorPane || !model.editor)
				return;
			model.selected = true;
			HideClipEditor();
			_InspectorPane.addChild(model.editor);
		}
		
		public function ShowClipEditor():void
		{
			if (!_CurrentlySelected.editor || !_InspectorPane)
				return;
			HideClipEditor();
			_InspectorPane.addChild(_CurrentlySelected.editor);
		}
		
		public function HideClipEditor():void
		{
			if (!_InspectorPane)
				return;
			for (var i:uint = 0; i < _InspectorPane.numChildren; i++)
				_InspectorPane.removeChildAt(0);
		}
	}
}