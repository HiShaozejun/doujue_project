#ifdef __OBJC__
#import <UIKit/UIKit.h>
#else
#ifndef FOUNDATION_EXPORT
#if defined(__cplusplus)
#define FOUNDATION_EXPORT extern "C"
#else
#define FOUNDATION_EXPORT extern
#endif
#endif
#endif

#import "AMapFlutterLocationPlugin.h"
#import "AMapFlutterStreamManager.h"

FOUNDATION_EXPORT double amap_flutter_locationVersionNumber;
FOUNDATION_EXPORT const unsigned char amap_flutter_locationVersionString[];

