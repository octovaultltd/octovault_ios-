#import <MapKit/MapKit.h>

@interface ImageTile : NSObject {
    NSString *imagePath;
    MKMapRect frame;
}

@property (nonatomic, readonly) MKMapRect frame;
@property (nonatomic, readonly) NSString *imagePath;

@end

@interface TileOverlay : NSObject <MKOverlay> {
    MKMapRect boundingMapRect;
    NSSet *tilePaths;
}

- (id)initOverlay;

- (NSArray *)tilesInMapRect:(MKMapRect)rect zoomScale:(MKZoomScale)scale;

@end
