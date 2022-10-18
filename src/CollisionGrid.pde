class CollisionGrid{
	int width;
	int height;
	int grid_width;
	int grid_height;
	ArrayList<Point> _data[][];
	int _render_count[][];
	int _width;
	int _height;



	CollisionGrid(int width,int height,int grid_width,int grid_height){
		this.width=width;
		this.height=height;
		this.grid_width=grid_width;
		this.grid_height=grid_width;
		this.rebuild_grid();
		this._render_count=null;
	}



	void add(Point p){
		p._next_point=null;
		float x=p.x/SCALE;
		float y=p.y/SCALE;
		int x_idx=int(x/this.grid_width);
		int y_idx=int(y/this.grid_height);
		x-=x_idx*this.grid_width;
		y-=y_idx*this.grid_height;
		this._data[x_idx][y_idx].add(p);
		boolean x_near=x_idx>0&&x<2*RADIUS;
		boolean y_near=y_idx>0&&y<2*RADIUS;
		if (x_near){
			this._data[x_idx-1][y_idx].add(p);
			if (y_near){
				this._data[x_idx][y_idx-1].add(p);
			}
		}
		if (y_near){
			this._data[x_idx][y_idx-1].add(p);
		}
	}



	void solve(){
		for (int i=0;i<this._width;i++){
			for (int j=0;j<this._height;j++){
				ArrayList<Point> points=this._data[i][j];
				for (int k=1;k<points.size();k++){
					Point a=points.get(k);
					for (int l=0;l<k;l++){
						Point b=points.get(l);
						float dx=b.x-a.x;
						float dy=b.y-a.y;
						float dist=dx*dx+dy*dy;
						if (dist==0){
							if (!a.fixed){
								a.x+=1;
							}
							if (!b.fixed){
								b.x-=1;
							}
						}
						else if (dist<4*RADIUS*RADIUS*SCALE*SCALE){
							dist=sqrt(dist);
							dist=(dist-2*RADIUS*SCALE)/dist*0.5;
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
				}
				if (this._render_count!=null){
					this._render_count[i][j]=points.size();
				}
				points.clear();
			}
		}
	}



	void rebuild_grid(){
		this._width=(this.width+this.grid_width-1)/this.grid_width;
		this._height=(this.height+this.grid_height-1)/this.grid_height;
		this._data=(ArrayList<Point>[][]) new ArrayList[this._width][this._height];
		for (int i=0;i<this._width;i++){
			for (int j=0;j<this._height;j++){
				this._data[i][j]=new ArrayList<Point>();
			}
		}
		this._render_count=null;
	}



	void draw(){
		stroke(#3d3846);
		for (int i=1;i<this._width;i++){
			line(i*this.grid_width,0,i*this.grid_width,this.height);
		}
		for (int i=1;i<this._height;i++){
			line(0,i*this.grid_height,this.width,i*this.grid_height);
		}
		if (this._render_count==null){
			this._render_count=new int[this._width][this._height];
			return;
		}
		noStroke();
		fill(#ee9b25);
		textSize(30);
		textAlign(CENTER,CENTER);
		for (int i=0;i<this._width;i++){
			for (int j=0;j<this._height;j++){
				text(str(this._render_count[i][j]),(i+0.5)*this.grid_width,(j+0.5)*this.grid_height);
			}
		}
	}
}
