class Point{
	float x;
	float y;
	float px;
	float py;
	boolean f;
	float dx;
	float dy;
	int dn;



	Point(float x,float y,boolean f){
		this.x=x;
		this.y=y;
		this.px=x;
		this.py=y;
		this.f=f;
		this.dx=0;
		this.dy=0;
		this.dn=0;
	}



	void update(){
		if (this.f){
			this.px=this.x;
			this.py=this.y;
			return;
		}
		float vx=(this.x-this.px)*DRAG;
		float vy=(this.y-this.py)*DRAG+GRAVITY;
		this.px=this.x;
		this.py=this.y;
		this.x+=vx;
		this.y+=vy;
		if (this.y>height){
			this.y=height;
			this.py=this.y;
		}
	}



	void update_pos(){
		if (this.dn==0){
			return;
		}
		this.x+=this.dx/this.dn;
		this.y+=this.dy/this.dn;
		this.dx=0;
		this.dy=0;
		this.dn=0;
	}



	void draw(){
		noStroke();
		fill((this.f?#43F949:#4f47fa));
		circle(this.x,this.y,RADIUS*2);
	}
}
