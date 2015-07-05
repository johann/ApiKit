//
//  MasterViewController.m
//  ApiKit
//
//  Created by Johann Kerr on 5/11/14.
//  Copyright (c) 2014 Johann Kerr. All rights reserved.
//
#define kCLIENTID @"11Y1Q3G3WK1KNYIHR0VUC3FKVRLXAC3GDBN24CFYIDVQ152H"
#define kCLIENTSECRET @"R3P4DCYVCWD2T4O1KP4LWWO14VNAC3X0ZLCXA5TMB2SYCEKC"

#import "MasterViewController.h"
#import <RestKit/RestKit.h>
#import "MBProgressHUD.h"
#import "Venue.h"
#import "Location.h"
#import "VenueCell.h"
#import "Stats.h"
#import "DetailViewController.h"
#import <INTULocationManager/INTULocationManager.h>



@interface MasterViewController () {}

@property (nonatomic, strong) NSArray *venues;
@property (assign, nonatomic) INTULocationAccuracy desiredAccuracy;
@property (assign, nonatomic) NSTimeInterval timeout;
@property (nonatomic, strong) NSString *latLongCurrent;
@property (nonatomic, strong) NSString *latLong;

@property (assign, nonatomic) INTULocationRequestID locationRequestID;
    

@end

@implementation MasterViewController

- (void)awakeFromNib
{
    [super awakeFromNib];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self configureRestKit];
    
    self.desiredAccuracy = INTULocationAccuracyCity;
    self.timeout = 10.0;
    self.locationRequestID = NSNotFound;
    
    [self lookupCurrentLocation];
    NSLog(@"--> %@", self.latLongCurrent);
    
    
    
    
    
}

-(void)configureRestKit
{
    NSURL *baseURL = [NSURL URLWithString:@"https://api.foursquare.com"];
    AFHTTPClient *client = [[AFHTTPClient alloc] initWithBaseURL:baseURL];
    
    RKObjectManager *objectManager = [[RKObjectManager alloc] initWithHTTPClient:client];
    
    RKObjectMapping *venueMapping =  [RKObjectMapping mappingForClass:[Venue class]];
    [venueMapping addAttributeMappingsFromArray:@[@"name"]];
    
    RKResponseDescriptor *responseDescriptor =
    [RKResponseDescriptor responseDescriptorWithMapping:venueMapping
                                                 method:RKRequestMethodGET
                                            pathPattern:@"/v2/venues/search"
                                                keyPath:@"response.venues"
                                            statusCodes:[NSIndexSet indexSetWithIndex:200]];
    [objectManager addResponseDescriptor:responseDescriptor];
    
    RKObjectMapping *locationMapping = [RKObjectMapping mappingForClass:[Location class]];
    [locationMapping addAttributeMappingsFromArray:@[@"address", @"city", @"country", @"crossStreet", @"postalCode", @"state", @"distance", @"lat", @"lng"]];
    
    [venueMapping addPropertyMapping:[RKRelationshipMapping relationshipMappingFromKeyPath:@"location" toKeyPath:@"location" withMapping:locationMapping]];
    
    RKObjectMapping *statsMapping = [RKObjectMapping mappingForClass:[Stats class]];
    [statsMapping addAttributeMappingsFromDictionary:@{@"checkinsCount": @"checkins", @"tipsCount": @"tips", @"usersCount": @"users"}];
    
    [venueMapping addPropertyMapping:[RKRelationshipMapping relationshipMappingFromKeyPath:@"stats" toKeyPath:@"stats" withMapping:statsMapping]];
    
}
- (void)lookupCurrentLocation{
    __weak __typeof(self) weakSelf = self;
    INTULocationManager *locMgr = [INTULocationManager sharedInstance];
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.mode = MBProgressHUDModeIndeterminate;
    hud.labelText = @"Searching..";
    
    self.locationRequestID = [locMgr requestLocationWithDesiredAccuracy:INTULocationAccuracyHouse                                                                timeout:10.0
        delayUntilAuthorized:YES
        block:
                              ^(CLLocation *currentLocation, INTULocationAccuracy achievedAccuracy, INTULocationStatus status) {
                                  [hud show:YES];
                                  __typeof(weakSelf) strongSelf = weakSelf;
                                  
                                  if (status == INTULocationStatusSuccess) {
                                    
                                      NSLog(@"CurrentLocation -> (%f,%f)", currentLocation.coordinate.latitude, currentLocation.coordinate.longitude);
                                      self.latLongCurrent = [NSString stringWithFormat:@"%f,%f",currentLocation.coordinate.latitude, currentLocation.coordinate.longitude];
                                      [self loadVenues];
                                      [hud hide:YES];
                                    
                                      
                                      //NSLog(@"LatLongCurrent -> %@",self.latLongCurrent);
                                  }
                                  else if (status == INTULocationStatusTimedOut) {
                                      NSLog(@"CurrentLocation -> (%f,%f)", currentLocation.coordinate.latitude, currentLocation.coordinate.longitude);
                                  }
                                  else {
                                   
                                  }
                                  
                                  strongSelf.locationRequestID = NSNotFound;
                              }];
}
- (void)loadVenues
{
    NSString *latLon = @"40.721405,-73.793197";
    //NSString *latLon = self.latLongCurrent;
    // approximate latLon of The Mothership (a.k.a Apple headquarters)
    NSString *clientID = kCLIENTID;
    NSString *clientSecret = kCLIENTSECRET;
    
   
     latLon = [NSString stringWithFormat:@"%@", self.latLongCurrent];
     NSLog(@"latLon -> %@",self.latLongCurrent);
    
    NSDictionary *queryParams = @{@"ll" : latLon,
                                  @"client_id" : clientID,
                                  @"client_secret" : clientSecret,
                                  @"categoryId" : @"4bf58dd8d48988d101941735",
                                  @"v" : @"20140118"};
    
    [[RKObjectManager sharedManager] getObjectsAtPath:@"/v2/venues/search"
                                           parameters:queryParams
                                              success:^(RKObjectRequestOperation *operation, RKMappingResult *mappingResult) {
                                                  _venues = mappingResult.array;
                                                  [self.tableView reloadData];
                                              }
                                              failure:^(RKObjectRequestOperation *operation, NSError *error) {
                                                  NSLog(@"What do you mean by 'there is no coffee?': %@", error);
                                              }];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



#pragma mark - Table View

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _venues.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    VenueCell *cell = [tableView dequeueReusableCellWithIdentifier:@"VenueCell" forIndexPath:indexPath];

    Venue *venue = _venues[indexPath.row];
    cell.nameLabel.text = venue.name;
    cell.distanceLabel.text = [NSString stringWithFormat:@"%.0fm", venue.location.distance.floatValue];
    cell.checkinsLabel.text = [NSString stringWithFormat:@"%d checkins", venue.stats.checkins.intValue];
    return cell;
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    if([segue.identifier isEqualToString:@"showDetail"]){
        
        
        NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
        Venue *venue = _venues[indexPath.row];
        DetailViewController *destViewController = segue.destinationViewController;
        destViewController.titleName = venue.name;
        destViewController.lat = [venue.location.lat doubleValue];
        destViewController.longitude = [venue.location.lng doubleValue];
        destViewController.checkins = [venue.stats.checkins stringValue];
        destViewController.users = [venue.stats.users stringValue];
        destViewController.tips = [venue.stats.tips stringValue];
        destViewController.distance = venue.location.distance;
        destViewController.address = venue.location.address;
        destViewController.crossStreet = venue.location.crossStreet;
        destViewController.city = venue.location.city;
        destViewController.postalCode = venue.location.postalCode;
        
    }
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

@end
