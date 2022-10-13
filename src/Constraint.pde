class Constraint{
	Point a;
	Point b;
	float length;



	Constraint(Point a,Point b,float length){
		this.a=a;
		this.b=b;
		this.length=length;
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
		distance=this.length/(distance*2)-0.5;
		distance_x*=distance;
		distance_y*=distance;
		this.a.accumulator.add(-distance_x,-distance_y);
		this.b.accumulator.add(distance_x,distance_y);
	}



	void draw(){
		strokeWeight(4);
		stroke(#9e9e9e);
		line(this.a.x,this.a.y,this.b.x,this.b.y);
	}
}
