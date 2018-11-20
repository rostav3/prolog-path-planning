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
time_step(0.1).

% speed limit in m/s (meter per second)
max_velocity(22.352).

% maximum acceleration in m/s^2 
max_acceleration(10.0).

% motion jerk in m/s^3 (it's a measure of acceleration 'smoothness')
max_jerk(50.0).

% coordinates are assumed to be in Frenet reference frame
valid_position(POS_X, POS_Y) :-
    % position is discrete (1m resolution, accuracy of +-0.5m).
    % integer(POS_X), integer(POS_Y),
    % vehicle is between road center separator and left edge
    POS_X >= 2, POS_X =< 10,
    % vehicle is within defined highway segment 
    POS_Y >= 0, POS_Y =< 6946.

% distance (and direction) between positions
displacement(CUR_POS_X, CUR_POS_Y, NEXT_POS_X, NEXT_POS_Y, DISP_X, DISP_Y) :-
    DISP_X = NEXT_POS_X - CUR_POS_X,
    DISP_Y = NEXT_POS_Y - CUR_POS_Y.

% average velocity between positions
velocity(DISP_X, DISP_Y, VEL_X, VEL_Y) :-
    time_step(TIME_STEP),
    VEL_X = DISP_X/TIME_STEP,
    VEL_Y = DISP_Y/TIME_STEP.

% average change in velocity during transition
acceleration(CUR_VEL_X, CUR_VEL_Y, NEXT_VEL_X, NEXT_VEL_Y, ACCL_X, ACCL_Y) :-
    time_step(TIME_STEP),
    ACCL_X = (NEXT_VEL_X - CUR_VEL_X)/TIME_STEP,
    ACCL_Y = (NEXT_VEL_Y - CUR_VEL_Y)/TIME_STEP. 

% average change in acceleration during transition
jerk(CUR_ACCL_X, CUR_ACCL_Y, NEXT_ACCL_X, NEXT_ACCL_Y, JERK_X, JERK_Y) :-
    time_step(TIME_STEP),
    JERK_X = (NEXT_ACCL_X - CUR_ACCL_X)/TIME_STEP,
    JERK_Y = (NEXT_ACCL_Y - CUR_ACCL_Y)/TIME_STEP.

% velocity constraints
valid_velocity(DISP_X, DISP_Y, VEL_X, VEL_Y) :- 
    velocity(DISP_X, DISP_Y, VEL_X, VEL_Y),
    max_velocity(MAX_VEL),
    VEL_Y > 0, VEL_Y < MAX_VEL,
    VEL_X > -VEL_Y/2, VEL_X < VEL_Y/2. 

% acceleration constraints
valid_acceleration(CUR_VEL_X, CUR_VEL_Y, NEXT_VEL_X, NEXT_VEL_Y, NEXT_ACCL_X, NEXT_ACCL_Y) :-
    acceleration(CUR_VEL_X, CUR_VEL_Y, NEXT_VEL_X, NEXT_VEL_Y, NEXT_ACCL_X, NEXT_ACCL_Y),
    max_acceleration(MAX_ACCL),
    NEXT_ACCL_Y < MAX_ACCL, NEXT_ACCL_Y > -MAX_ACCL,
    NEXT_ACCL_X < ACCL_Y/2, NEXT_ACCL_X > -ACCL_Y/2.

% jerk constraints
valid_jerk(CUR_ACCL_X, CUR_ACCL_Y, NEXT_ACCL_X, NEXT_ACCL_Y) :-
    jerk(CUR_ACCL_X, CUR_ACCL_Y, NEXT_ACCL_X, NEXT_ACCL_Y, JERK_X, JERK_Y),
    max_jerk(MAX_JERK), 
    JERK_Y < MAX_JERK, JERK_Y > -MAX_JERK,
    JERK_X < JERK_Y/2, JERK_X > -JERK_Y/2.

% overall transition constraints
valid_transition(CUR_POS_X, CUR_POS_Y, CUR_VEL_X, CUR_VEL_Y, CUR_ACCL_X, CUR_ACCL_Y) :-
    valid_position(NEXT_POS_X, NEXT_POS_Y),
    displacement(CUR_POS_X, CUR_POS_Y, NEXT_POS_X, NEXT_POS_Y, DISP_X, DISP_Y),
    valid_velocity(NEXT_VEL_X, NEXT_VEL_Y, DISP_X, DISP_Y), 
    valid_acceleration(CUR_VEL_X, CUR_VEL_Y, NEXT_VEL_X, NEXT_VEL_Y, NEXT_ACCL_X, NEXT_ACCL_Y),
    valid_jerk(CUR_ACCL_X, CUR_ACCL_Y, NEXT_ACCL_X, NEXT_ACCL_Y).

    
    