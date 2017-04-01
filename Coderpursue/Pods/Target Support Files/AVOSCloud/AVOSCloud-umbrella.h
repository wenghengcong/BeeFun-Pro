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

#import "AVACL.h"
#import "AVRole.h"
#import "AVSaveOption.h"
#import "AVAnalytics.h"
#import "AVConstants.h"
#import "AVOSCloud.h"
#import "AVCloud.h"
#import "AVFile.h"
#import "AVGeoPoint.h"
#import "AVGroup.h"
#import "AVHistoryMessage.h"
#import "AVHistoryMessageQuery.h"
#import "AVMessage.h"
#import "AVSession.h"
#import "AVSignature.h"
#import "AVObject+Subclass.h"
#import "AVObject.h"
#import "AVRelation.h"
#import "AVSubclassing.h"
#import "AVInstallation.h"
#import "AVFileQuery.h"
#import "AVPush.h"
#import "AVCloudQueryResult.h"
#import "AVQuery.h"
#import "AVSearchQuery.h"
#import "AVSearchSortBuilder.h"
#import "AVStatus.h"
#import "AVAnonymousUtils.h"
#import "AVUser.h"
#import "AVLogger.h"
#import "AVAvailability.h"

FOUNDATION_EXPORT double AVOSCloudVersionNumber;
FOUNDATION_EXPORT const unsigned char AVOSCloudVersionString[];

