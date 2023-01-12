class PointSelectorCopyData{
	private ArrayList<PointSelectorCopyDataPoint> _points;
	private ArrayList<PointSelectorCopyDataConnection> _connections;



	PointSelectorCopyData(){
		this._points=new ArrayList<PointSelectorCopyDataPoint>();
		this._connections=new ArrayList<PointSelectorCopyDataConnection>();
	}



	void from_point(Point point){
		this.reset();
		this._points.add(new PointSelectorCopyDataPoint(0,0,point.fixed,point.has_collision));
	}



	void from_points(Engine engine,ArrayList<Point> points,AABB aabb){
		this.reset();
		float cx=(aabb.ax+aabb.bx)*0.5;
		float cy=(aabb.ay+aabb.by)*0.5;
		for (Point point:engine.points){
			point.copy_index=-1;
		}
		for (Point point:points){
			point.copy_index=this._points.size();
			this._points.add(new PointSelectorCopyDataPoint(point.x-cx,point.y-cy,point.fixed,point.has_collision));
		}
		for (Connection connection:engine.connections){
			if (connection.a.copy_index==-1||connection.b.copy_index==-1){
				continue;
			}
			this._connections.add(new PointSelectorCopyDataConnection(connection.a.copy_index,connection.b.copy_index,connection.length,connection.type,connection.get_extra_data().copy()));
		}
	}



	void paste(Engine engine,float cx,float cy){
		engine.point_selector.deselect();
		engine.point_selector.dragged_points=new ArrayList<Point>();
		for (PointSelectorCopyDataPoint point:this._points){
			point.new_index=engine.points.size();
			Point new_point=new Point(point.x+cx,point.y+cy,point.fixed,point.has_collision);
			engine.points.add(new_point);
			engine.point_selector.dragged_points.add(new_point);
		}
		for (PointSelectorCopyDataConnection connection:this._connections){
			Connection new_connection=new Connection(engine.points.get(this._points.get(connection.a).new_index),engine.points.get(this._points.get(connection.b).new_index),connection.length);
			new_connection.set_type(engine,connection.type);
			new_connection.set_extra_data(connection.extra_data.copy());
			engine.connections.add(new_connection);
		}
	}



	void reset(){
		this._points.clear();
		this._connections.clear();
	}
}
