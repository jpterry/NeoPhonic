//
//  TriggerViewController.m
//  NeoPhonic
//
//  Created by John Terry on 5/3/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "TriggerViewController.h"

#import "SoundPlayer.h"

@implementation TriggerViewController
@synthesize soundPlayer;
@synthesize triggers;
@synthesize soundKeys;
@synthesize triggerMap;
@synthesize selectedTrigger;
@synthesize editMode, recording;
@synthesize loopButton1, loopButton2, loopButton3, loopButton4;
@synthesize currentLoop, loop1, loop2, loop3, loop4;
@synthesize tempoSlider;
@synthesize tempoLabel;
@synthesize loopLengthControl;

#pragma mark -
#pragma mark View actions

-(IBAction)tapPressed:(id)sender{
	UIButton *trigger = (UIButton*)sender;
	self.selectedTrigger = trigger;
	NSUInteger index = self.selectedTrigger.tag;
	@try {
		NSString *key = [self.soundKeys objectAtIndex:index];
		[soundPlayer playSound:key];
		if(self.recording){
			[self.currentLoop recordSoundAtCurrentSubBeat:key];
		}
	}
	@catch (NSException * e) {
		//
		NSLog(@"catch");
	}
	@finally {
		//
	}
	
}

-(IBAction)recordPressed:(id)sender{	
	UIButton *button = (UIButton*)sender;
	Loop *loop = nil;
	switch (button.tag) {
		case 1:
			loop = self.loop1;
			break;
		case 2:
			loop = self.loop2;
			break;
		case 3:
			loop = self.loop3;
			break;
		case 4:
			loop = self.loop4;
			break;
		default:
			loop = self.loop1;
			break;
	}
	self.currentLoop = loop;
	self.currentLoop.soundPlayer = self.soundPlayer;
	self.recording = YES;
	if ([[button titleForState:UIControlStateNormal] isEqualToString:@"Record"]) {
		[button setTitle:@"Recording" forState:UIControlStateNormal];
		[button setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
		// Record with playback
		[loop startRecordingWithPlaybackLoop:self];
		
	} else if ([[button titleForState:UIControlStateNormal] isEqualToString:@"Recording"]){
		[button setTitle:@"Stop" forState:UIControlStateNormal];
		[button setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
		// Stop recording - keep playing
		self.recording = NO;
		
	}else if ([[button titleForState:UIControlStateNormal] isEqualToString:@"Stop"]){
		[button setTitle:@"Record" forState:UIControlStateNormal];
		[button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
		// Stop loop
		[loop stop];
		
		
	} else {

	}

}

-(IBAction)editPressed:(id)sender{
	self.editMode = self.editMode ? NO : YES;
	EditTapsViewController *editController = [[EditTapsViewController alloc] initWithNibName:@"EditTapsView" bundle:nil];
	editController.delegate = self;
	editController.modalTransitionStyle = UIModalTransitionStyleFlipHorizontal;
	[self presentModalViewController:editController animated:YES];
		
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
			if (button.tag > 10) {
				[buttons addObject:button];
			}
		}
	}
	self.triggers = buttons;
	[buttons release];
	
	self.soundKeys = [NSMutableArray arrayWithCapacity:[self.triggers count]];
	[self.soundKeys addObject:@""];
	self.loop1 = [[Loop alloc] init];
	self.loop2 = [[Loop alloc] init];
	self.loop3 = [[Loop alloc] init];
	self.loop4 = [[Loop alloc] init];
	
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
	[self.currentLoop release];
    [super dealloc];
}

#pragma mark -
#pragma mark SoundPickerViewController delegate 

/*
- (void) soundPickerController:(SoundPickerViewController *)controller DidChooseSound:(NeoSound *)sound WithGain:(float)gain AndPitch:(float)pitch{
	self.editMode = NO;
	NSString *soundKey = [self.soundPlayer prepBufferWithSound:sound AndGain:gain AndPitch:pitch];
	[self.soundKeys addObject:soundKey];
	self.selectedTrigger.tag = [self.soundKeys indexOfObject:soundKey];
	
	
	[controller dismissModalViewControllerAnimated:YES];
	// TODO: Does this work like I think it does?
	[controller release];
}
*/
 
- (void)soundPickerControllerDidCancel:(SoundPickerViewController *)controller{
	[controller dismissModalViewControllerAnimated:YES];
	[controller release];
}

- (void)editTapsViewControllerDidFinish:(EditTapsViewController *)controller{
	for (UIButton *button in triggers) {
		if (button.tag == controller.selectedTag) {
			// assign sound to trigger
		}
	}
	[controller dismissModalViewControllerAnimated:YES];
	[controller release];
}


#pragma mark -
#pragma mark Loop control

-(IBAction)tempoChanged:(id)sender{
	UISlider *slider = (UISlider*)sender;
	self.tempoLabel.text = [NSString stringWithFormat:@"%d bpm",(int)[slider value]];
	self.currentLoop.bpm = (int)slider.value;
}


@end
