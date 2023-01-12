class PointSelectorCopyDataPoint{
	float x;
	float y;
	boolean fixed;
	boolean has_collision;
	int new_index;



	PointSelectorCopyDataPoint(float x,float y,boolean fixed,boolean has_collision){
		this.x=x;
		this.y=y;
		this.fixed=fixed;
		this.has_collision=has_collision;
		this.new_index=-1;
	}
}
