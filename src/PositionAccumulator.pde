class PositionAccumulator{
	float x;
	float y;
	int count;



	PositionAccumulator(){
		this.x=x;
		this.y=y;
		this.count=0;
	}



	void add(float x,float y){
		this.count++;
		this.x+=x;
		this.y+=y;
	}



	float get_x(){
		return (this.count==0?0:this.x/this.count);
	}



	float get_y(){
		return (this.count==0?0:this.y/this.count);
	}



	void reset(){
		this.x=0;
		this.y=0;
		this.count=0;
	}
}
