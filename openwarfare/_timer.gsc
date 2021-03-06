#include maps\mp\_utility;
#include maps\mp\gametypes\_hud_util;
#include openwarfare\_utils;

init()
{
	// Wait for the game to start
	level waittill("prematch_over");
	
	// Init some variables we'll be using
	level.timerStart = gettime();
	level.timerDiscard = 0;
	
	// Start the thread to monitor timeouts
	level thread monitorTimeOuts();
}


monitorTimeOuts()
{
	level endon("game_ended");
	
	while(1) {
		wait (0.05);
		// Check if we are in timeout mode
		if ( level.inTimeoutPeriod )
			level.timerDiscard += 50;
	}
}

getTimePassed()
{
	if ( level.inReadyUpPeriod ) {
		return gettime();
	}
	else if ( !isDefined( level.timerStart ) ) {
		return 0;
	}
	else {
		return ( gettime() - level.timerStart - level.timerDiscard );
	}
}