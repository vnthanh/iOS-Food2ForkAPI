//
//  RecipesTableViewCell.m
//  3-Food2ForkAPI
//
//  Created by ThanhVo on 8/10/16.
//  Copyright © 2016 ThanhVo. All rights reserved.
//

#import "RecipesTableViewCell.h"

@implementation RecipesTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)dealloc {
    [_imvRecipeImage release];
    [_lblRecipeTitle release];
    [_lblRecipePublisher release];
    [_lblRecipeRank release];
    [super dealloc];
}
@end
