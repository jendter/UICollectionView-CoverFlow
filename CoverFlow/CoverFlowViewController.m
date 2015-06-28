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
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UILabel *descriptionLabel;
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
@property (nonatomic) CGSize cellSize;

@end

@implementation CoverFlowViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // self.clearsSelectionOnViewWillAppear = NO;
    
    [self addDescriptiveLabels];
    
    [self loadSamplePhotos];
    
    self.cellSize = (CGSize){140, 129};

}

// Style choice: Not beginning at start of collection
//-(void)viewDidAppear:(BOOL)animated {
//    [super viewDidAppear:animated];
//    NSIndexPath *indexPath = [NSIndexPath indexPathForItem:4 inSection:0];
//    [self.collectionView scrollToItemAtIndexPath:indexPath atScrollPosition:UICollectionViewScrollPositionCenteredHorizontally animated:NO];
//}

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
    photo1.subject = @"Opera House";
    photo1.location = @"Australia";
    
    Photo *photo3 = [Photo new];
    photo3.imageName = @"california";
    photo3.subject = @"Found a Cave";
    photo3.location = @"California";
    
    Photo *photo4 = [Photo new];
    photo4.imageName = @"california2";
    photo4.subject = @"Stairs";
    photo4.location = @"California";
    
    Photo *photo5 = [Photo new];
    photo5.imageName = @"california3";
    photo5.subject = @"Old Gold Rush Town";
    photo5.location = @"California";
    
    Photo *photo6 = [Photo new];
    photo6.imageName = @"california4";
    photo6.subject = @"Driving to SFO";
    photo6.location = @"California";
    
    Photo *photo7 = [Photo new];
    photo7.imageName = @"cat";
    photo7.subject = @"An Everyday Cat";
    photo7.location = @"The Internet";
    
    Photo *photo8 = [Photo new];
    photo8.imageName = @"cat2";
    photo8.subject = @"Dinner";
    photo8.location = @"The Internet";
    
    Photo *photo9 = [Photo new];
    photo9.imageName = @"coast";
    photo9.subject = @"The Coast";
    photo9.location = @"Oregon";
    
    Photo *photo10 = [Photo new];
    photo10.imageName = @"forest";
    photo10.subject = @"Hermit House";
    photo10.location = @"Philadelphia";
    
    Photo *photo11 = [Photo new];
    photo11.imageName = @"park";
    photo11.subject = @"Hiking in Valley Green";
    photo11.location = @"Philadelphia";
    
    Photo *photo12 = [Photo new];
    photo12.imageName = @"waiting";
    photo12.subject = @"Waiting is Tough";
    photo12.location = @"The Internet";
    
    Photo *photo13 = [Photo new];
    photo13.imageName = @"winter";
    photo13.subject = @"Winter";
    photo13.location = @"Philadelphia";
    
    self.photos = [NSMutableArray arrayWithObjects:photo1, photo3, photo4, photo5, photo6, photo7, photo9, photo10, photo11, photo12, photo13, nil];
}


#pragma mark - Adding Labels

-(void)addDescriptiveLabels {
    self.titleLabel = [[UILabel alloc] initWithFrame:CGRectZero];
    
    self.titleLabel.textColor = [UIColor whiteColor];
    
    self.titleLabel.translatesAutoresizingMaskIntoConstraints = NO;
    
    self.titleLabel.text = @"Subject";
    
    [self.view addSubview:self.titleLabel];
    
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:self.titleLabel
                                                          attribute:NSLayoutAttributeBottom
                                                          relatedBy:NSLayoutRelationEqual
                                                             toItem:self.view
                                                          attribute:NSLayoutAttributeBottom
                                                         multiplier:1.0
                                                           constant:-45]];
    
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:self.titleLabel
                                                          attribute:NSLayoutAttributeCenterX
                                                          relatedBy:NSLayoutRelationEqual
                                                             toItem:self.view
                                                          attribute:NSLayoutAttributeCenterX
                                                         multiplier:1.0
                                                           constant:10]];
    
    
    self.descriptionLabel = [[UILabel alloc] initWithFrame:CGRectZero];
    
    self.descriptionLabel.textColor = [UIColor grayColor];
    
    self.descriptionLabel.translatesAutoresizingMaskIntoConstraints = NO;
    
    self.descriptionLabel.text = @"Description";
    
    [self.view addSubview:self.descriptionLabel];
    
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:self.descriptionLabel
                                                          attribute:NSLayoutAttributeTop
                                                          relatedBy:NSLayoutRelationEqual
                                                             toItem:self.titleLabel
                                                          attribute:NSLayoutAttributeBottom
                                                         multiplier:1.0
                                                           constant:0]];
    
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:self.descriptionLabel
                                                          attribute:NSLayoutAttributeCenterX
                                                          relatedBy:NSLayoutRelationEqual
                                                             toItem:self.view
                                                          attribute:NSLayoutAttributeCenterX
                                                         multiplier:1.0
                                                           constant:10]];
}

#pragma mark - Cover Flow Delegate

-(void)cellIsCenteredAtIndexPath:(NSIndexPath *)indexPath {
    
    // When the Cover Flow Layout changes, we need to update the title and description labels
    Photo *photo = self.photos[indexPath.item];
    self.titleLabel.text = photo.subject;
    self.descriptionLabel.text = photo.location;
    
}


#pragma mark <UICollectionViewDelegateFlowLayout>

-(UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
    //NSLog(@"-----------width %f",collectionViewLayout.collectionView.frame.size.width);
    
    
    CGFloat frameWidth = collectionViewLayout.collectionView.frame.size.width;
    CGFloat cellWidth = self.cellSize.width;
    CGFloat leftAndRightInset = (frameWidth/2.0)-(cellWidth/2.0);
    
    return UIEdgeInsetsMake(70, leftAndRightInset, 70, leftAndRightInset); // 70's are hardcoded, this will break on an ipad.
}

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
