//
//  CoverFlowViewController.m
//  CoverFlow
//
//  Created by Josh Endter on 6/26/15.
//  Copyright (c) 2015 Josh Endter. All rights reserved.
//

#import "CoverFlowViewController.h"
#import "Photo.h"
#import "CoverFlowCell.h"

@interface CoverFlowViewController ()

@property (nonatomic, strong) NSMutableArray *photos;

@end

@implementation CoverFlowViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Register cell classes
    //[self.collectionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:@"CoverFlowCell"];
    
    // Do any additional setup after loading the view.
    
    [self loadSamplePhotos];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark <UICollectionViewDataSource>

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
//#warning Incomplete method implementation -- Return the number of sections
    return 1;
}


- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
//#warning Incomplete method implementation -- Return the number of items in the section
    return self.photos.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    CoverFlowCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"CoverFlowCell" forIndexPath:indexPath];
    
    Photo *photo = self.photos[indexPath.item];
    
    cell.imageView.image = [UIImage imageNamed:photo.imageName];
    
    return cell;
}


#pragma mark - Load data

-(void)loadSamplePhotos {
    
    Photo *photo1 = [Photo new];
    photo1.imageName = @"australia";
    photo1.subject = @"Travel";
    photo1.location = @"Australia";
    
    Photo *photo3 = [Photo new];
    photo3.imageName = @"california";
    photo3.subject = @"Travel";
    photo3.location = @"California";
    
    Photo *photo4 = [Photo new];
    photo4.imageName = @"california2";
    photo4.subject = @"Travel";
    photo4.location = @"California";
    
    Photo *photo5 = [Photo new];
    photo5.imageName = @"california3";
    photo5.subject = @"Travel";
    photo5.location = @"California";
    
    Photo *photo6 = [Photo new];
    photo6.imageName = @"california4";
    photo6.subject = @"Travel";
    photo6.location = @"California";
    
    Photo *photo7 = [Photo new];
    photo7.imageName = @"cat";
    photo7.subject = @"Animal";
    photo7.location = @"The Internet";
    
    Photo *photo8 = [Photo new];
    photo8.imageName = @"cat2";
    photo8.subject = @"Animal";
    photo8.location = @"The Internet";
    
    Photo *photo9 = [Photo new];
    photo9.imageName = @"coast";
    photo9.subject = @"Travel";
    photo9.location = @"Oregon";
    
    Photo *photo10 = [Photo new];
    photo10.imageName = @"forest";
    photo10.subject = @"Hiking";
    photo10.location = @"Philadelphia";
    
    Photo *photo11 = [Photo new];
    photo11.imageName = @"park";
    photo11.subject = @"Hiking";
    photo11.location = @"Philadelphia";
    
    Photo *photo12 = [Photo new];
    photo12.imageName = @"waiting";
    photo12.subject = @"Animal";
    photo12.location = @"The Internet";
    
    Photo *photo13 = [Photo new];
    photo13.imageName = @"winter";
    photo13.subject = @"Weather";
    photo13.location = @"Philadelphia";
    
    self.photos = [NSMutableArray arrayWithObjects:photo1, photo3, photo4, photo5, photo6, photo7, photo8, photo9, photo10, photo11, photo12, photo13, nil];
    
    NSLog(@"%@", self.photos);
}


#pragma mark <UICollectionViewDelegate>

/*
// Uncomment this method to specify if the specified item should be highlighted during tracking
- (BOOL)collectionView:(UICollectionView *)collectionView shouldHighlightItemAtIndexPath:(NSIndexPath *)indexPath {
	return YES;
}
*/

/*
// Uncomment this method to specify if the specified item should be selected
- (BOOL)collectionView:(UICollectionView *)collectionView shouldSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}
*/

/*
// Uncomment these methods to specify if an action menu should be displayed for the specified item, and react to actions performed on the item
- (BOOL)collectionView:(UICollectionView *)collectionView shouldShowMenuForItemAtIndexPath:(NSIndexPath *)indexPath {
	return NO;
}

- (BOOL)collectionView:(UICollectionView *)collectionView canPerformAction:(SEL)action forItemAtIndexPath:(NSIndexPath *)indexPath withSender:(id)sender {
	return NO;
}

- (void)collectionView:(UICollectionView *)collectionView performAction:(SEL)action forItemAtIndexPath:(NSIndexPath *)indexPath withSender:(id)sender {
	
}
*/

@end
