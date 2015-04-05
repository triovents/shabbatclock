//
//  EditDurationViewController.m
//  ShabbatClock
//
//  Created by Yehuda Cohen on 7/1/12.
//  Copyright (c) 2012 Independent. All rights reserved.
//

#import "EditDurationViewController.h"


@interface EditDurationViewController ()

@end

@implementation EditDurationViewController

@synthesize unique_id = _unique_id;
@synthesize fifteenCell = _fifteenCell;
@synthesize thirtyCell = _thirtyCell;
@synthesize sixtyCell = _sixtyCell;
@synthesize ninetyCell = _ninetyCell;
@synthesize twoMinutesCell = _twoMinutesCell;
@synthesize threeMinutesCell = _threeMinutesCell;
@synthesize fourMinutesCell = _fourMinutesCell;
@synthesize fiveMinutesCell = _fiveMinutesCell;

- (id)initWithStyle:(UITableViewStyle)style{
    self = [super initWithStyle:style];
    if (self) {
    }
    return self;
}

- (void)viewDidLoad{
	
	NSPredicate *predicate = [NSPredicate predicateWithFormat:@"unique_id == %@ ", self.unique_id];
    Alarm *alarmFound = [Alarm MR_findFirstWithPredicate:predicate inContext:[NSManagedObjectContext MR_contextForCurrentThread]];

	if ([alarmFound.duration intValue] == 15) 
		_fifteenCell.accessoryType = UITableViewCellAccessoryCheckmark;
	else if ([alarmFound.duration intValue] == 30) 
		_thirtyCell.accessoryType = UITableViewCellAccessoryCheckmark;
	else if ([alarmFound.duration intValue] == 60) 
		_sixtyCell.accessoryType = UITableViewCellAccessoryCheckmark;
	else if ([alarmFound.duration intValue] == 90) 
		_ninetyCell.accessoryType = UITableViewCellAccessoryCheckmark;
	else if ([alarmFound.duration intValue] == 120) 
		_twoMinutesCell.accessoryType = UITableViewCellAccessoryCheckmark;
	else if ([alarmFound.duration intValue] == 180) 
		_threeMinutesCell.accessoryType = UITableViewCellAccessoryCheckmark;
	else if ([alarmFound.duration intValue] == 240) 
		_fourMinutesCell.accessoryType = UITableViewCellAccessoryCheckmark;
	else if ([alarmFound.duration intValue] == 300) 
		_fiveMinutesCell.accessoryType = UITableViewCellAccessoryCheckmark;
	
    [super viewDidLoad];
}

- (void)viewDidUnload{
    [super viewDidUnload];
}


#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
	[tableView deselectRowAtIndexPath:indexPath animated:YES];
	
	_fifteenCell.accessoryType = UITableViewCellAccessoryNone;
	_thirtyCell.accessoryType = UITableViewCellAccessoryNone;
	_sixtyCell.accessoryType = UITableViewCellAccessoryNone;
	_ninetyCell.accessoryType = UITableViewCellAccessoryNone;
	_twoMinutesCell.accessoryType = UITableViewCellAccessoryNone;
	_threeMinutesCell.accessoryType = UITableViewCellAccessoryNone;
	_fourMinutesCell.accessoryType = UITableViewCellAccessoryNone;
	_fiveMinutesCell.accessoryType = UITableViewCellAccessoryNone;

    if (cell.accessoryType == UITableViewCellAccessoryNone) 
	{
        cell.accessoryType = UITableViewCellAccessoryCheckmark;
    }else 
	{
        cell.accessoryType = UITableViewCellAccessoryNone;
    }
	
	NSManagedObjectContext *localContext    = [NSManagedObjectContext MR_contextForCurrentThread];
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"unique_id == %@ ", self.unique_id];
    Alarm *alarmFound = [Alarm MR_findFirstWithPredicate:predicate inContext:localContext];
	
//	DLog(@"cell.tag: %ld",cell.tag);
	
	alarmFound.duration = [NSNumber numberWithInteger:cell.tag];
	
	[localContext MR_saveOnlySelfAndWait];
	
}

@end
