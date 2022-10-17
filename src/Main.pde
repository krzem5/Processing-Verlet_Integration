final int COUNT=50;
final float DRAG=0.95;
final float GRAVITY=0.981;
final float LENGTH=50;
final float RADIUS=5;
final int ROPE_COUNT=20;
final int SHAPE_RADIUS=40;
final float SCALE=1e-2f;
final int CLOTH_X_POINTS=16;
final int CLOTH_Y_POINTS=14;



ArrayList<Constraint> cl;
ArrayList<Point> pl;
Point e=null;
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
		cl.add(new Constraint(a,n,LENGTH*SCALE,false,1));
		if (i*2==count){
			out=n;
		}
		a=n;
	}
	cl.add(new Constraint(a,b,LENGTH*SCALE,false,1));
	return out;
}



void setup(){
	size(1920,1080);
	_last_time=millis();
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
	// Point a=new Point(width/2*SCALE,height/4*SCALE,true);
	// Point b=new Point(0,0,false);
	// create_rope(a,b,20);
	// pl.add(a);
	// pl.add(b);
	// e=b;
	////////////////////////////////
	for (int i=0;i<CLOTH_X_POINTS;i++){
		for (int j=0;j<CLOTH_Y_POINTS;j++){
			Point p=new Point(0,0,false);
			if (i!=0){
				cl.add(new Constraint(p,pl.get(pl.size()-CLOTH_Y_POINTS),LENGTH*SCALE,false,1.0));
			}
			if (j!=0){
				cl.add(new Constraint(p,pl.get(pl.size()-1),LENGTH*SCALE,false,1.0));
			}
			pl.add(p);
		}
	}
	for (int i=0;i<CLOTH_X_POINTS;i++){
		Point p=new Point(0,0,false);
		cl.add(new Constraint(p,pl.get(i*CLOTH_Y_POINTS+CLOTH_Y_POINTS-1),LENGTH*0.5*SCALE,false,1.0));
		pl.add(p);
		p=new Point(0,0,false);
		cl.add(new Constraint(p,pl.get(i*CLOTH_Y_POINTS),LENGTH*0.5*SCALE,false,1.0));
		pl.add(p);
	}
	for (int i=0;i<CLOTH_Y_POINTS;i++){
		Point p=new Point(0,0,false);
		cl.add(new Constraint(p,pl.get(i),LENGTH*0.5*SCALE,false,1.0));
		pl.add(p);
		p=new Point(0,0,false);
		cl.add(new Constraint(p,pl.get(i+CLOTH_Y_POINTS*(CLOTH_X_POINTS-1)),LENGTH*0.5*SCALE,false,1.0));
		pl.add(p);
	}
	Point a=pl.get(0);
	a.x=width/4*SCALE;
	a.y=height/6*SCALE;
	a.fixed=true;
	Point b=pl.get((CLOTH_X_POINTS-1)*CLOTH_Y_POINTS);
	b.x=width*3/4*SCALE;
	b.y=height/6*SCALE;
	b.fixed=true;
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
}



void draw(){
	float time=millis();
	float delta_time=(time-_last_time)*0.001;
	_last_time=time;
	background(0);
	if (mousePressed){
		if (e==null){
			float d=0.0;
			for (int i=0;i<pl.size();i++){
				Point p=pl.get(i);
				float pd=(p.x-mouseX*SCALE)*(p.x-mouseX*SCALE)+(p.y-mouseY*SCALE)*(p.y-mouseY*SCALE);
				if (i==0||pd<d){
					d=pd;
					e=p;
				}
			}
		}
		e.x=mouseX*SCALE;
		e.y=mouseY*SCALE;
		e._prev_x=e.x;
		e._prev_y=e.y;
	}
	else{
		e=null;
	}
	float wind=((0.5+sin(time/5000))*(0.7+sin(time/370))*(0.5+cos(time/4100)))*0.6*SCALE;
	for (Point p:pl){
		p.update(delta_time);
		if (!p.fixed){
			p.x+=wind;
		}
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
	noStroke();
	fill(255,0,0,200);
	beginShape(QUADS);
	for (int i=1;i<CLOTH_X_POINTS;i++){
		for (int j=1;j<CLOTH_Y_POINTS;j++){
			Point p=pl.get((i-1)*CLOTH_Y_POINTS+j-1);
			vertex(p.x/SCALE,p.y/SCALE);
			p=pl.get(i*CLOTH_Y_POINTS+j-1);
			vertex(p.x/SCALE,p.y/SCALE);
			p=pl.get(i*CLOTH_Y_POINTS+j);
			vertex(p.x/SCALE,p.y/SCALE);
			p=pl.get((i-1)*CLOTH_Y_POINTS+j);
			vertex(p.x/SCALE,p.y/SCALE);
		}
	}
	endShape();
}
