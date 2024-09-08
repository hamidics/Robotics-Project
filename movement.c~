/* helloworld.c for TOPPERS/ATK(OSEK) */ 
#include "kernel.h"
#include "kernel_id.h"
#include "ecrobot_interface.h"


/* OSEK declarations */

DeclareTask(OSEK_Task_Background);
//DeclareTask(Move_forward);

void user_1ms_isr_type2(void){ /* do nothing */ }

/* NXT motor port configuration */
#define PORT_MOTOR_R NXT_PORT_B
#define PORT_MOTOR_L NXT_PORT_C

/* NXT sensor port configuration */
#define PORT_SONAR   NXT_PORT_S3

/* NXT light sensor port configuration */
#define PORT_LIGHT_R   NXT_PORT_S1
#define PORT_LIGHT_L   NXT_PORT_S4

/* NXT motor spedd */
#define MOTOR_SPEED 50   
int MOTOR_SPEED_R = MOTOR_SPEED;
int MOTOR_SPEED_L = MOTOR_SPEED;

/* NXT sensor port configuration */
#define PORT_SONAR   NXT_PORT_S3
#define MIN_DISTANCE (20)    /* minimum distance in cm for obstacle avoidance */

int grid[6][6];
int direction;

void initialize_grid(){
	int i,j;
	for( i = 0; i< 6; i++){
		for( j= 0; j<6; j++){
			grid[i][j] = 0;
		}
	} 
	//set starting position
	grid[0][0] = 1;
	//direction: 0: right; 1: up; 2: left; 3: down
	direction = 0;
}

int get_i_pos(){
	int i,j;
	for( i = 0; i< 6; i++){
		for( j= 0; j<6; j++){
			if(grid[i][j] == 1) return i;
		}
	}
	return -2;
}

int get_j_pos(){
	int i,j;
	for( i = 0; i< 6; i++){
		for( j= 0; j<6; j++){
			if(grid[i][j] == 1) return j;
		}
	}
	return -1;
}

void display_position(){
	display_clear(0);	
	display_string("\nPosition: ");
	display_int(get_i_pos(),0);	
	display_string(",");
	display_int(get_j_pos(),0);
	display_string("\nDirection: ");
	display_int(direction,0);	
	display_update();

	systick_wait_ms(200);

}

void update_position(){
	int pos_i = get_i_pos();
	int pos_j = get_j_pos();
	grid[pos_i][pos_j] = 0;

	switch(direction) {
	case 0: grid[pos_i+1][pos_j]   = 1; break;
	case 1: grid[pos_i]  [pos_j+1] = 1; break;
	case 2: grid[pos_i-1][pos_j ]  = 1; break;
	case 3: grid[pos_i]  [pos_j-1] = 1; break;
	}
	
	display_position();
}

int check_boundary(){
	int pos_i = get_i_pos();
	int pos_j = get_j_pos();
	
	if((direction == 0) && (pos_i+1 > 5)) return -1;
	if((direction == 1) && (pos_j+1 > 5)) return -1;
	if((direction == 2) && (pos_i-1 < 0)) return -1;
	if((direction == 3) && (pos_j-1 < 0)) return -1;

	return 0;
}

void ecrobot_device_initialize()
{
	ecrobot_init_sonar_sensor(PORT_SONAR) ;
	ecrobot_set_light_sensor_active(PORT_LIGHT_R);
	ecrobot_set_light_sensor_active(PORT_LIGHT_L);
	/*ecrobot_init_compass_sensor(NXT_PORT_S3); */
}

void move_forward(){
	nxt_motor_set_speed( PORT_MOTOR_L,MOTOR_SPEED_L,1);
	nxt_motor_set_speed( PORT_MOTOR_R,MOTOR_SPEED_R,1);
}

void move_stop(){
	nxt_motor_set_speed( PORT_MOTOR_L,0,1);
	nxt_motor_set_speed( PORT_MOTOR_R,0,1);
}

// Manage directioni with light sensor
void direction_management(){
	int lightLeft =ecrobot_get_light_sensor(PORT_LIGHT_L);
	int lightRight=ecrobot_get_light_sensor(PORT_LIGHT_R);
	
	//Check the left and right light sensor if it reached the line

	//left wheel didnt reach the line
	if(lightLeft < 500){ 
		//nxt_motor_set_speed( PORT_MOTOR_R,MOTOR_SPEED-(MOTOR_SPEED/10),1);
		nxt_motor_set_speed( PORT_MOTOR_R,-MOTOR_SPEED_R,1);
		nxt_motor_set_count( PORT_MOTOR_L, 0);
		//wait till left wheel reaches the line
		while(1){
			if(ecrobot_get_light_sensor(PORT_LIGHT_L) >= 500) break;		
		}
		move_stop();
		// -- DISPLAY --
		//display_clear(0);	
		//display_string("count is: ");
		//display_int(nxt_motor_get_count(PORT_MOTOR_L),0);
		
		int difference = nxt_motor_get_count(PORT_MOTOR_L);
		//lower the speed of the faster wheel
		int new_speed = MOTOR_SPEED - (MOTOR_SPEED *((float)difference / 600));
		
		/* --DISPLAY--
		display_string("difference:");
		display_int(difference,0);
		display_string("\n new speed: ");
		display_int(new_speed,0);
		*/
		
		//nxt_motor_set_speed( PORT_MOTOR_R,new_speed,1);
		MOTOR_SPEED_R = new_speed;

		//display_update();
		systick_wait_ms(1000);
	}
	//right wheel didnt reach the line
	if(lightRight < 500){
		nxt_motor_set_speed( PORT_MOTOR_L,-MOTOR_SPEED_L,1);
		nxt_motor_set_count( PORT_MOTOR_R, 0);
		//wait till left wheel reaches the line
		while(1){
			if(ecrobot_get_light_sensor(PORT_LIGHT_R) >= 500) break;		
		}
		move_stop();
		// -- DISPLAY --
		//display_clear(0);	
		//display_string("count is: ");
		//display_int(nxt_motor_get_count(PORT_MOTOR_L),0);
		
		int difference = nxt_motor_get_count(PORT_MOTOR_R);
		//lower the speed of the faster wheel
		int new_speed = MOTOR_SPEED - (MOTOR_SPEED *((float)difference / 600));
		
		/* --DISPLAY--
		display_string("difference:");
		display_int(difference,0);
		display_string("\n new speed: ");
		display_int(new_speed,0);
		*/
		
		//nxt_motor_set_speed( PORT_MOTOR_L,new_speed,1);
		MOTOR_SPEED_L = new_speed;

		//display_update();
		systick_wait_ms(200);	
	}
}

void move_forward_one_grid()
{
	
	if(check_boundary() == -1){
		ecrobot_sound_tone(500,300,100);
		return;
	} 

	move_forward();
	

	//move forward till black line
	while(1){
		int lightLeft =ecrobot_get_light_sensor(PORT_LIGHT_L);
		int lightRight=ecrobot_get_light_sensor(PORT_LIGHT_R);


		//robot reached black line
		if (lightLeft > 500 || lightRight >500) break;
	}
	direction_management();
	move_forward();
	nxt_motor_set_count( PORT_MOTOR_L, 0);
			while(1)
			{
				if(nxt_motor_get_count(PORT_MOTOR_L) >= 450)
				{
					nxt_motor_set_speed( PORT_MOTOR_L,0,1);
					nxt_motor_set_speed( PORT_MOTOR_R,0,1);
					break;
					
				}
				//Check if robot is drifiting into another grid
				if((nxt_motor_get_count(PORT_MOTOR_L) >= 50) & 
				 (ecrobot_get_light_sensor(PORT_LIGHT_L) > 500 ||
				 ecrobot_get_light_sensor(PORT_LIGHT_R) > 500)){
					move_stop();
					ecrobot_sound_tone(500,300,100);
					break;
				
				}
			}
	systick_wait_ms(200);
	update_position();
	move_stop();

}

void rotate_left(){
	//ecrobot_status_monitor("Turning Left");
	nxt_motor_set_speed( PORT_MOTOR_R, MOTOR_SPEED,1);
	nxt_motor_set_speed( PORT_MOTOR_L,-MOTOR_SPEED,1);
	nxt_motor_set_count( PORT_MOTOR_R, 0);	
	while(1){
		if(nxt_motor_get_count(PORT_MOTOR_R) > 170)
		{
			//ecrobot_status_monitor("Stop");
			nxt_motor_set_speed( PORT_MOTOR_R,0,1);
			nxt_motor_set_speed( PORT_MOTOR_L,0,1);
			break;
		}
	}
	systick_wait_ms(200);
	if(direction == 3) direction = 0;
	else direction++;
}

void rotate_right(){
	//ecrobot_status_monitor("Turning Right");
	nxt_motor_set_speed( PORT_MOTOR_R,-MOTOR_SPEED,1);
	nxt_motor_set_speed( PORT_MOTOR_L, MOTOR_SPEED,1);
	nxt_motor_set_count( PORT_MOTOR_L, 0);	
	while(1){
		if(nxt_motor_get_count(PORT_MOTOR_L) > 170)
		{
			//ecrobot_status_monitor("Stop");
			nxt_motor_set_speed( PORT_MOTOR_R,0,1);
			nxt_motor_set_speed( PORT_MOTOR_L,0,1);
			break;
		}
	}
	systick_wait_ms(200);
	if(direction == 0) direction = 3;
	else direction--;

}

void move_back(){
	rotate_right();
	rotate_right();
	move_forward();
}

// find the obstalce. check the return value if it is 1 obstacle exists. 
int sonar_sensor_found()
{
	int return_value;
	if (ecrobot_get_sonar_sensor(PORT_SONAR) <= MIN_DISTANCE)
		return_value=1;		
	else 
		return_value=0;	
	return  return_value;
}


TASK(OSEK_Task_Background)
{
	
	initialize_grid();
	

	move_forward_one_grid();
	move_forward_one_grid();
	move_forward_one_grid();
	move_forward_one_grid();
	move_forward_one_grid();
	move_forward_one_grid();
	move_forward_one_grid();
	rotate_left();
	move_forward_one_grid();
	move_forward_one_grid();
	rotate_right();
	rotate_right();
	move_forward_one_grid();
	rotate_left();
	move_forward_one_grid();
	move_forward_one_grid();
	rotate_left();	
	move_forward_one_grid();
	rotate_right();
	move_forward_one_grid();
	rotate_right();
	move_forward_one_grid();	
	move_forward_one_grid();
	rotate_right();
	move_forward_one_grid();	
	move_forward_one_grid();
	move_forward_one_grid();	
	move_forward_one_grid();
	move_forward_one_grid();
	
	//rotate_right();
	//move_forward_one_grid();

	TerminateTask();
}


void ecrobot_device_terminate() {
	ecrobot_set_light_sensor_inactive(NXT_PORT_S1) ;
	ecrobot_term_sonar_sensor(NXT_PORT_S3) ;
	ecrobot_set_light_sensor_inactive(NXT_PORT_S4) ;
}

