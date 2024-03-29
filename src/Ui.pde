class Ui{
	final Engine engine;
	boolean overlay;
	private PFont _ui_font;
	private PFont _ui_font_large;



	Ui(Engine engine){
		this.engine=engine;
		this.overlay=false;
		this._ui_font=createFont((System.getProperty("os.name").toLowerCase().contains("windows")?"consolas":"monospaced"),UI_FONT_SIZE);
		this._ui_font_large=createFont((System.getProperty("os.name").toLowerCase().contains("windows")?"consolas":"monospaced"),UI_FONT_SIZE*8);
	}



	void get_save_name(){
		this.overlay=true;
		this.engine.file_name="";
	}



	void type_key(int key){
		if (!this.overlay||this.engine.file_name.length()==MAX_FILE_NAME_CHARACTERS){
			return;
		}
		this.engine.file_name+=(char)key;
	}



	void remove_key(){
		if (!this.overlay||this.engine.file_name.length()==0){
			return;
		}
		this.engine.file_name=this.engine.file_name.substring(0,this.engine.file_name.length()-1);
	}



	void end_key(){
		if (!this.overlay){
			return;
		}
		this.overlay=false;
		if (this.engine.file_name.length()==0){
			this.engine.file_name=null;
		}
		else{
			this.engine.save();
		}
	}



	void draw(){
		textFont(this._ui_font);
		String text="<#ffffff>Left Click<!> — select\n<#ffffff>Right Click<!> — create & select point\n<#ffffff>Drag<!> — move";
		if (this.engine.point_selector.dragged_point==null&&this.engine.point_selector.dragged_points==null){
			text+="\n<#ffffff>Shift + Drag<!> — select multiple";
		}
		else if (this.engine.point_selector.dragged_point!=null&&(this.engine.flags&FLAG_DRAW_GRID)!=0){
			text+="\n<#ffffff>Shift + Drag<!> — move & snap to grid";
		}
		text+="\n<#ffffff>Ctrl + Click<!> — toggle another point";
		if (this.engine.point_selector.dragged_point!=null||this.engine.point_selector.dragged_points!=null){
			text+="\n<#ffffff>Left<!>, <#ffffff>Right<!>, <#ffffff>Up<!>, <#ffffff>Down<!> — move all points\n<#ffffff>Q<!> — deselect all points";
		}
		if (this.engine.point_selector.dragged_points!=null){
			text+="\n<#ffffff>Ctrl + Shift + Left<!>, <#ffffff>Ctrl + Shift + Right<!> — rotate -45°, rotate +45°\n<#ffffff>Shift + Left<!>, <#ffffff>Shift + Right<!> — rotate -90°, rotate +90°\n<#ffffff>Shift + Up<!>, <#ffffff>Shift + Down<!> — rotate 180°\n<#ffffff>Ctrl + Left<!>, <#ffffff>Ctrl + Right<!> — flip points horizontally\n<#ffffff>Ctrl + Up<!>, <#ffffff>Ctrl + Down<!> — flip points vertically";
		}
		text+="\n\n<#ffffff>F<!> — toggle forces\n<#ffffff>X<!> — toggle collision\n<#ffffff>Shift + F<!> — enable forces\n<#ffffff>Shift + X<!> — disable collision\n\n<#ffffff>C<!> — toggle 'connection' mode\n<#ffffff>D<!> — toggle 'break' mode\n<#ffffff>E<!> — toggle simulation";
		if ((this.engine.flags&FLAG_ENABLE_FORCES)==0){
			text+="\n<#ffffff>G<!> — toggle grid";
		}
		text+="\n<#ffffff>L<!> — toggle stress breaks";
		if ((this.engine.flags&FLAG_ENABLE_FORCES)!=0){
			text+="\n<#ffffff>M<!> — toggle stress";
		}
		text+="\n<#ffffff>S<!> — toggle connection type\n<#ffffff>W<!> — toggle wind";
		if ((this.engine.flags&FLAG_ENABLE_FORCES)==0){
			text+="\n<#ffffff>Y<!> — recalculate fixed connections\n<#ffffff>Shift + G<!> — toggle guides";
		}
		if ((this.engine.flags&(FLAG_DRAW_GRID|FLAG_ENABLE_FORCES))==FLAG_DRAW_GRID){
			text+="\n\n<#ffffff>+<!> — increase grid size\n<#ffffff>-<!> — decrease grid size";
		}
		text+="\n\n<#ffffff>Ctrl + O<!> — open\n<#ffffff>Ctrl + S<!> — save\n<#ffffff>Ctrl + Shift + S<!> — save as";
		this._write_text(text,10,10+textAscent(),UI_ALIGN_LEFT,0xb4ffffff);
		text=String.format("Points: <#ffffff>%d<!>\nConnections: <#ffffff>%d<!>",this.engine.points.size(),this.engine.connections.size());
		if ((this.engine.flags&FLAG_ENABLE_FORCES)==0){
			text+=String.format("\nGrid: %s<!>\nGuides: %s<!>",((this.engine.flags&FLAG_DRAW_GRID)!=0?"<#ffffff>"+GRID_SIZE_NAMES[this.engine.snap_grid.size]:"<#f34242>Off"),((this.engine.flags&FLAG_DRAW_GUIDES)!=0?"<#42f342>On":"<#f34242>Off"));
		}
		else{
			text+=String.format("\nStress: %s<!>",((this.engine.flags&FLAG_DRAW_STRESS)!=0?"<#42f342>On":"<#f34242>Off"));
		}
		text+=String.format("\nStress breaks: %s<!>\nWind: %s<!>\nConnecion type: %s━━━<!>\nMode: %s<!>\nSimulation: %s<!>",((this.engine.flags&FLAG_ENABLE_STRESS_BREAKS)!=0?"<#42f342>On":"<#f34242>Off"),((this.engine.flags&FLAG_ENABLE_WIND)!=0?"<#42f342>On":"<#f34242>Off"),CONNECTION_TYPE_NAMES[this.engine.connection_type],((this.engine.flags&FLAG_BREAK_CONNECTIONS)!=0?"<#00ffff>Break":(this.engine.flags&FLAG_CREATE_CONNECTIONS)!=0?"<#ffff00>Create":"<#ffffff>N/A"),((this.engine.flags&FLAG_ENABLE_FORCES)!=0?"<#42f342>On":"<#f34242>Off"));
		if (this.engine.point_selector.dragged_point!=null){
			text+=String.format("\n\nForces: %s<!>\nCollision: %s<!>",(this.engine.point_selector.is_dragged_point_fixed()?"<#f34242>Off":"<#42f342>On"),(this.engine.point_selector.dragged_point.has_collision?"<#42f342>On":"<#f34242>Off"));
		}
		else if (this.engine.point_selector.dragged_points!=null){
			text+=String.format("\n\nSelected points: <#ffffff>%d<!>",this.engine.point_selector.dragged_points.size());
		}
		this._write_text(text,width-10,10+textAscent(),UI_ALIGN_RIGHT,0xb4ffffff);
		if (!this.overlay){
			return;
		}
		noStroke();
		fill(0x902a2a2a);
		rect(0,0,width,height);
		fill(0);
		textFont(this._ui_font_large);
		PVector size=_get_text_size("Save as:\n"+(" ").repeat(MAX_FILE_NAME_CHARACTERS));
		rect(width/2-size.x/2-UI_BORDER_SIZE,height/2-size.y/2-UI_BORDER_SIZE,size.x+UI_BORDER_SIZE*2,size.y+UI_BORDER_SIZE*2);
		_write_text("Save as:",width/2,height/2-size.y/2+textAscent(),UI_ALIGN_CENTER,0xffffffff);
		_write_text(this.engine.file_name,width/2-size.x/2,height/2-size.y/2+textAscent()*2+textDescent(),UI_ALIGN_LEFT,0xffffffff);
		stroke(0xffffffff);
		line(width/2-size.x/2,height/2+size.y/2,width/2+size.x/2,height/2+size.y/2);
	}



	private PVector _get_text_size(String text){
		float line_height=textAscent()+textDescent();
		PVector out=new PVector(0,0);
		for (String line:text.split("\\n",-1)){
			float line_width=0;
			int i=0;
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
			if (line_width>out.x){
				out.x=line_width;
			}
			out.y+=line_height;
		}
		return out;
	}



	private PVector _write_text(String text,float x,float y,int align,int color_){
		noStroke();
		fill(color_);
		float line_height=textAscent()+textDescent();
		PVector out=new PVector(0,0);
		for (String line:text.split("\\n",-1)){
			float line_x=x;
			float line_width=0;
			int i=0;
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
			if (line_width>out.x){
				out.x=line_width;
			}
			if (align!=UI_ALIGN_LEFT){
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
						else if (fmt.equals("L")){
							align=UI_ALIGN_LEFT;
						}
						else if (fmt.equals("C")){
							align=UI_ALIGN_CENTER;
						}
						else if (fmt.equals("R")){
							align=UI_ALIGN_RIGHT;
						}
						else if (fmt.equals("!")){
							fill(color_);
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
			y+=line_height;
			out.y+=line_height;
		}
		return out;
	}
}
