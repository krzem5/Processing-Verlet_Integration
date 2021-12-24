class Constraint{
	Point a;
	Point b;
	float l;



	Constraint(Point a,Point b,float l){
		this.a=a;
		this.b=b;
		this.l=l;
	}



	void update(){
		if (this.a.f&&this.b.f){
			return;
		}
		float dx=this.b.x-this.a.x;
		float dy=this.b.y-this.a.y;
		float m=sqrt(dx*dx+dy*dy);
		if (m==0){
			if (!this.a.f){
				this.a.dx--;
			}
			if (!this.b.f){
				this.b.dx++;
			}
			return;
		}
		m=this.l/(m*2)-0.5;
		dx*=m;
		dy*=m;
		if (!this.a.f){
			this.a.dx-=dx;
			this.a.dy-=dy;
			this.a.dn++;
		}
		if (!this.b.f){
			this.b.dx+=dx;
			this.b.dy+=dy;
			this.b.dn++;
		}
	}



	void draw(){
		strokeWeight(4);
		stroke(#9e9e9e);
		line(this.a.x,this.a.y,this.b.x,this.b.y);
	}
}
