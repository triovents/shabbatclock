//
//  AlarmListCell.m
//  ShabbatClock
//
//  Created by Yehuda Cohen on 6/28/12.
//  Copyright (c) 2012 Independent. All rights reserved.
//

#import "AlarmListCell.h"

@implementation AlarmListCell

@synthesize lblTime = _lblTime;
@synthesize lblRepeat = _lblRepeat;
@synthesize lblLabel = _lblLabel;
@synthesize switchOnOff = _switchOnOff;
@synthesize lblDuration = _lblDuration;


- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
