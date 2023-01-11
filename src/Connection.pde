class Connection{
	Point a;
	Point b;
	float length;
	int type;
	private float _animation_time;



	Connection(Point a,Point b,float length,int type){
		this.a=a;
		this.b=b;
		this.length=length;
		this.type=type;
		this._animation_time=-1;
	}



	void recalculate_distance(){
		if (!this.a.fixed||!this.b.fixed){
			return;
		}
		float length=sqrt((this.a.x-this.b.x)*(this.a.x-this.b.x)+(this.a.y-this.b.y)*(this.a.y-this.b.y));
		if (this.length!=length){
			this._animation_time=0;
		}
		this.length=length;
	}



	void update(){
		if (this.a.fixed&&this.b.fixed){
			return;
		}
		float distance_x=this.b.x-this.a.x;
		float distance_y=this.b.y-this.a.y;
		float distance=distance_x*distance_x+distance_y*distance_y;
		if (this.type==CONNECTION_TYPE_STRING&&distance<=this.length*this.length){
			return;
		}
		if (distance==0){
			if (!this.a.fixed){
				this.a.x--;
			}
			if (!this.b.fixed){
				this.b.x++;
			}
			return;
		}
		distance=1-this.length/sqrt(distance);
		if (!this.a.fixed&&!this.b.fixed){
			distance/=2;
		}
		distance_x*=distance;
		distance_y*=distance;
		if (!this.a.fixed){
			this.a.x+=distance_x;
			this.a.y+=distance_y;
		}
		if (!this.b.fixed){
			this.b.x-=distance_x;
			this.b.y-=distance_y;
		}
	}



	void update_animation(float delta_time){
		if (this._animation_time!=-1){
			this._animation_time+=delta_time;
			if (this._animation_time>=RESIZE_ANIMATION_TIME){
				this._animation_time=-1;
			}
		}
	}



	boolean draw(boolean forces){
		if (ENABLE_CONNECTION_BREAKING&&forces&&(this.type==CONNECTION_TYPE_STRING||this.type==CONNECTION_TYPE_WOOD)){
			if ((this.a.x-this.b.x)*(this.a.x-this.b.x)+(this.a.y-this.b.y)*(this.a.y-this.b.y)>=this.length*this.length*CONNECTION_BREAK_DISTANCE_FACTOR*CONNECTION_BREAK_DISTANCE_FACTOR){
				return true;
			}
		}
		strokeWeight(4+(this._animation_time==-1?0:8*sin(this._animation_time/RESIZE_ANIMATION_TIME*PI)));
		stroke(CONNECTION_TYPE_COLORS[this.type]);
		line(this.a.x/SCALE,this.a.y/SCALE,this.b.x/SCALE,this.b.y/SCALE);
		return false;
	}
}
