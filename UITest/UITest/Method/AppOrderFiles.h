//
//  AppOrderFiles.h
//  AppOrderFiles
//
//

#import <Foundation/Foundation.h>

//! Project version number for AppOrderFiles.
FOUNDATION_EXPORT double AppOrderFilesVersionNumber;

//! Project version string for AppOrderFiles.
FOUNDATION_EXPORT const unsigned char AppOrderFilesVersionString[];

extern void AppOrderFiles(void(^completion)(NSString *orderFilePath));
