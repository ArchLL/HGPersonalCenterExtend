//
//  HGPersonalCenterExtendMacro.h
//  Pods
//
//  Created by Arch on 2019/5/15.
//

#ifndef HGPersonalCenterExtendMacro_h
#define HGPersonalCenterExtendMacro_h

#ifndef weakify
#if DEBUG
#if __has_feature(objc_arc)
#define weakify(object) autoreleasepool{} __weak __typeof__(object) weak##_##object = object;
#else
#define weakify(object) autoreleasepool{} __block __typeof__(object) block##_##object = object;
#endif
#else
#if __has_feature(objc_arc)
#define weakify(object) try{} @finally{} {} __weak __typeof__(object) weak##_##object = object;
#else
#define weakify(object) try{} @finally{} {} __block __typeof__(object) block##_##object = object;
#endif
#endif
#endif

#ifndef strongify
#if DEBUG
#if __has_feature(objc_arc)
#define strongify(object) autoreleasepool{} __typeof__(object) object = weak##_##object;
#else
#define strongify(object) autoreleasepool{} __typeof__(object) object = block##_##object;
#endif
#else
#if __has_feature(objc_arc)
#define strongify(object) try{} @finally{} __typeof__(object) object = weak##_##object;
#else
#define strongify(object) try{} @finally{} __typeof__(object) object = block##_##object;
#endif
#endif
#endif

// device
#define HG_SCREEN_HEIGHT [[UIScreen mainScreen] bounds].size.height
#define HG_SCREEN_WIDTH [[UIScreen mainScreen] bounds].size.width
#define HG_ONE_PIXEL (1 / [UIScreen mainScreen].scale)

// static
static const CGFloat HGCategoryViewDefaultHeight = 41;

#endif /* HGPersonalCenterExtendMacro_h */
