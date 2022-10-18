class Util{
	static boolean line_intersection(float ax,float ay,float bx,float by,float cx,float cy,float dx,float dy){
		return Util._is_counterclockwise(ax,ay,cx,cy,dx,dy)!=Util._is_counterclockwise(bx,by,cx,cy,dx,dy)&&Util._is_counterclockwise(ax,ay,bx,by,cx,cy)!=Util._is_counterclockwise(ax,ay,bx,by,dx,dy);
	}



	static float generate_wind_wave(float time){
		return (0.5+sin(time/5000))*(0.7+sin(time/370))*(0.5+cos(time/4100));
	}



	private static boolean _is_counterclockwise(float ax,float ay,float bx,float by,float cx,float cy){
		return (cy-ay)*(bx-ax)>(by-ay)*(cx-ax);
	}
}
