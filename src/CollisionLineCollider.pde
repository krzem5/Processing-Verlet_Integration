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
		for (Connection c:this.lines){
			if (p==c.a||p==c.b){
				continue;
			}
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
			line(cx,cy,cx+c.normal_x*30,cy-c.normal_y*30);
		}
	}
}
