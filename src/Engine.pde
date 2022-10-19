class Engine{
	final ArrayList<Point> points;
	final ArrayList<Connection> connections;
	final CollisionGrid collision_grid;
	final Ui ui;
	final PointSelector point_selector;
	final KeyboardHandler keyboard_handler;
	int flags;



	Engine(){
		this.points=new ArrayList<Point>();
		this.connections=new ArrayList<Connection>();
		this.collision_grid=new CollisionGrid(width,height,COLLISION_GRID_SIZE,COLLISION_GRID_SIZE);
		this.ui=new Ui(this);
		this.point_selector=new PointSelector(this);
		this.keyboard_handler=new KeyboardHandler(this);
		this.flags=FLAG_ENABLE_WIND|FLAG_ENABLE_FORCES;
	}



	void update(float delta_time){
		this.point_selector.update();
		float wind=Util.generate_wind_wave(millis())*0.6*SCALE;
		if ((this.flags&FLAG_ENABLE_FORCES)!=0){
			for (Point p:this.points){
				if (p.fixed){
					continue;
				}
				p.update(delta_time);
				if ((this.flags&FLAG_ENABLE_WIND)!=0){
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
		if (this.point_selector.dragged_point!=null){
			if ((this.flags&FLAG_DRAW_GRID)!=0){
				stroke(0x805a9a9a);
				line(this.point_selector.dragged_point.x/SCALE,0,this.point_selector.dragged_point.x/SCALE,height);
				line(0,this.point_selector.dragged_point.y/SCALE,width,this.point_selector.dragged_point.y/SCALE);
			}
			noStroke();
			fill(#ef1c98);
			circle(this.point_selector.dragged_point.x/SCALE,this.point_selector.dragged_point.y/SCALE,RADIUS*3);
		}
		this.point_selector.draw();
		this.ui.draw();
	}



	void load(String file_path){
		this.point_selector.delete();
		this.points.clear();
		this.connections.clear();
		if (!new File(file_path).exists()){
			return;
		}
		JSONObject data=loadJSONObject(file_path);
		JSONArray points=data.getJSONArray("points");
		JSONArray connections=data.getJSONArray("connections");
		for (int i=0;i<points.size();i++){
			JSONObject point_data=points.getJSONObject(i);
			this.points.add(new Point(point_data.getFloat("x"),point_data.getFloat("y"),point_data.getBoolean("fixed"),point_data.getBoolean("collision")));
		}
		for (int i=0;i<connections.size();i++){
			JSONObject connections_data=connections.getJSONObject(i);
			this.connections.add(new Connection(this.points.get(connections_data.getInt("a")),this.points.get(connections_data.getInt("b")),connections_data.getFloat("length"),connections_data.getBoolean("fixed")));
		}
	}



	void save(String file_path){
		JSONObject out=new JSONObject();
		JSONArray points=new JSONArray();
		for (int i=0;i<this.points.size();i++){
			Point p=this.points.get(i);
			p._index=i;
			JSONObject point_data=new JSONObject();
			point_data.setFloat("x",p.x);
			point_data.setFloat("y",p.y);
			point_data.setBoolean("fixed",p.fixed);
			point_data.setBoolean("collision",p.has_collision);
			points.append(point_data);
		}
		JSONArray connections=new JSONArray();
		for (Connection c:this.connections){
			JSONObject connection_data=new JSONObject();
			connection_data.setInt("a",c.a._index);
			connection_data.setInt("b",c.b._index);
			connection_data.setFloat("length",c.length);
			connection_data.setBoolean("fixed",c.fixed);
			connections.append(connection_data);
		}
		out.setJSONArray("points",points);
		out.setJSONArray("connections",connections);
		saveJSONObject(out,file_path);
	}
}
