final int COUNT=50;
final float DRAG=0.95;
final float GRAVITY=0.981;
final float LENGTH=50;
final float RADIUS=5;
final int ROPE_COUNT=20;
final int SHAPE_RADIUS=40;
final float SCALE=1e-2f;
final int CLOTH_X_POINTS=12;
final int CLOTH_Y_POINTS=10;



ArrayList<Constraint> constraint_list;
ArrayList<Point> point_list;
CollisionGrid collision_grid;
Point dragged_point=null;
float _last_time;



Point _generate_symmetric_shape(float x,float y,float r,int sides){
	Point points[]=new Point[sides];
	for (int i=0;i<sides;i++){
		Point a=new Point(x+r*cos(TWO_PI/sides*i),y+r*sin(TWO_PI/sides*i),false,true);
		points[i]=a;
		point_list.add(a);
		for (int j=0;j<i;j++){
			Point b=points[j];
			constraint_list.add(new Constraint(a,b,sqrt((a.x-b.x)*(a.x-b.x)+(a.y-b.y)*(a.y-b.y)),true,1.0));
		}
	}
	return points[0];
}



Point create_rope(Point a,Point b,int count){
	Point out=a;
	for (int i=0;i<count;i++){
		Point n=new Point(0,0,false,true);
		point_list.add(n);
		constraint_list.add(new Constraint(a,n,LENGTH*SCALE,false,1));
		if (i*2==count){
			out=n;
		}
		a=n;
	}
	constraint_list.add(new Constraint(a,b,LENGTH*SCALE,false,1));
	return out;
}



void setup(){
	size(1920,1080);
	_last_time=millis();
	constraint_list=new ArrayList<Constraint>();
	point_list=new ArrayList<Point>();
	collision_grid=new CollisionGrid(width,height,100,100);
	// Point a=new Point(width/4*SCALE,height/4*SCALE,true);
	// Point b=new Point(width*3/4*SCALE,height/4*SCALE,true);
	// Point c=new Point(width/2*SCALE,height*3/4*SCALE,true);
	// dragged_point=new Point(width/2*SCALE,height*2*SCALE,false);
	// point_list.add(a);
	// point_list.add(b);
	// point_list.add(c);
	// point_list.add(dragged_point);
	// Point ca=create_rope(a,b,50);
	// Point cb=create_rope(b,c,40);
	// Point cc=create_rope(a,c,40);
	// create_rope(ca,dragged_point,20);
	// create_rope(cb,dragged_point,20);
	// create_rope(cc,dragged_point,20);
	////////////////////////////////
	// Point a=new Point(width/2*SCALE,height/4*SCALE,true);
	// Point b=new Point(0,0,false);
	// create_rope(a,b,20);
	// point_list.add(a);
	// point_list.add(b);
	// dragged_point=b;
	////////////////////////////////
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
		for (int j=0;j<2;j++){
			Point p=new Point(0,0,false,true);
			constraint_list.add(new Constraint(p,point_list.get(i*CLOTH_Y_POINTS+CLOTH_Y_POINTS-1),LENGTH*0.5*SCALE,true,1.0));
			point_list.add(p);
			p=new Point(0,0,false,true);
			constraint_list.add(new Constraint(p,point_list.get(i*CLOTH_Y_POINTS),LENGTH*0.5*SCALE,true,1.0));
			point_list.add(p);
		}
	}
	for (int i=1;i<CLOTH_Y_POINTS-1;i++){
		for (int j=0;j<2;j++){
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
	b.x=width*3/4*SCALE;
	b.y=height/6*SCALE;
	b.fixed=true;
	////////////////////////////////
	// point_list.add(new Point(width/4*SCALE,height/4*SCALE,true));
	// Point n=null;
	// for (int i=0;i<COUNT;i++){
	// 	n=new Point(0,0,false);
	// 	constraint_list.add(new Constraint(point_list.get(i),n,LENGTH*SCALE,true,1.0));
	// 	point_list.add(n);
	// }
	// n.x=width*3/4*SCALE;
	// n.y=height/4*SCALE;
	// n.fixed=true;
	// dragged_point=point_list.get(COUNT/2+1);
	// for (int i=0;i<ROPE_COUNT;i++){
	// 	n=new Point(0,0,false);
	// 	constraint_list.add(new Constraint(dragged_point,n,LENGTH*SCALE,true,1.0));
	// 	point_list.add(n);
	// 	dragged_point=n;
	// }
	// dragged_point=point_list.get(COUNT+ROPE_COUNT);
	// dragged_point.fixed=true;
	// dragged_point.x=width/2*SCALE;
	// dragged_point.y=height*2/3*SCALE;
	// constraint_list.add(new Constraint(_generate_symmetric_shape(width/2*SCALE,0,SHAPE_RADIUS*SCALE,3),dragged_point,LENGTH*SCALE,false,0.0025));
	// dragged_point=point_list.get(point_list.size()-3);
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
	}
	else{
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
		collision_grid.solve();
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
	collision_grid.draw();
}
