#import "PlacesLoader.h"
#import <CoreLocation/CoreLocation.h>
#import <Foundation/NSJSONSerialization.h>
#import "Place.h"

NSString * const apiURL = @"https://maps.googleapis.com/maps/api/place/";
NSString * const apiKey = @"AIzaSyBrQyRpA3v1gZCznfUvcjSZFG5r_KnrnVs";

@interface PlacesLoader ()

@property (nonatomic, strong) SuccessHandler successHandler;
@property (nonatomic, strong) ErrorHandler errorHandler;
@property (nonatomic, strong) NSMutableData *responseData;

@end

@implementation PlacesLoader

+ (PlacesLoader *)sharedInstance {
    static PlacesLoader *instance = nil;
    static dispatch_once_t onceToken;
    
    dispatch_once(&onceToken, ^{
        instance = [[PlacesLoader alloc] init];
    });
    
    return instance;
}

- (void)loadPOIsForLocation:(CLLocation *)location radius:(int)radius successHandler:(SuccessHandler)handler errorHandler:(ErrorHandler)errorHandler {
    
    _responseData = nil;
    [self setSuccessHandler:handler];
    [self setErrorHandler:errorHandler];
    
    CLLocationDegrees latitude = [location coordinate].latitude;
    CLLocationDegrees longitude = [location coordinate].longitude;
    
    NSMutableString *uri = [NSMutableString stringWithString:apiURL];
    [uri appendFormat:@"nearbysearch/json?location=%f,%f&radius=%d&sensor=true&types=establishment&key=%@", latitude, longitude, radius, apiKey];
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:[uri stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]] cachePolicy:NSURLRequestReloadIgnoringCacheData timeoutInterval:20.0f];
    
    [request setHTTPShouldHandleCookies: YES];
    [request setHTTPMethod:@"GET"];
    
    NSURLConnection *connection = [[NSURLConnection alloc] initWithRequest:request delegate:self];
    
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
    NSLog(@"Starting connection: %@ for request: %@", connection, request);
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data {
    if(!_responseData){
        _responseData = [NSMutableData dataWithData:data];
    } else {
        [_responseData appendData:data];
    }
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection {
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
    
    id object = [NSJSONSerialization JSONObjectWithData:_responseData options:NSJSONReadingAllowFragments error:nil];
    
    if(_successHandler) {
        _successHandler(object);
    }
}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error {
    if(_errorHandler) {
        _errorHandler(error);
    }
    
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
}

- (void)loadDetailInformation:(Place *)location successHandler:(SuccessHandler)handler errorHandler:(ErrorHandler)errorHandler {
    
    _responseData = nil;
    _successHandler = handler;
    _errorHandler = errorHandler;
    
    NSMutableString *uri = [NSMutableString stringWithString:apiURL];
    
    [uri appendFormat:@"details/json?placeid=%@&key=%@", [location placeId], apiKey];
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:[uri stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]] cachePolicy:NSURLRequestReloadIgnoringCacheData timeoutInterval:20.0f];
    
    [request setHTTPShouldHandleCookies:YES];
    [request setHTTPMethod:@"GET"];
    
    NSURLConnection *connection = [[NSURLConnection alloc] initWithRequest:request delegate:self];
    
    NSLog(@"Starting connection: %@ for request:%@", connection, request);
}

@end
