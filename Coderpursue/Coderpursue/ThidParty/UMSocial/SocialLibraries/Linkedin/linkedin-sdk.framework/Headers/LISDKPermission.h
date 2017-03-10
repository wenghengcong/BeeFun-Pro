//
//  LISDKPermission.h
//
//  Copyright (c) 2015 linkedin. All rights reserved.
//

#ifndef LISDKPermission_h
#define LISDKPermission_h

/** 
 @file LISDKPermission.h
 list of valid permissions
 */

/**
  @def LISDK_BASIC_PROFILE_PERMISSION permission to retrieve name, photo, headline and current position
 */
#define LISDK_BASIC_PROFILE_PERMISSION @"r_basicprofile"

/**
 LISDK_FULL_PROFILE_PERMISSION permission to retrieve full profile including experience, education, skills and recommendations
 This permission is not open to all developers.
 */
#define LISDK_FULL_PROFILE_PERMISSION @"r_fullprofile"

/**
 LISDK_EMAILADDRESS_PERMISSION permission to retrieve email address
 */
#define LISDK_EMAILADDRESS_PERMISSION @"r_emailaddress"

/**
 LISDK_W_SHARE_PERMISSION  permission to post updates, make comments and like posts
 */
#define LISDK_W_SHARE_PERMISSION @"w_share"

/**
 LISDK_CONTACT_INFO_PERMISSION permission to retrieve address, phone number, and bound accounts
 This permission is not open to all developers.
 */
#define LISDK_CONTACT_INFO_PERMISSION @"r_contactinfo"

/**
 LISDK_RW_COMPANY_ADMIN_PERMISSION permission to edit company pages for which I am an Admin and post status updates on behalf of those companies
 */
#define LISDK_RW_COMPANY_ADMIN_PERMISSION @"rw_company_admin"



#endif
