//
//  Series.h
//  Tsuki
//
//  Created by James Wu on 8/19/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Series : NSObject

@property (nonatomic, copy) NSString *title;
@property (nonatomic, copy) NSString *url;
@property (nonatomic, copy) NSString *author;
@property (nonatomic, copy) NSString *coverUrl;
@property (nonatomic, copy) UIImage *coverImage;

@end
