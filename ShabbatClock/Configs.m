//
//  AppConfigs.m
//  ShabbatClock
//
//  Created by Yehuda Cohen on 6/29/12.
//  Copyright (c) 2012 Independent. All rights reserved.
//


NSString * const kMailFriend = @"friend";
NSString * const kMailSupport = @"Support";
NSString * const kUnlimitedAlarmsProductId = @"com.yocoproductions.shabbatclock.unlimitedalarms";
NSString * const kEmailKey = @"email";
NSString * const kUnlockedAlarmsKey = @"unlocked_alarms";


#import "Configs.h"
#include <stdlib.h>

@implementation Configs

+(NSString*)versionBuildString{
	NSBundle *bundle = [NSBundle mainBundle];   
	NSString *appVersion = [bundle objectForInfoDictionaryKey:(NSString *)@"CFBundleShortVersionString"];
	NSString *appBuildNumber = [bundle objectForInfoDictionaryKey:(NSString *)kCFBundleVersionKey];
	NSString *versionBuild = [NSString stringWithFormat:@"Version %@ r%@",appVersion,appBuildNumber];
	return versionBuild;
}

+(BOOL)validateEmailWithString:(NSString*)email{
    NSString *emailRegex = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}"; 
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex]; 
	BOOL valid = [emailTest evaluateWithObject:email];
    return valid;
}

+ (int) getDeviceCurrentDateTimeStamp{
	// get the current device time in unix timestamp (adjusting for GMT Offset)
	NSInteger currentGMTOffset = [[NSTimeZone systemTimeZone] secondsFromGMTForDate:[NSDate date]];
	NSDate* dateNew = [NSDate dateWithTimeInterval:currentGMTOffset sinceDate:[NSDate date]];
	int timeUnix = [dateNew timeIntervalSince1970];
	return (timeUnix);
}

+ (NSString *)dataFilePath:(NSString*)fileName{
	NSString *dataFilePath;
	NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
	NSString *documentsDirectory = [paths objectAtIndex:0];
	dataFilePath = [documentsDirectory stringByAppendingPathComponent:fileName];
	//DLog(@"dataFilePath: %@",dataFilePath);
	return dataFilePath;
}


+(void)writeOutRepeat:(Alarm*)alarm forLabel:(UILabel*)lblRepeat{
	
	NSMutableString *repeatString = [NSMutableString string];
	
	if ([alarm.repeatSUN boolValue]) [repeatString appendString:@"Sun "];
	if ([alarm.repeatMON boolValue]) [repeatString appendString:@"Mon "];
	if ([alarm.repeatTUE boolValue]) [repeatString appendString:@"Tue "];
	if ([alarm.repeatWED boolValue]) [repeatString appendString:@"Wed "];
	if ([alarm.repeatTHU boolValue]) [repeatString appendString:@"Thu "];
	if ([alarm.repeatFRI boolValue]) [repeatString appendString:@"Fri "];
	if ([alarm.repeatSAT boolValue]) [repeatString appendString:@"Sat "];
	
	if ([repeatString length] == 0) {
		[repeatString appendString:@"NEVER"];
	}
	
	lblRepeat.text = repeatString;	
}

+(void)writeOutDuration:(Alarm*)alarm forLabel:(UILabel*)lblDuration{
	
	switch ([alarm.duration intValue]) {
		case 15:
			lblDuration.text = @"15 Seconds";
			break;
		case 30:
			lblDuration.text = @"30 Seconds";
			break;
		case 60:
			lblDuration.text = @"60 Seconds";
			break;
		case 90:
			lblDuration.text = @"90 Seconds";
			break;
		case 120:
			lblDuration.text = @"2 minutes";
			break;
		case 180:
			lblDuration.text = @"3 minutes";
			break;
		case 240:
			lblDuration.text = @"4 minutes";
			break;
		case 300:
			lblDuration.text = @"5 minutes";
			break;
			
		default:
			break;
	}
}

+(void)unlockContentCheck{
	
	if (![[NSUserDefaults standardUserDefaults] valueForKey:kEmailKey]) {
		return;
	}
	
	PFQuery *query = [PFQuery queryWithClassName:@"NewsletterEmails"];
	[query whereKey:@"email" equalTo:[[NSUserDefaults standardUserDefaults] valueForKey:kEmailKey]];

	[query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
		
		if (!error) {
			DLog(@"objects retrieved: %@", objects);
			if (objects.count > 0){
				DLog(@"unlocked_alarms: %@", [objects objectAtIndex:0]);
				
				NSDictionary *row = [objects objectAtIndex:0];
				if ([row valueForKey:kUnlockedAlarmsKey]) {
					BOOL unlocked_alarms = [[[objects objectAtIndex:0] valueForKey:kUnlockedAlarmsKey] boolValue];
					[[NSUserDefaults standardUserDefaults] setBool:unlocked_alarms forKey:kUnlockedAlarmsKey];
					[[NSUserDefaults standardUserDefaults] synchronize];	
				}
			}
			else{
			}
		}
		else {
			DLog(@"Error: %@ %@", error, [error userInfo]);
		}
		
	}];
}


@end
