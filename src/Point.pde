class Point{
	float x;
	float y;
	boolean fixed;
	boolean has_collision;
	Point _next_point;
	boolean _deleted;
	int _index;
	float prev_x;
	float prev_y;



	Point(float x,float y,boolean fixed,boolean has_collision){
		this.x=x;
		this.y=y;
		this.fixed=fixed;
		this.has_collision=has_collision;
		this._deleted=false;
		this.prev_x=x;
		this.prev_y=y;
	}



	void constrain(){
		if (this.x<RADIUS*SCALE){
			this.x=RADIUS*SCALE;
			this.prev_x=this.x;
		}
		else if (this.x>(width-RADIUS)*SCALE){
			this.x=(width-RADIUS)*SCALE;
			this.prev_x=this.x;
		}
		if (this.y<RADIUS*SCALE){
			this.y=RADIUS*SCALE;
			this.prev_y=this.y;
		}
		else if (this.y>(height-RADIUS-GROUND_Y_OFFSET)*SCALE){
			this.y=(height-RADIUS-GROUND_Y_OFFSET)*SCALE;
			this.prev_x=this.x;
			this.prev_y=this.y;
		}
	}



	void update(float dt){
		if (this.fixed){
			return;
		}
		float vx=this.x-this.prev_x;
		float vy=this.y-this.prev_y;
		this.prev_x=this.x;
		this.prev_y=this.y;
		this.x+=vx*DRAG;
		this.y+=vy*DRAG+GRAVITY*dt;
	}
}
