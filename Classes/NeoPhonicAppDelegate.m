//
//  NeoPhonicAppDelegate.m
//  NeoPhonic
//
//  Created by John Terry on 5/3/10.
//  Copyright __MyCompanyName__ 2010. All rights reserved.
//

#import "NeoPhonicAppDelegate.h"


@interface NeoPhonicAppDelegate (PrivateCoreDataStack)
@property (nonatomic, retain, readonly) NSManagedObjectModel *managedObjectModel;
@property (nonatomic, retain, readonly) NSManagedObjectContext *managedObjectContext;
@property (nonatomic, retain, readonly) NSPersistentStoreCoordinator *persistentStoreCoordinator;
@end


@implementation NeoPhonicAppDelegate

@synthesize window;
@synthesize triggerViewController;


#pragma mark -
#pragma mark Application lifecycle

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {    
	
	if (![[NSUserDefaults standardUserDefaults] boolForKey:@"installed"]){
		[self installSounds];
	}
    // Override point for customization after application launch
	[window setBackgroundColor:[UIColor blackColor]];
	[window addSubview:triggerViewController.view];
	[window makeKeyAndVisible];
	
	return YES;
}


/**
 applicationWillTerminate: saves changes in the application's managed object context before the application terminates.
 */
- (void)applicationWillTerminate:(UIApplication *)application {
	
    NSError *error = nil;
    if (managedObjectContext != nil) {
        if ([managedObjectContext hasChanges] && ![managedObjectContext save:&error]) {
			/*
			 Replace this implementation with code to handle the error appropriately.
			 
			 abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development. If it is not possible to recover from the error, display an alert panel that instructs the user to quit the application by pressing the Home button.
			 */
			NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
			abort();
        } 
    }
}


#pragma mark -
#pragma mark Core Data stack

/**
 Returns the managed object context for the application.
 If the context doesn't already exist, it is created and bound to the persistent store coordinator for the application.
 */
- (NSManagedObjectContext *) managedObjectContext {
	
    if (managedObjectContext != nil) {
        return managedObjectContext;
    }
	
    NSPersistentStoreCoordinator *coordinator = [self persistentStoreCoordinator];
    if (coordinator != nil) {
        managedObjectContext = [[NSManagedObjectContext alloc] init];
        [managedObjectContext setPersistentStoreCoordinator: coordinator];
    }
    return managedObjectContext;
}


/**
 Returns the managed object model for the application.
 If the model doesn't already exist, it is created by merging all of the models found in the application bundle.
 */
- (NSManagedObjectModel *)managedObjectModel {
	
    if (managedObjectModel != nil) {
        return managedObjectModel;
    }
    managedObjectModel = [[NSManagedObjectModel mergedModelFromBundles:nil] retain];    
    return managedObjectModel;
}


/**
 Returns the persistent store coordinator for the application.
 If the coordinator doesn't already exist, it is created and the application's store added to it.
 */
- (NSPersistentStoreCoordinator *)persistentStoreCoordinator {
	
    if (persistentStoreCoordinator != nil) {
        return persistentStoreCoordinator;
    }
	
    NSURL *storeUrl = [NSURL fileURLWithPath: [[self applicationDocumentsDirectory] stringByAppendingPathComponent: @"NeoPhonic.sqlite"]];
	
	NSError *error = nil;
    persistentStoreCoordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:[self managedObjectModel]];
    if (![persistentStoreCoordinator addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:storeUrl options:nil error:&error]) {
        /*
         Replace this implementation with code to handle the error appropriately.
         
         abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development. If it is not possible to recover from the error, display an alert panel that instructs the user to quit the application by pressing the Home button.
         
         Typical reasons for an error here include:
         * The persistent store is not accessible;
         * The schema for the persistent store is incompatible with current managed object model.
         Check the error message to determine what the actual problem was.
         
         
         If the persistent store is not accessible, there is typically something wrong with the file path. Often, a file URL is pointing into the application's resources directory instead of a writeable directory.
         
         If you encounter schema incompatibility errors during development, you can reduce their frequency by:
         * Simply deleting the existing store:
         [[NSFileManager defaultManager] removeItemAtURL:storeURL error:nil]
         
         * Performing automatic lightweight migration by passing the following dictionary as the options parameter: 
         [NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithBool:YES],NSMigratePersistentStoresAutomaticallyOption, [NSNumber numberWithBool:YES], NSInferMappingModelAutomaticallyOption, nil];
         
         Lightweight migration will only work for a limited set of schema changes; consult "Core Data Model Versioning and Data Migration Programming Guide" for details.
         
         */
		NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
		abort();
    }    
	
    return persistentStoreCoordinator;
}


#pragma mark -
#pragma mark Filesystem helpers

/**
 Returns the path to the application's Documents directory.
 */
- (NSString *)applicationDocumentsDirectory {
	return [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
}

- (NSString *)soundsDirectory {
	return [[self applicationDocumentsDirectory] stringByAppendingPathComponent:@"Sounds"];
}


#pragma mark -
#pragma mark Memory management

- (void)dealloc {
	
    [managedObjectContext release];
    [managedObjectModel release];
    [persistentStoreCoordinator release];
    
	[window release];
	[super dealloc];
}

#pragma mark -
#pragma mark Installation

- (void)installSounds{
	NSLog(@"Installing Sounds");
	NSFileManager *fm = [NSFileManager defaultManager];
	// Copy Sound directory from bundle to documents
	NSError *error = nil;
	NSLog(@"Copying files");
	BOOL success = [fm copyItemAtPath:[[NSBundle mainBundle] pathForResource:@"Sounds" ofType:nil] 
							   toPath:[self soundsDirectory] 
								error:&error];
	if(!success){
		NSLog(@"Couldn't copy sounds directory to documents: %@",error);
		return; // Don't insert the sounds
	}
	NSLog(@"Done copying");
	
	// Insert Sounds into core data store
    // TODO: new api returns an enumerator    
    NSArray *catNames = [fm contentsOfDirectoryAtPath:[self soundsDirectory] error:&error];
	
	for (NSString *category in catNames){
		NSLog(@"in category %@:", category);
		NSString *currentPath = [[self soundsDirectory] stringByAppendingPathComponent:category];
		NSArray *soundFileNames = [fm contentsOfDirectoryAtPath:currentPath error:&error];
		for( NSString *soundFileName in soundFileNames){
			NSLog(@"Inserting: %@",soundFileName);
			NSManagedObject *newSound = [NSEntityDescription insertNewObjectForEntityForName:@"NeoSound" inManagedObjectContext:self.managedObjectContext];
			[newSound setValue:category forKey:@"category"];
			[newSound setValue:soundFileName forKey:@"fileName"];
		}
	}
	error = nil;
	if (![self.managedObjectContext save:&error]) {
		NSLog(@"Couldn't save objects");
	}
	[[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"installed"];
		
}


@end

