#import <MapKit/MapKit.h>


@interface TileOverlayView : MKOverlayView {
    CGFloat tileAlpha;
}

@property (nonatomic, assign) CGFloat tileAlpha;
@end
