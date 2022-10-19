class KeyboardHandler{
	final Engine engine;



	KeyboardHandler(Engine engine){
		this.engine=engine;
	}



	void update(int key){
		int flag=0;
		switch (key){
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
				if (this.engine.point_selector.dragged_point!=null){
					this.engine.point_selector.toggle_dragged_point_fixed();
				}
				return;
			case 'S':
				flag=FLAG_STRONG_BONDS;
				break;
			case 'W':
				flag=FLAG_ENABLE_WIND;
				break;
			case 'X':
				if (this.engine.point_selector.dragged_point!=null){
					this.engine.point_selector.dragged_point.has_collision=!this.engine.point_selector.dragged_point.has_collision;
				}
				return;
		}
		if ((flag&this.engine.flags)!=0){
			this.engine.flags&=~flag;
		}
		else{
			this.engine.flags|=flag;
		}
	}
}



void keyPressed(){
	engine.keyboard_handler.update(keyCode);
}
