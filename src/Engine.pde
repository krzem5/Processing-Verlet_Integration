boolean _is_counterclockwise(float ax,float ay,float bx,float by,float cx,float cy){
	return (cy-ay)*(bx-ax)>(by-ay)*(cx-ax);
}



class Engine{
	ArrayList<Point> points;
	ArrayList<Constraint> connections;
	CollisionGrid collision_grid;
	Ui ui;
	int flags;
	Point dragged_point;
	private boolean _dragged_point_was_fixed;



	Engine(){
		this.points=new ArrayList<Point>();
		this.connections=new ArrayList<Constraint>();
		this.collision_grid=new CollisionGrid(width,height,COLLISION_GRID_SIZE,COLLISION_GRID_SIZE);
		this.ui=new Ui(this);
		this.flags=FLAG_ENABLE_WIND;
		this.dragged_point=null;
	}



	void update(float delta_time){
		if (mousePressed){
			if (this.dragged_point==null){
				float d=-1;
				for (Point p:this.points){
					float pd=(p.x-mouseX*SCALE)*(p.x-mouseX*SCALE)+(p.y-mouseY*SCALE)*(p.y-mouseY*SCALE);
					if (d==-1||pd<d){
						d=pd;
						this.dragged_point=p;
					}
				}
				this._dragged_point_was_fixed=this.dragged_point.fixed;
				this.dragged_point.fixed=true;
			}
			this.dragged_point.x=mouseX*SCALE;
			this.dragged_point.y=mouseY*SCALE;
			this.dragged_point._prev_x=this.dragged_point.x;
			this.dragged_point._prev_y=this.dragged_point.y;
		}
		else if (this.dragged_point!=null){
			this.dragged_point.fixed=this._dragged_point_was_fixed;
			this.dragged_point=null;
		}
		float wind=((0.5+sin(millis()/5000))*(0.7+sin(millis()/370))*(0.5+cos(millis()/4100)))*0.6*SCALE;
		for (Point p:this.points){
			p.update(delta_time);
			if ((this.flags&FLAG_ENABLE_WIND)!=0&&!p.fixed){
				p.x+=wind;
			}
		}
		for (int idx=0;idx<400;idx++){
			for (Constraint c:this.connections){
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
				Constraint c=this.connections.get(i);
				if (c.a==this.dragged_point||c.b==this.dragged_point||(_is_counterclockwise(c.a.x,c.a.y,px,py,x,y)!=_is_counterclockwise(c.b.x,c.b.y,px,py,x,y)&&_is_counterclockwise(c.a.x,c.a.y,c.b.x,c.b.y,px,py)!=_is_counterclockwise(c.a.x,c.a.y,c.b.x,c.b.y,x,y))){
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
			if (target!=null&&d<MAX_GLUE_DISTANCE*SCALE){
				for (Constraint c:this.connections){
					if ((c.a==target&&c.b==this.dragged_point)||(c.a==this.dragged_point&&c.b==target)){
						target=null;
						break;
					}
				}
				if (target!=null){
					this.connections.add(new Constraint(this.dragged_point,target,LENGTH*SCALE,((flags&FLAG_STRONG_BONDS)!=0?true:false)));
				}
			}
		}
	}



	void draw(){
		background(0);
		strokeWeight(4);
		for (Constraint c:this.connections){
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



void keyPressed(){
	int flag=0;
	switch (keyCode){
		case 'C':
			flag=FLAG_CREATE_CONNECTIONS;
			engine.flags&=~FLAG_BREAK_CONNECTIONS;
			break;
		case 'D':
			flag=FLAG_BREAK_CONNECTIONS;
			engine.flags&=~FLAG_CREATE_CONNECTIONS;
			break;
		case 'F':
			if (engine.dragged_point!=null){
				engine._dragged_point_was_fixed=!engine._dragged_point_was_fixed;
			}
			return;
		case 'S':
			flag=FLAG_STRONG_BONDS;
			break;
		case 'W':
			flag=FLAG_ENABLE_WIND;
			break;
		case 'X':
			if (engine.dragged_point!=null){
				engine.dragged_point.has_collision=!engine.dragged_point.has_collision;
			}
			return;
	}
	if ((flag&engine.flags)!=0){
		engine.flags&=~flag;
	}
	else{
		engine.flags|=flag;
	}
}
