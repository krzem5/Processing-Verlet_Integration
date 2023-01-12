class ExtraConnectionData{
	float raw_length;
	float piston_time;
	float piston_offset;
	float piston_length_multiplier;
	float piston_extended_time;
	float piston_retracted_time;
	float piston_movement_time;
	float spring_strength;



	ExtraConnectionData(float length){
		this.raw_length=length;
		this.piston_time=0;
		this.piston_offset=0;
		this.piston_length_multiplier=2.5;
		this.piston_extended_time=1.5;
		this.piston_retracted_time=0.5;
		this.piston_movement_time=1;
		this.spring_strength=1;
	}



	ExtraConnectionData copy(){
		ExtraConnectionData out=new ExtraConnectionData(this.raw_length);
		out.piston_time=this.piston_time;
		out.piston_offset=this.piston_offset;
		out.piston_length_multiplier=this.piston_length_multiplier;
		out.piston_extended_time=this.piston_extended_time;
		out.piston_retracted_time=this.piston_retracted_time;
		out.piston_movement_time=this.piston_movement_time;
		out.spring_strength=this.spring_strength;
		return out;
	}
}
