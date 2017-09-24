//
//  IWCShopDetailViewController.m
//  I Want Coffee
//
//  Created by Adam on 2015-09-25.
//  Copyright © 2015 Adam Boyd. All rights reserved.
//

#import "IWCShopDetailViewController.h"

@implementation IWCShopDetailViewController

@synthesize shop;
@synthesize detailTableView;
@synthesize titleArray;
@synthesize descArray;
@synthesize actionArray;

- (id)initWithShop:(IWCShop *)shopToShow {
    if (self = [super init]) {
        shop = shopToShow;
    }
    
    titleArray = [[NSMutableArray alloc] init];
    descArray = [[NSMutableArray alloc] init];
    actionArray = [[NSMutableArray alloc] init];
    
    //If the shop has a menu url
    if (shop.menuURL) {
        [titleArray addObject:@"Menu"];
        [descArray addObject:@"Tap to view menu"];
        [actionArray addObject:shop.menuURL];
    }
    
    if (shop.phoneNumber) {
        [titleArray addObject:@"Phone Number"];
        [descArray addObject:shop.phoneNumber];
        
        //Phone url
        NSString *phoneURLString = [NSString stringWithFormat:@"tel:%@", shop.unformattedPhone];
        [actionArray addObject:phoneURLString];
    }
    
    if (shop.twitter) {
        [titleArray addObject:@"Twitter"];
        [descArray addObject:[NSString stringWithFormat:@"@%@", shop.twitter]];
        
        [actionArray addObject: [NSString stringWithFormat:@"https://twitter.com/%@", shop.twitter]];
    }
    
    [titleArray addObject:@"Address"];
    [descArray addObject:shop.formattedAddress];
    [actionArray addObject:[NSString stringWithFormat:@"http://maps.apple.com?address=%@", shop.urlReadyAddress]];
    
    [titleArray addObject:@"More"];
    [descArray addObject:@"Tap to view more info"];
    [actionArray addObject:[NSString stringWithFormat:@"https://foursquare.com/v/%@", shop.ident]];
    
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self.navigationItem setTitle:[shop name]];
    
    if (@available(iOS 11, *)) {
        //Large titles for iOS 11
        self.navigationController.navigationBar.prefersLargeTitles = YES;
        self.navigationController.navigationItem.largeTitleDisplayMode = UINavigationItemLargeTitleDisplayModeAlways;
        self.navigationController.navigationBar.largeTitleTextAttributes = @{NSForegroundColorAttributeName: [UIColor whiteColor]};
    }
        
    //Detail view
    detailTableView = [[UITableView alloc] init];
    [self.view addSubview:detailTableView];
    detailTableView.backgroundColor = [UIColor whiteColor];
    [detailTableView setTranslatesAutoresizingMaskIntoConstraints:false];
    detailTableView.dataSource = self;
    detailTableView.delegate = self;
    
    //Autonatic row height
    detailTableView.rowHeight = UITableViewAutomaticDimension;
    detailTableView.estimatedRowHeight = 100;
    
    //0px below navBar, 0px on left, right, bottom
    
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:detailTableView attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeTop multiplier:1 constant:0]];
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:detailTableView attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeBottom multiplier:1 constant:0]];
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:detailTableView attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeLeft multiplier:1 constant:0]];
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:detailTableView attribute:NSLayoutAttributeRight relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeRight multiplier:1 constant:0]];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark StatusBarStyle
- (UIStatusBarStyle)preferredStatusBarStyle {
    return UIStatusBarStyleLightContent;
}

- (BOOL)prefersStatusBarHidden {
    return NO;
}

#pragma mark UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section      {
    return [titleArray count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    IWCDetailTableViewCell *cell = [[IWCDetailTableViewCell alloc] init];
    
    cell.header.text = [titleArray objectAtIndex:indexPath.row];
    cell.mainText.text = [descArray objectAtIndex:indexPath.row];
    
    return cell;
}

#pragma mark UITableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[actionArray objectAtIndex:indexPath.row]]];
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

//Simple static height for all cells
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 100;
}

- (CGFloat)tableView:(UITableView *)tableView estimatedHeightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 100;
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
