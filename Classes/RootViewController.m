//
//  RootViewController.m
//  Conference
//
//  Created by Steve Baker on 1/3/10.
//  Copyright Beepscore LLC 2010. All rights reserved.
//
//
//  RootViewController.m
//  Conference
//
//  Created by Bill Dudney on 5/11/09.
//  Copyright Gala Factory Software LLC 2009. All rights reserved.
//
//
//  Licensed with the Apache 2.0 License
//  http://apache.org/licenses/LICENSE-2.0
//

#import "RootViewController.h"
#import "TrackEditingViewController.h"
#import "SessionsViewController.h"
#import "Track.h"

@interface RootViewController()
@property(nonatomic, assign) BOOL firstInsert;
@end

@implementation RootViewController

@synthesize fetchedResultsController;
@synthesize managedObjectContext;
@synthesize trackEditingVC = _trackEditingVC;
@synthesize sessionsVC = _sessionsVC;
@synthesize firstInsert = _firstInsert;

//START:code.RVC.viewDidLoad
- (void)viewDidLoad {
    [super viewDidLoad];
    
	// Set up the edit and add buttons.
    self.navigationItem.leftBarButtonItem = self.editButtonItem;
    
    UIBarButtonItem *addButton = [[UIBarButtonItem alloc]
                                  initWithBarButtonSystemItem:UIBarButtonSystemItemAdd
                                  target:self
                                  action:@selector(insertTrack)];
    self.navigationItem.rightBarButtonItem = addButton;
    [addButton release];
	
	NSError *error = nil;
	if (![self.fetchedResultsController performFetch:&error]) {
        // handle the error...
	}
    
    self.title = @"Tracks";
}
//END:code.RVC.viewDidLoad

//START:code.RVC.insertTrack
- (void)insertTrack {
    self.firstInsert = [self.fetchedResultsController.sections count] == 0;
	
    NSManagedObjectContext *context = 
    [self.fetchedResultsController managedObjectContext];
    NSEntityDescription *entity = 
    [self.fetchedResultsController.fetchRequest entity];
    Track *track = 
    [NSEntityDescription insertNewObjectForEntityForName:[entity name]
                                  inManagedObjectContext:context];
    
    [track setValue:@"Track" forKey:@"name"];
    [track setValue:@"This is a great track" forKey:@"trackAbstract"];
    
    NSError *error = nil;
    if (![context save:&error]) {
        // Handle the error...
    }
}
//END:code.RVC.insertTrack

- (void)viewDidUnload {
    self.fetchedResultsController = nil;
}


#pragma mark Table view methods

//START:code.RVC.numberOfSectionsInTableView
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return [[fetchedResultsController sections] count];
}
//END:code.RVC.numberOfSectionsInTableView

//START:code.RVC.numberOfRowsInSection
- (NSInteger)tableView:(UITableView *)tableView 
 numberOfRowsInSection:(NSInteger)section {
    return [[[fetchedResultsController sections] objectAtIndex:section]
            numberOfObjects];
}
//END:code.RVC.numberOfRowsInSection

//START:code.RVC.cellForRowAtIndexPath
- (void)configureCell:(UITableViewCell *)cell withTrack:(Track *)track {
	cell.textLabel.text = track.name;
    cell.detailTextLabel.text = track.trackAbstract;
}

- (UITableViewCell *)tableView:(UITableView *)tableView 
         cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell =
    [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle 
                                       reuseIdentifier:CellIdentifier] autorelease];
    }
    
    Track *track = [fetchedResultsController objectAtIndexPath:indexPath];//<label id="code.RVC.cellForRowAtIndexPath.getTrack"/>
    [self configureCell:cell withTrack:track];
	
    return cell;
}
//END:code.RVC.cellForRowAtIndexPath

//START:code.RVC.didSelectRowAtIndexPath
- (void)tableView:(UITableView *)tableView 
didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    Track *track = [[self fetchedResultsController] objectAtIndexPath:indexPath];
    if(YES == self.editing) {
        self.trackEditingVC.selectedTrack = track;
        [self.navigationController pushViewController:self.trackEditingVC animated:YES];
    } else {
        self.sessionsVC.selectedTrack = track;
        self.sessionsVC.title = track.name;
        [self.navigationController pushViewController:self.sessionsVC animated:YES];
    }
}
//END:code.RVC.didSelectRowAtIndexPath

//START:code.RVC.commitEditingStyle
- (void)tableView:(UITableView *)tableView 
commitEditingStyle:(UITableViewCellEditingStyle)editingStyle 
forRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        NSManagedObjectContext *context = 
        [fetchedResultsController managedObjectContext];
        Track *track = [fetchedResultsController objectAtIndexPath:indexPath];
        [context deleteObject:track];
		
		// Save the context.
        NSError *error;
        if (![context save:&error]) {
            // Handle the error...
        }
    }   
}
//END:code.RVC.commitEditingStyle

- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // The table view should not be re-orderable.
    // because the fetch order is defined in the fetch results controller
    // and moving the rows would not be possible persistently
    return NO;
}


#pragma mark -

//START:code.RVC.fetchedResultsController
- (NSFetchedResultsController *)fetchedResultsController {
    if (fetchedResultsController != nil) {
        return fetchedResultsController;
    }
    
	NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
	NSEntityDescription *entity = 
    [NSEntityDescription entityForName:@"Track"
                inManagedObjectContext:managedObjectContext];
	[fetchRequest setEntity:entity];
	
	NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] 
                                        initWithKey:@"name" ascending:YES];
	[fetchRequest setSortDescriptors:[NSArray arrayWithObject:sortDescriptor]];
	
	NSFetchedResultsController *aFetchedResultsController = 
    [[NSFetchedResultsController alloc] initWithFetchRequest:fetchRequest 
                                        managedObjectContext:managedObjectContext
                                          sectionNameKeyPath:nil
                                                   cacheName:@"Root"];
    aFetchedResultsController.delegate = self; // <label id="code.RVC.FRC.delegate"/>
	self.fetchedResultsController = aFetchedResultsController;
	
	[aFetchedResultsController release];
	[fetchRequest release];
	[sortDescriptor release];
	
	return fetchedResultsController;
}    
//END:code.RVC.fetchedResultsController

#pragma mark FRC delegate methods

- (void)controllerWillChangeContent:(NSFetchedResultsController *)controller {
    [self.tableView beginUpdates];
}

//START:code.RVC.didChangeObject
- (void)controller:(NSFetchedResultsController *)controller 
   didChangeObject:(id)anObject 
       atIndexPath:(NSIndexPath *)indexPath 
     forChangeType:(NSFetchedResultsChangeType)type 
      newIndexPath:(NSIndexPath *)newIndexPath {
    
    if(NSFetchedResultsChangeUpdate == type) {
        [self configureCell:[self.tableView cellForRowAtIndexPath:indexPath]
                  withTrack:anObject];
    } else if(NSFetchedResultsChangeMove == type) {
        [self.tableView reloadSections:[NSIndexSet indexSetWithIndex:0]
                      withRowAnimation:UITableViewRowAnimationFade];
    } else if(NSFetchedResultsChangeInsert == type) {
        if(!self.firstInsert) {
            [self.tableView insertRowsAtIndexPaths:[NSArray arrayWithObject:newIndexPath]
                                  withRowAnimation:UITableViewRowAnimationRight];
        } else {
            [self.tableView insertSections:[[NSIndexSet alloc] initWithIndex:0] 
                          withRowAnimation:UITableViewRowAnimationRight];
        }
    } else if(NSFetchedResultsChangeDelete == type) {
        NSInteger sectionCount = [[fetchedResultsController sections] count];
        if(0 == sectionCount) {
            NSIndexSet *indexes = [NSIndexSet indexSetWithIndex:indexPath.section];
            [self.tableView deleteSections:indexes
                          withRowAnimation:UITableViewRowAnimationFade];
        } else {
            [self.tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath]
                                  withRowAnimation:UITableViewRowAnimationFade];
        }
    }
}
//END:code.RVC.didChangeObject

- (void)controllerDidChangeContent:(NSFetchedResultsController *)controller {
    [self.tableView endUpdates];
}

#pragma mark -

- (void)dealloc {
	[fetchedResultsController release];
	[managedObjectContext release];
    self.trackEditingVC = nil;
    self.sessionsVC = nil;
    [super dealloc];
}

@end
