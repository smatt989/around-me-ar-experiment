#import <Foundation/Foundation.h>

@class CLLocation;
@class Place;

typedef void (^SuccessHandler)(NSDictionary *responseDict);
typedef void (^ErrorHandler)(NSError *error);

@interface PlacesLoader : NSObject

+ (PlacesLoader *)sharedInstance;

- (void)loadPOIsForLocation:(CLLocation *)location radius:(int)radius successHandler:(SuccessHandler)handler errorHandler:(ErrorHandler)errorHandler;

- (void)loadDetailInformation:(Place *)location successHandler:(SuccessHandler)handler errorHandler:(ErrorHandler)errorHandler;

@end
