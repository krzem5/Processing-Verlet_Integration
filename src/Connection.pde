class Connection{
	Point a;
	Point b;
	float length;
	float distance;
	int type;
	float normal_x;
	float normal_y;
	private float _animation_time;



	Connection(Point a,Point b,float length){
		this.a=a;
		this.b=b;
		this.length=length;
		this.distance=length;
		this.type=-1;
		this._animation_time=-1;
	}



	void delete(Engine engine){
		if (this.type==CONNECTION_TYPE_ROAD){
			engine.collision_line_collider.remove_connection(this);
		}
	}



	void set_type(Engine engine,int type){
		if (this.type==type){
			return;
		}
		if (this.type==CONNECTION_TYPE_ROAD){
			engine.collision_line_collider.remove_connection(this);
		}
		this.type=type;
		if (this.type==CONNECTION_TYPE_ROAD){
			engine.collision_line_collider.add_connection(this);
		}
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
		this.distance=length;
	}



	void update(){
		float distance_x=this.b.x-this.a.x;
		float distance_y=this.b.y-this.a.y;
		this.distance=sqrt(distance_x*distance_x+distance_y*distance_y);
		if (this.a.fixed&&this.b.fixed){
			return;
		}
		if (this.type==CONNECTION_TYPE_STRING&&this.distance<=this.length){
			return;
		}
		if (this.distance==0){
			if (!this.a.fixed){
				this.a.x--;
			}
			if (!this.b.fixed){
				this.b.x++;
			}
			this.normal_x=0;
			this.normal_y=1;
			return;
		}
		float adjust=1-this.length/this.distance;
		if (!this.a.fixed&&!this.b.fixed){
			adjust/=2;
		}
		float adjust_x=distance_x*adjust;
		float adjust_y=distance_y*adjust;
		if (!this.a.fixed){
			this.a.x+=adjust_x;
			this.a.y+=adjust_y;
		}
		if (!this.b.fixed){
			this.b.x-=adjust_x;
			this.b.y-=adjust_y;
		}
		if (this.type!=CONNECTION_TYPE_ROAD){
			return;
		}
		this.normal_x=distance_y/this.distance;
		this.normal_y=distance_x/this.distance;
		if (this.normal_y<0){
			this.normal_x=-this.normal_x;
			this.normal_y=-this.normal_y;
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



	boolean draw(int flags){
		float delta_distance=0;
		if ((flags&FLAG_ENABLE_FORCES)!=0){
			delta_distance=sqrt((this.a.x-this.b.x)*(this.a.x-this.b.x)+(this.a.y-this.b.y)*(this.a.y-this.b.y))/this.length;
			if ((flags&FLAG_ENABLE_STRESS_BREAKS)!=0){
				if (delta_distance>CONNECTION_BREAK_TENSION_FACTOR[this.type]){
					return true;
				}
				if (delta_distance<CONNECTION_BREAK_COMPRESSION_FACTOR[this.type]){
					return true;
				}
			}
		}
		strokeWeight(CONNECTION_TYPE_WIDTH[this.type]+(this._animation_time==-1?0:8*sin(this._animation_time/RESIZE_ANIMATION_TIME*PI)));
		if ((flags&(FLAG_ENABLE_FORCES|FLAG_DRAW_STRESS))!=(FLAG_ENABLE_FORCES|FLAG_DRAW_STRESS)){
			stroke(CONNECTION_TYPE_COLORS[this.type]);
		}
		else{
			if (delta_distance>1){
				float t=Util.adjust_curve(min((delta_distance-1)/(CONNECTION_BREAK_TENSION_FACTOR[this.type]-1),1))*255;
				stroke(t,128-t/2,0);
			}
			else if (CONNECTION_BREAK_COMPRESSION_FACTOR[this.type]>0&&delta_distance<1){
				float t=Util.adjust_curve(min((delta_distance-1)/(CONNECTION_BREAK_COMPRESSION_FACTOR[this.type]-1),1))*255;
				stroke(0,128-t/2,t);
			}
			else{
				stroke(0,128,0);
			}
		}
		line(this.a.x/SCALE,this.a.y/SCALE,this.b.x/SCALE,this.b.y/SCALE);
		return false;
	}
}
