//
//  PeopleViewController.m
//  BookClub
//
//  Created by tim on 4/1/15.
//  Copyright (c) 2015 Timothy Yeh. All rights reserved.
//

#import "ListPeopleViewController.h"
#import "AppDelegate.h"
#import "FriendSubclass.h"

@interface ListPeopleViewController () <UITableViewDelegate,UITableViewDataSource>

@property (nonatomic) NSMutableArray *tableviewArray; //each element is a Friend object (aka NSManagedObject)

@property (weak, nonatomic) IBOutlet UITableView *tableview;

@property (nonatomic)  NSIndexPath *selectedIndexPath;


@end

@implementation ListPeopleViewController

-(void)viewWillAppear:(BOOL)animated
{
    [FriendSubclass retrieveListWithCompletion:self.managedObjectContext allList:YES completionHandler:^(NSArray *array)  {

        self.tableviewArray = [array mutableCopy]; //setter will reload tableview

        NSLog(@"list tableview array count%ld",self.tableviewArray.count);

    }];

}

-(void)viewDidLoad {
    [super viewDidLoad];
    self.tableview.delegate = self;
    self.tableview.dataSource =self;
}


#pragma mark - setter for tableview array
//tableviewArray setter
-(void) setTableviewArray:(NSMutableArray *)tableviewArray
{
    _tableviewArray = tableviewArray;
    [self.tableview reloadData];
}
- (IBAction)buttonSave:(id)sender {

    //cell's didselect takes care of core data updates
    //just dismiss here
    [self dismissViewControllerAnimated:YES completion:nil];

}


- (IBAction)buttonCancel:(id)sender {

    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - UITableViewDataSource, UITableViewDelegate
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"peopleCell"];
    NSManagedObject *mo = [self.tableviewArray objectAtIndex:indexPath.row];

    cell.textLabel.text = [mo valueForKey:@"name"];

    if([[mo valueForKey:@"isFriend"] boolValue] ){
        cell.accessoryType = UITableViewCellAccessoryCheckmark;
    } else {
        cell.accessoryType = UITableViewCellAccessoryNone;
    }

    //photo in core data is NSDATA
    //    NSData *imageNSData = [friend valueForKey:@"photo"];
    //    cell.imageView.image = [UIImage imageWithData:imageNSData];

    return cell;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.tableviewArray.count;
}

#pragma mark tableview:  didSelectRowAtIndexPath
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSLog(@"======Select this row");
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    NSManagedObject *mo = [self.tableviewArray objectAtIndex:indexPath.row];

    // update managed object
    if(cell.accessoryType == UITableViewCellAccessoryCheckmark){ //de-select friend
        cell.accessoryType = UITableViewCellAccessoryNone;
        [mo setValue:[NSNumber numberWithBool:NO] forKey:@"isFriend"];
    } else { // select friend
        cell.accessoryType = UITableViewCellAccessoryCheckmark;
        [mo setValue:[NSNumber numberWithBool:YES] forKey:@"isFriend"];
    }

    //now update core data
    NSError *error = nil;
    if (![self.managedObjectContext save:&error]) {
        NSLog(@"Unable to save managed object context.");
        NSLog(@"%@, %@", error, error.localizedDescription);
    }

}



@end