//
//  EditAlarmViewController.m
//  ShabbatClock
//
//  Created by Yehuda Cohen on 6/28/12.
//  Copyright (c) 2012 Independent. All rights reserved.
//

#import "EditAlarmViewController.h"


@interface EditAlarmViewController ()

@property(nonatomic,strong) Alarm *alarm;

-(void)cancelPage;

@end

@implementation EditAlarmViewController

@synthesize unique_id = _unique_id;
@synthesize lblLabel = _lblLabel;
@synthesize lblSound = _lblSound;
@synthesize lblDuration = _lblDuration;
@synthesize lblRepeat = _lblRepeat;
@synthesize pickerDate = _pickerDate;
@synthesize alarm = _alarm;


- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
    }
    return self;
}


- (void)viewDidLoad{
	
	[super viewDidLoad];
	
	NSDictionary *barButtonAppearanceDict = @{NSFontAttributeName : [UIFont fontWithName:@"AvenirNext-Regular" size:17.0] , NSForegroundColorAttributeName: [UIColor blackColor]};
	[[UIBarButtonItem appearance] setTitleTextAttributes:barButtonAppearanceDict forState:UIControlStateNormal];
	
	UIBarButtonItem *backButton = [[UIBarButtonItem alloc] initWithTitle:@"Cancel"
																   style:UIBarButtonItemStyleBordered 
																  target:self
																  action:@selector(cancelPage)];
	
	
	[self.navigationItem setLeftBarButtonItem: backButton];
	self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Save" style:UIBarButtonItemStyleDone target:self action:@selector(saveAlarm)];
	
	
//	self.pickerDate = [[UIDatePicker alloc] init];
//	self.pickerDate.backgroundColor = [UIColor whiteColor];
//	
//	self.tableView.tableHeaderView = self.pickerDate;
	
//	NSArray *familyNames = [[NSArray alloc] initWithArray:[UIFont familyNames]];
//    NSArray *fontNames;
//    NSInteger indFamily, indFont;
//    for (indFamily=0; indFamily<[familyNames count]; ++indFamily)
//    {
//        DLog(@"Family name: %@", [familyNames objectAtIndex:indFamily]);
//        fontNames = [[NSArray alloc] initWithArray:
//                     [UIFont fontNamesForFamilyName:
//                      [familyNames objectAtIndex:indFamily]]];
//        for (indFont=0; indFont<[fontNames count]; ++indFont)
//        {
//            DLog(@"    Font name: %@", [fontNames objectAtIndex:indFont]);
//        }
//    }
	
	self.tableView.dataSource = self;
	self.tableView.delegate = self;
	
}

-(void)viewWillAppear:(BOOL)animated{
	[super viewWillAppear:animated];
	
	self.lblLabel.text = self.alarm.label;
	self.lblSound.text = [self.alarm.soundURL stringByReplacingOccurrencesOfString:@".m4a" withString:@""];
	
	NSCalendar *gregorian = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
	
	NSDate *date = [gregorian dateFromComponents:self.alarm.dateComponents];
	
	self.pickerDate.timeZone = [NSTimeZone localTimeZone];//[self.alarm.dateComponents timeZone];
	self.pickerDate.date = date;
	
	[Configs writeOutRepeat:self.alarm forLabel:_lblRepeat];
	[Configs writeOutDuration:self.alarm forLabel:_lblDuration];
	
}


-(Alarm *)alarm{
	
	if (_alarm != nil) return _alarm;
	
	if ([self.unique_id isEqualToString:@"-1"]) {
		
		NSManagedObjectContext *localContext    = [NSManagedObjectContext MR_contextForCurrentThread];
		
		// Create a new Alarm in the current thread context
		_alarm = [Alarm MR_createInContext:localContext];
		_alarm.date = [NSDate date] ;
		_alarm.unique_id = [NSString stringWithFormat:@"%d",[Configs getDeviceCurrentDateTimeStamp]];
		self.unique_id = _alarm.unique_id;
		_alarm.label = @"Alarm Label";
		_alarm.soundURL = @"El Adon.m4a";
		_alarm.active = [NSNumber numberWithBool:YES];
		_alarm.duration = [NSNumber numberWithInt:30];
		_alarm.active   = [NSNumber numberWithBool:YES];
		_alarm.repeatSUN = [NSNumber numberWithBool:NO];
		_alarm.repeatMON = [NSNumber numberWithBool:NO];
		_alarm.repeatTUE = [NSNumber numberWithBool:NO];
		_alarm.repeatWED = [NSNumber numberWithBool:NO];
		_alarm.repeatTHU = [NSNumber numberWithBool:NO];
		_alarm.repeatFRI = [NSNumber numberWithBool:NO];
		_alarm.repeatSAT = [NSNumber numberWithBool:NO];
		
		NSCalendar *gregorian = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
		NSDateComponents *comps = [gregorian components:(NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit | NSHourCalendarUnit | NSMinuteCalendarUnit) fromDate:self.pickerDate.date];
		comps.timeZone = [NSTimeZone localTimeZone];
		comps.calendar = gregorian;
		comps.second = 0;
		
		self.alarm.dateComponents = comps;	
		
//		DLog(@"comps:		%@",comps);
//		DLog(@"pickerDate: %@",self.pickerDate.date);
		
	}
	else {
		NSManagedObjectContext *localContext    = [NSManagedObjectContext MR_contextForCurrentThread];
		NSPredicate *predicate = [NSPredicate predicateWithFormat:@"unique_id == %@ ", self.unique_id];
		_alarm = [Alarm MR_findFirstWithPredicate:predicate inContext:localContext];
	}
		
	return _alarm;
}



- (void)viewDidUnload{
    [super viewDidUnload];
}


-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
	if ([segue.destinationViewController respondsToSelector:@selector(setUnique_id:)]) {
		[segue.destinationViewController setUnique_id:self.unique_id];
	}
}

-(IBAction)setTime:(id)sender{
	UIDatePicker *datePicker = (UIDatePicker*)sender;
	NSCalendar *gregorian = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
	gregorian.timeZone = [NSTimeZone localTimeZone];//[self.alarm.dateComponents timeZone];// [NSTimeZone localTimeZone];
	NSDateComponents *comps = [gregorian components:(NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit | NSHourCalendarUnit | NSMinuteCalendarUnit) fromDate:datePicker.date];
//	comps.timeZone =  [NSTimeZone localTimeZone]; //[self.alarm.dateComponents timeZone];
	comps.second = 0;
	comps.calendar = gregorian;
	DLog(@"alarm.comps: %@",comps);
	self.alarm.dateComponents = comps;
	
}

-(void)saveAlarm{
	[[NSManagedObjectContext MR_contextForCurrentThread] MR_saveOnlySelfAndWait];
	[self.navigationController dismissViewControllerAnimated:YES completion:nil];
	DLog(@"self.alarm.unique_id: %@",self.alarm.unique_id);
	self.alarm.active = [NSNumber numberWithBool:YES];
	[AlarmManager cancelNotificationWithAlarm:self.alarm];
	[AlarmManager scheduleAlarm:self.alarm];
}

-(void)cancelPage{
	[NSManagedObjectContext MR_resetContextForCurrentThread];
	[self.navigationController dismissViewControllerAnimated:YES completion:nil];
}




@end
