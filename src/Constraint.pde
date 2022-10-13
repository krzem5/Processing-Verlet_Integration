class Constraint{
	Point a;
	Point b;
	float length;
	boolean fixed;



	Constraint(Point a,Point b,float length,boolean fixed){
		this.a=a;
		this.b=b;
		this.length=length;
		this.fixed=fixed;
	}



	void update(){
		if (this.a.fixed&&this.b.fixed){
			return;
		}
		float distance_x=this.b.x-this.a.x;
		float distance_y=this.b.y-this.a.y;
		float distance=sqrt(distance_x*distance_x+distance_y*distance_y);
		if (distance==0){
			if (!this.a.fixed){
				this.a.x--;
			}
			if (!this.b.fixed){
				this.b.x++;
			}
			return;
		}
		if (!this.fixed&&distance<=this.length){
			return;
		}
		distance=(distance-this.length)/distance*0.5;
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



	void draw(){
		strokeWeight(4);
		stroke((this.fixed?#fe9e9e:#9e9e9e));
		line(this.a.x/SCALE,this.a.y/SCALE,this.b.x/SCALE,this.b.y/SCALE);
	}
}
