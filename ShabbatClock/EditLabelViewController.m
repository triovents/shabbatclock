//
//  EditLabelViewController.m
//  ShabbatClock
//
//  Created by Yehuda Cohen on 7/1/12.
//  Copyright (c) 2012 Independent. All rights reserved.
//

#import "EditLabelViewController.h"


@interface EditLabelViewController ()

@end

@implementation EditLabelViewController

@synthesize txtLabel = _txtLabel;
@synthesize unique_id = _unique_id;

- (void)viewDidLoad{
	
	NSManagedObjectContext *localContext    = [NSManagedObjectContext MR_contextForCurrentThread];
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"unique_id == %@ ", self.unique_id];
    Alarm *alarmFound = [Alarm MR_findFirstWithPredicate:predicate inContext:localContext];

	self.txtLabel.text = alarmFound.label;
	[self.txtLabel becomeFirstResponder];
	
	self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Save" style:UIBarButtonItemStyleDone target:self action:@selector(saveLabel:)];
    [super viewDidLoad];
}

- (void)viewDidUnload{
    [super viewDidUnload];
}

-(void)saveLabel:(id)sender{
	
	
	NSManagedObjectContext *localContext    = [NSManagedObjectContext MR_contextForCurrentThread];
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"unique_id == %@ ", self.unique_id];
    Alarm *alarmFound = [Alarm MR_findFirstWithPredicate:predicate inContext:localContext];
	
	alarmFound.label = self.txtLabel.text;
	
	[localContext MR_saveOnlySelfAndWait];
	
	[self.navigationController popViewControllerAnimated:YES];
}


@end
