//
//  TriggerViewController.m
//  NeoPhonic
//
//  Created by John Terry on 5/3/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "TriggerViewController.h"

#import "SoundPlayer.h"
#import "Loop.h"

@implementation TriggerViewController
@synthesize soundPlayer;
@synthesize triggers;
@synthesize soundKeys;
@synthesize selectedTrigger;
@synthesize editMode;

@synthesize tempoSlider;
@synthesize tempoLabel;
@synthesize loopLengthControl;

#pragma mark -
#pragma mark View actions

-(IBAction)tapPressed:(id)sender{
	UIButton *trigger = (UIButton*)sender;
	self.selectedTrigger = trigger;
	
	if (self.editMode) {
		SoundPickerViewController *pvc = [[SoundPickerViewController alloc] initWithNibName:@"SoundPickerView" bundle:nil];
		pvc.delegate = self;
		[self presentModalViewController:pvc animated:YES];
	} else {
		NSUInteger index = self.selectedTrigger.tag;
		NSString *key = [self.soundKeys objectAtIndex:index];
		[soundPlayer playSound:key];
	}

}

-(IBAction)recordPressed:(id)sender{
	Loop *theLoop = [[Loop alloc] init];
	[theLoop startRecordingWithPlaybackLoop:self];
}

-(IBAction)editPressed:(id)sender{
	self.editMode = self.editMode ? NO : YES;
		
}

#pragma mark -
#pragma mark View lifecycle


// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
	self.soundPlayer = [[SoundPlayer alloc] init];
	// Find all the triggers and put them into self.triggers
	NSMutableArray *buttons = [[NSMutableArray alloc] init];
	for( UIView *subView in self.view.subviews ){
		if ([subView isKindOfClass:[UIButton class]]) {
			UIButton *button = (UIButton*)subView;
			button.tag = 0;
			[buttons addObject:button];
		}
	}
	self.triggers = buttons;
	[buttons release];
	
	self.soundKeys = [NSMutableArray arrayWithCapacity:[self.triggers count]];
	[self.soundKeys addObject:@""];
	NSLog(@"%@",self.soundKeys);
	
    [super viewDidLoad];
}



- (void)didReceiveMemoryWarning {
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

- (void)viewDidUnload {
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}


- (void)dealloc {
	[self.soundPlayer release];
	[self.triggers release];
    [super dealloc];
}

#pragma mark -
#pragma mark SoundPickerViewController delegate 


- (void) soundPickerController:(SoundPickerViewController *)controller DidChooseSound:(NeoSound *)sound WithGain:(float)gain AndPitch:(float)pitch{
	self.editMode = NO;
	NSString *soundKey = [self.soundPlayer prepBufferWithSound:sound AndGain:gain AndPitch:pitch];
	[self.soundKeys addObject:soundKey];
	self.selectedTrigger.tag = [self.soundKeys indexOfObject:soundKey];
	
	[controller dismissModalViewControllerAnimated:YES];
	// TODO: Does this work like I think it does?
	[controller release];
	
}

#pragma mark -
#pragma mark Loop control

-(IBAction)tempoChanged:(id)sender{
	UISlider *slider = (UISlider*)sender;
	NSLog(@"Tempo Change: %d",(int)[slider value]);
	self.tempoLabel.text = [NSString stringWithFormat:@"%d bpm",(int)[slider value]];
}

-(IBAction)measureLengthChanged:(id)sender{
	
}

@end
