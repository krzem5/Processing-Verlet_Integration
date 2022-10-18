class Ui{
	final Engine engine;
	private PFont _ui_font;



	Ui(Engine engine){
		this.engine=engine;
		this._ui_font=createFont("monospaced",UI_FONT_SIZE);
		String[] fonts=PFont.list();
		for (String font:fonts){
			font=font.toLowerCase();
			if (font.equals("consolas")||font.equals("monospaced")){
				this._ui_font=createFont(font,UI_FONT_SIZE);
				break;
			}
		}
	}



	void draw(){
		textFont(this._ui_font);
		noStroke();
		fill(255,180);
		textAlign(LEFT);
		text("Click (Hold) — Select & Drag\nF — toggle force\nX — toggle collision\n\nC — toggle 'connection' mode\nD — toggle 'break' mode\nS — toggle connection type\nW — toggle wind",10,10+textAscent());
		textAlign(RIGHT);
		text(String.format("Points: %d\nConnections: %d\nWind: %s\nConnecion type: %s\nMode: %s",this.engine.points.size(),this.engine.connections.size(),((this.engine.flags&FLAG_ENABLE_WIND)!=0?"On":"Off"),((this.engine.flags&FLAG_STRONG_BONDS)!=0?"Wood":"String"),((this.engine.flags&FLAG_BREAK_CONNECTIONS)!=0?"Break":(this.engine.flags&FLAG_CREATE_CONNECTIONS)!=0?"Create":"N/A")),width-10,10+textAscent());
	}
}
