//
//  RecipesTableViewCell.h
//  3-Food2ForkAPI
//
//  Created by ThanhVo on 8/10/16.
//  Copyright © 2016 ThanhVo. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RecipesTableViewCell : UITableViewCell
@property (retain, nonatomic) IBOutlet UIImageView *imvRecipeImage;

@property (retain, nonatomic) IBOutlet UILabel *lblRecipeTitle;
@property (retain, nonatomic) IBOutlet UILabel *lblRecipePublisher;
@property (retain, nonatomic) IBOutlet UILabel *lblRecipeRank;
@end
