class Util{
	static boolean line_intersection(float ax,float ay,float bx,float by,float cx,float cy,float dx,float dy){
		return Util.is_counterclockwise(ax,ay,cx,cy,dx,dy)!=Util.is_counterclockwise(bx,by,cx,cy,dx,dy)&&Util.is_counterclockwise(ax,ay,bx,by,cx,cy)!=Util.is_counterclockwise(ax,ay,bx,by,dx,dy);
	}



	static float generate_wind_wave(float time){
		return (0.5+sin(time/5))*(0.7+sin(time/0.37))*(0.5+cos(time/4.1));
	}



	static float adjust_curve(float t){
		final float n=5;
		return (n-pow(n,1-t))/(n-1);
	}



	static boolean is_counterclockwise(float ax,float ay,float bx,float by,float cx,float cy){
		return (cy-ay)*(bx-ax)>(by-ay)*(cx-ax);
	}
}



void draw_dashed_line(float sx,float sy,float ex,float ey,float on,float off){
	float dx=ex-sx;
	float dy=ey-sy;
	float length=sqrt(dx*dx+dy*dy);
	dx/=length;
	dy/=length;
	for (float offset=0;offset<length;offset+=on+off){
		float end=offset+on;
		if (end>length){
			end=length;
		}
		line(sx+dx*offset,sy+dy*offset,sx+dx*end,sy+dy*end);
	}
}
