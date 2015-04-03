//
//  ViewController.m
//  BookClub
//
//  Created by tim on 4/1/15.
//  Copyright (c) 2015 Timothy Yeh. All rights reserved.
//

#import "RootViewController.h"
#import "ListPeopleViewController.h"
#import "AppDelegate.h"
#import "FriendSubclass.h"

@interface RootViewController () <UITableViewDataSource,UITableViewDelegate>

//App's ManagedObjectContext
@property NSManagedObjectContext *managedObjectContext;
@property (nonatomic) NSMutableArray *myFriendsArray; //each element is a Friend object (aka NSManagedObject)
@property (weak, nonatomic) IBOutlet UITableView *tableview;
@property (nonatomic)  NSIndexPath *selectedIndexPath;

@end

@implementation RootViewController

-(void)viewWillAppear:(BOOL)animated
{
    [FriendSubclass retrieveListWithCompletion:self.managedObjectContext allList:NO completionHandler:^(NSArray *array) {
        self.myFriendsArray = [array mutableCopy]; //setter will reload tableview
    }];

}
- (void)viewDidLoad {
    [super viewDidLoad];

    //if App crashed...reset Simulator to clean previous appdelegate
    // viewDidLoad is called once!
    AppDelegate *appDelegate = [[UIApplication sharedApplication]delegate];
    self.managedObjectContext = appDelegate.managedObjectContext;

}


#pragma mark - setter for tableview array
//friendArray setter
-(void) setMyFriendsArray:(NSMutableArray *)myFriendsArray
{
    _myFriendsArray = myFriendsArray;
    [self.tableview reloadData];
}


#pragma mark - prepareSegue for Modal View
- (void) prepareForSegue:(UIStoryboardSegue *)segue sender:(UIButton *)sender
{
    //pass MOC to next VC
    ListPeopleViewController  *listPeopleVC = segue.destinationViewController;
    listPeopleVC.modalTransitionStyle = UIModalTransitionStyleFlipHorizontal;
    listPeopleVC.managedObjectContext = self.managedObjectContext;
    
    listPeopleVC.myFriendsArray = self.myFriendsArray; // just pass the reference to next view...nextview will update the array
}


#pragma mark - UITableViewDataSource, UITableViewDelegate
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"myFriendsCell"];
    NSManagedObject *friend = [self.myFriendsArray objectAtIndex:indexPath.row];


    cell.textLabel.text = [friend valueForKey:@"name"];

    //photo in core data is NSDATA
//    NSData *imageNSData = [friend valueForKey:@"photo"];
//    cell.imageView.image = [UIImage imageWithData:imageNSData];

    return cell;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.myFriendsArray.count;
}



@end
