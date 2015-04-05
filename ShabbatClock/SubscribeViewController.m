//
//  SubscribeViewController.m
//  ShabbatClock
//
//  Created by Yehuda Cohen on 7/22/12.
//  Copyright (c) 2012 Independent. All rights reserved.
//

#import "SubscribeViewController.h"


@interface SubscribeViewController ()

@property(nonatomic,strong) IBOutlet UITextField *txtEmail;

@end

@implementation SubscribeViewController

@synthesize txtEmail = _txtEmail;

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
    [super viewDidLoad];
	[_txtEmail becomeFirstResponder];
	_txtEmail.text = [[NSUserDefaults standardUserDefaults] valueForKey:@"email"];
//	UIImageView *img = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"table_bg.png"]];
//	[self.tableView setBackgroundView:img];  
	
}

- (void)viewDidUnload
{
    [super viewDidUnload];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}


-(void)subscribe:(id)sender{
	
	if ([_txtEmail.text length] == 0) {
//		[SVProgressHUD show];
//		[SVProgressHUD dismissWithError:@"Please enter E-mail"];
		
		MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
		hud.labelText = NSLocalizedString(@"Please enter E-mail..",nil);

		
		return;
	}
	
//	if ([_txtEmail.text isEqualToString:[[NSUserDefaults standardUserDefaults] valueForKey:@"email"]]) {
//		[SVProgressHUD show];
//		[SVProgressHUD dismissWithSuccess:@"Email Updated"];
//		return;
//	}
	
	
	if ([Configs validateEmailWithString:_txtEmail.text] == NO) {
//		[SVProgressHUD show];
//		[SVProgressHUD dismissWithError:@"Invalid E-mail" afterDelay:0.75];
		MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
		hud.labelText = NSLocalizedString(@"Invalid E-mail",nil);

		
		return;
	}
	
//	[SVProgressHUD showWithStatus:@"Sending E-mail" maskType:SVProgressHUDMaskTypeGradient];
	MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
	hud.labelText = NSLocalizedString(@"Sending E-mail",nil);

	
	
	PFQuery *query = [PFQuery queryWithClassName:@"NewsletterEmails"];
	[query whereKey:kEmailKey equalTo:_txtEmail.text];
	[query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
		
		PFObject *emailObject;
		
		if (!error) {

			DLog(@"objects retrieved: %@", objects);
			
			if (objects.count > 0){
				[[NSUserDefaults standardUserDefaults] setValue:_txtEmail.text forKey:kEmailKey];
//				[SVProgressHUD dismissWithSuccess:@"Email Updated"];
				hud.labelText = NSLocalizedString(@"Email Updated",nil);
				[MBProgressHUD hideAllHUDsForView:self.view animated:YES];
			}
			else{
				emailObject = [PFObject objectWithClassName:@"NewsletterEmails"];
				
				[emailObject setObject:[NSString stringWithString:_txtEmail.text] forKey:kEmailKey];
				[emailObject saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
					[[NSUserDefaults standardUserDefaults] setValue:_txtEmail.text forKey:kEmailKey];					
					[[NSUserDefaults standardUserDefaults] synchronize];
					[emailObject setObject:[NSString stringWithString:_txtEmail.text] forKey:kEmailKey];
					[emailObject saveInBackground];
				}];	
//				[SVProgressHUD dismissWithSuccess:@"Success"];
				hud.labelText = NSLocalizedString(@"Success",nil);
				[MBProgressHUD hideAllHUDsForView:self.view animated:YES];
			}
			[Configs unlockContentCheck];
		}
		else {
			// Log details of the failure
			DLog(@"Error: %@ %@", error, [error userInfo]);
//			[SVProgressHUD dismissWithError:@"Failed"];
			hud.labelText = NSLocalizedString(@"Failed",nil);
			[MBProgressHUD hideAllHUDsForView:self.view animated:YES];

		}
		
	}];
	
	
	
}


@end
