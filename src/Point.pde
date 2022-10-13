class Point{
	float x;
	float y;
	boolean fixed;
	float px;
	float py;
	PositionAccumulator accumulator;



	Point(float x,float y,boolean fixed){
		this.x=x;
		this.y=y;
		this.fixed=fixed;
		this.px=x;
		this.py=y;
		this.accumulator=new PositionAccumulator();
	}



	void update(){
		if (this.fixed){
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
		if (this.fixed){
			return;
		}
		this.x+=this.accumulator.get_x();
		this.y+=this.accumulator.get_y();
	}



	void draw(){
		noStroke();
		fill((this.fixed?#43F949:#4f47fa));
		circle(this.x,this.y,RADIUS*2);
	}
}
