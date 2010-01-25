//
//  SessionsViewController.m
//  Conference
//
//  Created by Steve Baker on 1/25/10.
//  Copyright 2010 Beepscore LLC. All rights reserved.
//
//  Created by Bill Dudney on 5/11/09.
//  Copyright 2009 Gala Factory Software LLC. All rights reserved.
//
//  Licensed with the Apache 2.0 License
//  http://apache.org/licenses/LICENSE-2.0
//

#import "SessionsViewController.h"
#import "SessionEditingViewController.h"
#import "Track.h"
#import "Session.h"

@interface SessionsViewController()
@property(nonatomic, assign) BOOL firstInsert;
@end

@implementation SessionsViewController

@synthesize selectedTrack = _selectedTrack;
@synthesize selectedIndexPath = _selectedIndexPath;
@synthesize sessionEditingVC = _sessionEditingVC;
@synthesize fetchedResultsController = _fetchedResultsController;
@synthesize firstInsert = _firstInsert;

- (void)viewDidLoad {
    [super viewDidLoad];
    
    UIBarButtonItem *addButton = [[UIBarButtonItem alloc]
                                  initWithBarButtonSystemItem:UIBarButtonSystemItemAdd
                                  target:self
                                  action:@selector(insertSession)];
    self.navigationItem.rightBarButtonItem = addButton;
    [addButton release];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    if(nil != self.selectedIndexPath) {
        [self configureCell:[self.tableView cellForRowAtIndexPath:self.selectedIndexPath]
                withSession:[self.fetchedResultsController objectAtIndexPath:self.selectedIndexPath]];
    }
    self.selectedIndexPath = nil;
}

#pragma mark -

//START:code.SVC.nextSessionIdentifier
- (NSString *)nextSessionIdentifier {
    NSString *nextId = @"Session01";
    
    NSManagedObjectContext *ctx = self.selectedTrack.managedObjectContext;
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"Session" 
                                              inManagedObjectContext:ctx];
	NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
	[fetchRequest setEntity:entity];
    NSString *predFormat = @"sessionID = max(sessionID)";
    NSPredicate *pred = [NSPredicate predicateWithFormat:predFormat];
    [fetchRequest setPredicate:pred];
    
    NSError *error = nil;
    NSArray *values = [ctx executeFetchRequest:fetchRequest error:&error];
    if(0 != [values count]) {
        Session *session = [values objectAtIndex:0];
        NSString *maxId = [session valueForKey:@"sessionID"];
        NSString *number = [maxId stringByTrimmingCharactersInSet:
                            [NSCharacterSet letterCharacterSet]];
        NSString *name = [maxId stringByTrimmingCharactersInSet:
                          [NSCharacterSet decimalDigitCharacterSet]];
        NSNumberFormatter *formatter = 
        [[[NSNumberFormatter alloc] init] autorelease];
        NSNumber *value = [formatter numberFromString:number];
        nextId = [NSString stringWithFormat:@"%@%02d", name, [value intValue] + 1];
    }
    return nextId;
}
//END:code.SVC.nextSessionIdentifier

//START:code.SVC.insertSession
- (void)insertSession {
    self.firstInsert = [self.fetchedResultsController.sections count] == 0;
    NSString *nextId = [self nextSessionIdentifier]; //<label id="code.SVC.getNextIdentifier"/>
	// Create a new instance of the entity managed by the 
    // fetched results controller.
    NSManagedObjectContext *context = self.selectedTrack.managedObjectContext;
	Session *session = 
    [NSEntityDescription insertNewObjectForEntityForName:@"Session"
                                  inManagedObjectContext:context];
	
	// If appropriate, configure the new managed object.
	[session setValue:@"Session" forKey:@"name"];
	[session setValue:@"This is a great session" forKey:@"sessionAbstract"];
    [session setValue:nextId forKey:@"sessionID"];
    
    [self.selectedTrack addSessionsObject:session]; //<label id="code.SVC.addSessionObject"/>
    
	// Save the context.
    NSError *error = nil;
    if (![context save:&error]) {
		// Handle the error...
    }
}
//END:code.SVC.insertSession

//START:code.SVC.setSelectedTrack
- (void)setSelectedTrack:(Track *)track {
    if(track != _selectedTrack) {
        [_selectedTrack release];
        _selectedTrack = [track retain];
        self.fetchedResultsController = nil;
        [self.tableView reloadData];
    }
}
//END:code.SVC.setSelectedTrack

#pragma mark Table view methods

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.fetchedResultsController.sections.count;
}

// Customize the number of rows in the table view.
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    id info = [self.fetchedResultsController.sections objectAtIndex:section];
    return [info numberOfObjects];
}

- (void)configureCell:(UITableViewCell *)cell withSession:(NSManagedObject *)model {
	cell.textLabel.text = [model valueForKey:@"name"];
    cell.detailTextLabel.text = [model valueForKey:@"sessionID"];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier] autorelease];
    }
    
    [self configureCell:cell
            withSession:[self.fetchedResultsController objectAtIndexPath:indexPath]];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView 
didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    self.selectedIndexPath = indexPath;
    Session *session = [self.fetchedResultsController 
                        objectAtIndexPath:indexPath];
    self.sessionEditingVC.selectedSession = session;
    self.sessionEditingVC.title = session.name;
    [self.navigationController pushViewController:self.sessionEditingVC 
                                         animated:YES];
}

//START:code.SVC.commitEditingStyle
- (void)tableView:(UITableView *)tableView 
commitEditingStyle:(UITableViewCellEditingStyle)editingStyle 
forRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        Session *session = [self.fetchedResultsController objectAtIndexPath:indexPath];
        [self.selectedTrack removeSessionsObject:session];//<label id="code.SVC.removeSessionsObject"/>
        NSManagedObjectContext *context = self.selectedTrack.managedObjectContext;
        [context deleteObject:session];
        // Save the context.
        NSError *error;
        if (![context save:&error]) {
            // Handle the error...
        }
    }   
}
//END:code.SVC.commitEditingStyle

#pragma mark -

//START:code.SVC.fetchedResultsController
- (NSFetchedResultsController *)fetchedResultsController {
    if (nil == _fetchedResultsController) {
        NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
        NSManagedObjectContext *context = self.selectedTrack.managedObjectContext;
        NSEntityDescription *entity = 
        [NSEntityDescription entityForName:@"Session"
                    inManagedObjectContext:context];
        [fetchRequest setEntity:entity];
        
        NSPredicate *pred = [NSPredicate predicateWithFormat:@"track = %@",
                             self.selectedTrack]; //<label id="code.SVC.predicate"/>
        [fetchRequest setPredicate:pred];
        
        NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] 
                                            initWithKey:@"name" ascending:YES];
        [fetchRequest setSortDescriptors:[NSArray arrayWithObject:sortDescriptor]];
        
        NSFetchedResultsController *aFetchedResultsController = 
        [[NSFetchedResultsController alloc] initWithFetchRequest:fetchRequest 
                                            managedObjectContext:context
                                              sectionNameKeyPath:nil
                                                       cacheName:@"Sessions"];
        aFetchedResultsController.delegate = self;
        self.fetchedResultsController = aFetchedResultsController;
        NSError *error = nil;
        if (![self.fetchedResultsController performFetch:&error]) {
            // handle the error...
        }
        [aFetchedResultsController release];
        [fetchRequest release];
        [sortDescriptor release];
    }	
	return _fetchedResultsController;
}    
//END:code.SVC.fetchedResultsController

#pragma mark FRC delegate methods

- (void)controllerWillChangeContent:(NSFetchedResultsController *)controller {
    [self.tableView beginUpdates];
}

- (void)controller:(NSFetchedResultsController *)controller 
   didChangeObject:(id)anObject 
       atIndexPath:(NSIndexPath *)indexPath 
     forChangeType:(NSFetchedResultsChangeType)type 
      newIndexPath:(NSIndexPath *)newIndexPath {
    
    if(NSFetchedResultsChangeUpdate == type) {
        [self configureCell:[self.tableView cellForRowAtIndexPath:indexPath]
                withSession:anObject];
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
        [self.tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath]
                              withRowAnimation:UITableViewRowAnimationFade];
    }
}

- (void)controllerDidChangeContent:(NSFetchedResultsController *)controller {
    [self.tableView endUpdates];
}

#pragma mark -

- (void)dealloc {
    self.selectedTrack = nil;
    self.fetchedResultsController = nil;
    self.selectedIndexPath = nil;
    [super dealloc];
}

@end

