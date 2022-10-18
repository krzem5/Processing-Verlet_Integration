final float DRAG=0.95;
final float GRAVITY=0.981;
final float LENGTH=50;
final float RADIUS=5;
final float SCALE=1e-2f;
final int CLOTH_X_POINTS=12;
final int CLOTH_Y_POINTS=10;
final int COLLISION_GRID_SIZE=30;
final int POINTS_PER_EDGE_VERTEX=2;
final float MAX_GLUE_DISTANCE=2.5;

final int UI_FONT_SIZE=22;

final int FLAG_ENABLE_WIND=1;
final int FLAG_BREAK_CONNECTIONS=2;
final int FLAG_CREATE_CONNECTIONS=4;
final int FLAG_STRONG_BONDS=8;



ArrayList<Constraint> constraint_list;
ArrayList<Point> point_list;
CollisionGrid collision_grid;
Ui ui;
Point dragged_point=null;
boolean dragged_point_was_fixed;
float _last_time;
int flags=FLAG_ENABLE_WIND;



boolean _is_counterclockwise(float ax,float ay,float bx,float by,float cx,float cy){
	return (cy-ay)*(bx-ax)>(by-ay)*(cx-ax);
}



void setup(){
	size(1920,1080);
	_last_time=millis();
	constraint_list=new ArrayList<Constraint>();
	point_list=new ArrayList<Point>();
	collision_grid=new CollisionGrid(width,height,COLLISION_GRID_SIZE,COLLISION_GRID_SIZE);
	ui=new Ui();
	for (int i=0;i<CLOTH_X_POINTS;i++){
		for (int j=0;j<CLOTH_Y_POINTS;j++){
			Point p=new Point(0,0,false,false);
			if (i!=0){
				constraint_list.add(new Constraint(p,point_list.get(point_list.size()-CLOTH_Y_POINTS),LENGTH*SCALE,false));
			}
			if (j!=0){
				constraint_list.add(new Constraint(p,point_list.get(point_list.size()-1),LENGTH*SCALE,false));
			}
			point_list.add(p);
		}
	}
	for (int i=0;i<CLOTH_X_POINTS;i++){
		for (int j=0;j<POINTS_PER_EDGE_VERTEX;j++){
			Point p=new Point(0,0,false,true);
			constraint_list.add(new Constraint(p,point_list.get(i*CLOTH_Y_POINTS+CLOTH_Y_POINTS-1),LENGTH*0.5*SCALE,true));
			point_list.add(p);
			p=new Point(0,0,false,true);
			constraint_list.add(new Constraint(p,point_list.get(i*CLOTH_Y_POINTS),LENGTH*0.5*SCALE,true));
			point_list.add(p);
		}
	}
	for (int i=1;i<CLOTH_Y_POINTS-1;i++){
		for (int j=0;j<POINTS_PER_EDGE_VERTEX;j++){
			Point p=new Point(0,0,false,true);
			constraint_list.add(new Constraint(p,point_list.get(i),LENGTH*0.5*SCALE,true));
			point_list.add(p);
			p=new Point(0,0,false,true);
			constraint_list.add(new Constraint(p,point_list.get(i+CLOTH_Y_POINTS*(CLOTH_X_POINTS-1)),LENGTH*0.5*SCALE,true));
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



void keyPressed(){
	int flag=0;
	switch (keyCode){
		case 'C':
			flag=FLAG_CREATE_CONNECTIONS;
			flags&=~FLAG_BREAK_CONNECTIONS;
			break;
		case 'D':
			flag=FLAG_BREAK_CONNECTIONS;
			flags&=~FLAG_CREATE_CONNECTIONS;
			break;
		case 'F':
			if (dragged_point!=null){
				dragged_point_was_fixed=!dragged_point_was_fixed;
			}
			return;
		case 'S':
			flag=FLAG_STRONG_BONDS;
			break;
		case 'W':
			flag=FLAG_ENABLE_WIND;
			break;
		case 'X':
			if (dragged_point!=null){
				dragged_point.has_collision=!dragged_point.has_collision;
			}
			return;
	}
	if ((flag&flags)!=0){
		flags&=~flag;
	}
	else{
		flags|=flag;
	}
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
			dragged_point_was_fixed=dragged_point.fixed;
			dragged_point.fixed=true;
		}
		dragged_point.x=mouseX*SCALE;
		dragged_point.y=mouseY*SCALE;
		dragged_point._prev_x=dragged_point.x;
		dragged_point._prev_y=dragged_point.y;
	}
	else if (dragged_point!=null){
		dragged_point.fixed=dragged_point_was_fixed;
		dragged_point=null;
	}
	float wind=((0.5+sin(time/5000))*(0.7+sin(time/370))*(0.5+cos(time/4100)))*0.6*SCALE;
	for (Point p:point_list){
		p.update(delta_time);
		if ((flags&FLAG_ENABLE_WIND)!=0&&!p.fixed){
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
	if ((flags&FLAG_BREAK_CONNECTIONS)!=0){
		float x=mouseX*SCALE;
		float y=mouseY*SCALE;
		float px=pmouseX*SCALE;
		float py=pmouseY*SCALE;
		for (int i=0;i<constraint_list.size();i++){
			Constraint c=constraint_list.get(i);
			if (c.a==dragged_point||c.b==dragged_point||(_is_counterclockwise(c.a.x,c.a.y,px,py,x,y)!=_is_counterclockwise(c.b.x,c.b.y,px,py,x,y)&&_is_counterclockwise(c.a.x,c.a.y,c.b.x,c.b.y,px,py)!=_is_counterclockwise(c.a.x,c.a.y,c.b.x,c.b.y,x,y))){
				constraint_list.remove(i);
				i--;
			}
		}
	}
	if ((flags&FLAG_CREATE_CONNECTIONS)!=0&&dragged_point!=null){
		float d=0.0;
		Point target=null;
		for (int i=0;i<point_list.size();i++){
			Point p=point_list.get(i);
			if (p==dragged_point){
				continue;
			}
			float pd=(p.x-mouseX*SCALE)*(p.x-mouseX*SCALE)+(p.y-mouseY*SCALE)*(p.y-mouseY*SCALE);
			if (i==0||pd<d){
				d=pd;
				target=p;
			}
		}
		if (target!=null&&d<MAX_GLUE_DISTANCE*SCALE){
			for (Constraint c:constraint_list){
				if ((c.a==target&&c.b==dragged_point)||(c.a==dragged_point&&c.b==target)){
					target=null;
					break;
				}
			}
			if (target!=null){
				constraint_list.add(new Constraint(dragged_point,target,LENGTH*SCALE,((flags&FLAG_STRONG_BONDS)!=0?true:false)));
			}
		}
	}
	strokeWeight(4);
	for (Constraint c:constraint_list){
		stroke((c.fixed?0xa0ff8e8e:0x909e9e9e));
		line(c.a.x/SCALE,c.a.y/SCALE,c.b.x/SCALE,c.b.y/SCALE);
	}
	for (Point p:point_list){
		if (p.has_collision){
			noStroke();
			fill((p.fixed?#e8d220:#4f47fa));
			circle(p.x/SCALE,p.y/SCALE,RADIUS*2);
		}
		else{
			stroke((p.fixed?0x90f94943:0x9043f949));
			line(p.x/SCALE-RADIUS,p.y/SCALE-RADIUS,p.x/SCALE+RADIUS,p.y/SCALE+RADIUS);
			line(p.x/SCALE-RADIUS,p.y/SCALE+RADIUS,p.x/SCALE+RADIUS,p.y/SCALE-RADIUS);
		}
	}
	if (dragged_point!=null){
		fill(#ef1c98);
		circle(dragged_point.x/SCALE,dragged_point.y/SCALE,RADIUS*3);
	}
	ui.draw();
}
