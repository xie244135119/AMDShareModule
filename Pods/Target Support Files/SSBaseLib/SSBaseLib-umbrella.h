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

#import "AMDBaseModel.h"
#import "AMDBaseViewModel.h"
#import "SSBaseLib.h"
#import "SSJSONModel.h"
#import "SSJSONModelClassProperty.h"
#import "SSJSONModelError.h"
#import "SSJSONModelLib.h"
#import "SSJSONKeyMapper.h"
#import "SSJSONValueTransformer.h"

FOUNDATION_EXPORT double SSBaseLibVersionNumber;
FOUNDATION_EXPORT const unsigned char SSBaseLibVersionString[];

