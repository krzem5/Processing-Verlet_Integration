class CollisionLineCollider{
	ArrayList<Connection> lines;



	CollisionLineCollider(){
		this.lines=new ArrayList<Connection>();
	}



	void add_connection(Connection c){
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



	void collide(Point p){
		boolean reset_prev_pos=false;
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
			reset_prev_pos=true;
		}
		if (reset_prev_pos){
			p.prev_x=p.x;
			p.prev_y=p.y;
		}
	}



	void draw(){
		strokeWeight(10);
		for (Connection c:this.lines){
			stroke(#ff00ff);
			line(c.a.x/SCALE,c.a.y/SCALE,c.b.x/SCALE,c.b.y/SCALE);
			float cx=(c.a.x+c.b.x)/2/SCALE;
			float cy=(c.a.y+c.b.y)/2/SCALE;
			stroke(#ffff00);
			line(cx,cy,cx+c.normal_x*30,cy+c.normal_y*30);
		}
	}
}
