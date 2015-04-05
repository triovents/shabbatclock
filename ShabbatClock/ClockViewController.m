//
//  ClockViewController.m
//  ShabbatClock
//
//  Created by Yehuda Cohen on 7/18/12.
//  Copyright (c) 2012 Independent. All rights reserved.
//

#import "ClockViewController.h"


#import <BEMAnalogClock/BEMAnalogClockView.h>

@interface ClockViewController () <BEMAnalogClockDelegate>

@property (weak, nonatomic) IBOutlet BEMAnalogClockView *bemAnalogClockView;

@end

@implementation ClockViewController


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	
	[self.bemAnalogClockView setClockToCurrentTimeAnimated:YES];
	self.bemAnalogClockView.hourHandWidth = 5.0;
	self.bemAnalogClockView.minuteHandWidth = 5.0;
	self.bemAnalogClockView.enableShadows = NO;
	self.bemAnalogClockView.realTime = YES;
	self.bemAnalogClockView.secondHandAlpha = 1;
	self.bemAnalogClockView.borderWidth = 10;
	self.bemAnalogClockView.faceBackgroundAlpha = 1;
	self.bemAnalogClockView.delegate = self;
	[self setNeedsStatusBarAppearanceUpdate];
	
}


- (void)currentTimeOnClock:(BEMAnalogClockView *)clock Hours:(NSString *)hours Minutes:(NSString *)minutes Seconds:(NSString *)seconds{
	if ([[NSUserDefaults standardUserDefaults] boolForKey:DefaultKeys.ticktock_ON] == YES) {
		[[SoundManager sharedManager] playSound:@"ticking.mp3"];
	}
}

-(UIStatusBarStyle)preferredStatusBarStyle{
    return UIStatusBarStyleLightContent;
}

-(void)viewWillAppear:(BOOL)animated{
//	[[UIApplication sharedApplication] setStatusBarHidden:YES withAnimation:UIStatusBarAnimationFade];
}

-(void)viewWillDisappear:(BOOL)animated{
//	[[UIApplication sharedApplication] setStatusBarHidden:NO withAnimation:UIStatusBarAnimationFade];
	[[SoundManager sharedManager] stopSound:@"ticking.mp3"];
}


-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
	[self dismissViewControllerAnimated:YES completion:nil];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
	return interfaceOrientation;
//    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

@end
