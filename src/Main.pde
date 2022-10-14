final int COUNT=50;
final float DRAG=0.95;
final float GRAVITY=0.981;
final float LENGTH=20;
final float RADIUS=10;
final int ROPE_COUNT=20;
final int SHAPE_RADIUS=40;
final float SCALE=1e-2f;



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
			cl.add(new Constraint(a,b,sqrt((a.x-b.x)*(a.x-b.x)+(a.y-b.y)*(a.y-b.y)),true,1.0));
		}
	}
	return points[0];
}



Point create_rope(Point a,Point b,int count){
	Point out=a;
	for (int i=0;i<count;i++){
		Point n=new Point(0,0,false);
		pl.add(n);
		cl.add(new Constraint(a,n,LENGTH*SCALE,true,1.0));
		if (i*2==count){
			out=n;
		}
		a=n;
	}
	cl.add(new Constraint(a,b,LENGTH*SCALE,true,1.0));
	return out;
}



void setup(){
	size(1920,1080);
	cl=new ArrayList<Constraint>();
	pl=new ArrayList<Point>();
	// Point a=new Point(width/4*SCALE,height/4*SCALE,true);
	// Point b=new Point(width*3/4*SCALE,height/4*SCALE,true);
	// Point c=new Point(width/2*SCALE,height*3/4*SCALE,true);
	// e=new Point(width/2*SCALE,height*2*SCALE,false);
	// pl.add(a);
	// pl.add(b);
	// pl.add(c);
	// pl.add(e);
	// Point ca=create_rope(a,b,50);
	// Point cb=create_rope(b,c,40);
	// Point cc=create_rope(a,c,40);
	// create_rope(ca,e,20);
	// create_rope(cb,e,20);
	// create_rope(cc,e,20);
	////////////////////////////////
	Point a=new Point(width/4*SCALE,height/4*SCALE,true);
	Point b=new Point(width*3/4*SCALE,height/4*SCALE,true);
	pl.add(a);
	pl.add(b);
	create_rope(a,b,40);
	for (int i=2;i<42;i++){
		Point c=new Point(0,0,false);
		create_rope(pl.get(i),c,10);
		pl.add(c);
		if (i==2){
			continue;
		}
		for (int j=0;j<11;j++){
			cl.add(new Constraint(pl.get(9+j+i*11),pl.get(20+j+i*11),LENGTH*SCALE,false,1.0));
		}
	}
	e=b;
	////////////////////////////////
	// pl.add(new Point(width/4*SCALE,height/4*SCALE,true));
	// Point n=null;
	// for (int i=0;i<COUNT;i++){
	// 	n=new Point(0,0,false);
	// 	cl.add(new Constraint(pl.get(i),n,LENGTH*SCALE,true,1.0));
	// 	pl.add(n);
	// }
	// n.x=width*3/4*SCALE;
	// n.y=height/4*SCALE;
	// n.fixed=true;
	// e=pl.get(COUNT/2+1);
	// for (int i=0;i<ROPE_COUNT;i++){
	// 	n=new Point(0,0,false);
	// 	cl.add(new Constraint(e,n,LENGTH*SCALE,true,1.0));
	// 	pl.add(n);
	// 	e=n;
	// }
	// e=pl.get(COUNT+ROPE_COUNT);
	// e.fixed=true;
	// e.x=width/2*SCALE;
	// e.y=height*2/3*SCALE;
	// cl.add(new Constraint(_generate_symmetric_shape(width/2*SCALE,0,SHAPE_RADIUS*SCALE,3),e,LENGTH*SCALE,false,0.0025));
	// e=pl.get(pl.size()-3);
	// _last_time=millis();
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
