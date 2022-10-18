class Engine{
	final ArrayList<Point> points;
	final ArrayList<Connection> connections;
	final CollisionGrid collision_grid;
	final Ui ui;
	final MouseHandler mouse_handler;
	final KeyboardHandler keyboard_handler;
	int flags;
	Point dragged_point;
	private boolean _dragged_point_was_fixed;



	Engine(){
		this.points=new ArrayList<Point>();
		this.connections=new ArrayList<Connection>();
		this.collision_grid=new CollisionGrid(width,height,COLLISION_GRID_SIZE,COLLISION_GRID_SIZE);
		this.ui=new Ui(this);
		this.mouse_handler=new MouseHandler(this);
		this.keyboard_handler=new KeyboardHandler(this);
		this.flags=FLAG_ENABLE_WIND;
		this.dragged_point=null;
	}



	boolean is_dragged_point_fixed(){
		return this._dragged_point_was_fixed;
	}



	void update(float delta_time){
		this.mouse_handler.update();
		float wind=Util.generate_wind_wave(millis())*0.6*SCALE;
		for (Point p:this.points){
			p.update(delta_time);
			if ((this.flags&FLAG_ENABLE_WIND)!=0&&!p.fixed){
				p.x+=wind;
			}
		}
		for (int idx=0;idx<400;idx++){
			for (Connection c:this.connections){
				c.update();
			}
			for (Point p:this.points){
				p.constrain();
				if (p.has_collision){
					this.collision_grid.add(p);
				}
			}
			this.collision_grid.update();
		}
		if ((this.flags&FLAG_BREAK_CONNECTIONS)!=0){
			float x=mouseX*SCALE;
			float y=mouseY*SCALE;
			float px=pmouseX*SCALE;
			float py=pmouseY*SCALE;
			for (int i=0;i<this.connections.size();i++){
				Connection c=this.connections.get(i);
				if (c.a==this.dragged_point||c.b==this.dragged_point||Util.line_intersection(c.a.x,c.a.y,c.b.x,c.b.y,px,py,x,y)){
					this.connections.remove(i);
					i--;
				}
			}
		}
		if ((this.flags&FLAG_CREATE_CONNECTIONS)!=0&&this.dragged_point!=null){
			float d=0.0;
			Point target=null;
			for (int i=0;i<this.points.size();i++){
				Point p=this.points.get(i);
				if (p==this.dragged_point){
					continue;
				}
				float pd=(p.x-mouseX*SCALE)*(p.x-mouseX*SCALE)+(p.y-mouseY*SCALE)*(p.y-mouseY*SCALE);
				if (i==0||pd<d){
					d=pd;
					target=p;
				}
			}
			if (target!=null&&d<MAX_CONNECTION_DISTANCE*SCALE){
				for (Connection c:this.connections){
					if ((c.a==target&&c.b==this.dragged_point)||(c.a==this.dragged_point&&c.b==target)){
						target=null;
						break;
					}
				}
				if (target!=null){
					this.connections.add(new Connection(this.dragged_point,target,LENGTH*SCALE,((flags&FLAG_STRONG_BONDS)!=0?true:false)));
				}
			}
		}
	}



	void draw(){
		background(0);
		strokeWeight(4);
		for (Connection c:this.connections){
			stroke((c.fixed?0xa0ff8e8e:0x909e9e9e));
			line(c.a.x/SCALE,c.a.y/SCALE,c.b.x/SCALE,c.b.y/SCALE);
		}
		for (Point p:this.points){
			if (p.has_collision){
				noStroke();
				fill((p.fixed?#e8d220:#4f47fa));
				circle(p.x/SCALE,p.y/SCALE,RADIUS*2);
			}
			else{
				stroke((p.fixed?0x90f94943:0x9043f949));
				line(p.x/SCALE-RADIUS,p.y/SCALE-RADIUS,p.x/SCALE+RADIUS,p.y/SCALE+RADIUS);
				line(p.x/SCALE-RADIUS,p.y/SCALE+RADIUS,p.x/SCALE+RADIUS,p.y/SCALE-RADIUS);
			}
		}
		if (this.dragged_point!=null){
			fill(#ef1c98);
			circle(this.dragged_point.x/SCALE,this.dragged_point.y/SCALE,RADIUS*3);
		}
		this.ui.draw();
	}
}
