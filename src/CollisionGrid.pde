class CollisionGrid{
	int width;
	int height;
	int grid_width;
	int grid_height;
	private Point _data[][];
	private int _width;
	private int _height;
	private float _x_offset;
	private float _y_offset;



	CollisionGrid(int width,int height,int grid_width,int grid_height){
		this.width=width;
		this.height=height;
		this.grid_width=grid_width;
		this.grid_height=grid_width;
		this.rebuild_grid();
	}



	void add(Point p){
		int x=int((p.x/SCALE+this._x_offset)/this.grid_width);
		int y=int((p.y/SCALE+this._y_offset)/this.grid_height);
		if (x<0||y<0||x>=this._width||y>=this._height){
			return;
		}
		p._next_point=this._data[x][y];
		this._data[x][y]=p;
	}



	void update(){
		for (int i=0;i<this._width;i++){
			for (int j=0;j<this._height;j++){
				Point a=this._data[i][j];
				this._data[i][j]=null;
				while (a!=null){
					Point b=a._next_point;
					while (b!=null){
						float dx=b.x-a.x;
						float dy=b.y-a.y;
						if (dx==0&&dy==0){
							if (!a.fixed){
								a.x++;
							}
							if (!b.fixed){
								b.x--;
							}
						}
						else{
							float dist=dx*dx+dy*dy;
							if (dist<4*RADIUS*RADIUS*SCALE*SCALE){
								dist=sqrt(dist);
								dist=(dist*0.5-RADIUS*SCALE)/dist;
								dx*=dist;
								dy*=dist;
								if (!a.fixed){
									a.x+=dx;
									a.y+=dy;
								}
								if (!b.fixed){
									b.x-=dx;
									b.y-=dy;
								}
							}
						}
						b=b._next_point;
					}
					a=a._next_point;
				}
			}
		}
		this._x_offset+=this.grid_width/4.0;
		if (this._x_offset>=this.grid_width){
			this._x_offset=0;
		}
		this._y_offset+=this.grid_height/5.0;
		if (this._y_offset>=this.grid_height){
			this._y_offset=0;
		}
	}



	void rebuild_grid(){
		this._width=(this.width+this.grid_width)/this.grid_width;
		this._height=(this.height+this.grid_height)/this.grid_height;
		this._data=new Point[this._width][this._height];
	}
}
