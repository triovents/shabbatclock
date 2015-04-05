//
//  ScheduleAlarm.h
//  ShabbatClock
//
//  Created by Yehuda Cohen on 6/23/14.
//  Copyright (c) 2014 Yehuda Cohen. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CWLSynthesizeSingleton/CWLSynthesizeSingleton.h>

@interface AlarmManager : NSObject

CWL_DECLARE_SINGLETON_FOR_CLASS(AlarmManager);



+(void)cancelNotificationWithAlarm:(Alarm*)alarm;
+(void)scheduleNotificationWithAlarm:(Alarm*)alarm repeatOnDay:(int)theDay;
+(void)scheduleAlarm:(Alarm*)alarm;
-(void)handleAlarm:(Alarm*)alarm application:(UIApplication *)application;

@end
