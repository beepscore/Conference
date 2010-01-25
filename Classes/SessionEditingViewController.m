//
//  SessionEditingViewController.m
//  Conference
//
//  Created by Steve Baker on 1/25/10.
//  Copyright 2010 Beepscore LLC. All rights reserved.
//
//
//  Created by Bill Dudney on 5/12/09.
//  Copyright 2009 Gala Factory Software LLC. All rights reserved.
//
//
//  Licensed with the Apache 2.0 License
//  http://apache.org/licenses/LICENSE-2.0
//

#import "SessionEditingViewController.h"
#import "Session.h"

@implementation SessionEditingViewController

@synthesize selectedSession = _selectedSession;
@synthesize nameField = _nameField;
@synthesize sessionAbstractText = _sessionAbstractText;

- (void)viewDidLoad {
    [super viewDidLoad];
    UIBarButtonItem *doneButton = [[UIBarButtonItem alloc]
                                   initWithBarButtonSystemItem:UIBarButtonSystemItemDone
                                   target:self
                                   action:@selector(done)];
    self.navigationItem.rightBarButtonItem = doneButton;
    [doneButton release];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:YES];
    self.nameField.text = self.selectedSession.name;
    self.sessionAbstractText.text = self.selectedSession.sessionAbstract;
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    NSError *error = nil;
    if (![self.selectedSession.managedObjectContext save:&error]) {
		// Handle the error...
    }
}

- (void)done {
    [self.nameField resignFirstResponder];
    [self.sessionAbstractText resignFirstResponder];
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark Text Field Delegate Methods

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    return YES;
}

- (void)textFieldDidEndEditing:(UITextField *)textField {
    self.selectedSession.name = textField.text;
}

#pragma mark Text View Delegate Methods

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text {
    if([text length] == 1 && range.location == [[textView text] length] && [text characterAtIndex:0] == '\n') {
        [textView resignFirstResponder];
    }
    return YES;
}

- (BOOL)textViewShouldEndEditing:(UITextView *)textView {
    return YES;
}

- (void)textViewDidEndEditing:(UITextView *)textView {
    self.selectedSession.sessionAbstract = textView.text;
    [textView resignFirstResponder];
}

#pragma mark -

- (void)dealloc {
    self.selectedSession = nil;
    self.nameField = nil;
    self.sessionAbstractText = nil;
    [super dealloc];
}


@end
