class KeyboardHandler{
	final Engine engine;
	boolean is_ctrl_pressed;
	boolean is_shift_pressed;



	KeyboardHandler(Engine engine){
		this.engine=engine;
		this.is_ctrl_pressed=false;
		this.is_shift_pressed=false;
	}



	void press(int key){
		int flag=0;
		switch (key){
			case CONTROL:
				this.is_ctrl_pressed=true;
				return;
			case SHIFT:
				this.is_shift_pressed=true;
				return;
			case DELETE:
				this.engine.point_selector.delete();
				return;
			case 'C':
				flag=FLAG_CREATE_CONNECTIONS;
				this.engine.flags&=~FLAG_BREAK_CONNECTIONS;
				break;
			case 'D':
				flag=FLAG_BREAK_CONNECTIONS;
				this.engine.flags&=~FLAG_CREATE_CONNECTIONS;
				break;
			case 'E':
				flag=FLAG_ENABLE_FORCES;
				break;
			case 'F':
				this.engine.point_selector.toggle_forces(this.is_shift_pressed);
				return;
			case 'G':
				flag=FLAG_DRAW_GRID;
				break;
			case 'S':
				flag=FLAG_STRONG_BONDS;
				break;
			case 'W':
				flag=FLAG_ENABLE_WIND;
				break;
			case 'X':
				this.engine.point_selector.toggle_collision(this.is_shift_pressed);
				return;
			case 'Y':
				if ((this.engine.flags&FLAG_ENABLE_FORCES)==0){
					for (Connection c:this.engine.connections){
						if (c.a.fixed&&c.b.fixed){
							c.length=sqrt((c.a.x-c.b.x)*(c.a.x-c.b.x)+(c.a.y-c.b.y)*(c.a.y-c.b.y));
						}
					}
				}
				return;
			case 'O':
				this.engine.save("data.json");
				return;
			case 'P':
				this.engine.load("data.json");
				return;
		}
		if ((flag&this.engine.flags)!=0){
			this.engine.flags&=~flag;
		}
		else{
			this.engine.flags|=flag;
		}
	}



	void release(int key){
		switch (key){
			case CONTROL:
				this.is_ctrl_pressed=false;
				return;
			case SHIFT:
				this.is_shift_pressed=false;
				return;
		}
	}
}



void keyPressed(){
	engine.keyboard_handler.press(keyCode);
}
void keyReleased(){
	engine.keyboard_handler.release(keyCode);
}
