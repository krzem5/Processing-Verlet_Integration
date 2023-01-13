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
final int FLAG_DRAW_STRESS=64;
final int FLAG_ENABLE_STRESS_BREAKS=128;

final int CONNECTION_TYPE_ROPE=0;
final int CONNECTION_TYPE_WOOD=1;
final int CONNECTION_TYPE_ROAD=2;
final int CONNECTION_TYPE_PISTON=3;
final int CONNECTION_TYPE_STEEL=4;
final int CONNECTION_TYPE_BUNGEE_ROPE=5;
final int CONNECTION_TYPE_SPRING=6;
final int CONNECTION_MAX_TYPE=CONNECTION_TYPE_SPRING;

final float CONNECTION_CREATE_LINE_DASH=25;
final String CONNECTION_TYPE_NAMES[]={"Rope <#a79970>","Wood <#954b4b>","Road <#525448>","Piston <#62a0ea>","Steel <#c0bfbc>","Bungee Rope <#c061cb>","Spring <#f5c211>"};
final color CONNECTION_TYPE_COLORS[]={#a79970,#954b4b,#525448,#62a0ea,#c0bfbc,#c061cb,#f5c211};
final float CONNECTION_TYPE_WIDTH[]={2,3.5,6.5,5,6.5,2,4.2};
final float CONNECTION_BREAK_TENSION_FACTOR[]={1.2,1.6,2.4,3.2,3.2,6,4};
final float CONNECTION_BREAK_COMPRESSION_FACTOR[]={-1,0.6,0.8,0.95,0.5,-1,0.2};

final String DEFUALT_OPEN_FILE_PATH="v9";



float _last_time;
Engine engine;



void setup(){
	size(1920,1080);
	fullScreen();
	_last_time=millis();
	engine=new Engine();
	engine.load(DEFUALT_OPEN_FILE_PATH);
}



void draw(){
	float time=millis();
	float delta_time=(time-_last_time)*0.001;
	_last_time=time;
	engine.update(delta_time);
	engine.draw();
}
