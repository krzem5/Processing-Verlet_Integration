class Point{
	float x;
	float y;
	boolean fixed;
	float _prev_x;
	float _prev_y;
	float _delta_x;
	float _delta_y;
	int _delta_count;



	Point(float x,float y,boolean fixed){
		this.x=x;
		this.y=y;
		this.fixed=fixed;
		this._prev_x=x;
		this._prev_y=y;
		this._delta_x=0;
		this._delta_y=0;
		this._delta_count=0;
	}



	void update(float dt){
		if (this.fixed){
			return;
		}
		float vx=this.x-this._prev_x;
		float vy=this.y-this._prev_y;
		this._prev_x=this.x;
		this._prev_y=this.y;
		this.x+=vx*DRAG;
		this.y+=vy*DRAG+GRAVITY*dt;
	}



	void constrain(){
		if (this._delta_count!=0){
			this.x+=this._delta_x/this._delta_count;
			this.y+=this._delta_y/this._delta_count;
			this._delta_count=0;
		}
		if (this.y>(height-RADIUS)*SCALE){
			this.y=(height-RADIUS)*SCALE;
			this._prev_x=this.x;
			this._prev_y=this.y;
		}
	}



	void draw(){
		noStroke();
		fill((this.fixed?#43F949:#4f47fa));
		circle(this.x/SCALE,this.y/SCALE,RADIUS*2);
	}
}
