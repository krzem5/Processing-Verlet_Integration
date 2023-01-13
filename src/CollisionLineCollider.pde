class CollisionLineCollider{
	ArrayList<Connection> lines;



	CollisionLineCollider(){
		this.lines=new ArrayList<Connection>();
	}



	void reset(){
		this.lines.clear();
	}



	void add_connection(Connection c){
		c.delta=0;
		this.lines.add(c);
	}



	void remove_connection(Connection c){
		for (int i=0;i<this.lines.size();i++){
			if (this.lines.get(i)==c){
				this.lines.remove(i);
				return;
			}
		}
	}



	void apply_deltas(){
		for (Connection c:this.lines){
			if (!c.a.fixed){
				c.a.x-=c.normal_x*c.delta;
				c.a.y-=c.normal_y*c.delta;
			}
			if (!c.b.fixed){
				c.b.x-=c.normal_x*c.delta;
				c.b.y-=c.normal_y*c.delta;
			}
			c.delta=0;
		}
	}



	void collide(Point p){
		boolean has_collision=false;
		float collision_factor=0;
		for (Connection c:this.lines){
			if (p==c.a||p==c.b){
				continue;
			}
			PVector intersection=Util.line_intersection_point(c.a.x,c.a.y,c.b.x,c.b.y,p.x,p.y,p.prev_x,p.prev_y);
			if (intersection==null){
				continue;
			}
			float factor=RADIUS*SCALE;
			if (!Util.is_counterclockwise(c.a.x,c.a.y,c.b.x,c.b.y,p.prev_x,p.prev_y)){
				factor=-factor;
			}
			p.x=intersection.x+c.normal_x*factor;
			p.y=intersection.y+c.normal_y*factor;
			if (abs(collision_factor)<abs(c.normal_y*factor)){
				collision_factor=c.normal_y*factor;
				p.last_line=c;
			}
			c.delta+=factor;
			has_collision=true;
		}
		if (has_collision){
			p.prev_y=p.y+collision_factor;
		}
	}
}
