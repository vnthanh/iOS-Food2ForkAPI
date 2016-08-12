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

#define kURLString @"http://food2fork.com/api/search?key=7094f866ecc388982e34015eddfaa2d8&page="


@interface ViewController ()
@property (nonatomic) int recipesCount;
@property int pageNumber; //to append to url request string, to get specific page from API

// to animate an indicator, add programmatically
@property (nonatomic, retain) UIActivityIndicatorView *activityIndicator;
@end

static NSMutableArray *arrayOfRecipes;

@implementation ViewController

+ (NSMutableArray *)getArrayOfRecipes {
    return arrayOfRecipes;
}

- (void)viewDidLoad {
    [super viewDidLoad];

    // add activity indicator
    self.activityIndicator = [[UIActivityIndicatorView alloc] initWithFrame:CGRectMake(0, 0, 20, 20)];
    UIBarButtonItem * barButton = [[UIBarButtonItem alloc] initWithCustomView:self.activityIndicator];
    [self navigationItem].rightBarButtonItem = barButton;
    
    arrayOfRecipes = [[NSMutableArray alloc] init];

    // page number init
    self.pageNumber = 1;
    
    // set string
    NSString *urlString = [NSString stringWithFormat:@"%@%d",kURLString,self.pageNumber];
    NSURL *url = [NSURL URLWithString:urlString];
    
    // start indicator. NOTE : MUST CALL IN MAIN THREAD (UI THREAD)
    [self.activityIndicator startAnimating];
    
    // and call request, parse thread
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        NSData *data = [NSData dataWithContentsOfURL:url];
        [self fetchedData:data];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.tbvRecipes reloadData];
            
            // stop indicator
            [self.activityIndicator stopAnimating];
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
    
    // fix laggy load image from url & "image change issue"
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
    
    
    // when reach last cell, start sen request and parse more, add more to array
    if(indexPath.row == arrayOfRecipes.count-1)
    {
        // increase page number, to append to url string
        self.pageNumber ++;
        
        // start indicator. NOTE : MUST CALL IN MAIN THREAD  (UI UPDATE)
        [self.activityIndicator startAnimating];
        
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            NSString *urlString = [NSString stringWithFormat:@"%@%d",kURLString,self.pageNumber];
            NSURL *url = [NSURL URLWithString:urlString];
            
            NSData *data = [NSData dataWithContentsOfURL:url];
            [self fetchedData:data];
            
            dispatch_async(dispatch_get_main_queue(), ^{
                [self.tbvRecipes reloadData];
                
                // stop indicator
                [self.activityIndicator stopAnimating];

            });
        });
    }
    
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
