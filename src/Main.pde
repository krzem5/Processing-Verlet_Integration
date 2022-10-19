final float DRAG=0.95;
final float GRAVITY=0.981;
final float LENGTH=50;
final float RADIUS=5;
final float SCALE=1e-2f;
final int CLOTH_X_POINTS=12;
final int CLOTH_Y_POINTS=10;
final int COLLISION_GRID_SIZE=30;
final int POINTS_PER_EDGE_VERTEX=2;
final float MAX_CONNECTION_DISTANCE=2.5;
final float GROUND_Y_OFFSET=50;

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
final int FLAG_STRONG_BONDS=8;
final int FLAG_ENABLE_FORCES=16;
final int FLAG_DRAW_GRID=32;



float _last_time;
Engine engine;



void setup(){
	size(1920,1080);
	fullScreen();
	_last_time=millis();
	engine=new Engine();
	for (int i=0;i<CLOTH_X_POINTS;i++){
		for (int j=0;j<CLOTH_Y_POINTS;j++){
			Point p=new Point((i*LENGTH+width/4)*SCALE,(j*LENGTH+height/6)*SCALE,false,false);
			if (i!=0){
				engine.connections.add(new Connection(p,engine.points.get(engine.points.size()-CLOTH_Y_POINTS),LENGTH*SCALE,false));
			}
			if (j!=0){
				engine.connections.add(new Connection(p,engine.points.get(engine.points.size()-1),LENGTH*SCALE,false));
			}
			engine.points.add(p);
		}
	}
	for (int i=0;i<CLOTH_X_POINTS;i++){
		for (int j=0;j<POINTS_PER_EDGE_VERTEX;j++){
			Point p=new Point((i*LENGTH+width/4)*SCALE,(CLOTH_Y_POINTS*LENGTH+height/6)*SCALE,false,true);
			engine.connections.add(new Connection(p,engine.points.get(i*CLOTH_Y_POINTS+CLOTH_Y_POINTS-1),LENGTH*0.5*SCALE,true));
			engine.points.add(p);
			p=new Point((i*LENGTH+width/4)*SCALE,height/6*SCALE,false,true);
			engine.connections.add(new Connection(p,engine.points.get(i*CLOTH_Y_POINTS),LENGTH*0.5*SCALE,true));
			engine.points.add(p);
		}
	}
	for (int i=1;i<CLOTH_Y_POINTS-1;i++){
		for (int j=0;j<POINTS_PER_EDGE_VERTEX;j++){
			Point p=new Point(width/4*SCALE,((i+1)*LENGTH+height/6)*SCALE,false,true);
			engine.connections.add(new Connection(p,engine.points.get(i),LENGTH*0.5*SCALE,true));
			engine.points.add(p);
			p=new Point((width/4+LENGTH*(CLOTH_X_POINTS-1))*SCALE,((i+1)*LENGTH+height/6)*SCALE,false,true);
			engine.connections.add(new Connection(p,engine.points.get(i+CLOTH_Y_POINTS*(CLOTH_X_POINTS-1)),LENGTH*0.5*SCALE,true));
			engine.points.add(p);
		}
	}
	engine.points.get(0).fixed=true;
	engine.points.get((CLOTH_X_POINTS-1)*CLOTH_Y_POINTS).fixed=true;
}



void draw(){
	float time=millis();
	float delta_time=(time-_last_time)*0.001;
	_last_time=time;
	engine.update(delta_time);
	engine.draw();
}
