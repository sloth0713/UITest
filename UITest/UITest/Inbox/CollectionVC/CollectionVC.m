//
//  CollectionVC.m
//  UITest
//
//  Created by ByteDance on 2024/11/27.
//

#import "CollectionVC.h"
#import "MyLayout.h"

@implementation CollectionVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    MyLayout * layout = [[MyLayout alloc]init];
    layout.width = self.view.bounds.size.width;
    layout.scrollDirection = UICollectionViewScrollDirectionVertical;
    layout.itemCount=100;
    UICollectionView * collect  = [[UICollectionView alloc]initWithFrame:self.view.frame collectionViewLayout:layout];
    collect.delegate=self;
    collect.dataSource=self;
    
    [collect registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:@"cellid"];
  
    [self.view addSubview:collect];
    
}
 
-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return 1;
}

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return 100;
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    UICollectionViewCell * cell  = [collectionView dequeueReusableCellWithReuseIdentifier:@"cellid" forIndexPath:indexPath];
    cell.backgroundColor = [UIColor colorWithRed:arc4random()%255/255.0 green:arc4random()%255/255.0 blue:arc4random()%255/255.0 alpha:1];
    return cell;
}

@end
