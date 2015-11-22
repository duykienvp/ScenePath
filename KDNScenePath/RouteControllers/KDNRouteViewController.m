//
//  RouteViewController.m
//  KDNScenePath
//
//  Created by Kien Nguyen Duy on 11/22/15.
//  Copyright © 2015 Kien Nguyen Duy. All rights reserved.
//

#import "KDNRouteViewController.h"

@interface KDNRouteViewController ()
@property (weak, nonatomic) IBOutlet UITextField *fromTextField;
@property (weak, nonatomic) IBOutlet UITextField *toTextField;
@property (weak, nonatomic) IBOutlet UISwitch *scenicPathSwitch;

@property (strong, nonatomic) KDNSearchResultsTableViewController* searchResultsTableViewController;
@end

@implementation RouteViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self.fromTextField addTarget:self action:@selector(fromTextFieldClicked) forControlEvents:UIControlEventEditingDidBegin];
    [self.toTextField addTarget:self action:@selector(toTextFieldClicked) forControlEvents:UIControlEventEditingDidBegin];
    
    self.searchResultsTableViewController = [[KDNSearchResultsTableViewController alloc] init];
    self.searchResultsTableViewController.delegate = self;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

-(void)fromTextFieldClicked {
    NSLog(@"fromTextFieldClicked");
    
}

-(void)toTextFieldClicked {
    NSLog(@"toTextFieldClicked");
}

-(void)locateWithLatitude:(double)lat andLongitude:(double)lng andTitle:(NSString*)title {
    
}

-(void)showSearchController {
    UISearchController* searchController = [[UISearchController alloc] initWithSearchResultsController:self.searchResultsTableViewController];
    searchController.searchBar.delegate = self;
    [self presentViewController:searchController animated:YES completion:nil];
}

-(void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText {
    NSLog(@"New text: %@", searchText);
}

@end
