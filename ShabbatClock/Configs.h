//
//  AppConfigs.h
//  ShabbatClock
//
//  Created by Yehuda Cohen on 6/29/12.
//  Copyright (c) 2012 Independent. All rights reserved.
//

extern NSString * const kMailFriend;
extern NSString * const kMailSupport;
extern NSString * const kUnlimitedAlarmsProductId;
extern NSString * const kEmailKey;
extern NSString * const kUnlockedAlarmsKey;


#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>
#import "Alarm.h"


@interface Configs : NSObject 

+ (int) getDeviceCurrentDateTimeStamp;
+ (NSString *)dataFilePath:(NSString*)fileName;
+ (void)writeOutRepeat:(Alarm*)alarm forLabel:(UILabel*)lblRepeat;
+ (void)writeOutDuration:(Alarm*)alarm forLabel:(UILabel*)lblDuration;
+ (NSString*)versionBuildString;
+ (BOOL)validateEmailWithString:(NSString*)email;
+ (void)unlockContentCheck;

@end
