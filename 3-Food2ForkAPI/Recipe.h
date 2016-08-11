//
//  Recipe.h
//  3-Food2ForkAPI
//
//  Created by ThanhVo on 8/10/16.
//  Copyright © 2016 ThanhVo. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Recipe : NSObject

@property (nonatomic, retain) NSString *recipeID;

@property (nonatomic, retain) NSString *title;
@property (nonatomic, retain) NSString *publisher;
@property (nonatomic, retain) NSNumber *rank;
@property (nonatomic, retain) NSString *imageURL;

@end
