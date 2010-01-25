//
//  TrackEditingViewController.m
//  Conference
//
//  Created by Steve Baker on 1/25/10.
//  Copyright 2010 Beepscore LLC. All rights reserved.
//
//  Created by Bill Dudney on 5/11/09.
//  Copyright 2009 Gala Factory Software LLC. All rights reserved.
//  Licensed with the Apache 2.0 License
//  http://apache.org/licenses/LICENSE-2.0
//

#import "TrackEditingViewController.h"
#import "Track.h"

@implementation TrackEditingViewController

@synthesize nameField = _nameField;
@synthesize abstractText = _abstractText;
@synthesize selectedTrack = _selectedTrack;

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.nameField.text = self.selectedTrack.name;
    self.abstractText.text = self.selectedTrack.trackAbstract;
}

//START:code.TEVC.viewWillDisappear:
- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    NSError *error = nil;
    if (![self.selectedTrack.managedObjectContext save:&error]) {
		// Handle the error...
    }
}
//END:code.TEVC.viewWillDisappear:

- (void)didReceiveMemoryWarning {
    // if the view's window is nil then the view is not displayed
    if(nil == self.view.window) {
        self.nameField = nil;
        self.abstractText = nil;
    }
    [super didReceiveMemoryWarning];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    UIBarButtonItem *doneButton = [[UIBarButtonItem alloc]
                                   initWithBarButtonSystemItem:UIBarButtonSystemItemDone
                                   target:self
                                   action:@selector(done)];
    self.navigationItem.rightBarButtonItem = doneButton;
    [doneButton release];
}

- (void)viewDidUnload {
    self.nameField = nil;
    self.abstractText = nil;
}

#pragma mark action methods

//START:code.TEVC.done
- (void)done {
    [self.abstractText resignFirstResponder];
    [self.nameField resignFirstResponder];
    [self.navigationController popViewControllerAnimated:YES];
}
//END:code.TEVC.done

#pragma mark Text Field Delegate Methods

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    return YES;
}

//START:code.TEVC.textFieldDidEndEditing:
- (void)textFieldDidEndEditing:(UITextField *)textField {
    self.selectedTrack.name = textField.text;
}
//END:code.TEVC.textFieldDidEndEditing:

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

//START:code.TEVC.textViewDidEndEditing:
- (void)textViewDidEndEditing:(UITextView *)textView {
    self.selectedTrack.trackAbstract = textView.text;
}
//END:code.TEVC.textViewDidEndEditing:

#pragma mark -
- (void)dealloc {
    self.nameField = nil;
    self.abstractText = nil;
    self.selectedTrack = nil;
    [super dealloc];
}


@end
