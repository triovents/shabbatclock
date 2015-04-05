//
//  SettingsTableViewController.h
//  ShabbatClock
//
//  Created by Yehuda Cohen on 7/20/12.
//  Copyright (c) 2012 Independent. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MessageUI/MFMailComposeViewController.h>

extern NSString * const kMailFriend;
extern NSString * const kMailSupport;
extern NSString * const kUnlimitedAlarmsProductId;

@interface SettingsTableViewController : UITableViewController <MFMailComposeViewControllerDelegate>


@property(nonatomic,strong) IBOutlet UILabel *lblVersion;
@property(nonatomic,strong) IBOutlet UILabel *lblInAppMessage;

-(IBAction)	toggleTickTockSound:(id)sender;
-(void)		sendMail:(NSString*)type;
-(void)		purchase;
-(void)		recoverPurchases;

@end
