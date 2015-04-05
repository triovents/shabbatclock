//
//  EditDurationViewController.h
//  ShabbatClock
//
//  Created by Yehuda Cohen on 7/1/12.
//  Copyright (c) 2012 Independent. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface EditDurationViewController : UITableViewController

@property(nonatomic,strong) NSString *unique_id;
@property(nonatomic,strong) IBOutlet UITableViewCell *fifteenCell;
@property(nonatomic,strong) IBOutlet UITableViewCell *thirtyCell;
@property(nonatomic,strong) IBOutlet UITableViewCell *sixtyCell;
@property(nonatomic,strong) IBOutlet UITableViewCell *ninetyCell;
@property(nonatomic,strong) IBOutlet UITableViewCell *twoMinutesCell;
@property(nonatomic,strong) IBOutlet UITableViewCell *threeMinutesCell;
@property(nonatomic,strong) IBOutlet UITableViewCell *fourMinutesCell;
@property(nonatomic,strong) IBOutlet UITableViewCell *fiveMinutesCell;

@end
