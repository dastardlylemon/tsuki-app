//
//  MasterViewController.m
//  Tsuki
//
//  Created by James Wu on 8/19/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "MasterViewController.h"

#import "DetailViewController.h"
#import "TFHpple.h"
#import "Series.h"

@interface MasterViewController () {
    NSMutableArray *_objects;
}
@end

@implementation MasterViewController

@synthesize detailViewController = _detailViewController;
@synthesize novelSearchBar;
@synthesize filteredNovelArray;

- (UIImage *)imageWithImage:(UIImage *)image scaledToSize:(CGSize)newSize
{
    // Scaling calculations
    CGRect scaleRect = CGRectMake(0, 0, newSize.width, newSize.height);
    
    float hfactor = image.size.width / scaleRect.size.width;
    float vfactor = image.size.height / scaleRect.size.height;
    
    float factor = fmax(hfactor, vfactor);
    
    float newWidth = image.size.width / factor;
    float newHeight = image.size.height / factor;
    
    float leftOffset = (scaleRect.size.width - newWidth) / 2;
    float topOffset = (scaleRect.size.height - newHeight) / 2;
    
    CGRect newRect = CGRectMake(leftOffset, topOffset, newWidth, newHeight);
    
    // Resize the image proper
    UIGraphicsBeginImageContextWithOptions(newSize, 1.0f, 0.0f);
    [image drawInRect:newRect];
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return newImage;
}

- (void)loadNovels {
    
    // Define the URL, parsers, Xpaths
    NSURL *BTUrl = [NSURL URLWithString:@"http://www.baka-tsuki.org/project/index.php"];
    NSData *BTHtmlData = [NSData dataWithContentsOfURL:BTUrl];
    
    TFHpple *novelParser = [TFHpple hppleWithHTMLData:BTHtmlData];
    
    NSString *novelXpathQueryString = @"//div[@id='p-Light_Novels']/div/ul/li/a";
    NSString *drillXpathQueryString = @"//div[@class='thumbinner']/a";
    NSString *coverXpathQueryString = @"//div[@class='fullImageLink']/a/img";
    NSArray *novelNodes = [novelParser searchWithXPathQuery:novelXpathQueryString];
    
    NSMutableArray *newNovels = [[NSMutableArray alloc] initWithCapacity:0];
    
    // Go through the array and populate with LN data
    for (TFHppleElement *element in novelNodes) {
        Series *novel = [[Series alloc] init];
        int i = 1;
        int j = 1;
        [newNovels addObject:novel];
        
        novel.title = [[element firstChild] content];
        
        NSString *topLevel = @"http://www.baka-tsuki.org";
        
        novel.url = [topLevel stringByAppendingString:([element objectForKey:@"href"])];
        
        // Get the cover image URLs from individual LN pages
        NSURL *drillUrl = [NSURL URLWithString:novel.url];
        NSData *drillData = [NSData dataWithContentsOfURL:drillUrl];
        TFHpple *drillParser = [TFHpple hppleWithHTMLData:drillData];
        NSArray *drillNodes = [drillParser searchWithXPathQuery:drillXpathQueryString];
        for (TFHppleElement *drill in drillNodes) {
            if (i == 1) {
                novel.coverUrl = [topLevel stringByAppendingString:([drill objectForKey:@"href"])];
                i = 0;
            }
        }

        // Get the cover images from individual LN pages
        NSURL *gigaUrl = [NSURL URLWithString:novel.coverUrl];
        NSData *gigaData = [NSData dataWithContentsOfURL:gigaUrl];
        TFHpple *gigaParser = [TFHpple hppleWithHTMLData:gigaData];
        NSArray *gigaNodes = [gigaParser searchWithXPathQuery:coverXpathQueryString];
        for (TFHppleElement *giga in gigaNodes) {
            if (j == 1) {
                novel.coverUrl = [topLevel stringByAppendingString:([giga objectForKey:@"src"])];
                j = 0;
            }
        }
        
        // Set cover images to the Series if it exists
        if (novel.coverUrl != nil) {
            NSData *coverData = [NSData dataWithContentsOfURL:([[NSURL alloc] initWithString:novel.coverUrl])];
            UIImage *thisCover = [[UIImage alloc] initWithData:coverData];
            novel.coverImage = [self imageWithImage:thisCover scaledToSize:CGSizeMake(127.0, 182.0)];
        } else {
            novel.coverImage = [UIImage imageNamed:@"placeholder.jpg"];
        }
    }
    
    _objects = newNovels;
    [self.tableView reloadData];
//    [self.activityIndicator removeFromSuperview];
}

- (void)awakeFromNib
{
    [super awakeFromNib];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    searchData = [[NSMutableArray alloc] init];
    
    [self performSelectorInBackground:@selector(loadNovels) withObject:nil];
    searchBar.scopeButtonTitles = nil;
    
    // Initialize the filteredNovelArray with a capacity equal to the _objects capacity
    self.filteredNovelArray = [NSMutableArray arrayWithCapacity:[_objects count]];

    self.navigationItem.title = @"Novels";
    
    [self.tableView setContentOffset:CGPointMake(0, 44)];
    [self.tableView setEditing:NO];
    
    
	// Do any additional setup after loading the view, typically from a nib.
    /* self.navigationItem.leftBarButtonItem = self.editButtonItem;

    UIBarButtonItem *addButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(insertNewObject:)];
    self.navigationItem.rightBarButtonItem = addButton; */
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation != UIInterfaceOrientationPortraitUpsideDown);
}

- (void)insertNewObject:(id)sender
{
    if (!_objects) {
        _objects = [[NSMutableArray alloc] init];
    }
    [_objects insertObject:[NSDate date] atIndex:0];
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:0];
    [self.tableView insertRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
}

#pragma mark - Table View

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    int rows = 0;
    // Return the number of rows in the section.
    
    // Check to see whether the normal table or search results table is being displayed and return the count from the appropriate array
    if (tableView == self.searchDisplayController.searchResultsTableView) {
        return [filteredNovelArray count];
    } else {
        return [_objects count];
    }
    
    return rows;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }
    
    // Define the Series object, set the cell properties
    
    Series *thisSeries = [[Series alloc] init];
    
    // Check to see whether the normal table or search results table is being displayed and set the Candy object from the appropriate array
    if (tableView == self.searchDisplayController.searchResultsTableView) {
        thisSeries = [filteredNovelArray objectAtIndex:indexPath.row];
    } else {
        thisSeries = [_objects objectAtIndex:indexPath.row];
    }
    

    cell.textLabel.text = thisSeries.title;
    cell.detailTextLabel.text = thisSeries.coverUrl;
    cell.imageView.image = thisSeries.coverImage;
    
    return cell;
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return NO;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        [_objects removeObjectAtIndex:indexPath.row];
        [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view.
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 100;
}

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
{
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([[segue identifier] isEqualToString:@"showDetail"]) {
        //NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
        //NSDate *object = [_objects objectAtIndex:indexPath.row];
        if(sender == self.searchDisplayController.searchResultsTableView) {
            NSIndexPath *indexPath = [self.searchDisplayController.searchResultsTableView indexPathForSelectedRow];
            NSDate *object = [filteredNovelArray objectAtIndex:indexPath.row];
            [[segue destinationViewController] setDetailItem:object];
        }
        else {
            NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
            NSDate *object = [_objects objectAtIndex:indexPath.row];
            [[segue destinationViewController] setDetailItem:object];
        }
    }

    self.detailViewController=segue.destinationViewController;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (!self.detailViewController) {
     self.detailViewController = [[DetailViewController alloc] initWithNibName:@"DetailViewController" bundle:nil];
     }
    

     //[self.navigationController pushViewController:self.detailViewController animated:YES];
}

#pragma mark - UISearchDisplayController Delegate Methods
-(BOOL)searchDisplayController:(UISearchDisplayController *)controller shouldReloadTableForSearchString:(NSString *)searchString {
    // Tells the table data source to reload when text changes
    [self filterContentForSearchText:searchString scope:
     [[self.searchDisplayController.searchBar scopeButtonTitles] objectAtIndex:[self.searchDisplayController.searchBar selectedScopeButtonIndex]]];
    // Return YES to cause the search result table view to be reloaded.
    return YES;
}

-(BOOL)searchDisplayController:(UISearchDisplayController *)controller shouldReloadTableForSearchScope:(NSInteger)searchOption {
    // Tells the table data source to reload when scope bar selection changes
    [self filterContentForSearchText:self.searchDisplayController.searchBar.text scope:
     [[self.searchDisplayController.searchBar scopeButtonTitles] objectAtIndex:searchOption]];
    // Return YES to cause the search result table view to be reloaded.
    return YES;
}

#pragma mark Content Filtering
-(void)filterContentForSearchText:(NSString*)searchText scope:(NSString*)scope {
    // Update the filtered array based on the search text and scope.
    // Remove all objects from the filtered search array
    [self.filteredNovelArray removeAllObjects];
    // Filter the array using NSPredicate
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF.title contains[c] %@",searchText];
    filteredNovelArray = [NSMutableArray arrayWithArray:[_objects filteredArrayUsingPredicate:predicate]];
}

@end
