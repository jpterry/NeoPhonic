//
//  SoundPickerViewController.m
//  NeoPhonic
//
//  Created by John Terry on 5/4/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "SoundPickerViewController.h"

#import "NeoPhonicAppDelegate.h"

@implementation SoundPickerViewController
@synthesize delegate;
@synthesize player;
@synthesize selectedSound;
@synthesize soundLabel;
@synthesize soundPickerView;
@synthesize gainSlider, pitchSlider;
@synthesize categories, instruments;

#pragma mark Actions
- (IBAction)playPressed:(id)sender{
	// Load selected sound into buffer and play it
	
	
	// TODO: This needs to come from the datasource not be mocked
	//self.selectedSound.fileName = [[NSBundle mainBundle] pathForResource:@"Snare" ofType:@"caf"];
	NSString* key = [player prepBufferWithSound:self.selectedSound AndGain:self.gainSlider.value AndPitch:self.pitchSlider.value];
	
	[player playSound:key];
	//[player cleanUpOpenAL:self];
	
	
}

- (IBAction)savePressed:(id)sender{
	[self.delegate soundPickerController:self DidChooseSound:self.selectedSound WithGain:self.gainSlider.value AndPitch:self.pitchSlider.value];
}

// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
	self.player = [[SoundPlayer alloc]init];
	
    [super viewDidLoad];
	
	// Load up the list of sounds;
	NeoPhonicAppDelegate *appDelegate = [[UIApplication sharedApplication] delegate];
	NSManagedObjectContext *context = appDelegate.managedObjectContext;
	NSFetchRequest *request = [[NSFetchRequest alloc] init];
	NSEntityDescription *entity = [NSEntityDescription entityForName:@"NeoSound" inManagedObjectContext:context];
	[request setEntity:entity];
	
	NSError *error = nil;
	NSArray *array = [context executeFetchRequest:request error:&error];
	NSLog(@"%@",array);
	
	self.instruments = array;
	[request release];
	
	self.selectedSound = [self.instruments objectAtIndex:0];
	
	//mock:
	self.categories = [[NSMutableArray alloc] initWithObjects:@"Rock", @"Hip Hop",nil];
	//self.instruments = [[NSMutableArray alloc] initWithObjects:@"Static", @"Placeholder",nil];
	

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

- (NSString *) pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component{
	if (component==1) {
		return [NSString stringWithFormat:@"%@",[[self.instruments objectAtIndex:row] fileName]];
	}
	else {
		return @"All";
	}


}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component{
	//Sound *sound = [[Sound alloc]initWithDefaults];	
	//NSLog(@"%@",[Sound soundsForCategory:@"string"]);
	self.selectedSound = (NeoSound*)[self.instruments objectAtIndex:row];
}


#pragma mark -
#pragma mark Memory

- (void)didReceiveMemoryWarning {
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

- (void)viewDidUnload {
	self.player = nil;
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}


- (void)dealloc {
	[self.player release];
    [super dealloc];
}

@end
