class Engine{
	final ArrayList<Point> points;
	final ArrayList<Connection> connections;
	final CollisionGrid collision_grid;
	final Ui ui;
	final PointSelector point_selector;
	final KeyboardHandler keyboard_handler;
	final SnapGrid snap_grid;
	final CollisionLineCollider collision_line_collider;
	String file_name;
	int flags;
	int connection_type;
	private float _wind_time;



	Engine(){
		this.points=new ArrayList<Point>();
		this.connections=new ArrayList<Connection>();
		this.collision_grid=new CollisionGrid(width,height,COLLISION_GRID_SIZE,COLLISION_GRID_SIZE);
		this.ui=new Ui(this);
		this.point_selector=new PointSelector(this);
		this.keyboard_handler=new KeyboardHandler(this);
		this.snap_grid=new SnapGrid(this);
		this.collision_line_collider=new CollisionLineCollider();
		this.file_name=null;
		this.flags=FLAG_ENABLE_WIND;
		this.connection_type=CONNECTION_TYPE_WOOD;
	}



	void update(float delta_time){
		this.point_selector.update();
		for (Connection c:this.connections){
			c.update_animation(delta_time,this.flags);
		}
		if ((this.flags&FLAG_ENABLE_FORCES)!=0){
			this._wind_time+=delta_time;
			float wind=Util.generate_wind_wave(this._wind_time)*0.6*SCALE*20;
			for (Point p:this.points){
				if (p.fixed){
					continue;
				}
				p.update(delta_time);
				if ((this.flags&FLAG_ENABLE_WIND)!=0){
					p.x+=wind;
					p.y+=wind*cos(this._wind_time*0.03);
				}
			}
			for (int idx=0;idx<200;idx++){
				for (Connection c:this.connections){
					c.update();
				}
				for (Point p:this.points){
					p.constrain();
					if (p.has_collision){
						this.collision_grid.add(p);
						this.collision_line_collider.collide(p);
					}
				}
				this.collision_grid.update();
			}
		}
	}



	void draw(){
		background(0);
		if ((this.flags&(FLAG_DRAW_GRID|FLAG_ENABLE_FORCES))==FLAG_DRAW_GRID){
			this.snap_grid.draw();
		}
		for (int i=0;i<this.connections.size();i++){
			Connection c=this.connections.get(i);
			if (c.draw(this.flags)){
				c.delete(this);
				this.connections.remove(i);
				i--;
			}
		}

		strokeWeight(4);
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
			if ((this.flags&FLAG_DRAW_GUIDES)!=0){
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



	void load(String file_name){
		this.point_selector.deselect();
		this.collision_line_collider.reset();
		this.points.clear();
		this.connections.clear();
		this.file_name=file_name;
		file_name=SAVE_FOLDER+file_name+".json";
		if (!new File(file_name).exists()){
			this.file_name=null;
			return;
		}
		JSONObject data=loadJSONObject(file_name);
		this._wind_time=data.getFloat("wind");
		JSONArray points=data.getJSONArray("points");
		JSONArray connections=data.getJSONArray("connections");
		for (int i=0;i<points.size();i++){
			JSONObject point_data=points.getJSONObject(i);
			this.points.add(new Point(point_data.getFloat("x"),point_data.getFloat("y"),point_data.getBoolean("fixed"),point_data.getBoolean("collision")));
		}
		for (int i=0;i<connections.size();i++){
			JSONObject connection_data=connections.getJSONObject(i);
			Connection c=new Connection(this.points.get(connection_data.getInt("a")),this.points.get(connection_data.getInt("b")),connection_data.getFloat("length"));
			c.set_type(this,connection_data.getInt("type"));
			c.load_data(connection_data);
			this.connections.add(c);
		}
	}



	void save(){
		if (this.file_name==null){
			this.ui.get_save_name();
			return;
		}
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
			connection_data.setInt("type",c.type);
			c.save_data(connection_data);
			connections.append(connection_data);
		}
		out.setFloat("wind",this._wind_time);
		out.setJSONArray("points",points);
		out.setJSONArray("connections",connections);
		new File(SAVE_FOLDER).mkdirs();
		saveJSONObject(out,SAVE_FOLDER+this.file_name+".json");
	}
}
