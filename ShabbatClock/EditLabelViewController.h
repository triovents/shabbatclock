//
//  EditLabelViewController.h
//  ShabbatClock
//
//  Created by Yehuda Cohen on 7/1/12.
//  Copyright (c) 2012 Independent. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface EditLabelViewController : UITableViewController <UITextFieldDelegate>

@property(nonatomic,strong) NSString *unique_id;
@property(nonatomic,strong) IBOutlet UITextField *txtLabel;

@end
