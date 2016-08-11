//
//  Recipe.m
//  3-Food2ForkAPI
//
//  Created by ThanhVo on 8/10/16.
//  Copyright © 2016 ThanhVo. All rights reserved.
//

#import "Recipe.h"

@implementation Recipe

- (void)dealloc {
    
    if(_recipeID!=nil)
    {
        [_recipeID release];
        _recipeID = nil;
    }
    
    if(_title!=nil)
    {
        [_title release];
        _title = nil;
    }
    
    if(_publisher!=nil)
    {
        [_publisher release];
        _publisher = nil;
    }
    
    if(_rank!=nil)
    {
        [_rank release];
        _rank = nil;
    }
    
    if(_imageURL!=nil)
    {
        [_imageURL release];
        _imageURL = nil;
    }
    
    [super dealloc];
}

@end
