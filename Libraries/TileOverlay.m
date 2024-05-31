#import "TileOverlay.h"

#define TILE_SIZE 256.0

@interface ImageTile (FileInternal)
- (id)initWithFrame:(MKMapRect)f path:(NSString *)p;
@end

@implementation ImageTile

@synthesize frame, imagePath;

- (id)initWithFrame:(MKMapRect)f path:(NSString *)p
{
    if (self = [super init]) {
//        imagePath = [p retain];
        frame = f;
    }
    return self;
}

- (void)dealloc
{
//    [imagePath release];
//    [super dealloc];
}

@end

// Convert an MKZoomScale to a zoom level where level 0 contains 4 256px square tiles,
// which is the convention used by gdal2tiles.py.
static NSInteger zoomScaleToZoomLevel(MKZoomScale scale) {
    double numTilesAt1_0 = MKMapSizeWorld.width / TILE_SIZE;
    NSInteger zoomLevelAt1_0 = log2(numTilesAt1_0);  // add 1 because the convention skips a virtual level with 1 tile.
    NSInteger zoomLevel = MAX(0, zoomLevelAt1_0 + floor(log2f(scale) + 0.5));
    return zoomLevel;
}

@implementation TileOverlay

- (id)initOverlay
{
    if (self = [super init]) {
        boundingMapRect = MKMapRectMake(-180, -90, MKMapSizeWorld.width, MKMapSizeWorld.height);
    }
    return self;
}

- (CLLocationCoordinate2D)coordinate
{
    return MKCoordinateForMapPoint(MKMapPointMake(MKMapRectGetMidX(boundingMapRect),
                                                  MKMapRectGetMidY(boundingMapRect)));
}

- (MKMapRect)boundingMapRect
{
    return boundingMapRect;
}

- (void)dealloc
{
//    [tilePaths release];
//    [super dealloc];
}

- (NSArray *)tilesInMapRect:(MKMapRect)rect zoomScale:(MKZoomScale)scale
{
    NSInteger z = zoomScaleToZoomLevel(scale);
    
    NSInteger minX = floor((MKMapRectGetMinX(rect) * scale) / TILE_SIZE);
    NSInteger maxX = floor((MKMapRectGetMaxX(rect) * scale) / TILE_SIZE);
    NSInteger minY = floor((MKMapRectGetMinY(rect) * scale) / TILE_SIZE);
    NSInteger maxY = floor((MKMapRectGetMaxY(rect) * scale) / TILE_SIZE);
    
    NSMutableArray *tiles = nil;
    
    for (NSInteger x = minX; x < maxX; x++) {
        for (NSInteger y = minY; y < maxY; y++) {
            
            NSString *tileKey = [[NSString alloc] initWithFormat:@"%d/%d/%d", z, x, y]; // was flippedY
                if (!tiles) {
                    tiles = [NSMutableArray array];
                }
                
                MKMapRect frame = MKMapRectMake((double)(x * TILE_SIZE) / scale,
                                                (double)(y * TILE_SIZE) / scale,
                                                TILE_SIZE / scale,
                                                TILE_SIZE / scale);
                
                ImageTile *tile = [[ImageTile alloc] initWithFrame:frame path:tileKey];
                [tiles addObject:tile];
//                [tile release];
//            [tileKey release];
        }
    }
    return tiles;
}

@end
