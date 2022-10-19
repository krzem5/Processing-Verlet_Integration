class Ui{
	final Engine engine;
	private PFont _ui_font;



	Ui(Engine engine){
		this.engine=engine;
		this._ui_font=createFont((System.getProperty("os.name").toLowerCase().contains("windows")?"consolas":"monospaced"),UI_FONT_SIZE);
	}



	void draw(){
		textFont(this._ui_font);
		noStroke();
		fill(255,180);
		textAlign(LEFT);
		String text="Left Click — select\nRight Click — create & select point\nDrag — move\nShift + Drag — select multiple\n\nF — toggle forces\nX — toggle collision\nShift + F — enable forces\nShift + X — disable collision\n\nC — toggle 'connection' mode\nD — toggle 'break' mode\nE — toggle simulation\nG — toggle grid\nS — toggle connection type\nW — toggle wind";
		if ((this.engine.flags&FLAG_ENABLE_FORCES)==0){
			text+="\nY — recalculate fixed connections";
		}
		text(text,10,10+textAscent());
		textAlign(RIGHT);
		text=String.format("Points: %d\nConnections: %d\nGrid: %s\nWind: %s\nConnecion type: %s\nMode: %s\nSimulation: %s",this.engine.points.size(),this.engine.connections.size(),((this.engine.flags&FLAG_DRAW_GRID)!=0?"On":"Off"),((this.engine.flags&FLAG_ENABLE_WIND)!=0?"On":"Off"),((this.engine.flags&FLAG_STRONG_BONDS)!=0?"Wood":"String"),((this.engine.flags&FLAG_BREAK_CONNECTIONS)!=0?"Break":(this.engine.flags&FLAG_CREATE_CONNECTIONS)!=0?"Create":"N/A"),((this.engine.flags&FLAG_ENABLE_FORCES)!=0?"On":"Off"));
		if (this.engine.point_selector.dragged_point!=null){
			text+=String.format("\n\nForces: %s\nCollision: %s",(this.engine.point_selector.is_dragged_point_fixed()?"Off":"On"),(this.engine.point_selector.dragged_point.has_collision?"On":"Off"));
		}
		else if (this.engine.point_selector.dragged_points!=null){
			text+=String.format("\n\nSelected points: %d",this.engine.point_selector.dragged_points.size());
		}
		text(text,width-10,10+textAscent());
	}
}
