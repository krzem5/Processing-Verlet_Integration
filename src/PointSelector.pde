class PointSelector{
	final Engine engine;
	Point dragged_point;
	ArrayList<Point> dragged_points;
	private boolean _dragged_point_was_fixed;
	private boolean _is_mouse_down;
	private int _region_start_x;
	private int _region_start_y;
	private float _drag_offset_x;
	private float _drag_offset_y;



	PointSelector(Engine engine){
		this.engine=engine;
		this.dragged_point=null;
		this.dragged_points=null;
		this._is_mouse_down=false;
	}



	boolean is_dragged_point_fixed(){
		return this._dragged_point_was_fixed;
	}



	void toggle_forces(boolean force_disable){
		if (this.dragged_points!=null){
			for (Point p:this.dragged_points){
				p.fixed=(force_disable?false:!p.fixed);
			}
		}
		else if (this.dragged_point!=null){
			this._dragged_point_was_fixed=!this._dragged_point_was_fixed;
			if (!this._is_mouse_down){
				this.dragged_point.fixed=(force_disable?false:!this.dragged_point.fixed);
			}
		}
	}



	void toggle_collision(boolean force_disable){
		if (this.dragged_points!=null){
			for (Point p:this.dragged_points){
				p.has_collision=(force_disable?false:!p.has_collision);
			}
		}
		else if (this.dragged_point!=null){
			this.dragged_point.has_collision=(force_disable?false:!this.dragged_point.has_collision);
		}
	}



	void delete(){
		if (this.dragged_points==null&&this.dragged_point==null){
			return;
		}
		if (this.dragged_points!=null){
			for (Point p:this.dragged_points){
				p._deleted=true;
				this.engine.points.remove(p);
			}
			this.dragged_points=null;
		}
		else{
			this.dragged_point._deleted=true;
			this.engine.points.remove(this.dragged_point);
			this.dragged_point=null;
		}
		for (int i=0;i<this.engine.connections.size();i++){
			Connection c=this.engine.connections.get(i);
			if (c.a._deleted||c.b._deleted){
				this.engine.connections.remove(i);
				i--;
			}
		}
	}



	void deselect(){
		if (this.dragged_point!=null){
			this.dragged_point.fixed=this._dragged_point_was_fixed;
			this.dragged_point=null;
		}
		this.dragged_points=null;
	}



	void click_mouse(int button){
		if (this.engine.ui.overlay){
			return;
		}
		if (button==LEFT){
			this._is_mouse_down=true;
			if (this.engine.keyboard_handler.is_ctrl_pressed){
				if (this.dragged_points==null){
					this.dragged_points=new ArrayList<Point>();
				}
				if (this.dragged_point!=null){
					this.dragged_points.add(this.dragged_point);
					this.dragged_point.fixed=this._dragged_point_was_fixed;
					this.dragged_point=null;
				}
				Point target=this._get_clicked_point();
				if (target!=null){
					for (Point p:this.dragged_points){
						if (p==target){
							this.dragged_points.remove(p);
							target=null;
							break;
						}
					}
					if (target!=null){
						this.dragged_points.add(target);
					}
				}
				if (this.dragged_points.size()==0){
					this.dragged_points=null;
				}
				this._region_start_x=-1;
				this._region_start_y=-1;
				return;
			}
			if (this.dragged_point!=null){
				this.dragged_point.fixed=this._dragged_point_was_fixed;
				this.dragged_point=null;
			}
			if (this.engine.keyboard_handler.is_shift_pressed){
				this.dragged_points=new ArrayList<Point>();
				this._region_start_x=mouseX;
				this._region_start_y=mouseY;
			}
			else{
				this.dragged_points=null;
				this.dragged_point=this._get_clicked_point();
				if (this.dragged_point!=null){
					this._drag_offset_x=this.dragged_point.x/SCALE-mouseX;
					this._drag_offset_y=this.dragged_point.y/SCALE-mouseY;
					this._dragged_point_was_fixed=this.dragged_point.fixed;
					this.dragged_point.fixed=true;
				}
			}
		}
		else if (button==RIGHT){
			this._is_mouse_down=true;
			this.dragged_points=null;
			this.dragged_point=new Point(mouseX*SCALE,mouseY*SCALE,false,false);
			this._dragged_point_was_fixed=false;
			this.engine.points.add(this.dragged_point);
		}
	}



	void unclick_mouse(int button){
		if (this.engine.ui.overlay){
			return;
		}
		if (button==LEFT){
			if (this.dragged_point!=null){
				this.dragged_point.fixed=this._dragged_point_was_fixed;
			}
			if (this.dragged_points!=null&&this.dragged_points.size()==0){
				this.dragged_points=null;
			}
			this._is_mouse_down=false;
		}
		else if (button==RIGHT){
			this._is_mouse_down=false;
			this.dragged_point.fixed=this._dragged_point_was_fixed;
			this.dragged_point=null;
		}
	}



	void move(float dx,float dy){
		dx*=this.engine.snap_grid.get_scale()*SCALE/2;
		dy*=this.engine.snap_grid.get_scale()*SCALE/2;
		if (this.dragged_point!=null){
			this.dragged_point.x+=dx;
			this.dragged_point.y+=dy;
		}
		else if (this.dragged_points!=null){
			for (Point p:this.dragged_points){
				p.x+=dx;
				p.y+=dy;
			}
		}
	}



	void update(){
		float x=mouseX*SCALE;
		float y=mouseY*SCALE;
		float px=pmouseX*SCALE;
		float py=pmouseY*SCALE;
		if (this._is_mouse_down){
			if (this.dragged_point!=null){
				this.dragged_point.x=(this.engine.keyboard_handler.is_shift_pressed?this.engine.snap_grid.snap_x(mouseX+this._drag_offset_x)*SCALE:x+this._drag_offset_x*SCALE);
				this.dragged_point.y=(this.engine.keyboard_handler.is_shift_pressed?this.engine.snap_grid.snap_y(mouseY+this._drag_offset_y)*SCALE:y+this._drag_offset_y*SCALE);
				this.dragged_point.prev_x=this.dragged_point.x;
				this.dragged_point.prev_y=this.dragged_point.y;
			}
			else if (this.dragged_points!=null&&this._region_start_x!=-1){
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
					c.delete(this.engine);
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
			if (target!=null&&d<MAX_CONNECTION_DISTANCE*MAX_CONNECTION_DISTANCE*SCALE*SCALE){
				for (Connection c:this.engine.connections){
					if ((c.a==target&&c.b==this.dragged_point)||(c.a==this.dragged_point&&c.b==target)){
						c.set_type(this.engine,this.engine.connection_type);
						target=null;
						break;
					}
				}
				if (target!=null){
					float dx=this.dragged_point.x-target.x;
					float dy=this.dragged_point.y-target.y;
					Connection c=new Connection(this.dragged_point,target,sqrt(dx*dx+dy*dy));
					c.set_type(this.engine,this.engine.connection_type);
					this.engine.connections.add(c);
				}
			}
		}
	}



	void draw(){
		if (this.dragged_points!=null){
			if (this._is_mouse_down&&this._region_start_x!=-1){
				noStroke();
				fill(0x805b57ab);
				rect((this._region_start_x<mouseX?this._region_start_x:mouseX),(this._region_start_y<mouseY?this._region_start_y:mouseY),abs(mouseX-this._region_start_x),abs(mouseY-this._region_start_y));
			}
			stroke(#ff8f00);
			noFill();
			for (Point p:this.dragged_points){
				circle(p.x/SCALE,p.y/SCALE,RADIUS*2);
			}
		}
		else if ((this.engine.flags&FLAG_CREATE_CONNECTIONS)!=0&&this.dragged_point!=null){
			strokeWeight(CONNECTION_TYPE_WIDTH[this.engine.connection_type]);
			stroke(CONNECTION_TYPE_COLORS[this.engine.connection_type]);
			draw_dashed_line(this.dragged_point.x/SCALE,this.dragged_point.y/SCALE,mouseX,mouseY,CONNECTION_CREATE_LINE_DASH,CONNECTION_CREATE_LINE_DASH);
		}
		else if ((this.engine.flags&FLAG_BREAK_CONNECTIONS)!=0){
			strokeWeight(8);
			stroke(0xaaff2f2f);
			line(mouseX-10,mouseY-10,mouseX+10,mouseY+10);
			line(mouseX-10,mouseY+10,mouseX+10,mouseY-10);
		}
	}



	private Point _get_clicked_point(){
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
		return (d<MAX_CONNECTION_DISTANCE*SCALE?target:null);
	}
}



void mousePressed(){
	engine.point_selector.click_mouse(mouseButton);
}
void mouseReleased(){
	engine.point_selector.unclick_mouse(mouseButton);
}
