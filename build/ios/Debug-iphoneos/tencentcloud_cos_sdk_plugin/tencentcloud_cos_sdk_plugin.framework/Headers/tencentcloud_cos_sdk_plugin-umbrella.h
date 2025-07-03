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

#import "CosPlugin.h"
#import "CosPluginSignatureProvider.h"
#import "pigeon.h"

FOUNDATION_EXPORT double tencentcloud_cos_sdk_pluginVersionNumber;
FOUNDATION_EXPORT const unsigned char tencentcloud_cos_sdk_pluginVersionString[];

