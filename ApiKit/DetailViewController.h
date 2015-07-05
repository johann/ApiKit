//
//  DetailViewController.h
//  ApiKit
//
//  Created by Johann Kerr on 7/5/15.
//  Copyright (c) 2015 Johann Kerr. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>

@interface DetailViewController : UIViewController <MKMapViewDelegate>
@property (strong, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet MKMapView *mapView;
@property (weak, nonatomic) IBOutlet UILabel *checkinsLabel;
@property (weak, nonatomic) IBOutlet UILabel *usersLabel;
@property (weak, nonatomic) IBOutlet UILabel *distanceLabel;
@property (weak, nonatomic) IBOutlet UILabel *addressLabel;
@property (weak, nonatomic) IBOutlet UILabel *crossLabel;
@property (weak, nonatomic) IBOutlet UILabel *cityLabel;
@property (weak, nonatomic) IBOutlet UILabel *postLabel;




@property (nonatomic, strong) NSString *titleName;
@property (nonatomic, strong) NSString *checkins;
@property (nonatomic, strong) NSString *users;
@property (nonatomic, strong) NSString *tips;
@property (nonatomic, strong) NSString *address;
@property (nonatomic, strong) NSString *crossStreet;
@property (nonatomic, strong) NSString *postalCode;
@property (nonatomic, strong) NSString *city;
@property (nonatomic, strong) NSString *country;
@property (nonatomic, strong) NSString *state;
@property (nonatomic, strong) NSNumber *distance;

@property (nonatomic) double lat;
@property (nonatomic) double longitude;




@end
