//
//  AlarmListViewController.h
//  ShabbatClock
//
//  Created by Yehuda Cohen on 6/28/12.
//  Copyright (c) 2012 Independent. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AlarmListViewController : UITableViewController <NSFetchedResultsControllerDelegate>


-(void)initializeTableData;
-(IBAction)setSwitch:(id)sender;
-(IBAction)addAlarm:(id)sender;

@end
