//
//  AlarmListViewController.m
//  ShabbatClock
//
//  Created by Yehuda Cohen on 6/28/12.
//  Copyright (c) 2012 Independent. All rights reserved.
//

#import "AlarmListViewController.h"
#import "AlarmListCell.h"
#import "Configs.h"
#import "EditAlarmViewController.h"
#import "AboutViewController.h"


#define ALARM_FILE @"alarms.lst"

@interface AlarmListViewController ()

@property(nonatomic,strong) NSMutableArray *alarmsData;
@property(nonatomic,strong) AboutViewController *about;

@end




@implementation AlarmListViewController

@synthesize alarmsData = _alarmsData;
@synthesize about = _about;

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
    }
    return self;
}


- (void)viewDidLoad{
	
//	self.navigationController.view.backgroundColor = [UIColor whiteColor];
	
//	[self customizeAppearance];
	
//	[[UITableView appearance] setBackgroundColor:[UIColor whiteColor]];
	
//	[[MKStoreManager sharedManager] removeAllKeychainData];
	
	NSDictionary *barButtonAppearanceDict = @{NSFontAttributeName : [UIFont fontWithName:@"AvenirNext-Regular" size:17.0] , NSForegroundColorAttributeName: [UIColor whiteColor]};
	[[UIBarButtonItem appearance] setTitleTextAttributes:barButtonAppearanceDict forState:UIControlStateNormal];

	
	_about = [[AboutViewController alloc] initWithNibName:@"AboutViewController" bundle:nil];
	
	[[NSNotificationCenter defaultCenter] addObserver:self
											 selector:@selector(initializeTableData) 
												 name:Notifications.alarmListRefresh
											   object:nil];

	[[NSNotificationCenter defaultCenter] addObserver:self
											 selector:@selector(unlockContent) 
												 name:@"verification_complete"
											   object:nil];

    
	self.navigationItem.leftBarButtonItem = self.editButtonItem;
	
}

- (void)customizeAppearance{
	UIImageView *tableBgImg = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"table_bg"]];
	[self.tableView setBackgroundView:tableBgImg];
}


-(void)initializeTableData{
	_alarmsData = [NSMutableArray arrayWithArray:[Alarm MR_findAll]];
	[self.tableView reloadData];
	[self showWelcomeMessage];
}

-(void)showWelcomeMessage{

	if (self.tableView.tableHeaderView != nil) {
		_about.view.alpha = 1.0;	
	}
	else {
		_about.view.alpha = 0.0;
	}
	
	
	[UIView beginAnimations:nil context:nil];
	[UIView setAnimationDelay:0.3];

	
	if ([_alarmsData count] == 0) {
		_about.view.alpha = 1.0;
		self.tableView.tableHeaderView = _about.view;
	}
	else {
		self.tableView.tableHeaderView = nil;
	}
	[UIView commitAnimations];	
}

-(void)viewWillAppear:(BOOL)animated{
	[super viewWillAppear:animated];
	[self initializeTableData];

	NSDictionary *barButtonAppearanceDict = @{NSFontAttributeName : [UIFont fontWithName:@"AvenirNext-Regular" size:17.0] , NSForegroundColorAttributeName: [UIColor whiteColor]};
	[[UIBarButtonItem appearance] setTitleTextAttributes:barButtonAppearanceDict forState:UIControlStateNormal];

}

-(void)viewDidAppear:(BOOL)animated{
	[super viewDidAppear:animated];
}

-(void)viewDidDisappear:(BOOL)animated{
	self.editing = NO;
	self.tableView.editing = NO;
	
}

- (void)viewDidUnload{
	[[NSNotificationCenter defaultCenter] removeObserver:self];
    [super viewDidUnload];
}

-(void)dealloc{
	[[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [_alarmsData count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Alarm Cell";
    AlarmListCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
	Alarm *alarm = [_alarmsData objectAtIndex:indexPath.row];
	
	NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
	dateFormatter.timeZone = [NSTimeZone localTimeZone];//[alarm.dateComponents timeZone];
	dateFormatter.locale = [NSLocale currentLocale];
	dateFormatter.timeStyle = NSDateFormatterShortStyle;
	dateFormatter.dateStyle = NSDateFormatterNoStyle;
	
	NSCalendar *gregorian = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
	NSDate *date = [gregorian dateFromComponents:alarm.dateComponents];

	DLog(@"date: %@",date);
	
	cell.lblTime.text = [dateFormatter stringFromDate:date];
	cell.lblLabel.text = alarm.label;
	cell.switchOnOff.on = [alarm.active boolValue];
	cell.lblRepeat.textColor = [UIColor darkGrayColor];
	
	[Configs writeOutRepeat:alarm forLabel:cell.lblRepeat];
	[Configs writeOutDuration:alarm forLabel:cell.lblDuration];
	
	if ([cell.lblRepeat.text isEqualToString:@"NEVER"]) {
		cell.lblRepeat.text = cell.lblLabel.text;
		cell.lblLabel.text = @"";
	}
	
	
	UIImageView *bg = [[UIImageView alloc] initWithFrame:cell.bounds];
	[bg setImage:[UIImage imageNamed:@"cell_bg.png"]];
	cell.backgroundView = bg;
	
	[cell.switchOnOff setAlpha:1.0];
	[cell setSelectionStyle:UITableViewCellSelectionStyleNone];
	if (self.tableView.editing) {
		[cell.switchOnOff setAlpha:0.0];	
		[cell setSelectionStyle:UITableViewCellSelectionStyleBlue];
	}

	
    return cell;
}


// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
	
	AlarmListCell *cell =  (AlarmListCell*)[tableView cellForRowAtIndexPath:indexPath];
	
	UISwitch *theSwitch = (UISwitch*)[cell viewWithTag:55];
	
	[UIView beginAnimations:nil context:nil];
	[UIView setAnimationDuration:0.2];
	if (tableView.editing) {
		[theSwitch setAlpha:0.0];
		[cell setSelectionStyle:UITableViewCellSelectionStyleBlue];
	}
	else {
		[theSwitch setAlpha:1.0];
		[cell setSelectionStyle:UITableViewCellSelectionStyleNone];
	}
	[UIView commitAnimations];
	
	return tableView.editing ;
}



-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{

	if([[segue identifier] isEqualToString:@"info"]){
		return;
	}

	EditAlarmViewController *vc = (EditAlarmViewController*)((UINavigationController*)segue.destinationViewController).topViewController;
	if([[segue identifier] isEqualToString:@"editAlarm"]){
		NSIndexPath *indexPath = [self.tableView indexPathForCell:sender];
		Alarm *alarm = [_alarmsData objectAtIndex:indexPath.row];
		if ([vc respondsToSelector:@selector(setUnique_id:)]){
			[vc setUnique_id:alarm.unique_id];
			[vc setTitle:@"Edit Alarm"];
		}
	}
	else if([[segue identifier] isEqualToString:@"addAlarm"]){
		[vc setTitle:@"Add Alarm"];
		[vc setUnique_id:@"-1"];
	}

}

-(IBAction)addAlarm:(id)sender{
	
	[self performSegueWithIdentifier:@"addAlarm" sender:sender];
	
	return;
	
	
	// For Paid Functionality
	
	if ([_alarmsData count] == 0) {
		[self performSegueWithIdentifier:@"addAlarm" sender:sender];
	}
	
//	else if ([MKStoreManager isFeaturePurchased:kUnlimitedAlarmsProductId]) {
//		[self performSegueWithIdentifier:@"addAlarm" sender:sender];
//	}
	
	else if ([[NSUserDefaults standardUserDefaults] boolForKey:kUnlockedAlarmsKey] == YES) {
		[self performSegueWithIdentifier:@"addAlarm" sender:sender];
	}

	else {
		
		MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
		hud.labelText = NSLocalizedString(@"Contacting App Store..",nil);

		
		/*
		[[MKStoreManager sharedManager] buyFeature:kUnlimitedAlarmsProductId onComplete:^(NSString *purchaseString, NSData *purchaseData, SKPaymentTransaction *transaction) {

			DLog(@"purchaseString: %@",purchaseString);
			[SVProgressHUD showWithStatus:@"Verifying Purchase..." maskType:SVProgressHUDMaskTypeGradient networkIndicator:NO];
			BOOL isOK = [[VerificationController sharedInstance] verifyPurchase:transaction];
			if (!isOK) {
				[SVProgressHUD dismissWithError:@"Unverified Receipt. Please Try Again." afterDelay:3.0];	
			}
			
		} onCancelled:^{
			[SVProgressHUD dismissWithError:@"Purchase Cancelled" afterDelay:1.0];
		}];
		 */

		
	}
}

-(void)unlockContent{
//	[SVProgressHUD dismissWithSuccess:@"Congratulations!\n\nUnlimited Alarms Activated!!" afterDelay:4.0];
	[MBProgressHUD hideAllHUDsForView:self.view animated:YES];
}

-(void)performSegueWithIdentifier:(NSString *)identifier sender:(id)sender{
	DLog(@"i: %@",identifier);
	[super performSegueWithIdentifier:identifier sender:sender];
}


-(IBAction)setSwitch:(id)sender{
	
	UITableViewCell *cell = (UITableViewCell*)[[sender superview] superview];
	UISwitch *activeSwitch = (UISwitch*)sender;
	NSIndexPath *indexPath = [self.tableView indexPathForCell:cell];
	
	Alarm *alarm = [_alarmsData objectAtIndex:indexPath.row];
	alarm.active = [NSNumber numberWithBool:activeSwitch.on];
	
	if ([alarm.active boolValue] == YES) {
		[AlarmManager scheduleAlarm:alarm];
	}
	else if ([alarm.active boolValue] == NO) {
		[AlarmManager cancelNotificationWithAlarm:alarm];
	}
	
	
	[[NSManagedObjectContext MR_contextForCurrentThread] MR_saveOnlySelfAndWait];
}



- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
		
		// Get the local context
		NSManagedObjectContext *localContext    = [NSManagedObjectContext MR_contextForCurrentThread];
		
		Alarm *alarm = [_alarmsData objectAtIndex:indexPath.row];
		
		// Retrieve the first person who have the given firstname
		Alarm *alarmFound  = [Alarm MR_findFirstByAttribute:@"unique_id" withValue:alarm.unique_id inContext:localContext];
		
		if (alarmFound)
		{
			// Delete the person found
			[alarmFound MR_deleteInContext:localContext];
			[_alarmsData removeObjectAtIndex:indexPath.row];
			
			[AlarmManager cancelNotificationWithAlarm:alarm];
			
			// Save the modification in the local context
			[localContext MR_saveOnlySelfAndWait];
		}
		
        [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationLeft];
    }   
    else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
	else {
		
	}
	
	[self showWelcomeMessage];

}


/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
{
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

#pragma mark - Table view delegate


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
	
	if (self.editing) {
		UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
		[self performSegueWithIdentifier:@"editAlarm" sender:cell];
	}
	
	
}


@end
