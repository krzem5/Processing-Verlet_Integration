final int COUNT=50;
final float DRAG=0.95;
final float GRAVITY=9.81;
final float LENGTH=20;
final float RADIUS=10;
final int ROPE_COUNT=5;
final int SHAPE_RADIUS=40;
final float SCALE=0.03125;



ArrayList<Constraint> cl;
ArrayList<Point> pl;
Point e;
float _last_time;



Point _generate_symmetric_shape(float x,float y,float r,int sides){
	Point points[]=new Point[sides];
	for (int i=0;i<sides;i++){
		Point a=new Point(x+r*cos(TWO_PI/sides*i),y+r*sin(TWO_PI/sides*i),false);
		points[i]=a;
		pl.add(a);
		for (int j=0;j<i;j++){
			Point b=points[j];
			cl.add(new Constraint(a,b,sqrt((a.x-b.x)*(a.x-b.x)+(a.y-b.y)*(a.y-b.y)),true));
		}
	}
	return points[0];
}



void setup(){
	size(1920,1080);
	cl=new ArrayList<Constraint>();
	pl=new ArrayList<Point>();
	pl.add(new Point(width/4*SCALE,height/4*SCALE,true));
	Point n=null;
	for (int i=0;i<COUNT;i++){
		n=new Point(0,0,false);
		cl.add(new Constraint(pl.get(i),n,LENGTH*SCALE,true));
		pl.add(n);
	}
	n.x=width*3/4*SCALE;
	n.y=height/4*SCALE;
	n.fixed=true;
	e=pl.get(COUNT/2+1);
	for (int i=0;i<ROPE_COUNT;i++){
		n=new Point(0,0,false);
		cl.add(new Constraint(e,n,LENGTH*SCALE,true));
		pl.add(n);
		e=n;
	}
	e=pl.get(COUNT+ROPE_COUNT);
	cl.add(new Constraint(_generate_symmetric_shape(width/2*SCALE,0,SHAPE_RADIUS*SCALE,6),e,LENGTH*SCALE,true));
	// cl.remove(cl.size()-1);
	e=pl.get(pl.size()-3);
	_last_time=millis();
}



void draw(){
	float time=millis();
	float delta_time=(time-_last_time)*0.001;
	_last_time=time;
	background(0);
	if (mousePressed){
		e.x=mouseX*SCALE;
		e.y=mouseY*SCALE;
		e._prev_x=e.x;
		e._prev_y=e.y;
	}
	for (Point p:pl){
		p.update(delta_time);
	}
	for (int i=0;i<400;i++){
		for (Constraint c:cl){
			c.update();
		}
		for (Point p:pl){
			p.constrain();
		}
	}
	for (Constraint c:cl){
		c.draw();
	}
	for (Point p:pl){
		p.draw();
	}
}
