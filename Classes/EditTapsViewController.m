//
//  EditTapsViewController.m
//  NeoPhonic
//
//  Created by John Terry on 5/17/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "EditTapsViewController.h"
#import "TriggerViewController.h"

@implementation EditTapsViewController
@synthesize delegate;
@synthesize bpmLabel;
@synthesize selectedTag;
@synthesize triggers;

#pragma mark -
#pragma mark Actions

-(IBAction)tapPressed:(id)sender{
	UIButton *button = (UIButton*)sender;
	SoundPickerViewController *pvc = [[SoundPickerViewController alloc] initWithNibName:@"SoundPickerView" bundle:nil];
	pvc.delegate = self;
	pvc.button = button;
	
	[self presentModalViewController:pvc animated:YES];
	
	
}

-(void)donePressed:(id)sender{
	[self.delegate editTapsViewControllerDidFinish:self];
}

-(IBAction)sliderChanged:(id)sender{
	UISlider *slider = (UISlider*)sender;
	self.bpmLabel.text = [NSString stringWithFormat:@"%d bpm",(int)slider.value];
	
	TriggerViewController *spvc =  (TriggerViewController*)delegate;
	spvc.currentLoop.bpm = (int)slider.value;
}

-(void) measureLengthChanged:(id)sender{
	UISegmentedControl *control = (UISegmentedControl*)sender;
	TriggerViewController *spvc =  (TriggerViewController*)delegate;
	spvc.currentLoop.quarterNotes = [[control titleForSegmentAtIndex:[control selectedSegmentIndex]] integerValue];
	
}

#pragma mark -
#pragma mark delegate stuff

- (void) soundPickerController:(SoundPickerViewController *)controller DidChooseSound:(NeoSound *)sound WithGain:(float)gain AndPitch:(float)pitch{
	
	NSString *soundKey = [[delegate soundPlayer] prepBufferWithSound:sound AndGain:gain AndPitch:pitch];
	[[delegate soundKeys] addObject:soundKey];
	
	
	for (UIButton *trigger in [delegate triggers]) {
	
		for (UIButton *myTrigger in self.triggers) {
			if (myTrigger.tag == trigger.tag && myTrigger.tag == controller.button.tag) {
				NSLog(@"found match. %d", myTrigger.tag);
				
				myTrigger.tag = trigger.tag = [[delegate soundKeys] indexOfObject:soundKey];
			}
		}
		
	}
	
	[controller dismissModalViewControllerAnimated:YES];
	[controller release];
	
}


#pragma mark -
#pragma mark View Lifecycle


// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
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
    [super dealloc];
}

- (void) soundPickerControllerDidCancel:(SoundPickerViewController *)controller{
	[controller dismissModalViewControllerAnimated:YES];
}



@end
