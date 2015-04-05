//
//  ScheduleAlarm.m
//  ShabbatClock
//
//  Created by Yehuda Cohen on 6/23/14.
//  Copyright (c) 2014 Yehuda Cohen. All rights reserved.
//

#import "AlarmManager.h"

@interface AlarmManager () <UIAlertViewDelegate>

@property (assign, nonatomic) int elapsedTime;
@property (strong, nonatomic) UIAlertView *alertAlarm;
@property (strong, nonatomic) NSTimer *timer;


@end

@implementation AlarmManager

CWL_SYNTHESIZE_SINGLETON_FOR_CLASS(AlarmManager);

-(id)init{
	self = [super init];
    if (self) {
		self.alertAlarm = [[UIAlertView alloc] initWithTitle:nil message:nil delegate:self cancelButtonTitle:@"Stop Shabbat Clock" otherButtonTitles:nil];
	}
	return self;
}

+(void)scheduleAlarm:(Alarm*)alarm {
	
	NSArray *repeatDays = [NSArray arrayWithObjects:alarm.repeatSUN,alarm.repeatMON,alarm.repeatTUE,alarm.repeatWED,alarm.repeatTHU,alarm.repeatFRI,alarm.repeatSAT, nil];
	
	//	int REPEATS = [alarm.repeatFRI intValue] + [alarm.repeatMON intValue] + [alarm.repeatTUE intValue] + [alarm.repeatWED intValue] + [alarm.repeatTHU intValue] + [alarm.repeatFRI intValue] + [alarm.repeatSAT intValue];
	//
	//	if ( REPEATS == 0)
	
	if (![repeatDays containsObject:[NSNumber numberWithBool:YES]]) {
		[AlarmManager scheduleNotificationWithAlarm:alarm repeatOnDay:0];
		return;
	}
	
	for (int day = 1; day <= 7; day++) {
		if ([[repeatDays objectAtIndex:day - 1] boolValue] == YES) {
			[AlarmManager scheduleNotificationWithAlarm:alarm repeatOnDay:day];
		}
	}
}

+(void)scheduleNotificationWithAlarm:(Alarm*)alarm repeatOnDay:(int)theDay{
	
	//	DLog(@"alarm: %@",[alarm.dateComponents date]);
	
	// 0. Create a calendar and set its timezone to the alarm's timezone which will always adjust to the user's time zone
	
	NSCalendar *gregorian = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
	gregorian.timeZone = [NSTimeZone localTimeZone];//[alarm.dateComponents timeZone];
	
	// 1. Get todays date and time and convert it to a dateComponents object
	
	NSDate *today = [NSDate date];
	
	NSDateComponents *todayAlarmComponents = [gregorian components:NSDayCalendarUnit | NSWeekdayCalendarUnit | NSYearCalendarUnit | NSMonthCalendarUnit fromDate:today];
	todayAlarmComponents.calendar = gregorian;
	
	// 2. Using the alarm's dateComponents object, update the todayAlarmComponents object to hold the correct hour and minute.
	
	todayAlarmComponents.hour   = [alarm.dateComponents hour];
	todayAlarmComponents.minute = [alarm.dateComponents minute];
	
	// 3. create a new date object based on the adjustedComponents
	
	NSDate *todayAlarmDate = [gregorian dateFromComponents:todayAlarmComponents];
	
	// 4. Create a new NSDateComponents Difference object and set the difference in the day parameter according to the adjusted date
	
	NSDateComponents *componentsDifference = [[NSDateComponents alloc] init];
	componentsDifference.calendar = gregorian;
	
	// 5. Create a new NSDate object by applying the componentsDifference object parameter on the todayAlarmDate
	
	// 6. Check if the final adjusted date is in the past. If so, add a week to it.
	
	NSDate *adjustedFinalDate;
	
	NSDateComponents *offsetComponents = [[NSDateComponents alloc] init];
	offsetComponents.calendar = gregorian;
	
	// handling for 30 second UILocalNotification alert sound - add another notification for each 30 second interval
	
	for (int i = 0; i < [alarm.duration intValue]; i = i + 30) {
		
		int repeatInterval = 0;
		
		// one time alarm
		
		if (theDay == 0) {
			
			adjustedFinalDate = todayAlarmDate;
			
			if ([adjustedFinalDate earlierDate:[NSDate date]] == todayAlarmDate) {
				[offsetComponents setDay:1];
				adjustedFinalDate = [gregorian dateByAddingComponents:offsetComponents toDate:adjustedFinalDate options:0];
			}
		}
		
		// repeating alarm
		
		else if (theDay > 0){
			
			[componentsDifference setDay: theDay - [todayAlarmComponents weekday]];
			adjustedFinalDate = [gregorian dateByAddingComponents:componentsDifference toDate:todayAlarmDate options:0];
			
			repeatInterval = NSWeekCalendarUnit;
			
			if ([todayAlarmDate earlierDate:adjustedFinalDate] != todayAlarmDate) {
				[offsetComponents setWeek:1];
				adjustedFinalDate = [gregorian dateByAddingComponents:offsetComponents toDate:adjustedFinalDate options:0];
			}
		}
		
		NSDateComponents *thirtySecondsComponents = [[NSDateComponents alloc] init];
		thirtySecondsComponents.calendar = gregorian;
		[thirtySecondsComponents setSecond:i];
		adjustedFinalDate = [gregorian dateByAddingComponents:thirtySecondsComponents toDate:adjustedFinalDate options:0];
		
		UILocalNotification *notification = [[UILocalNotification alloc] init];
		notification.fireDate = adjustedFinalDate;
		notification.alertBody = @"Shabbat Shalom";
		notification.soundName = alarm.soundURL;
		notification.timeZone = [NSTimeZone localTimeZone];
		notification.repeatInterval = repeatInterval;
		notification.userInfo = [NSDictionary dictionaryWithObject:alarm.unique_id forKey:@"unique_id"];
		[[UIApplication sharedApplication] scheduleLocalNotification:notification];
	}
	//DLog(@"[[UIApplication sharedApplication] scheduledLocalNotifications]: %@",[[UIApplication sharedApplication] scheduledLocalNotifications]);
}


+(void)cancelNotificationWithAlarm:(Alarm*)alarm
{
    // We search for the notification.
    // The entity's ID will be stored in the notification's user info.
	//	DLog(@"[[UIApplication sharedApplication] scheduledLocalNotifications]: %@",[[UIApplication sharedApplication] scheduledLocalNotifications]);
	
    [[[UIApplication sharedApplication] scheduledLocalNotifications] enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
		
		UILocalNotification *notification = (UILocalNotification *)obj;
		NSDictionary *userInfo = notification.userInfo;
		NSString *unique_id = [userInfo valueForKey:@"unique_id"];
		
		if ([unique_id isEqualToString:alarm.unique_id])
		{
			DLog(@"Cancelling alarm.unique_id: %@", alarm.unique_id);
			
			[[UIApplication sharedApplication] cancelLocalNotification:notification];
		}
	}];
}

-(void)handleAlarm:(Alarm*)alarm application:(UIApplication *)application{
	
	if ([application applicationState] == UIApplicationStateInactive) {
        // Application was in the background when notification was delivered.
		[self inactivateAlarm:alarm];
    }
	
	if ([self isDoubleAlarm:alarm]){
		//		return;
	}
	_elapsedTime = [alarm.duration intValue];
	self.timer =  [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(alarmClockTick) userInfo:alarm repeats:YES];
	
	
	dispatch_async(dispatch_get_main_queue(), ^{		
		[[SoundManager sharedManager] playSound:alarm.soundURL looping:YES fadeIn:YES];
		self.alertAlarm.title = alarm.label;
		self.alertAlarm.message = [NSString stringWithFormat:@"Auto-Shutdown in %d seconds",_elapsedTime];
		[self.alertAlarm show];
	});

	
}

-(BOOL)isDoubleAlarm:(Alarm*)alarm{
	
	NSCalendar *gregorian = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
	gregorian.timeZone = [NSTimeZone localTimeZone];
	
	NSDate *today = [NSDate date];
	NSDateComponents *todayAlarmComponents = [gregorian components:NSSecondCalendarUnit | NSMinuteCalendarUnit | NSHourCalendarUnit | NSDayCalendarUnit | NSYearCalendarUnit | NSMonthCalendarUnit fromDate:today];
	todayAlarmComponents.calendar = gregorian;
	
	DLog(@"t_m: %ld, t_h: %ld",(long)todayAlarmComponents.second, (long)todayAlarmComponents.minute);
	DLog(@"a_m: %ld, a_h: %ld",(long)((NSDateComponents*)alarm.dateComponents).second, (long)((NSDateComponents*)alarm.dateComponents).minute);
	
	if (todayAlarmComponents.second == ((NSDateComponents*)alarm.dateComponents).second &&
		todayAlarmComponents.minute == ((NSDateComponents*)alarm.dateComponents).minute)  {
		return NO;
	}
	
	return YES;
}

-(void)alarmClockTick{
	
	self.alertAlarm.message = [NSString stringWithFormat:@"Auto-Shutdown in %d seconds",_elapsedTime];
	
	if (_elapsedTime == 0) {
		[self inactivateAlarm:(Alarm*)_timer.userInfo];
		[self.alertAlarm dismissWithClickedButtonIndex:1 animated:YES];
		[_timer invalidate];
	}
	_elapsedTime = _elapsedTime - 1;
}

-(void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex{
	
	[[SoundManager sharedManager] stopAllSounds];
	
	// if you pressed cancel
	if (buttonIndex == 0) {
		Alarm *alarm = (Alarm*)_timer.userInfo;
		[self inactivateAlarm:alarm];
	}
}


-(void)inactivateAlarm:(Alarm*)alarm{
	// if the alarm is one time, then inactivate it.
	NSArray *repeatDays = [NSArray arrayWithObjects:alarm.repeatSUN,alarm.repeatMON,alarm.repeatTUE,alarm.repeatWED,alarm.repeatTHU,alarm.repeatFRI,alarm.repeatSAT, nil];
	if (![repeatDays containsObject:[NSNumber numberWithBool:YES]]) {
		alarm.active = [NSNumber numberWithBool:NO];
		[[NSManagedObjectContext MR_contextForCurrentThread] MR_saveOnlySelfAndWait];
		[[NSNotificationCenter defaultCenter] postNotificationName:Notifications.alarmListRefresh object:nil userInfo:nil];
	}
}


@end
