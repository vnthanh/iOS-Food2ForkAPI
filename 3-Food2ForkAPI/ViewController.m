//
//  ViewController.m
//  3-Food2ForkAPI
//
//  Created by ThanhVo on 8/10/16.
//  Copyright © 2016 ThanhVo. All rights reserved.
//

#import "ViewController.h"
#import "Recipe.h"
#import "RecipesTableViewCell.h"
#import "DetailViewController.h"

@interface ViewController ()
@property (nonatomic) int recipesCount;
@end

static NSMutableArray *arrayOfRecipes;

@implementation ViewController

+ (NSMutableArray *)getArrayOfRecipes {
    return arrayOfRecipes;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    arrayOfRecipes = [[NSMutableArray alloc] init];
    
    NSURL *url = [NSURL URLWithString:@"http://food2fork.com/api/search?key=7094f866ecc388982e34015eddfaa2d8"];
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        NSData *data = [NSData dataWithContentsOfURL:url];
        [self fetchedData:data];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.tbvRecipes reloadData];
        });
    });
    
}


// parse and add object to arrayOfRecipes
- (void)fetchedData:(NSData *)responseData {
    //parse out the json data
    NSError* error;
    NSDictionary* json = [NSJSONSerialization
                          JSONObjectWithData:responseData
                          options:kNilOptions
                          error:&error];
    
    NSArray *tempRecipeDict = [json objectForKey:@"recipes"];
    
    _recipesCount = [[json objectForKey:@"count"] intValue];
    
    
    for(int i=0;i<_recipesCount;i++)
    {
        Recipe *tempRecipe = [[Recipe alloc] init];
        
        tempRecipe.recipeID = [tempRecipeDict[i] objectForKey:@"recipe_id"];
        tempRecipe.title = [tempRecipeDict[i] objectForKey:@"title"];
        tempRecipe.publisher = [tempRecipeDict[i] objectForKey:@"publisher"];
        tempRecipe.imageURL = [tempRecipeDict[i] objectForKey:@"image_url"];
        tempRecipe.rank = [tempRecipeDict[i] objectForKey:@"social_rank"];
        
        [arrayOfRecipes addObject:tempRecipe];
        [tempRecipe release];
    }
    
    [tempRecipeDict release];
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    NSString *identifier = @"cell";
    RecipesTableViewCell *cell = [self.tbvRecipes dequeueReusableCellWithIdentifier:identifier];
    
    Recipe *tempRecipe = arrayOfRecipes[indexPath.row];
    
    cell.lblRecipeTitle.text = tempRecipe.title;
    cell.lblRecipePublisher.text = tempRecipe.publisher;
    cell.lblRecipeRank.text = [tempRecipe.rank stringValue];
    
    // fix laggy load image from url & "image chance issue"

    NSURLSessionTask *task = [[NSURLSession sharedSession] dataTaskWithURL:[NSURL URLWithString:tempRecipe.imageURL] completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        if (data) {
            UIImage *image = [UIImage imageWithData:data];
            if (image) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    cell.imvRecipeImage.image = image;
                });
            }
        }
    }];
    [task resume];
    
    return cell;
}



- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return arrayOfRecipes.count;
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    DetailViewController *vc = [segue destinationViewController];
    
    NSIndexPath *indexPath = [self.tbvRecipes indexPathForSelectedRow];
    
    [vc setRecipeIndex:(int)indexPath.row];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc {
    [_tbvRecipes release];
    [super dealloc];
}
@end
