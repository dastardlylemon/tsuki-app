//
//  DetailViewController.m
//  Tsuki
//
//  Created by James Wu on 8/19/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "DetailViewController.h"
#import "CollapsableTableView.h"
#import "Series.h"

@interface DetailViewController ()
- (void)configureView;
@end

@implementation DetailViewController {
    NSArray *recipes;
}

@synthesize detailItem = _detailItem;
@synthesize detailDescriptionLabel = _detailDescriptionLabel;
@synthesize coverView = _coverView;
@synthesize titleLabel = _titleLabel;

#pragma mark - Managing the detail item

- (void)setDetailItem:(id)newDetailItem
{
    if (_detailItem != newDetailItem) {
        _detailItem = newDetailItem;
        
        // Update the view.
        [self configureView];
    }
}

- (void)configureView
{
    // Update the user interface for the detail item.

    if (self.detailItem) {
        Series *theNovel = self.detailItem;
        self.coverView.image = theNovel.coverImage;
        self.detailDescriptionLabel.text = theNovel.url;
        self.titleLabel.text = theNovel.title;
        self.title = theNovel.title;
    }
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    recipes = [NSArray arrayWithObjects:@"Egg Benedict", @"Mushroom Risotto", @"Full Breakfast", @"Hamburger", @"Ham and Egg Sandwich", @"Creme Brelee", @"White Chocolate Donut", @"Starbucks Coffee", @"Vegetable Curry", @"Instant Noodle with Egg", @"Noodle with BBQ Pork", @"Japanese Noodle with Pork", @"Green Tea", @"Thai Shrimp Cake", @"Angry Birds Cake", @"Ham and Cheese Panini", nil];
    [self configureView];
}

- (void)viewDidUnload
{
    [self setCoverView:nil];
    [self setTitleLabel:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    self.detailDescriptionLabel = nil;
}

#pragma mark - Detail Table View

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation != UIInterfaceOrientationPortraitUpsideDown);
}

/*- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [recipes count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *simpleTableIdentifier = @"RecipeCell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:simpleTableIdentifier];
    }
    
    cell.textLabel.text = [recipes objectAtIndex:indexPath.row];
    return cell;
}*/

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 10;
}


+ (NSString*) titleForHeaderForSection:(int) section
{
    switch (section)
    {
        case 0 : return @"First Section";
        case 1 : return @"Second Section";
        case 2 : return @"Third Section";
        case 3 : return @"Fourth Section";
        case 4 : return @"Fifth Section";
        default : return [NSString stringWithFormat:@"Section no. %i",section + 1];
    }
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    return [DetailViewController titleForHeaderForSection:section];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return section==2 ? 20 : 8;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    
	// Configure the cell.
    
    switch (indexPath.row)
    {
        case 0 : cell.textLabel.text = @"First Cell"; break;
        case 1 : cell.textLabel.text = @"Second Cell"; break;
        case 2 : cell.textLabel.text = @"Third Cell"; break;
        case 3 : cell.textLabel.text = @"Fourth Cell"; break;
        case 4 : cell.textLabel.text = @"Fifth Cell"; break;
        case 5 : cell.textLabel.text = @"Sixth Cell"; break;
        case 6 : cell.textLabel.text = @"Seventh Cell"; break;
        case 7 : cell.textLabel.text = @"Eighth Cell"; break;
        default : cell.textLabel.text = [NSString stringWithFormat:@"Cell %i",indexPath.row + 1];
    }
    
    //cell.detailTextLabel.text = ...;
    
    return cell;
}



@end
