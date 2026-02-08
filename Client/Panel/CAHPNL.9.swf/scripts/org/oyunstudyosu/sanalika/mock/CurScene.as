package org.oyunstudyosu.sanalika.mock
{
   import com.oyunstudyosu.bot.IBotVO;
   import com.oyunstudyosu.engine.ICharacter;
   import com.oyunstudyosu.engine.IScene;
   import com.oyunstudyosu.engine.IntPoint;
   import com.oyunstudyosu.engine.core.Cell;
   import com.oyunstudyosu.engine.core.IsoElement;
   import com.oyunstudyosu.engine.core.MapEntry;
   import com.oyunstudyosu.engine.core.Vector3d;
   import com.oyunstudyosu.engine.grid.IGridManager;
   import com.oyunstudyosu.engine.scene.components.ISceneComponent;
   import com.oyunstudyosu.sanalika.interfaces.ISpeechable;
   import flash.display.MovieClip;
   import flash.display.Sprite;
   import flash.events.Event;
   import flash.events.EventDispatcher;
   import flash.geom.Point;
   import flash.xml.XMLNode;
   
   public class CurScene extends EventDispatcher implements IScene
   {
       
      
      private var _myChar:ICharacter;
      
      public function CurScene()
      {
         super(null);
      }
      
      public function getPermission() : int
      {
         return 5;
      }
      
      public function get activeGrid() : IntPoint
      {
         return null;
      }
      
      public function get botList() : Array
      {
         return null;
      }
      
      public function addBotSoon(param1:IBotVO) : ISpeechable
      {
         return null;
      }
      
      public function set botList(param1:Array) : void
      {
      }
      
      public function get ceilingContainer() : Sprite
      {
         return null;
      }
      
      public function set ceilingContainer(param1:Sprite) : void
      {
      }
      
      public function get speechContainer() : Sprite
      {
         return null;
      }
      
      public function set speechContainer(param1:Sprite) : void
      {
      }
      
      public function get characterList() : Array
      {
         return null;
      }
      
      public function set characterList(param1:Array) : void
      {
      }
      
      public function get speechBalloonsEnabled() : Boolean
      {
         return true;
      }
      
      public function set speechBalloonsEnabled(param1:Boolean) : void
      {
      }
      
      public function get container() : Sprite
      {
         return null;
      }
      
      public function set container(param1:Sprite) : void
      {
      }
      
      public function deleteChar(param1:String) : void
      {
      }
      
      public function disable() : void
      {
      }
      
      public function get doorList() : Vector.<MovieClip>
      {
         return null;
      }
      
      public function set doorList(param1:Vector.<MovieClip>) : void
      {
      }
      
      public function get elementsContainer() : Sprite
      {
         return null;
      }
      
      public function set elementsContainer(param1:Sprite) : void
      {
      }
      
      public function enable() : void
      {
      }
      
      public function getBotByName(param1:String) : ISpeechable
      {
         return null;
      }
      
      public function getCellTypeByGrid(param1:Number, param2:Number, param3:Number) : int
      {
         return 0;
      }
      
      public function getCharByName(param1:String) : ICharacter
      {
         return null;
      }
      
      public function getCharByNick(param1:String) : ICharacter
      {
         return null;
      }
      
      public function getPosFromGrid(param1:Number, param2:Number) : Point
      {
         return null;
      }
      
      public function hideCursors() : void
      {
      }
      
      public function indicateGrid(param1:int, param2:int, param3:Function) : void
      {
      }
      
      public function init() : void
      {
      }
      
      public function load() : void
      {
      }
      
      public function get myChar() : ICharacter
      {
         return new CharMock();
      }
      
      public function set myChar(param1:ICharacter) : void
      {
      }
      
      public function get paddingX() : Number
      {
         return 0;
      }
      
      public function get paddingY() : Number
      {
         return 0;
      }
      
      public function get point() : Point
      {
         return null;
      }
      
      public function set point(param1:Point) : void
      {
      }
      
      public function runDoorById(param1:String, param2:MovieClip) : void
      {
      }
      
      public function get scale() : Number
      {
         return 0;
      }
      
      public function set scale(param1:Number) : void
      {
      }
      
      public function screenShiftTo(param1:Number, param2:Number, param3:Number = 0.8) : void
      {
      }
      
      public function get speechBalloons() : Array
      {
         return null;
      }
      
      public function set speechBalloons(param1:Array) : void
      {
      }
      
      public function terminate() : void
      {
      }
      
      public function update(param1:Event) : void
      {
      }
      
      public function get xBase() : int
      {
         return 0;
      }
      
      public function set xBase(param1:int) : void
      {
      }
      
      public function get yBase() : int
      {
         return 0;
      }
      
      public function set yBase(param1:int) : void
      {
      }
      
      public function screenToTile(param1:Number, param2:Number, param3:Boolean = false) : Point
      {
         return null;
      }
      
      public function screenShifting() : void
      {
      }
      
      public function getCellAtIsUsing(param1:Number, param2:Number, param3:Number) : Boolean
      {
         return false;
      }
      
      public function clearBots() : void
      {
      }
      
      public function clearDoors() : void
      {
      }
      
      public function processBots() : void
      {
      }
      
      public function processDoors() : void
      {
      }
      
      public function getAvatarById(param1:String) : ICharacter
      {
         return new CharMock();
      }
      
      public function get bg() : MovieClip
      {
         return null;
      }
      
      public function set bg(param1:MovieClip) : void
      {
      }
      
      public function singleMode(param1:Boolean) : void
      {
      }
      
      public function showDoors() : void
      {
      }
      
      public function processBotsForEntry() : void
      {
      }
      
      public function setCellStatus(param1:int, param2:int, param3:Boolean) : void
      {
      }
      
      public function showGrid() : void
      {
      }
      
      public function getMovieClip(param1:String) : MovieClip
      {
         return null;
      }
      
      public function get mouseEnabled() : Boolean
      {
         return false;
      }
      
      public function set mouseEnabled(param1:Boolean) : void
      {
      }
      
      public function get mouseX() : Number
      {
         return 0;
      }
      
      public function get mouseY() : Number
      {
         return 0;
      }
      
      public function get sceneLoaded() : Boolean
      {
         return false;
      }
      
      public function get initialized() : Boolean
      {
         return false;
      }
      
      public function get map() : XMLNode
      {
         return undefined;
      }
      
      public function set map(param1:XMLNode) : void
      {
      }
      
      public function processMap(param1:XMLNode) : void
      {
      }
      
      public function processGrid() : void
      {
      }
      
      public function processBackground() : void
      {
      }
      
      public function get mapEntries() : Vector.<MapEntry>
      {
         return undefined;
      }
      
      public function set mapEntries(param1:Vector.<MapEntry>) : void
      {
      }
      
      public function get sceneElements() : Vector.<IsoElement>
      {
         return undefined;
      }
      
      public function get cursor() : MovieClip
      {
         return undefined;
      }
      
      public function get arrow() : MovieClip
      {
         return undefined;
      }
      
      public function addComponent(param1:Class, param2:Class = null) : ISceneComponent
      {
         return undefined;
      }
      
      public function existsComponent(param1:Class) : Boolean
      {
         return false;
      }
      
      public function getComponent(param1:Class) : ISceneComponent
      {
         return undefined;
      }
      
      public function get grid() : Vector.<Cell>
      {
         return undefined;
      }
      
      public function set grid(param1:Vector.<Cell>) : void
      {
      }
      
      public function get gridManager() : IGridManager
      {
         return undefined;
      }
      
      public function set gridManager(param1:IGridManager) : void
      {
      }
      
      public function get columnsCount() : int
      {
         return 0;
      }
      
      public function set columnsCount(param1:int) : void
      {
      }
      
      public function get rowsCount() : int
      {
         return 0;
      }
      
      public function set rowsCount(param1:int) : void
      {
      }
      
      public function translateToGrid(param1:Number, param2:Number) : IntPoint
      {
         return undefined;
      }
      
      public function get floorContainer() : Sprite
      {
         return undefined;
      }
      
      public function set floorContainer(param1:Sprite) : void
      {
      }
      
      public function get bgContainer() : Sprite
      {
         return undefined;
      }
      
      public function set bgContainer(param1:Sprite) : void
      {
      }
      
      public function get3DPosFromGrid(param1:int, param2:int) : Vector3d
      {
         return undefined;
      }
      
      public function get2dPoint(param1:Number, param2:Number, param3:Number) : Point
      {
         return undefined;
      }
      
      public function getPointAtDir(param1:int, param2:int, param3:int, param4:int) : IntPoint
      {
         return undefined;
      }
      
      public function getCellAtPoint(param1:IntPoint) : Cell
      {
         return undefined;
      }
      
      public function getScenePositionFromTile(param1:int, param2:int) : Vector3d
      {
         return undefined;
      }
      
      public function set activeGrid(param1:IntPoint) : void
      {
      }
      
      public function getCellAt(param1:Number, param2:Number, param3:Number) : Cell
      {
         return undefined;
      }
      
      public function translateToCell(param1:Vector3d) : Cell
      {
         return undefined;
      }
      
      public function dispose() : void
      {
      }
   }
}
