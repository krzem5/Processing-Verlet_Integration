class MouseHandler{
	final Engine engine;



	MouseHandler(Engine engine){
		this.engine=engine;
	}



	void update(){
		if (mousePressed){
			if (this.engine.dragged_point==null){
				float d=-1;
				for (Point p:this.engine.points){
					float pd=(p.x-mouseX*SCALE)*(p.x-mouseX*SCALE)+(p.y-mouseY*SCALE)*(p.y-mouseY*SCALE);
					if (d==-1||pd<d){
						d=pd;
						this.engine.dragged_point=p;
					}
				}
				this.engine._dragged_point_was_fixed=this.engine.dragged_point.fixed;
				this.engine.dragged_point.fixed=true;
			}
			this.engine.dragged_point.x=mouseX*SCALE;
			this.engine.dragged_point.y=mouseY*SCALE;
			this.engine.dragged_point._prev_x=this.engine.dragged_point.x;
			this.engine.dragged_point._prev_y=this.engine.dragged_point.y;
		}
		else if (this.engine.dragged_point!=null){
			this.engine.dragged_point.fixed=this.engine._dragged_point_was_fixed;
			this.engine.dragged_point=null;
		}
	}
}
