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
			case 'F':
				if (this.engine.dragged_point!=null){
					this.engine._dragged_point_was_fixed=!this.engine._dragged_point_was_fixed;
				}
				return;
			case 'S':
				flag=FLAG_STRONG_BONDS;
				break;
			case 'W':
				flag=FLAG_ENABLE_WIND;
				break;
			case 'X':
				if (this.engine.dragged_point!=null){
					this.engine.dragged_point.has_collision=!this.engine.dragged_point.has_collision;
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
