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
				if (!this.is_shift_pressed&&!this.is_ctrl_pressed){
					this.engine.point_selector.move(0,-1);
				}
				else if (this.is_ctrl_pressed){
					this.engine.point_selector.flip_vertically();
				}
				else if (this.is_shift_pressed){
					this.engine.point_selector.rotate(PI);
				}
				return;
			case DOWN:
				if (!this.is_shift_pressed&&!this.is_ctrl_pressed){
					this.engine.point_selector.move(0,1);
				}
				else if (this.is_ctrl_pressed){
					this.engine.point_selector.flip_vertically();
				}
				else if (this.is_shift_pressed){
					this.engine.point_selector.rotate(PI);
				}
				return;
			case LEFT:
				if (this.is_ctrl_pressed){
					if (this.is_shift_pressed){
						this.engine.point_selector.rotate(-PI/4);
					}
					else{
						this.engine.point_selector.flip_horizontally();
					}
				}
				else if (this.is_shift_pressed){
					this.engine.point_selector.rotate(-PI/2);
				}
				else{
					this.engine.point_selector.move(-1,0);
				}
				return;
			case RIGHT:
				if (this.is_ctrl_pressed){
					if (this.is_shift_pressed){
						this.engine.point_selector.rotate(PI/4);
					}
					else{
						this.engine.point_selector.flip_horizontally();
					}
				}
				else if (this.is_shift_pressed){
					this.engine.point_selector.rotate(PI/2);
				}
				else{
					this.engine.point_selector.move(1,0);
				}
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
				if ((this.engine.flags&FLAG_ENABLE_FORCES)!=0){
					return;
				}
				flag=(this.is_shift_pressed?FLAG_DRAW_GUIDES:FLAG_DRAW_GRID);
				break;
			case 'L':
				flag=FLAG_ENABLE_STRESS_BREAKS;
				break;
			case 'M':
				if ((this.engine.flags&FLAG_ENABLE_FORCES)==0){
					return;
				}
				flag=FLAG_DRAW_STRESS;
				break;
			case 'O':
				if (this.is_ctrl_pressed){
					this.engine.load(DEFUALT_OPEN_FILE_PATH);
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
				}
				else{
					if (this.engine.connection_type==CONNECTION_MAX_TYPE){
						this.engine.connection_type=0;
					}
					else{
						this.engine.connection_type++;
					}
				}
				return;
			case 'W':
				flag=FLAG_ENABLE_WIND;
				break;
			case 'X':
				this.engine.point_selector.toggle_collision(this.is_shift_pressed);
				return;
			case 'Y':
				if ((this.engine.flags&FLAG_ENABLE_FORCES)==0){
					for (Connection c:this.engine.connections){
						c.recalculate_distance();
					}
				}
				return;
			case '=':
				if (this.is_shift_pressed&&(this.engine.flags&FLAG_DRAW_GRID)!=0){
					this.engine.snap_grid.update_size(1);
				}
				return;
			case '-':
				if (!this.is_shift_pressed&&(this.engine.flags&FLAG_DRAW_GRID)!=0){
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
