class Connection{
	Point a;
	Point b;
	float length;
	float distance;
	int type;
	float normal_x;
	float normal_y;
	private float _animation_time;
	private float _raw_length;
	private float _piston_time;
	private float _piston_offset;
	private float _piston_length_multiplier;
	private float _piston_extended_time;
	private float _piston_retracted_time;
	private float _piston_movement_time;



	Connection(Point a,Point b,float length){
		this.a=a;
		this.b=b;
		this.length=length;
		this.distance=length;
		this.type=-1;
		this._animation_time=-1;
		this._raw_length=length;
		this._piston_time=0;
		this._piston_offset=0;
		this._piston_length_multiplier=2.5;
		this._piston_extended_time=1.5;
		this._piston_retracted_time=0.5;
		this._piston_movement_time=1;
	}



	void load_piston_data(JSONObject data){
		this._raw_length=data.getFloat("piston_length");
		this._piston_offset=data.getFloat("piston_offset");
		this._piston_time=data.getFloat("piston_time");
		this._piston_length_multiplier=data.getFloat("piston_length_multiplier");
		this._piston_extended_time=data.getFloat("piston_extended_time");
		this._piston_retracted_time=data.getFloat("piston_retracted_time");
		this._piston_movement_time=data.getFloat("piston_movement_time");
	}



	void save_piston_data(JSONObject data){
		data.setFloat("piston_length",this._raw_length);
		data.setFloat("piston_offset",this._piston_offset);
		data.setFloat("piston_time",this._piston_time);
		data.setFloat("piston_length_multiplier",this._piston_length_multiplier);
		data.setFloat("piston_extended_time",this._piston_extended_time);
		data.setFloat("piston_retracted_time",this._piston_retracted_time);
		data.setFloat("piston_movement_time",this._piston_movement_time);
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
		this._raw_length=length;
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
		this.normal_x=-distance_y/this.distance;
		this.normal_y=distance_x/this.distance;
	}



	void update_animation(float delta_time,int flags){
		if (this._animation_time!=-1){
			this._animation_time+=delta_time;
			if (this._animation_time>=RESIZE_ANIMATION_TIME){
				this._animation_time=-1;
			}
		}
		if (this.type!=CONNECTION_TYPE_PISTON){
			return;
		}
		if ((flags&FLAG_ENABLE_FORCES)!=0&&(!this.a.fixed||!this.b.fixed)){
			float total_time=this._piston_extended_time+this._piston_retracted_time+2*this._piston_movement_time;
			this._piston_time=(this._piston_time+delta_time)%total_time;
			float offset=this._piston_time-this._piston_offset+total_time;
			if (offset>=total_time){
				offset-=total_time;
			}
			if (offset<this._piston_movement_time){
				this.length=this._raw_length*map(cos(offset/this._piston_movement_time*PI),1,-1,1,this._piston_length_multiplier);
			}
			else if (offset<this._piston_extended_time+this._piston_movement_time){
				this.length=this._raw_length*this._piston_length_multiplier;
			}
			else if (offset<this._piston_extended_time+this._piston_movement_time*2){
				this.length=this._raw_length*map(cos((offset-this._piston_extended_time-this._piston_movement_time)/this._piston_movement_time*PI),1,-1,this._piston_length_multiplier,1);
			}
			else{
				this.length=this._raw_length;
			}
		}
		else if ((flags&FLAG_ENABLE_FORCES)==0){
			float distance_x=this.b.x-this.a.x;
			float distance_y=this.b.y-this.a.y;
			this.distance=sqrt(distance_x*distance_x+distance_y*distance_y);
			this.normal_x=-distance_y/this.distance;
			this.normal_y=distance_x/this.distance;
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
			if (this.type==CONNECTION_TYPE_PISTON){
				stroke(#c0bfbc);
			}
			else{
				stroke(CONNECTION_TYPE_COLORS[this.type]);
			}
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
		if (this.type==CONNECTION_TYPE_PISTON&&(flags&(FLAG_ENABLE_FORCES|FLAG_DRAW_STRESS))!=(FLAG_ENABLE_FORCES|FLAG_DRAW_STRESS)){
			strokeWeight(15);
			stroke(#62a0ea);
			line(this.a.x/SCALE,this.a.y/SCALE,(this.a.x+this.normal_y*this._raw_length)/SCALE,(this.a.y-this.normal_x*this._raw_length)/SCALE);
		}
		return false;
	}
}
