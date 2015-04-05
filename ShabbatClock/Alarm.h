//
//  Alarm.h
//  ShabbatClock
//
//  Created by Yehuda Cohen on 7/15/12.
//  Copyright (c) 2012 Independent. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface Alarm : NSManagedObject

@property (nonatomic, retain) NSNumber * active;
@property (nonatomic, retain) NSDate * date;
@property (nonatomic, retain) id dateComponents;
@property (nonatomic, retain) NSNumber * duration;
@property (nonatomic, retain) NSString * label;
@property (nonatomic, retain) NSNumber * repeatFRI;
@property (nonatomic, retain) NSNumber * repeatMON;
@property (nonatomic, retain) NSNumber * repeatSAT;
@property (nonatomic, retain) NSNumber * repeatSUN;
@property (nonatomic, retain) NSNumber * repeatTHU;
@property (nonatomic, retain) NSNumber * repeatTUE;
@property (nonatomic, retain) NSNumber * repeatWED;
@property (nonatomic, retain) NSString * soundURL;
@property (nonatomic, retain) NSString * unique_id;

@end
