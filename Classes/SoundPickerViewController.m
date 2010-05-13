//
//  SoundPickerViewController.m
//  NeoPhonic
//
//  Created by John Terry on 5/4/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "SoundPickerViewController.h"

@implementation SoundPickerViewController
@synthesize delegate;
@synthesize player;
@synthesize soundLabel;
@synthesize soundPickerView;
@synthesize gainSlider, pitchSlider;
@synthesize categories, instruments;

#pragma mark Actions
- (IBAction)playPressed:(id)sender{
	// Load selected sound into buffer and play it
	
	NeoSound *selectedSound = [[NeoSound alloc] initWithDefaults];
	
	// TODO: This needs to come from the datasource not be mocked
	selectedSound.fileName = [[NSBundle mainBundle] pathForResource:@"Snare" ofType:@"caf"];
	NSString* key = [player prepBufferWithSound:selectedSound AndGain:gainSlider.value AndPitch:pitchSlider.value];
	[player playSound:key];
	
}

- (IBAction)savePressed:(id)sender{
	// TODO: fix
	[self.delegate soundPickerController:self DidChooseSound:nil InBuffer:nil];
}

// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
	self.player = [[SoundPlayer alloc]init];
	
    [super viewDidLoad];
	
	// Load up the list of sounds;
	
	// Core data?
	// I'd like something like
	
	//mock:
	self.categories = [[NSMutableArray alloc] initWithObjects:@"Rock", @"Hip Hop",nil];
	self.instruments = [[NSMutableArray alloc] initWithObjects:@"Static", @"Placeholder",nil];;

}


/*
// Override to allow orientations other than the default portrait orientation.
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}
*/
#pragma mark -
#pragma mark Picker view

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView{
	return 2;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component{
	if (component == 0) {
		return [self.categories count];
	}
	else {
		return [self.instruments count];
	}
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component{
	//Sound *sound = [[Sound alloc]initWithDefaults];	
	//NSLog(@"%@",[Sound soundsForCategory:@"string"]);
	
}


#pragma mark -
#pragma mark Memory

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


@end
