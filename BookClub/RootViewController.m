//
//  ViewController.m
//  BookClub
//
//  Created by tim on 4/1/15.
//  Copyright (c) 2015 Timothy Yeh. All rights reserved.
//

#import "RootViewController.h"
#import "ListPeopleViewController.h"
#import "OneFriendViewController.h"
#import "AppDelegate.h"
#import "FriendSubclass.h"

@interface RootViewController () <UITableViewDataSource,UITableViewDelegate,UISearchBarDelegate>

//App's ManagedObjectContext
@property NSManagedObjectContext *managedObjectContext;

@property (weak, nonatomic) IBOutlet UITableView *tableview;
@property (nonatomic) NSMutableArray *myFriendsArray; //each element is a Friend object (aka NSManagedObject)

@property FriendSubclass *friend;

@property (weak, nonatomic) IBOutlet UISearchBar *mysearchBar;
@property (nonatomic) NSMutableArray *filteredtableviewArray;
@property BOOL isFiltered;

@end

@implementation RootViewController

-(void)viewWillAppear:(BOOL)animated
{
    [FriendSubclass retrieveListWithCompletion:self.managedObjectContext allList:NO completionHandler:^(NSArray *array) {
        self.myFriendsArray = [array mutableCopy]; //setter will reload tableview
    }];

    NSLog(@"in root...%ld",self.myFriendsArray.count);

}
- (void)viewDidLoad {
    [super viewDidLoad];

    //if App crashed...reset Simulator to clean previous appdelegate
    // viewDidLoad is called once!
    AppDelegate *appDelegate = [[UIApplication sharedApplication]delegate];
    self.managedObjectContext = appDelegate.managedObjectContext;

    self.myFriendsArray = [NSMutableArray new];

    //for search bar
    self.isFiltered = NO;

}


#pragma mark - setter for tableview array
//friendArray setter
-(void) setMyFriendsArray:(NSMutableArray *)myFriendsArray{
    _myFriendsArray = myFriendsArray;
    [self.tableview reloadData];
}


#pragma mark - prepareSegue for Modal View
- (void) prepareForSegue:(UIStoryboardSegue *)segue sender:(UIButton *)sender
{
    if ([[segue identifier] isEqualToString:@"ShowReaders"])
    {
        //pass MOC to next VC
        ListPeopleViewController  *listPeopleVC = segue.destinationViewController;
        listPeopleVC.modalTransitionStyle = UIModalTransitionStyleFlipHorizontal;
        listPeopleVC.managedObjectContext = self.managedObjectContext;

        listPeopleVC.myFriendsArray = self.myFriendsArray; // just pass the reference to next view...nextview will update the array
    } else if ([[segue identifier] isEqualToString:@"ShowOneFriend"])
    {
        OneFriendViewController *oneFriendVC = segue.destinationViewController;
        oneFriendVC.managedObjectContext = self.managedObjectContext;

        NSIndexPath *indexPath= [self.tableview indexPathForSelectedRow];

        if(self.isFiltered){
            self.friend = self.filteredtableviewArray[indexPath.row];
        } else {
            self.friend = self.myFriendsArray[indexPath.row];
        }

        oneFriendVC.friend = self.friend;
    }
}


#pragma mark - UITableViewDataSource, UITableViewDelegate
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell"];

    //if user uses search bar to filter result
    if(self.isFiltered){
        self.friend = [self.filteredtableviewArray  objectAtIndex:indexPath.row];
    }
    else {
        NSInteger i = indexPath.row;
        self.friend = [self.myFriendsArray objectAtIndex:i];
    }

    cell.textLabel.text = [self.friend valueForKey:@"name"];

    //photo in core data is NSDATA
//    NSData *imageNSData = [friend valueForKey:@"photo"];
//    cell.imageView.image = [UIImage imageWithData:imageNSData];

    return cell;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if(self.isFiltered){
        return self.filteredtableviewArray.count;
    } else {
        return self.myFriendsArray.count;
    }


}



#pragma mark - UISearchbarDelegate (fitering by entering characters
-(void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText
{
    if(self.mysearchBar.text.length == 0){
        self.isFiltered = NO;
    }
    else{
        self.isFiltered = YES;

        self.filteredtableviewArray = [NSMutableArray new];
        for (FriendSubclass *friend in self.myFriendsArray)
        {
            NSRange nameRange = [friend.name  rangeOfString:self.mysearchBar.text options:NSCaseInsensitiveSearch];

            if(nameRange.location != NSNotFound ){
                [self.filteredtableviewArray  addObject:friend];
            }
        }

    }

    [self.tableview reloadData];
}








@end
