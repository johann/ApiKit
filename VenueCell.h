//
//  VenueCell.h
//  ApiKit
//
//  Created by Johann Kerr on 5/11/14.
//  Copyright (c) 2014 Johann Kerr. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface VenueCell : UITableViewCell

@property (nonatomic, weak) IBOutlet UILabel *nameLabel;
@property (nonatomic, weak) IBOutlet UILabel *distanceLabel;
@property (nonatomic, weak) IBOutlet UILabel *checkinsLabel;

@end
