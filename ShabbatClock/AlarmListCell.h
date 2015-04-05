//
//  AlarmListCell.h
//  ShabbatClock
//
//  Created by Yehuda Cohen on 6/28/12.
//  Copyright (c) 2012 Independent. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AlarmListCell : UITableViewCell

@property(nonatomic,strong) IBOutlet UILabel *lblTime, *lblRepeat, *lblLabel, *lblDuration;
@property(nonatomic,strong) IBOutlet UISwitch *switchOnOff;

@end
