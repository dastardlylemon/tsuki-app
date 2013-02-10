//
//  MasterViewController.h
//  Tsuki
//
//  Created by James Wu on 8/19/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@class DetailViewController;

@interface MasterViewController : UITableViewController <UISearchBarDelegate, UISearchDisplayDelegate>
{
    NSMutableArray *searchData;
    
    UISearchBar *searchBar;
    UISearchDisplayController *searchDisplayController;
}

@property (strong,nonatomic) NSMutableArray *filteredNovelArray;
@property IBOutlet UISearchBar *novelSearchBar;
@property (strong, nonatomic) DetailViewController *detailViewController;

@end
