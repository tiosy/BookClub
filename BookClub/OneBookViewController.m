//
//  OneBookViewController.m
//  BookClub
//
//  Created by tim on 4/1/15.
//  Copyright (c) 2015 Timothy Yeh. All rights reserved.
//

#import "OneBookViewController.h"

@interface OneBookViewController () <UITableViewDelegate,UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UILabel *labelTitle;
@property (weak, nonatomic) IBOutlet UILabel *labelAuthor;
@property (nonatomic) NSMutableArray *tableviewArray; //each element is a comments object (aka NSManagedObject)
@property (weak, nonatomic) IBOutlet UITableView *tableview;
@property (nonatomic) NSSet *bookcomments;


@end

@implementation OneBookViewController

-(void) viewWillAppear:(BOOL)animated
{

    NSLog(@"in oneBook...book title.....%@", self.book.title);

    if(self.book.comments !=nil){
        self.bookcomments = [self.book valueForKey:@"comments" ];
        NSLog(@"in one book..# of comments.....%ld", self.bookcomments.count);
    }
    
}


- (void)viewDidLoad {
    [super viewDidLoad];
        
    self.labelTitle.text = self.book.title;
    self.labelAuthor.text = self.book.author;

}

#pragma mark - setter for tableview array
//bookcomments NSSet setter

-(void) setBookcomments:(NSSet *)bookcomments
{
    _bookcomments = bookcomments;

    self.tableviewArray = [[bookcomments allObjects] mutableCopy];
    [self.tableview  reloadData];
}


#pragma mark UITableViewDataSource protocols
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.tableviewArray.count;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{

    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell"];

    Comment *comment = self.tableviewArray[indexPath.row];

    cell.textLabel.text = comment.comment;

    return cell;
}


#pragma mark - button Add Comment
- (IBAction)buttonAddComment:(id)sender {

    UIAlertController *alertcontroller = [UIAlertController alertControllerWithTitle:@"Add a comment" message:nil preferredStyle:UIAlertControllerStyleAlert];

    [alertcontroller addTextFieldWithConfigurationHandler:^(UITextField *textField) {
        textField.placeholder = @"Enter comment";
    }];

    UIAlertAction *okAction = [UIAlertAction
                               actionWithTitle:@"Okay"
                               style:UIAlertActionStyleDefault
                               handler:^(UIAlertAction *action)
                               {
                                   Comment *newComment = [NSEntityDescription insertNewObjectForEntityForName:NSStringFromClass([Comment class]) inManagedObjectContext:self.managedObjectContext];
                                   UITextField *textField = alertcontroller.textFields.firstObject;
                                   newComment.comment = textField.text;

                                   //add to Book's NSSet comments
                                   [self.book addCommentsObject:newComment];

                                   [self.managedObjectContext save:nil];

                                   //in viewWillAppear, the setter will reload tableview
                                   [self viewWillAppear:YES];

                               }];

    [alertcontroller addAction:okAction];


    [self presentViewController:alertcontroller animated:YES completion:^{
        nil;
    }];






}



@end
