//  Created by Joy Biswas on 2/2/23.
//  Copyright © 2023 Kolpolok Limited. All rights reserved.

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>
#import "LocationViewController.h"

NS_ASSUME_NONNULL_BEGIN

@interface MeetUpAnnotationView: MKAnnotationView
@end



@interface HomeViewController : UIViewController <MKMapViewDelegate, LocationViewControllerCellDelegate>

@property(nonatomic,strong) NSMutableArray *allConnections;
@property (weak, nonatomic) IBOutlet UIView *serverview;
@property (weak, nonatomic) IBOutlet UIView *serverborder;
@property (weak, nonatomic) IBOutlet UIView *uploadview;
@property (weak, nonatomic) IBOutlet UIView *uploadborder;
@property (weak, nonatomic) IBOutlet UIView *downloadview;
@property (weak, nonatomic) IBOutlet UIView *downloadborder;
@property (weak, nonatomic) IBOutlet UIButton *btnstart;
@property (weak, nonatomic) IBOutlet UILabel *countryname;
@property (weak, nonatomic) IBOutlet UIImageView *countryimage;
@property (weak, nonatomic) IBOutlet UILabel *countryPing;
@property (weak, nonatomic) IBOutlet UIImageView *start;
@property (weak, nonatomic) IBOutlet UIImageView *uploadimage;
@property (weak, nonatomic) IBOutlet UIImageView *downloadimage;
@property (weak, nonatomic) IBOutlet UILabel *upload;
@property (weak, nonatomic) IBOutlet UILabel *download;
@property (nonatomic, strong) IBOutlet UILabel *status;
@property (nonatomic, strong) IBOutlet UILabel *iplabel;
@property (strong, nonatomic) IBOutlet MKMapView *mapView;

@property (strong, nonatomic) IBOutlet UILabel *downloadtag;
@property (strong, nonatomic) IBOutlet UILabel *uploadtag;


@end


@interface ArtPiece : NSObject <MKAnnotation>{

    NSString *title;
    NSString *artist;
    NSString *series;
    NSString *description;
    NSString *location;
    NSString *area;
    NSNumber *latitude;
    NSNumber *longitude;
    UIImage *image;
}

@property (nonatomic, retain) NSString *title;
@property (nonatomic, retain) NSString *artist;
@property (nonatomic, retain) NSString *series;
@property (nonatomic, retain) NSString *description;
@property (nonatomic, retain) NSString *location;
@property (nonatomic, retain) NSString *area;
@property (nonatomic, retain) NSNumber *latitude;
@property (nonatomic, retain) NSNumber *longitude;
@property (nonatomic, retain) UIImage *image;

@end

NS_ASSUME_NONNULL_END
