//
//  SettingsTableViewController.m
//  ShabbatClock
//
//  Created by Yehuda Cohen on 7/20/12.
//  Copyright (c) 2012 Independent. All rights reserved.
//



#import "SettingsTableViewController.h"

@interface SettingsTableViewController ()

@end

@implementation SettingsTableViewController

@synthesize lblVersion = _lblVersion;
@synthesize lblInAppMessage = _lblInAppMessage;


- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
    }
    return self;
}

- (void)viewDidLoad
{
//	UIImageView *img = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"table_bg.png"]];
//	[self.tableView setBackgroundView:img];
	_lblVersion.text = [Configs versionBuildString];
    [super viewDidLoad];
	
	[[NSNotificationCenter defaultCenter] addObserver:self
											 selector:@selector(unlockContent) 
												 name:@"verification_complete"
											   object:nil];
}

-(void)viewWillAppear:(BOOL)animated{
	
	[Configs unlockContentCheck];
	
	/*
	if ([MKStoreManager isFeaturePurchased:kUnlimitedAlarmsProductId] || [[NSUserDefaults standardUserDefaults] boolForKey:kUnlockedAlarmsKey] == YES) 
		[self unlockContent];
	else 
		_lblInAppMessage.text = @"Purchase Unlimited Alarms $1.99";	
	 */
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

-(void)toggleTickTockSound:(id)sender{
	
	UISwitch *theSwitch = (UISwitch*)sender;
	if (theSwitch.on) {
		[[NSUserDefaults standardUserDefaults] setBool:YES forKey:DefaultKeys.ticktock_ON];
	}
	else if (theSwitch.on == NO) {
		[[NSUserDefaults standardUserDefaults] setBool:NO forKey:DefaultKeys.ticktock_ON];
	}	
}

// The mail compose view controller delegate method
- (void)mailComposeController:(MFMailComposeViewController *)controller
          didFinishWithResult:(MFMailComposeResult)result
                        error:(NSError *)error
{
    if (error){
		DLog(@"error mail - %@",error);
	}
		
    else{
		DLog(@"mail successful");
	}
		
	[self dismissViewControllerAnimated:YES completion:nil];
}



-(void)sendMail:(NSString*)type{
    if ([MFMailComposeViewController canSendMail]){
        MFMailComposeViewController *picker = [[MFMailComposeViewController alloc] init];
        picker.mailComposeDelegate = self;
		
		if ([type isEqualToString:kMailFriend]) {
			[picker setSubject:@"Shabbat Clock Rocks!"];	
			[picker setMessageBody:@"Hi!<br><br>Try out the <a href=http://itunes.apple.com/us/app/kabbalah-reader/id546299433>Shabbat Clock</a> for iPhone and iPad!" isHTML:YES];	
		}
		else if ([type isEqualToString:kMailSupport]) {
			[picker setToRecipients:[NSArray arrayWithObject:@"shabbatclock@gmail.com"]];
			[picker setSubject:@"Shabbat Clock App Support Inquiry"];	
		}
		
		[self presentViewController:picker animated:YES completion:nil];
    }
    
}


#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
	[tableView deselectRowAtIndexPath:indexPath animated:YES];
		
	if (indexPath.section == 1 && indexPath.row == 1) {
		[self sendMail:kMailSupport];
	}
	
	else if (indexPath.section == 1 && indexPath.row == 2) {
		
//		if (![MKStoreManager isFeaturePurchased:kUnlimitedAlarmsProductId] || [[NSUserDefaults standardUserDefaults] boolForKey:kUnlockedAlarmsKey] != YES) 
//			[self purchase];	
	}
	
	else if (indexPath.section == 1 && indexPath.row == 3) {
		[self recoverPurchases];
	}
	
	else if (indexPath.section == 2 && indexPath.row == 1) {
		[self sendMail:kMailFriend];
	}
	else if (indexPath.section == 2 && indexPath.row == 2) {
		NSString* urlString = @"http://itunes.apple.com/app/id546299433?mt=8";
		[[UIApplication sharedApplication] openURL:[NSURL URLWithString:urlString]];	
	}
	
}

-(void)purchase{
	
	MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
	hud.labelText = NSLocalizedString(@"Contacting App Store..",nil);

	
	/*
	[[MKStoreManager sharedManager] buyFeature:kUnlimitedAlarmsProductId onComplete:^(NSString *purchaseString, NSData *purchaseData, SKPaymentTransaction *transaction) {
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

-(void)unlockContent{
	_lblInAppMessage.text = @"Unlimited Alarms Active";
}

-(void)recoverPurchases{
	MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
	hud.labelText = NSLocalizedString(@"Recovering Purchases..",nil);

	
	/*
	[[MKStoreManager sharedManager] restorePreviousTransactionsOnComplete:^{
		[SVProgressHUD dismissWithSuccess:@"Purchases Recovered" afterDelay:3.0];
		[self unlockContent];
	} onError:^(NSError *error) {
		[SVProgressHUD dismissWithError:@"Recovering Purchases Cancelled" afterDelay:1.0];
		DLog(@"error: %@",[error description]);
	}];
	 */
}

@end
