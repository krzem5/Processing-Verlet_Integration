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
	}



	void paste(Engine engine,float cx,float cy){
		for (PointSelectorCopyDataPoint point:this._points){
			point.new_index=engine.points.size();
			engine.points.add(new Point(point.x+cx,point.y+cy,point.fixed,point.has_collision));
		}
		for (PointSelectorCopyDataConnection connection:this._connections){
			Connection new_connection=new Connection(engine.points.get(this._points.get(connection.a).new_index),engine.points.get(this._points.get(connection.b).new_index),connection.length);
			new_connection.set_type(engine,CONNECTION_TYPE_WOOD);
			engine.connections.add(new_connection);
		}
	}



	void reset(){
		this._points.clear();
		this._connections.clear();
	}
}
