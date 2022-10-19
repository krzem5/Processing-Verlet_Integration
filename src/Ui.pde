class Ui{
	final Engine engine;
	private PFont _ui_font;
	private float _line_height;



	Ui(Engine engine){
		this.engine=engine;
		this._ui_font=createFont((System.getProperty("os.name").toLowerCase().contains("windows")?"consolas":"monospaced"),UI_FONT_SIZE);
		textFont(this._ui_font);
		this._line_height=textAscent()+textDescent();
	}



	void draw(){
		String text="<#ffffff>Left Click<!> — select\n<#ffffff>Right Click<!> — create & select point\n<#ffffff>Drag<!> — move\n<#ffffff>Shift + Drag<!> — select multiple\n\n<#ffffff>F<!> — toggle forces\n<#ffffff>X<!> — toggle collision\n<#ffffff>Shift + F<!> — enable forces\n<#ffffff>Shift + X<!> — disable collision\n\n<#ffffff>C<!> — toggle 'connection' mode\n<#ffffff>D<!> — toggle 'break' mode\n<#ffffff>E<!> — toggle simulation\n<#ffffff>G<!> — toggle grid\n<#ffffff>S<!> — toggle connection type\n<#ffffff>W<!> — toggle wind";
		if ((this.engine.flags&FLAG_ENABLE_FORCES)==0){
			text+="\n<#ffffff>Y<!> — recalculate fixed connections";
		}
		this.write_text(text,10,10+textAscent(),UI_ALIGN_LEFT);
		text=String.format("Points: <#ffffff>%d<!>\nConnections: <#ffffff>%d<!>\nGrid: %s<!>\nWind: %s<!>\nConnecion type: %s<!>\nMode: %s<!>\nSimulation: %s<!>",this.engine.points.size(),this.engine.connections.size(),((this.engine.flags&FLAG_DRAW_GRID)!=0?"<#42f342>On":"<#f34242>Off"),((this.engine.flags&FLAG_ENABLE_WIND)!=0?"<#42f342>On":"<#f34242>Off"),((this.engine.flags&FLAG_STRONG_BONDS)!=0?"Wood <#ff8e8e>━━━":"String <#9e9e9e>━━━"),((this.engine.flags&FLAG_BREAK_CONNECTIONS)!=0?"<#00ffff>Break":(this.engine.flags&FLAG_CREATE_CONNECTIONS)!=0?"<#ffff00>Create":"<#ffffff>N/A"),((this.engine.flags&FLAG_ENABLE_FORCES)!=0?"<#42f342>On":"<#f34242>Off"));
		if (this.engine.point_selector.dragged_point!=null){
			text+=String.format("\n\nForces: %s<!>\nCollision: %s<!>",(this.engine.point_selector.is_dragged_point_fixed()?"<#f34242>Off":"<#42f342>On"),(this.engine.point_selector.dragged_point.has_collision?"<#42f342>On":"<#f34242>Off"));
		}
		else if (this.engine.point_selector.dragged_points!=null){
			text+=String.format("\n\nSelected points: <#ffffff>%d<!>",this.engine.point_selector.dragged_points.size());
		}
		this.write_text(text,width-10,10+textAscent(),UI_ALIGN_RIGHT);
	}



	private void write_text(String text,float x,float y,int align){
		textFont(this._ui_font);
		noStroke();
		fill(0xb4ffffff);
		for (String line:text.split("\n")){
			float line_x=x;
			float line_width=0;
			int i=0;
			if (align!=UI_ALIGN_LEFT){
				while (i<line.length()){
					char c=line.charAt(i);
					if (c=='<'){
						int j=line.indexOf('>',i);
						if (j!=-1){
							i=j;
						}
					}
					else{
						line_width+=textWidth(c);
					}
					i++;
				}
				line_x-=line_width*(align==UI_ALIGN_CENTER?0.5:1);
			}
			i=0;
			while (i<line.length()){
				char c=line.charAt(i);
				if (c=='<'){
					int j=line.indexOf('>',i);
					if (j!=-1){
						String fmt=line.substring(i+1,j);
						if (fmt.charAt(0)=='#'&&fmt.length()==7){
							fill(Integer.parseInt(fmt,1,7,16)|0xff000000);
						}
						else if (fmt.equals("!")){
							fill(0xb4ffffff);
						}
						else{
							println("Unknown format code: "+fmt);
						}
						i=j;
					}
				}
				else{
					text(c,line_x,y);
					line_x+=textWidth(c);
				}
				i++;
			}
			y+=this._line_height;
		}
	}
}
