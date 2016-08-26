//
//  ViewController.m
//  ChatApp
//
//  Created by Jayaprada on 17/08/16.
//  Copyright © 2016 Jayaprada. All rights reserved.
//

#import "ViewController.h"
#import "UserCell.h"
#import "ChatViewController.h"

@interface ViewController ()<UICollectionViewDataSource,UICollectionViewDelegate,UISearchBarDelegate, UITableViewDelegate,UITableViewDataSource>
{
//    NSArray             *lastMessagesList;
    long int        currentIndex;

}
@property (nonatomic) NSArray *searchData;
@property (nonatomic) NSMutableArray *data;

@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    self.title = NSLocalizedString(@"Chats", nil);
    [self.navigationItem setHidesBackButton:YES animated:YES];

    UINib *cellNib = [UINib nibWithNibName:@"UserCell" bundle:nil];
    [_collectionView registerNib:cellNib forCellWithReuseIdentifier:@"userCell"];
    self.automaticallyAdjustsScrollViewInsets = NO;
    
//    lastMessagesList = [NSArray arrayWithObjects:@"Message 1", nil];
    
    messageElement = MESSAGE_TEAM;

    _suggestionTbl.hidden = YES;
    _searchBar.showsCancelButton = YES;
    
    self.data = [NSMutableArray new];

    for( int i = 0 ; i< 50; i++)
    {
        [self.data addObject:[NSString stringWithFormat:@"Team :%d", i]];
        [self.data addObject:[NSString stringWithFormat:@"People :%d", i]];
        [self.data addObject:[NSString stringWithFormat:@"Room :%d", i]];

    }
    
    self.searchData = self.data;

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)Logout:(id)sender
{
    [self.navigationController popToRootViewControllerAnimated:NO];
}





#pragma mark search methods

- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar
{
    _suggestionTbl.hidden = YES;

    searchBar.text = @"";
    [searchBar resignFirstResponder];
    [searchBar setShowsCancelButton:NO animated:YES];
}

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar
{
    [searchBar resignFirstResponder];
}


- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText
{
    [self filterTableViewWithText:searchText];

    BOOL atLeastOneChar = searchText.length > 0;
    
    if (atLeastOneChar)
    {
        [searchBar setShowsCancelButton:YES animated:YES];

        if( _suggestionTbl.hidden)
        {
            _suggestionTbl.hidden = NO;
//            [_suggestionTbl reloadData];
        }

     return;
    }
}


#pragma mark - Helper Methods

- (void)filterTableViewWithText:(NSString *)searchText {
    if ([searchText isEqualToString:@""]) {
        self.searchData = self.data;
    }
    else {
        NSPredicate *predicate = [NSPredicate predicateWithFormat:@"self CONTAINS[cd] %@", searchText];
        self.searchData = [self.data filteredArrayUsingPredicate:predicate];
    }
    
    [_suggestionTbl reloadData];
}



#pragma mark COLLECTION VIEW MTHODS



- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return CGSizeMake(_collectionView.frame.size.width, self.view.frame.size.height/9.0f);
}


-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    int numberOfSections = 1;
    return  numberOfSections;
}

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    int numberOfItems = 0;
    switch( messageElement)
    {
        case MESSAGE_TEAM:
        {
            numberOfItems = 10;
        }
            break;
        case MESSAGE_PEOPLE:
        {
            numberOfItems = 15;
        }
            break;
        case MESSAGE_ROOM:
        {
            numberOfItems = 25;
        }
            break;
    }
    return numberOfItems;
}


-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentifier = @"userCell";
    UserCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:cellIdentifier forIndexPath:indexPath];
    
    NSString *nameText;
    NSString *msgText;
//    NSString *timeText;
    switch( messageElement)
    {
        case MESSAGE_TEAM:
        {
            nameText = [NSString stringWithFormat:@"Team :%ld", indexPath.item];
            msgText = [NSString stringWithFormat:@"Team Message Description : %ld", indexPath.item];
        }
            break;
        case MESSAGE_PEOPLE:
        {
            nameText = [NSString stringWithFormat:@"People :%ld", indexPath.item];
            msgText = [NSString stringWithFormat:@"People Message Description : %ld", indexPath.item];
        }
            break;

        case MESSAGE_ROOM:
        {
            nameText = [NSString stringWithFormat:@"Room :%ld", indexPath.item];
            msgText = [NSString stringWithFormat:@"Room Message Description : %ld", indexPath.item];
        }
            break;
    }
    cell.nameLbl.text = nameText;
    cell.subLbl.text = msgText;
   
    return cell;
}


- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    //  self.title = @"";
    
    UserCell *cell = (UserCell*)[collectionView cellForItemAtIndexPath:indexPath];
   
    UIStoryboard *mainStoryboard = [UIStoryboard storyboardWithName:@"Main" bundle: nil];
    ChatViewController *vc;
    vc = [mainStoryboard instantiateViewControllerWithIdentifier: @"ChatViewController"];
    vc.title = cell.nameLbl.text;
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma  mark TableView Delegate Methods
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.searchData count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *simpleTableIdentifier = @"tableCell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:simpleTableIdentifier];
    }
    
    cell.textLabel.text = [self.searchData objectAtIndex:indexPath.row];;
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *obj = [self.searchData objectAtIndex:indexPath.item];

    
    UIStoryboard *mainStoryboard = [UIStoryboard storyboardWithName:@"Main" bundle: nil];
    ChatViewController *vc;
    vc = [mainStoryboard instantiateViewControllerWithIdentifier: @"ChatViewController"];
    vc.title =  NSLocalizedString(obj, nil);
    [self.navigationController pushViewController:vc animated:YES];
}




- (IBAction)onSegementChange:(id)sender
{
    UISegmentedControl *segmentedCtrl = (UISegmentedControl*)sender;
    NSInteger index = segmentedCtrl.selectedSegmentIndex;
    
    messageElement = (int) index;
    switch( index)
    {
        case MESSAGE_TEAM:
        {
        }
            break;
    }
    
    [_collectionView reloadData];

}
@end
