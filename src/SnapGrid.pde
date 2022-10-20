class SnapGrid{
	final Engine engine;
	int size;
	private int _size;
	private int _x_offset;
	private int _y_offset;



	SnapGrid(Engine engine){
		this.engine=engine;
		this.size=GRID_SIZE_NAMES.length/2;
		this._calculate_offsets();
	}



	void update_size(int delta){
		this.size+=delta;
		if (this.size<0){
			this.size=0;
		}
		else if (this.size>=GRID_SIZE_NAMES.length){
			this.size=GRID_SIZE_NAMES.length-1;
		}
		this._calculate_offsets();
	}



	float snap_x(float x){
		if ((this.engine.flags&FLAG_DRAW_GRID)==0){
			return x;
		}
		int nearest=int((x+this._size/2-this._x_offset)/this._size)*this._size+this._x_offset;
		return (abs(x-nearest)<MAX_SNAP_DISTANCE?nearest:x);
	}



	float snap_y(float y){
		if ((this.engine.flags&FLAG_DRAW_GRID)==0){
			return y;
		}
		int nearest=int((y+this._size/2-this._y_offset)/this._size)*this._size+this._y_offset;
		return (abs(y-nearest)<MAX_SNAP_DISTANCE?nearest:y);
	}



	void draw(){
		strokeWeight(2);
		stroke(#3a3a3a);
		for (int i=this._x_offset;i<width;i+=this._size){
			line(i,0,i,height);
		}
		for (int i=this._y_offset;i<height;i+=this._size){
			line(0,i,width,i);
		}
	}



	private void _calculate_offsets(){
		this._size=1<<(this.size+5);
		this._x_offset=(width-width/this._size*this._size)/2;
		this._y_offset=(height-height/this._size*this._size)/2;
	}
}
