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
@synthesize triggers;
@synthesize soundPlayer;

#pragma mark -
#pragma mark View actions

-(IBAction)tapPressed:(id)sender{

	[self.soundPlayer playSound:@"snare"];
	
}

-(IBAction)recordPressed:(id)sender{
	
}

-(IBAction)editPressed:(id)sender{
	SoundPickerViewController *pvc = [[SoundPickerViewController alloc] initWithNibName:@"SoundPickerView" bundle:nil];
	pvc.delegate = self;
	[self presentModalViewController:pvc animated:YES];
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
			[buttons addObject:button];
		}
	}
	self.triggers = buttons;
	[buttons release];
	
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
    [super dealloc];
}

#pragma mark -
#pragma mark SoundPickerViewController delegate 

-(void)soundPickerController:(SoundPickerViewController*)controller DidChooseSound:(NeoSound*)sound InBuffer:(NSNumber*)bufferID{
	// Assign buffer to trigger
	
	[controller dismissModalViewControllerAnimated:YES];
	// TODO: Does this work like I think it does?
	[controller release];
}


@end
