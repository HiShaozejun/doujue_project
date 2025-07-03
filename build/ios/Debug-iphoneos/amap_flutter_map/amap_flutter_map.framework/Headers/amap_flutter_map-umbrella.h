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

#import "AMapFlutterFactory.h"
#import "AMapFlutterMapPlugin.h"
#import "AMapViewController.h"
#import "FlutterMethodChannel+MethodCallDispatch.h"
#import "MAAnnotationView+Flutter.h"
#import "MAMapView+Flutter.h"
#import "MAPointAnnotation+Flutter.h"
#import "MAPolygon+Flutter.h"
#import "MAPolygonRenderer+Flutter.h"
#import "MAPolyline+Flutter.h"
#import "MAPolylineRenderer+Flutter.h"
#import "AMapCameraPosition.h"
#import "AMapInfoWindow.h"
#import "AMapLocation.h"
#import "AMapMarker.h"
#import "AMapPolygon.h"
#import "AMapPolyline.h"
#import "AMapMarkerController.h"
#import "AMapPolygonController.h"
#import "AMapPolylineController.h"
#import "AMapConvertUtil.h"
#import "AMapJsonUtils.h"
#import "AMapMethodCallDispatcher.h"

FOUNDATION_EXPORT double amap_flutter_mapVersionNumber;
FOUNDATION_EXPORT const unsigned char amap_flutter_mapVersionString[];

