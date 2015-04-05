//
//  EditAlarmViewController.h
//  ShabbatClock
//
//  Created by Yehuda Cohen on 6/28/12.
//  Copyright (c) 2012 Independent. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface EditAlarmViewController : UITableViewController

@property(nonatomic,strong) NSString *unique_id;
@property(nonatomic,strong) IBOutlet UILabel *lblRepeat;
@property(nonatomic,strong) IBOutlet UILabel *lblDuration;
@property(nonatomic,strong) IBOutlet UILabel *lblSound;
@property(nonatomic,strong) IBOutlet UILabel *lblLabel;
@property(nonatomic,strong) IBOutlet UIDatePicker *pickerDate;

-(IBAction)setTime:(id)sender;

@end
