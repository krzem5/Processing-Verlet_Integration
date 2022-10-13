final int COUNT=50;
final float DRAG=0.99;
final float GRAVITY=0.981;
final float LENGTH=20;
final float RADIUS=10;
final int ROPE_COUNT=2;
final int STIFFNESS=2000;
final int SHAPE_RADIUS=40;



ArrayList<Constraint> cl;
ArrayList<Point> pl;
Point e;



void _link_points(Point a,Point b){
	cl.add(new Constraint(a,b,sqrt((a.x-b.x)*(a.x-b.x)+(a.y-b.y)*(a.y-b.y))));
}



Point _generate_symmetric_shape(float x,float y,float r,int sides){
	Point points[]=new Point[sides];
	for (int i=0;i<sides;i++){
		Point a=new Point(x+r*cos(TWO_PI/sides*i),y+r*sin(TWO_PI/sides*i),false);
		points[i]=a;
		pl.add(a);
		for (int j=0;j<i;j++){
			Point b=points[j];
			cl.add(new Constraint(a,b,sqrt((a.x-b.x)*(a.x-b.x)+(a.y-b.y)*(a.y-b.y))));
		}
	}
	return points[0];
}



void setup(){
	size(1920,1080);
	cl=new ArrayList<Constraint>();
	pl=new ArrayList<Point>();
	pl.add(new Point(width/4,height/4,true));
	Point n=null;
	for (int i=0;i<COUNT;i++){
		n=new Point(0,0,false);
		cl.add(new Constraint(pl.get(i),n,LENGTH));
		pl.add(n);
	}
	n.x=width*3/4;
	n.y=height/4;
	n.f=true;
	e=pl.get(COUNT/2+1);
	for (int i=0;i<ROPE_COUNT;i++){
		n=new Point(0,0,false);
		cl.add(new Constraint(e,n,LENGTH));
		pl.add(n);
		e=n;
	}
	e=pl.get(COUNT+ROPE_COUNT);
	cl.add(new Constraint(_generate_symmetric_shape(width/2,0,SHAPE_RADIUS,5),e,LENGTH));
	// cl.remove(cl.size()-1);
	e=pl.get(pl.size()-1);
}



void draw(){
	background(0);
	if (mousePressed){
		e.x=mouseX;
		e.y=mouseY;
		e.f=true;
		e.px=e.x;
		e.py=e.y;
	}
	else{
		e.f=false;
	}
	for (Point p:pl){
		p.update();
	}
	for (int i=0;i<STIFFNESS;i++){
		for (Constraint c:cl){
			c.update();
		}
		for (Point p:pl){
			p.update_pos();
		}
	}
	for (Constraint c:cl){
		c.draw();
	}
	for (Point p:pl){
		p.draw();
	}
}
