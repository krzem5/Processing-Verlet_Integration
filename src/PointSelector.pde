class PointSelector{
	final Engine engine;
	Point dragged_point;
	ArrayList<Point> dragged_points;
	private boolean _dragged_point_was_fixed;
	private boolean _is_mouse_down;
	private int _region_start_x;
	private int _region_start_y;



	PointSelector(Engine engine){
		this.engine=engine;
		this.dragged_point=null;
		this.dragged_points=null;
		this._is_mouse_down=false;
	}



	boolean is_dragged_point_fixed(){
		return this._dragged_point_was_fixed;
	}
	void toggle_dragged_point_fixed(){
		if (this.dragged_points!=null){
			for (Point p:this.dragged_points){
				p.fixed=!p.fixed;
			}
		}
		else if (this.dragged_point!=null){
			this._dragged_point_was_fixed=!this._dragged_point_was_fixed;
			if (!this._is_mouse_down){
				this.dragged_point.fixed=!this.dragged_point.fixed;
			}
		}
	}



	void click_mouse(int button){
		if (button==LEFT){
			this._is_mouse_down=true;
			if (this.engine.keyboard_handler.is_shift_pressed){
				this.dragged_points=new ArrayList<Point>();
				this._region_start_x=mouseX;
				this._region_start_y=mouseY;
			}
			else{
				this.dragged_points=null;
				if (this.dragged_point!=null){
					this.dragged_point.fixed=this._dragged_point_was_fixed;
					this.dragged_point=null;
				}
				float x=mouseX*SCALE;
				float y=mouseY*SCALE;
				float d=0;
				Point target=null;
				for (Point p:this.engine.points){
					float pd=(p.x-x)*(p.x-x)+(p.y-y)*(p.y-y);
					if (target==null||pd<d){
						d=pd;
						target=p;
					}
				}
				if (d<MAX_CONNECTION_DISTANCE*SCALE){
					this.dragged_point=target;
					this._dragged_point_was_fixed=this.dragged_point.fixed;
					this.dragged_point.fixed=true;
				}
			}
		}
	}
	void unclick_mouse(int button){
		if (button==LEFT){
			if (this.dragged_point!=null){
				this.dragged_point.fixed=this._dragged_point_was_fixed;
			}
			this._is_mouse_down=false;
		}
	}



	void update(){
		float x=mouseX*SCALE;
		float y=mouseY*SCALE;
		float px=pmouseX*SCALE;
		float py=pmouseY*SCALE;
		if (this._is_mouse_down){
			if (this.dragged_point!=null){
				this.dragged_point.x=x;
				this.dragged_point.y=y;
				this.dragged_point._prev_x=this.dragged_point.x;
				this.dragged_point._prev_y=this.dragged_point.y;
			}
			else if (this.dragged_points!=null){
				this.dragged_points.clear();
				float min_x=(this._region_start_x<mouseX?this._region_start_x:mouseX)*SCALE;
				float min_y=(this._region_start_y<mouseY?this._region_start_y:mouseY)*SCALE;
				float max_x=min_x+abs(mouseX-this._region_start_x)*SCALE;
				float max_y=min_y+abs(mouseY-this._region_start_y)*SCALE;
				for (Point p:this.engine.points){
					if (min_x<=p.x&&p.x<=max_x&&min_y<=p.y&&p.y<=max_y){
						this.dragged_points.add(p);
					}
				}
			}
		}
		if ((this.engine.flags&FLAG_BREAK_CONNECTIONS)!=0){
			for (int i=0;i<this.engine.connections.size();i++){
				Connection c=this.engine.connections.get(i);
				if (c.a==this.dragged_point||c.b==this.dragged_point||Util.line_intersection(c.a.x,c.a.y,c.b.x,c.b.y,px,py,x,y)){
					this.engine.connections.remove(i);
					i--;
				}
			}
		}
		if ((this.engine.flags&FLAG_CREATE_CONNECTIONS)!=0&&this.dragged_point!=null){
			float d=0;
			Point target=null;
			for (Point p:this.engine.points){
				if (p==this.dragged_point){
					continue;
				}
				float pd=(p.x-x)*(p.x-x)+(p.y-y)*(p.y-y);
				if (target==null||pd<d){
					d=pd;
					target=p;
				}
			}
			if (target!=null&&d<MAX_CONNECTION_DISTANCE*SCALE){
				for (Connection c:this.engine.connections){
					if ((c.a==target&&c.b==this.dragged_point)||(c.a==this.dragged_point&&c.b==target)){
						target=null;
						break;
					}
				}
				if (target!=null){
					this.engine.connections.add(new Connection(this.dragged_point,target,LENGTH*SCALE,((this.engine.flags&FLAG_STRONG_BONDS)!=0?true:false)));
				}
			}
		}
	}



	void draw(){
		if (this.dragged_points!=null){
			if (this._is_mouse_down){
				noStroke();
				fill(0x805b57ab);
				rect((this._region_start_x<mouseX?this._region_start_x:mouseX),(this._region_start_y<mouseY?this._region_start_y:mouseY),abs(mouseX-this._region_start_x),abs(mouseY-this._region_start_y));
			}
			stroke(#ab575b);
			noFill();
			for (Point p:this.dragged_points){
				circle(p.x/SCALE,p.y/SCALE,RADIUS*2);
			}
		}
	}
}



void mousePressed(){
	engine.point_selector.click_mouse(mouseButton);
}
void mouseReleased(){
	engine.point_selector.unclick_mouse(mouseButton);
}
