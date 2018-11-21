%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
% constraints.pl
%
% Vehicle path planner module constraint definitions
%
% Stav Rockah, Roman Smirnov
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% temporal resolution is 0.1 seconds per search graph transition
time_step(1).

% speed limit in m/s (meter per second)
max_velocity(22.352).

% maximum acceleration in m/s^2 
max_acceleration(10.0).

% motion jerk in m/s^3 (it's a measure of acceleration 'smoothness')
max_jerk(50.0).

% coordinates are assumed to be in Frenet reference frame
valid_position(CUR_POS_X, CUR_POS_Y, POS_X, POS_Y) :-
    % position is discrete (1m resolution, accuracy of +-0.5m).
    % integer(POS_X), integer(POS_Y),
    % vehicle is between road center separator and left edge
    
    ((CUR_POS_X-1 > 2, MIN_X is CUR_POS_X-1); MIN_X is 2),
    ((CUR_POS_X+1 < 10, MAX_X is CUR_POS_X+1); MAX_X is 10),
    ((CUR_POS_Y-10 > 0, MIN_Y is CUR_POS_Y-10); MIN_Y is 0),
    ((CUR_POS_Y+100 < 6946, MAX_Y is CUR_POS_Y+100); MAX_Y is 6946),
    range(POS_X,MIN_X,MAX_X), 	
	range(POS_Y,MIN_Y,MAX_Y).

% distance (and direction) between positions
displacement(CUR_POS_X, CUR_POS_Y, NEXT_POS_X, NEXT_POS_Y, DISP_X, DISP_Y) :-
    DISP_X is NEXT_POS_X - CUR_POS_X,
    DISP_Y is NEXT_POS_Y - CUR_POS_Y.

range(Low, Low, _).
range(Out,Low,High) :- NewLow is Low+1, NewLow =< High, range(Out, NewLow, High).

% average velocity between positions
velocity(DISP_X, DISP_Y, VEL_X, VEL_Y) :-
    time_step(TIME_STEP),
    VEL_X is DISP_X*TIME_STEP,
    VEL_Y is DISP_Y*TIME_STEP.

% average change in velocity during transition
acceleration(CUR_VEL_X, CUR_VEL_Y, NEXT_VEL_X, NEXT_VEL_Y, ACCL_X, ACCL_Y) :-
    time_step(TIME_STEP),
    ACCL_X is (NEXT_VEL_X - CUR_VEL_X)*TIME_STEP,
    ACCL_Y is (NEXT_VEL_Y - CUR_VEL_Y)*TIME_STEP. 

% average change in acceleration during transition
jerk(CUR_ACCL_X, CUR_ACCL_Y, NEXT_ACCL_X, NEXT_ACCL_Y, JERK_X, JERK_Y) :-
    time_step(TIME_STEP),
    JERK_X is (NEXT_ACCL_X - CUR_ACCL_X)*TIME_STEP,
    JERK_Y is (NEXT_ACCL_Y - CUR_ACCL_Y)*TIME_STEP.

% velocity constraints DISP_X - distance in x
valid_velocity(DISP_X, DISP_Y, VEL_X, VEL_Y) :- 
    velocity(DISP_X, DISP_Y, VEL_X, VEL_Y),
    max_velocity(MAX_VEL),
    VEL_Y > 0, VEL_Y < MAX_VEL,
    VEL_X >= -VEL_Y/2, VEL_X =< VEL_Y/2. 

% acceleration constraints
valid_acceleration(CUR_VEL_X, CUR_VEL_Y, NEXT_VEL_X, NEXT_VEL_Y, NEXT_ACCL_X, NEXT_ACCL_Y) :-
    acceleration(CUR_VEL_X, CUR_VEL_Y, NEXT_VEL_X, NEXT_VEL_Y, NEXT_ACCL_X, NEXT_ACCL_Y),
    max_acceleration(MAX_ACCL),
    NEXT_ACCL_Y < MAX_ACCL, NEXT_ACCL_Y > -MAX_ACCL,
    NEXT_ACCL_X =< NEXT_ACCL_Y/2, NEXT_ACCL_X >= -NEXT_ACCL_Y/2.

% jerk constraints
valid_jerk(CUR_ACCL_X, CUR_ACCL_Y, NEXT_ACCL_X, NEXT_ACCL_Y) :-
    jerk(CUR_ACCL_X, CUR_ACCL_Y, NEXT_ACCL_X, NEXT_ACCL_Y, JERK_X, JERK_Y),
    max_jerk(MAX_JERK), 
    JERK_Y < MAX_JERK, JERK_Y > -MAX_JERK,
    JERK_X =< JERK_Y/2, JERK_X >= -JERK_Y/2.

% overall transition constraints
valid_transition(CUR_POS_X, CUR_POS_Y, CUR_VEL_X, CUR_VEL_Y, CUR_ACCL_X, CUR_ACCL_Y,
                 NEXT_POS_X, NEXT_POS_Y, NEXT_VEL_X, NEXT_VEL_Y,NEXT_ACCL_X, NEXT_ACCL_Y, CARS_LIST):-
    valid_position(CUR_POS_X, CUR_POS_Y, NEXT_POS_X, NEXT_POS_Y),
    displacement(CUR_POS_X, CUR_POS_Y, NEXT_POS_X, NEXT_POS_Y, DISP_X, DISP_Y),
    valid_velocity(DISP_X, DISP_Y, NEXT_VEL_X, NEXT_VEL_Y), 
    valid_acceleration(CUR_VEL_X, CUR_VEL_Y, NEXT_VEL_X, NEXT_VEL_Y, NEXT_ACCL_X, NEXT_ACCL_Y),
    valid_jerk(CUR_ACCL_X, CUR_ACCL_Y, NEXT_ACCL_X, NEXT_ACCL_Y),
    \+ is_car_position(NEXT_POS_X, NEXT_POS_Y,CARS_LIST).

is_car_position(DISP_X,DISP_Y,[[X_CAR,Y_CAR]|CARS_LIST]) :-
    (DISP_X is X_CAR, 
    DISP_Y is Y_CAR);
    is_car_position(DISP_X,DISP_Y,CARS_LIST).

is_car_position(DISP_X,DISP_Y,CARS_LIST):- \+.
