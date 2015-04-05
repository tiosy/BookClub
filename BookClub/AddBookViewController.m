//
//  AddBookViewController.m
//  BookClub
//
//  Created by tim on 4/1/15.
//  Copyright (c) 2015 Timothy Yeh. All rights reserved.
//

#import "AddBookViewController.h"


@interface AddBookViewController ()
@property (weak, nonatomic) IBOutlet UITextField *textfieldTitle;
@property (weak, nonatomic) IBOutlet UITextField *textfieldAuthor;

@end

@implementation AddBookViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (IBAction)buttonSave:(id)sender {

    Book *newBook = [NSEntityDescription insertNewObjectForEntityForName:@"Book" inManagedObjectContext: self.managedObjectContext];
    [newBook setValue:self.textfieldTitle.text forKey:@"title"];
    [newBook setValue:self.textfieldAuthor.text forKey:@"author"];

    //also adding dog to person's NSSet
    NSLog(@"person: %@",self.friend.name);
    [self.friend addBooksObject:newBook];

    //save now
    [self.managedObjectContext save:nil];


    [self dismissViewControllerAnimated:YES completion:nil];
}
- (IBAction)buttonCancel:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

@end
