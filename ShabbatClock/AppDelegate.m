//
//  AppDelegate.m
//  ShabbatClock
//
//  Created by Yehuda Cohen on 4/22/14.
//  Copyright (c) 2014 Yehuda Cohen. All rights reserved.
//

#import "AppDelegate.h"

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
	[MagicalRecord setupCoreDataStackWithStoreNamed:@"ShabbatClockStore.sqlite"];
	
    // running on iOS 8
    if ([application respondsToSelector:@selector(registerUserNotificationSettings:)]) {
        UIUserNotificationSettings *settings = [UIUserNotificationSettings settingsForTypes:(UIUserNotificationTypeBadge|UIUserNotificationTypeAlert|UIUserNotificationTypeSound) categories:nil];
        [application registerUserNotificationSettings:settings];
    } else {
        // iOS 7 or earlier
        UIRemoteNotificationType myTypes = UIRemoteNotificationTypeBadge | UIRemoteNotificationTypeAlert | UIRemoteNotificationTypeSound;
        [application registerForRemoteNotificationTypes:myTypes];
    }
    
	[[UILabel appearanceWhenContainedIn:[UITableViewHeaderFooterView class], nil] setFont:[UIFont fontWithName:@"AvenirNext-Bold" size:18]];
	[[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
	
	[[SoundManager sharedManager] prepareToPlay];
	[[SoundManager sharedManager] setAllowsBackgroundMusic:NO];
		
	[[UIApplication sharedApplication] cancelAllLocalNotifications];

	NSDictionary *regDefaults = [NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithBool:YES],DefaultKeys.ticktock_ON, nil];
	[[NSUserDefaults standardUserDefaults] registerDefaults:regDefaults];
	
    return YES;
}

-(void)application:(UIApplication *)application didReceiveLocalNotification:(UILocalNotification *)notification{
	
	NSDictionary *userInfo = notification.userInfo;
	NSString *unique_id = [userInfo valueForKey:@"unique_id"];
	NSManagedObjectContext *localContext = [NSManagedObjectContext MR_contextForCurrentThread];
	NSPredicate *predicate = [NSPredicate predicateWithFormat:@"unique_id == %@ ", unique_id];
	
	//discover alarm
	Alarm *alarmFound = [Alarm MR_findFirstWithPredicate:predicate inContext:localContext];
	
	if (alarmFound) [[AlarmManager sharedAlarmManager] handleAlarm:alarmFound application:application];
	
}

- (void)rankUsSetAndCheck{
	
	int count = (int)[[NSUserDefaults standardUserDefaults] integerForKey:@"rankUsCounter"];
	
	if (count >= 5) return;
	count ++;
	
	[[NSUserDefaults standardUserDefaults] setInteger:count forKey:@"rankUsCounter"];
	[[NSUserDefaults standardUserDefaults] synchronize];
	
	DLog(@"count: %ld", (long)count);
	
	if (count == 4) {
		UIAlertView * alert = [[UIAlertView alloc] initWithTitle:nil
														 message:@"Are you Enjoying Shabbat Clock? We'd appreciate your opinion!"
														delegate:self
											   cancelButtonTitle:@"No, Thanks"
											   otherButtonTitles:@"Rate Shabbat Clock",nil];
		[alert addButtonWithTitle:@"Remind me later"];
		[alert show];
	}
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
	DLog(@"%ld",(long)buttonIndex);
	if (buttonIndex == 0) {
	}
	if (buttonIndex == 1) {
		//TODO: get the right id for itunes app
		NSString* urlString = @"http://itunes.apple.com/app/id546299433?mt=8";
		[[UIApplication sharedApplication] openURL:[NSURL URLWithString:urlString]];
	}
	if (buttonIndex == 2) {
		[[NSUserDefaults standardUserDefaults] setInteger:0 forKey:@"rankUsCounter"];
		[[NSUserDefaults standardUserDefaults] synchronize];
	}
}

- (void)applicationWillResignActive:(UIApplication *)application{
}
- (void)applicationDidEnterBackground:(UIApplication *)application{
}
- (void)applicationWillEnterForeground:(UIApplication *)application{
}
- (void)applicationDidBecomeActive:(UIApplication *)application{
}
- (void)applicationWillTerminate:(UIApplication *)application{
}


@end
