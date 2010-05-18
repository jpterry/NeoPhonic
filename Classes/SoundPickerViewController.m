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
@synthesize button;

#pragma mark Actions
- (IBAction)playPressed:(id)sender{
	NSString* key = [player prepBufferWithSound:self.selectedSound AndGain:self.gainSlider.value AndPitch:self.pitchSlider.value];	
	[player playSound:key];
}

- (IBAction)savePressed:(id)sender{
	[self.delegate soundPickerController:self DidChooseSound:self.selectedSound WithGain:self.gainSlider.value AndPitch:self.pitchSlider.value];
}

- (IBAction)donePressed:(id)sender{
	[self.delegate soundPickerControllerDidCancel:self];
}

#pragma mark -
#pragma mark View lifecycle

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
	
	self.instruments = array;
	[request release];
	
	self.selectedSound = [self.instruments objectAtIndex:0];
	
	//mock:
	self.categories = [[NSMutableArray alloc] initWithObjects:@"Rock", @"Hip Hop",nil];
	//self.instruments = [[NSMutableArray alloc] initWithObjects:@"Static", @"Placeholder",nil];
	

}


#pragma mark -
#pragma mark Picker view

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView{
	return 1;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component{
	return [self.instruments count];
}

- (NSString *) pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component{
		return [NSString stringWithFormat:@"%@",[[self.instruments objectAtIndex:row] fileName]];
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
