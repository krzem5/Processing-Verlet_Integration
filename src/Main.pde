final int COUNT=50;
final float DRAG=0.99;
final float GRAVITY=0.981;
final float LENGTH=20;
final float RADIUS=10;
final int ROPE_COUNT=7;
final int STIFFNESS=1000;



ArrayList<Constraint> cl;
ArrayList<Point> pl;
Point e;



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
