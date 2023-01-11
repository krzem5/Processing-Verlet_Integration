class Util{
	static boolean line_intersection(float ax,float ay,float bx,float by,float cx,float cy,float dx,float dy){
		return Util.is_counterclockwise(ax,ay,cx,cy,dx,dy)!=Util.is_counterclockwise(bx,by,cx,cy,dx,dy)&&Util.is_counterclockwise(ax,ay,bx,by,cx,cy)!=Util.is_counterclockwise(ax,ay,bx,by,dx,dy);
	}



	static PVector line_intersection_point(float ax,float ay,float bx,float by,float cx,float cy,float dx,float dy){
		float m=1/((ax-bx)*(cy-dy)-(ay-by)*(cx-dx));
		if (m==0){
			return null;
		}
		float t=((ax-cx)*(cy-dy)-(ay-cy)*(cx-dx))*m;
		float u=((ax-cx)*(ay-by)-(ay-cy)*(ax-bx))*m;
		if (t<0||t>1||u<0||u>1){
			return null;
		}
		return new PVector(ax+t*(bx-ax),ay+t*(by-ay));
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
