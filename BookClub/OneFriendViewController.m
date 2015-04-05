//
//  OneFriendViewController.m
//  BookClub
//
//  Created by tim on 4/1/15.
//  Copyright (c) 2015 Timothy Yeh. All rights reserved.
//

#import "OneFriendViewController.h"
#import "AddBookViewController.h"
#import "OneBookViewController.h"

@interface OneFriendViewController () <UITableViewDataSource, UITableViewDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tableview;

@property (weak, nonatomic) IBOutlet UILabel *labelName;
@property (weak, nonatomic) IBOutlet UILabel *labelNumBooks;
@property (nonatomic) NSMutableArray *tableviewArray; //each element is a Book object (aka NSManagedObject)
@property (nonatomic) NSSet *friendbooks;

@end

@implementation OneFriendViewController

-(void) viewWillAppear:(BOOL)animated
{

    NSLog(@"in oneFriend...friend name.....%@", self.friend.name);

    self.labelName.text = self.friend.name;
    if(self.friend.books !=nil){
        self.friendbooks = self.friend.books;
        NSLog(@"in one friend..# of books.....%ld", self.friendbooks.count);
        self.labelNumBooks.text = [NSString stringWithFormat:@"%ld",self.friendbooks.count];
    }
    
}

- (void)viewDidLoad {
    [super viewDidLoad];

//only load once

}


#pragma mark - setter for tableview array
//friendBooksArray setter

-(void) setFriendbooks:(NSSet *)friendbooks
{
    _friendbooks = friendbooks;

    self.tableviewArray = [[friendbooks allObjects] mutableCopy];
    [self.tableview  reloadData];
}


#pragma mark - prepareSegue for Modal View
- (void) prepareForSegue:(UIStoryboardSegue *)segue sender:(UIButton *)sender
{
    if ([[segue identifier] isEqualToString:@"AddBook"])
    {
        //pass MOC to next VC
        AddBookViewController  *addBookVC = segue.destinationViewController;
        addBookVC.managedObjectContext = self.managedObjectContext;
        addBookVC.friend = self.friend;

    } else if ([[segue identifier] isEqualToString:@"ShowOneBook"])
    {
        OneBookViewController *oneBookVC = segue.destinationViewController;
        oneBookVC.managedObjectContext = self.managedObjectContext;
        oneBookVC.friend = self.friend;

        NSIndexPath *indexPath= [self.tableview indexPathForSelectedRow];
        oneBookVC.book = [self.tableviewArray objectAtIndex: indexPath.row];

    }
    
    
}





#pragma mark UITableViewDataSource protocols
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.tableviewArray.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{

    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell"];

    Book *book = self.tableviewArray[indexPath.row];

    cell.textLabel.text = book.title;
    cell.detailTextLabel.text = book.author;

    return cell;
}


@end
