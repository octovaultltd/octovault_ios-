
#import "TileOverlayView.h"
#import "TileOverlay.h"

@implementation TileOverlayView

@synthesize tileAlpha;

- (id)initWithOverlay:(id <MKOverlay>)overlay
{
    if (self = [super initWithOverlay:overlay]) {
        tileAlpha = 1.0; // 0.75 // base map alpha
    }
    return self;
}

- (BOOL)canDrawMapRect:(MKMapRect)mapRect
             zoomScale:(MKZoomScale)zoomScale
{
    // Return YES only if there are some tiles in this mapRect and at this zoomScale.

    TileOverlay *tileOverlay = (TileOverlay *)self.overlay;
    NSArray *tilesInRect = [tileOverlay tilesInMapRect:mapRect zoomScale:zoomScale];

    return [tilesInRect count] > 0;
}

- (void)drawMapRect:(MKMapRect)mapRect
          zoomScale:(MKZoomScale)zoomScale
          inContext:(CGContextRef)context
{
    TileOverlay *tileOverlay = (TileOverlay *)self.overlay;
    
    // Get the list of tile images from the model object for this mapRect.  The
    // list may be 1 or more images (but not 0 because canDrawMapRect would have
    // returned NO in that case).
    NSArray *tilesInRect = [tileOverlay tilesInMapRect:mapRect zoomScale:zoomScale];
    
    CGContextSetAlpha(context, tileAlpha);
        
    for (ImageTile *tile in tilesInRect) {
        // For each image tile, draw it in its corresponding MKMapRect frame
        CGRect rect = [self rectForMapRect:tile.frame];
        
      //  UIImage *image = [[UIImage alloc] initWithContentsOfFile:tile.imagePath];
        NSString *path = [[NSString alloc] initWithFormat:@"http://tile.openstreetmap.org/%@.png", tile.imagePath];
       // NSLog(@"Loading tile from URL %@", path);
        UIImage *image =[UIImage imageWithData: [NSData
                                                 dataWithContentsOfURL:[NSURL URLWithString: path]]];
        CGContextSaveGState(context);
        CGContextTranslateCTM(context, CGRectGetMinX(rect), CGRectGetMinY(rect));
        CGContextScaleCTM(context, 1/zoomScale, 1/zoomScale);
        CGContextTranslateCTM(context, 0, image.size.height);
        CGContextScaleCTM(context, 1, -1);
        CGContextDrawImage(context, CGRectMake(0, 0, image.size.width, image.size.height), [image CGImage]);
        CGContextRestoreGState(context);
//        [path release];

    }
}

@end

