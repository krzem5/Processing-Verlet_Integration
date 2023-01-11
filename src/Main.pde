final float DRAG=0.95;
final float GRAVITY=0.981;
final float LENGTH=50;
final float RADIUS=5;
final float SCALE=1e-2f;
final int COLLISION_GRID_SIZE=30;
final int POINTS_PER_EDGE_VERTEX=2;
final float MAX_CONNECTION_DISTANCE=5;

final float GROUND_Y_OFFSET=50;
final String GRID_SIZE_NAMES[]={"Tiny","Small","Medium","Large","Huge"};
final float MAX_SNAP_DISTANCE=16;

final float RESIZE_ANIMATION_TIME=0.8;

final int UI_FONT_SIZE=22;
final int UI_BORDER_SIZE=40;
final int UI_ALIGN_LEFT=0;
final int UI_ALIGN_CENTER=1;
final int UI_ALIGN_RIGHT=2;

final int MAX_FILE_NAME_CHARACTERS=16;
final String SAVE_FOLDER="saves/";

final int FLAG_ENABLE_WIND=1;
final int FLAG_BREAK_CONNECTIONS=2;
final int FLAG_CREATE_CONNECTIONS=4;
final int FLAG_ENABLE_FORCES=8;
final int FLAG_DRAW_GRID=16;
final int FLAG_DRAW_GUIDES=32;

final int CONNECTION_TYPE_STRING=0;
final int CONNECTION_TYPE_WOOD=1;
final int CONNECTION_TYPE_ROAD=2;
final int CONNECTION_MAX_TYPE=CONNECTION_TYPE_ROAD;
final String CONNECTION_TYPE_NAMES[]={"String <#beac6e>━━━","Wood <#954b4b>━━━","Road <#68605c>━━━"};
final color CONNECTION_TYPE_COLORS[]={0x90beac6e,0xa0954b4b,0xff68605c};

final float CONNECTION_CREATE_LINE_DASH=25;
final float CONNECTION_BREAK_DISTANCE_BUFFER=50;



float _last_time;
Engine engine;



void setup(){
	size(1920,1080);
	fullScreen();
	_last_time=millis();
	engine=new Engine();
}



void draw(){
	float time=millis();
	float delta_time=(time-_last_time)*0.001;
	_last_time=time;
	engine.update(delta_time);
	engine.draw();
}
