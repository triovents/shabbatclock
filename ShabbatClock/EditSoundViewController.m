//
//  EditSoundViewController.m
//  ShabbatClock
//
//  Created by Yehuda Cohen on 7/2/12.
//  Copyright (c) 2012 Independent. All rights reserved.
//

#import "EditSoundViewController.h"

@interface EditSoundViewController ()

@property(nonatomic,strong) NSMutableArray *sounds, *soundSectionNames;
@property(nonatomic,strong) Alarm *alarmFound;

@end


@implementation EditSoundViewController

@synthesize sounds = _sounds;
@synthesize soundSectionNames = _soundSectionNames;
@synthesize unique_id = _unique_id;
@synthesize alarmFound = _alarmFound;

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad{
	
	NSManagedObjectContext *localContext    = [NSManagedObjectContext MR_contextForCurrentThread];
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"unique_id == %@ ", self.unique_id];
    self.alarmFound = [Alarm MR_findFirstWithPredicate:predicate inContext:localContext];

	_soundSectionNames  = [NSMutableArray arrayWithObjects:@"Shabbat",@"Jazzy",@"Eastern",@"Nature",@"Chimes, Bells & Alarms",@"Synthesized",@"OK, I'll wake up", nil];
	
	NSArray *shabbat = [NSArray arrayWithObjects:@"El Adon",@"Lecha Dodi",@"Ana Bekoach", nil];
	NSArray *eastern = [NSArray arrayWithObjects:@"Chinese Birthday",@"Lute",@"Ohm",@"Pluck",@"Sitar", nil];
	NSArray *bells = [NSArray arrayWithObjects:@"80's Alarm",@"Bicycle",@"Cowbell",@"O'clock",@"Phone Ring",@"Progressive Alarm",@"Sage Tyrtle Bells",@"Wine Glasses",@"Xylophone", nil];
	NSArray *jazzy = [NSArray arrayWithObjects:@"Sunny", @"Downy", @"Groovy",@"Riffy",@"Trumpy", nil];
	NSArray *annoying = [NSArray arrayWithObjects:@"Airhorn",@"Fire Alarm",@"Honk",@"Meltdown",@"Police", nil];
	NSArray *nature = [NSArray arrayWithObjects:@"Birds",@"Lake",@"Ocean",@"Rain",@"Stream",@"Whale",@"Wind", nil];
	NSArray *synth = [NSArray arrayWithObjects:@"Boker Tov",@"Fly",@"Gan Eden",@"Get Busy", @"I am Alive",@"Pursuit",@"Sun Shower", nil];
	
	_sounds = [NSMutableArray arrayWithObjects:shabbat,jazzy,eastern,nature,bells,synth,annoying, nil];
	
    [super viewDidLoad];
}

- (void)viewDidUnload{
    [super viewDidUnload];
}

-(void)viewWillDisappear:(BOOL)animated{
	[[SoundManager sharedManager] stopAllSounds:NO];
	[super viewWillDisappear:animated];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return [_soundSectionNames count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [[_sounds objectAtIndex:section] count];
}

-(NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
	return [_soundSectionNames objectAtIndex:section];
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
	UILabel *header = [[UILabel alloc] init];
	header.backgroundColor = [UIColor clearColor];
	[header setFont:[UIFont fontWithName:@"AvenirNext-Bold" size:18]];
	header.textColor = [UIColor darkGrayColor];
	header.text = [NSString stringWithFormat:@"   %@", [_soundSectionNames objectAtIndex:section]];
	
	return  header;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"SoundCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
	NSArray *group = [_sounds objectAtIndex:indexPath.section];
	cell.textLabel.text = [group objectAtIndex:indexPath.row];
	
	[cell.textLabel setFont:[UIFont fontWithName:@"AvenirNext-Regular" size:18]];
	
	cell.accessoryType = UITableViewCellAccessoryNone;
	
	if ([[self.alarmFound.soundURL stringByReplacingOccurrencesOfString:@".m4a" withString:@""] isEqualToString:cell.textLabel.text]) {
		cell.accessoryType = UITableViewCellAccessoryCheckmark;
	}
	
    return cell;
}


#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
	UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
	[tableView deselectRowAtIndexPath:indexPath animated:YES];
	
	
	for (UITableViewCell *aCell in tableView.visibleCells) {
		aCell.accessoryType = UITableViewCellAccessoryNone;
	}
	
	if (cell.accessoryType == UITableViewCellAccessoryNone) 
	{
        cell.accessoryType = UITableViewCellAccessoryCheckmark;
    }
	
	self.alarmFound.soundURL = [NSString stringWithFormat:@"%@.m4a",cell.textLabel.text];
	
	[[SoundManager sharedManager] stopAllSounds:NO];
	[[SoundManager sharedManager] playSound:self.alarmFound.soundURL looping:NO fadeIn:NO];
	
//	NSString *directory = [NSString stringWithFormat:@"Audio/%@",[_soundSectionNames objectAtIndex:indexPath.section]];
//	NSString *filePath =	[[NSBundle mainBundle] pathForResource:cell.textLabel.text ofType:@"m4a" inDirectory:directory];
	
//	[[OALSimpleAudio sharedInstance] stopAllEffects];
//	[[OALSimpleAudio sharedInstance] playEffect:self.alarmFound.soundURL loop:YES];

	
}

@end
