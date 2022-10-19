class PointSelector{
	final Engine engine;
	Point dragged_point;
	private boolean _dragged_point_was_fixed;
	private boolean _is_mouse_down;



	PointSelector(Engine engine){
		this.engine=engine;
		this.dragged_point=null;
		this._is_mouse_down=false;
	}



	boolean is_dragged_point_fixed(){
		return this._dragged_point_was_fixed;
	}
	void toggle_dragged_point_fixed(){
		this._dragged_point_was_fixed=!this._dragged_point_was_fixed;
		if (!this._is_mouse_down){
			this.dragged_point.fixed=!this.dragged_point.fixed;
		}
	}



	void click_mouse(int button){
		if (button==LEFT){
			if (this.dragged_point!=null){
				this.dragged_point.fixed=this._dragged_point_was_fixed;
				this.dragged_point=null;
			}
			float x=mouseX*SCALE;
			float y=mouseY*SCALE;
			this._is_mouse_down=true;
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
		if (this._is_mouse_down&&this.dragged_point!=null){
			this.dragged_point.x=x;
			this.dragged_point.y=y;
			this.dragged_point._prev_x=this.dragged_point.x;
			this.dragged_point._prev_y=this.dragged_point.y;
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
}



void mousePressed(){
	engine.point_selector.click_mouse(mouseButton);
}
void mouseReleased(){
	engine.point_selector.unclick_mouse(mouseButton);
}
