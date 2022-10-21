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
		switch (key){
			case CONTROL:
				this.is_ctrl_pressed=true;
				return;
			case SHIFT:
				this.is_shift_pressed=true;
				return;
		}
		if (this.engine.ui.overlay){
			if (64<keyCode&&keyCode<91){
				this.engine.ui.type_key(keyCode+(this.is_shift_pressed?0:32));
			}
			else if (!this.is_shift_pressed&&47<keyCode&&keyCode<58){
				this.engine.ui.type_key(keyCode);
			}
			else if (keyCode==45){
				this.engine.ui.type_key(keyCode+(this.is_shift_pressed?50:0));
			}
			else if (keyCode==BACKSPACE){
				this.engine.ui.remove_key();
			}
			else if (keyCode==ENTER){
				this.engine.ui.end_key();
			}
			return;
		}
		int flag=0;
		switch (key){
			case DELETE:
				this.engine.point_selector.delete();
				return;
			case UP:
				this.engine.point_selector.move(0,-1);
				return;
			case DOWN:
				this.engine.point_selector.move(0,1);
				return;
			case LEFT:
				this.engine.point_selector.move(-1,0);
				return;
			case RIGHT:
				this.engine.point_selector.move(1,0);
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
				flag=(this.is_shift_pressed?FLAG_DRAW_GUIDES:FLAG_DRAW_GRID);
				break;
			case 'O':
				if (this.is_ctrl_pressed){
					this.engine.load("bridge_v2");
				}
				return;
			case 'Q':
				this.engine.point_selector.deselect();
				return;
			case 'S':
				if (this.is_ctrl_pressed){
					if (this.is_shift_pressed){
						this.engine.file_name=null;
					}
					this.engine.save();
					return;
				}
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
			case '=':
				if (this.is_shift_pressed&&(this.engine.flags&FLAG_DRAW_GRID)!=0){
					this.engine.snap_grid.update_size(1);
				}
				return;
			case '-':
				if ((this.engine.flags&FLAG_DRAW_GRID)!=0){
					this.engine.snap_grid.update_size(-1);
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
