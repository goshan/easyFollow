//
//  NSString+ParseCategory.h
//  easyFollow
//
//  Created by Qiu Han on 10/22/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface NSString (NSString_ParseCategory)
- (NSMutableDictionary *)explodeToDictionaryInnerGlue:(NSString *)innerGlue 
                                           outterGlue:(NSString *)outterGlue;
@end

