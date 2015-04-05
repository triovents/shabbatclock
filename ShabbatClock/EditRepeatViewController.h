//
//  EditRepeatViewController.h
//  ShabbatClock
//
//  Created by Yehuda Cohen on 6/28/12.
//  Copyright (c) 2012 Independent. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface EditRepeatViewController : UITableViewController

@property(nonatomic,strong) NSString *unique_id;
@property(nonatomic,strong) IBOutlet UITableViewCell *sundayCell;
@property(nonatomic,strong) IBOutlet UITableViewCell *mondayCell;
@property(nonatomic,strong) IBOutlet UITableViewCell *tuesdayCell;
@property(nonatomic,strong) IBOutlet UITableViewCell *wednesdayCell;
@property(nonatomic,strong) IBOutlet UITableViewCell *thursdayCell;
@property(nonatomic,strong) IBOutlet UITableViewCell *fridayCell;
@property(nonatomic,strong) IBOutlet UITableViewCell *saturdayCell;

@end
