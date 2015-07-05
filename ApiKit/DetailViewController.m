//
//  DetailViewController.m
//  ApiKit
//
//  Created by Johann Kerr on 7/5/15.
//  Copyright (c) 2015 Johann Kerr. All rights reserved.
//

#import "DetailViewController.h"
#import "Venue.h"
#import "Location.h"
#import "VenueCell.h"
#import "Stats.h"

#define METERS_PER_MILE 1609.344

@interface DetailViewController ()

@end



@implementation DetailViewController

@synthesize titleLabel;
@synthesize checkinsLabel;
@synthesize usersLabel;
@synthesize titleName;
@synthesize distanceLabel;
@synthesize addressLabel;
@synthesize crossLabel;
@synthesize postLabel;
@synthesize cityLabel;

@synthesize distance;
@synthesize checkins;
@synthesize users;
@synthesize tips;
@synthesize lat;
@synthesize longitude;
@synthesize address;
@synthesize crossStreet;
@synthesize city;
@synthesize postalCode;

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = titleName;
    titleLabel.text = titleName;
    [checkinsLabel setText:[NSString stringWithFormat:@"Checkins: %@", checkins]];
    [usersLabel setText:[NSString stringWithFormat:@"Users: %@", users]];
    
    [distanceLabel setText:[NSString stringWithFormat:@"%@ m", distance]];
    if (address != nil){
        [addressLabel setText:[NSString stringWithFormat:@"%@ ", address]];
    }
    if (crossStreet != nil){
        [crossLabel setText:[NSString stringWithFormat:@"%@", crossStreet]];
    }
    if (city != nil){
        [cityLabel setText:[NSString stringWithFormat:@"%@", city]];
    }
    if (postalCode != nil){
        [postLabel setText:[NSString stringWithFormat:@"%@", postalCode]];
    }
    
    
    
    
    
    
    
   
}

- (void)viewWillAppear:(BOOL)animated{
    CLLocationCoordinate2D zoomLocation;
    zoomLocation.latitude = lat;
    zoomLocation.longitude = longitude;
    MKCoordinateRegion viewRegion = MKCoordinateRegionMakeWithDistance(zoomLocation,0.5*METERS_PER_MILE, 0.5*METERS_PER_MILE);
    [_mapView setRegion:[_mapView regionThatFits:viewRegion] animated:YES];
    
    MKPointAnnotation *point = [[MKPointAnnotation alloc] init];
    point.coordinate = zoomLocation;
    //point.title = titleName;
    //point.subtitle = @"";
    MKPinAnnotationView *pointPin = [[MKPinAnnotationView alloc] init];
    pointPin.annotation = point;
    pointPin.canShowCallout = true;
    pointPin.rightCalloutAccessoryView = [UIButton buttonWithType:UIButtonTypeDetailDisclosure];
    [_mapView addAnnotation:point];
    
    
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


@end
