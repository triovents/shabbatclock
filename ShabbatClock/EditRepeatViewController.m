//
//  EditRepeatViewController.m
//  ShabbatClock
//
//  Created by Yehuda Cohen on 6/28/12.
//  Copyright (c) 2012 Independent. All rights reserved.
//

#import "EditRepeatViewController.h"


@interface EditRepeatViewController ()

@end

@implementation EditRepeatViewController

@synthesize sundayCell = _sundayCell;
@synthesize mondayCell = _mondayCell;
@synthesize tuesdayCell = _tuesdayCell;
@synthesize wednesdayCell = _wednesdayCell;
@synthesize thursdayCell = _thursdayCell;
@synthesize fridayCell = _fridayCell;
@synthesize saturdayCell = _saturdayCell;
@synthesize unique_id = _unique_id;

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
	_sundayCell.accessoryType = UITableViewCellAccessoryNone;
	_mondayCell.accessoryType = UITableViewCellAccessoryNone;
	_tuesdayCell.accessoryType = UITableViewCellAccessoryNone;
	_wednesdayCell.accessoryType = UITableViewCellAccessoryNone;
	_thursdayCell.accessoryType = UITableViewCellAccessoryNone;
	_fridayCell.accessoryType = UITableViewCellAccessoryNone;
	_saturdayCell.accessoryType = UITableViewCellAccessoryNone;
	
	NSPredicate *predicate = [NSPredicate predicateWithFormat:@"unique_id == %@ ", self.unique_id];
    Alarm *alarmFound = [Alarm MR_findFirstWithPredicate:predicate inContext:[NSManagedObjectContext MR_contextForCurrentThread]];
	
	if ([alarmFound.repeatSUN boolValue] == YES) 
		_sundayCell.accessoryType = UITableViewCellAccessoryCheckmark;
	if ([alarmFound.repeatMON boolValue] == YES) 
		_mondayCell.accessoryType = UITableViewCellAccessoryCheckmark;
	if ([alarmFound.repeatTUE boolValue] == YES) 
		_tuesdayCell.accessoryType = UITableViewCellAccessoryCheckmark;
	if ([alarmFound.repeatWED boolValue] == YES) 
		_wednesdayCell.accessoryType = UITableViewCellAccessoryCheckmark;
	if ([alarmFound.repeatTHU boolValue] == YES) 
		_thursdayCell.accessoryType = UITableViewCellAccessoryCheckmark;
	if ([alarmFound.repeatFRI boolValue] == YES) 
		_fridayCell.accessoryType = UITableViewCellAccessoryCheckmark;
	if ([alarmFound.repeatSAT boolValue] == YES) 
		_saturdayCell.accessoryType = UITableViewCellAccessoryCheckmark;
	
    [super viewDidLoad];
}

- (void)viewDidUnload{
    [super viewDidUnload];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}



- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
	
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
	[tableView deselectRowAtIndexPath:indexPath animated:YES];
	

	BOOL repeat;
	
    if (cell.accessoryType == UITableViewCellAccessoryNone) 
	{
        cell.accessoryType = UITableViewCellAccessoryCheckmark;
		repeat = YES;
    }else 
	{
        cell.accessoryType = UITableViewCellAccessoryNone;
		repeat = NO;
    }
	
	
	NSManagedObjectContext *localContext    = [NSManagedObjectContext MR_contextForCurrentThread];
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"unique_id == %@ ", self.unique_id];
    Alarm *alarmFound = [Alarm MR_findFirstWithPredicate:predicate inContext:localContext];
	
    if (alarmFound)
    {
		
		switch (indexPath.row) {
			case 2:
				alarmFound.repeatSUN = [NSNumber numberWithBool:repeat];
				break;
			case 3:
				alarmFound.repeatMON = [NSNumber numberWithBool:repeat];
				break;
			case 4:
				alarmFound.repeatTUE = [NSNumber numberWithBool:repeat];
				break;
			case 5:
				alarmFound.repeatWED = [NSNumber numberWithBool:repeat];
				break;
			case 6:
				alarmFound.repeatTHU = [NSNumber numberWithBool:repeat];
				break;
			case 0:
				alarmFound.repeatFRI = [NSNumber numberWithBool:repeat];
				break;
			case 1:
				alarmFound.repeatSAT = [NSNumber numberWithBool:repeat];
				break;
				
			default:
				break;
		}
    }
	
	[localContext MR_saveOnlySelfAndWait];

	
}

@end
