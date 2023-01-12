class AABB{
	float ax;
	float ay;
	float bx;
	float by;



	AABB(float ax,float ay,float bx,float by){
		this.ax=ax;
		this.ay=ay;
		this.bx=bx;
		this.by=by;
	}



	void add(float x,float y){
		if (x<this.ax){
			this.ax=x;
		}
		else if (x>this.bx){
			this.bx=x;
		}
		if (y<this.ay){
			this.ay=y;
		}
		else if (y>this.by){
			this.by=y;
		}
	}
}
