final float DRAG=0.95;
final float GRAVITY=0.981;
final float LENGTH=50;
final float RADIUS=5;
final float SCALE=1e-2f;
final int CLOTH_X_POINTS=12;
final int CLOTH_Y_POINTS=10;
final int COLLISION_GRID_SIZE=30;
final int POINTS_PER_EDGE_VERTEX=2;



ArrayList<Constraint> constraint_list;
ArrayList<Point> point_list;
CollisionGrid collision_grid;
Point dragged_point=null;
float _last_time;
boolean dragged_point_was_fixed;



void setup(){
	size(1920,1080);
	_last_time=millis();
	constraint_list=new ArrayList<Constraint>();
	point_list=new ArrayList<Point>();
	collision_grid=new CollisionGrid(width,height,COLLISION_GRID_SIZE,COLLISION_GRID_SIZE);
	for (int i=0;i<CLOTH_X_POINTS;i++){
		for (int j=0;j<CLOTH_Y_POINTS;j++){
			Point p=new Point(0,0,false,false);
			if (i!=0){
				constraint_list.add(new Constraint(p,point_list.get(point_list.size()-CLOTH_Y_POINTS),LENGTH*SCALE,false,1.0));
			}
			if (j!=0){
				constraint_list.add(new Constraint(p,point_list.get(point_list.size()-1),LENGTH*SCALE,false,1.0));
			}
			point_list.add(p);
		}
	}
	for (int i=0;i<CLOTH_X_POINTS;i++){
		for (int j=0;j<POINTS_PER_EDGE_VERTEX;j++){
			Point p=new Point(0,0,false,true);
			constraint_list.add(new Constraint(p,point_list.get(i*CLOTH_Y_POINTS+CLOTH_Y_POINTS-1),LENGTH*0.5*SCALE,true,1.0));
			point_list.add(p);
			p=new Point(0,0,false,true);
			constraint_list.add(new Constraint(p,point_list.get(i*CLOTH_Y_POINTS),LENGTH*0.5*SCALE,true,1.0));
			point_list.add(p);
		}
	}
	for (int i=1;i<CLOTH_Y_POINTS-1;i++){
		for (int j=0;j<POINTS_PER_EDGE_VERTEX;j++){
			Point p=new Point(0,0,false,true);
			constraint_list.add(new Constraint(p,point_list.get(i),LENGTH*0.5*SCALE,true,1.0));
			point_list.add(p);
			p=new Point(0,0,false,true);
			constraint_list.add(new Constraint(p,point_list.get(i+CLOTH_Y_POINTS*(CLOTH_X_POINTS-1)),LENGTH*0.5*SCALE,true,1.0));
			point_list.add(p);
		}
	}
	Point a=point_list.get(0);
	a.x=width/4*SCALE;
	a.y=height/6*SCALE;
	a.fixed=true;
	Point b=point_list.get((CLOTH_X_POINTS-1)*CLOTH_Y_POINTS);
	b.x=(width/4+LENGTH*(CLOTH_X_POINTS-1))*SCALE;
	b.y=height/6*SCALE;
	b.fixed=true;
}



void draw(){
	float time=millis();
	float delta_time=(time-_last_time)*0.001;
	_last_time=time;
	background(0);
	if (mousePressed){
		if (dragged_point==null){
			float d=0.0;
			for (int i=0;i<point_list.size();i++){
				Point p=point_list.get(i);
				float pd=(p.x-mouseX*SCALE)*(p.x-mouseX*SCALE)+(p.y-mouseY*SCALE)*(p.y-mouseY*SCALE);
				if (i==0||pd<d){
					d=pd;
					dragged_point=p;
				}
			}
		}
		dragged_point.x=mouseX*SCALE;
		dragged_point.y=mouseY*SCALE;
		dragged_point._prev_x=dragged_point.x;
		dragged_point._prev_y=dragged_point.y;
		dragged_point_was_fixed=dragged_point.fixed;
		dragged_point.fixed=true;
	}
	else{
		if (dragged_point!=null){
			dragged_point.fixed=dragged_point_was_fixed;
		}
		dragged_point=null;
	}
	float wind=((0.5+sin(time/5000))*(0.7+sin(time/370))*(0.5+cos(time/4100)))*0.6*SCALE;
	for (Point p:point_list){
		p.update(delta_time);
		if (!p.fixed){
			p.x+=wind;
		}
	}
	for (int idx=0;idx<400;idx++){
		for (Constraint c:constraint_list){
			c.update();
		}
		for (Point p:point_list){
			p.constrain();
			if (p.has_collision){
				collision_grid.add(p);
			}
		}
		collision_grid.update();
	}
	noStroke();
	fill(255,0,0,200);
	beginShape(QUADS);
	for (int i=1;i<CLOTH_X_POINTS;i++){
		for (int j=1;j<CLOTH_Y_POINTS;j++){
			Point p=point_list.get((i-1)*CLOTH_Y_POINTS+j-1);
			vertex(p.x/SCALE,p.y/SCALE);
			p=point_list.get(i*CLOTH_Y_POINTS+j-1);
			vertex(p.x/SCALE,p.y/SCALE);
			p=point_list.get(i*CLOTH_Y_POINTS+j);
			vertex(p.x/SCALE,p.y/SCALE);
			p=point_list.get((i-1)*CLOTH_Y_POINTS+j);
			vertex(p.x/SCALE,p.y/SCALE);
		}
	}
	endShape();
	for (int i=2*CLOTH_X_POINTS*CLOTH_Y_POINTS-CLOTH_Y_POINTS-CLOTH_X_POINTS;i<constraint_list.size();i++){
		constraint_list.get(i).draw();
	}
	for (int i=CLOTH_X_POINTS*CLOTH_Y_POINTS;i<point_list.size();i++){
		point_list.get(i).draw();
	}
	if (dragged_point!=null){
		fill(#ef1c98);
		circle(dragged_point.x/SCALE,dragged_point.y/SCALE,RADIUS*3);
	}
	// collision_grid.draw();
}
