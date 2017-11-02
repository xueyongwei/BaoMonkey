//
//  RecommendViewController.m
//  BaoMonkey
//
//  Created by xueyognwei on 2017/10/10.
//  Copyright © 2017年 BaoMonkey. All rights reserved.
//

#import "RecommendViewController.h"
#import <YYKit.h>
#import <UIImageView+YYWebImage.h>
@interface RecommendViewController ()
@property (weak, nonatomic) IBOutlet UIImageView *adIconImageView;
@property (weak, nonatomic) IBOutlet UILabel *adTitleLabel;
@property (weak, nonatomic) IBOutlet UILabel *adDescLabel;
@property (weak, nonatomic) IBOutlet UIImageView *adImageView;
@property (weak, nonatomic) IBOutlet UIButton *closeBtn;
@property (weak, nonatomic) IBOutlet UIButton *downloadBtn;

@end

@implementation RecommendViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.closeBtn.layer.cornerRadius = YYScreenSize().width*0.05;
    self.closeBtn.clipsToBounds = YES;
    self.downloadBtn.layer.cornerRadius = 8;
    self.downloadBtn.clipsToBounds = YES;
    self.adIconImageView.layer.cornerRadius = 8;
    self.adIconImageView.clipsToBounds = YES;
    
    [self customADView];
    // Do any additional setup after loading the view from its nib.
}
-(void)customADView{
    if (!YYImageWebPAvailable()) {
        NSLog(@"webp!");
    }else{
        
    }
//    NSURL *imgUrl = [NSURL URLWithString:@"https://isparta.github.io/compare-webp/image/png_webp/webp_lossy75/1.webp"];
//
//    [self.adImageView setImageWithURL:imgUrl options:YYWebImageOptionRefreshImageCache];
    
    [self.adIconImageView setImageURL:[NSURL URLWithString:self.recommondADModel.icon]];
    self.adTitleLabel.text = self.recommondADModel.title;
    self.adDescLabel.text = self.recommondADModel.desc;
    [self.adImageView setImageURL:[NSURL URLWithString:self.recommondADModel.banner]];
    
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)onClose:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}
- (IBAction)onInstall:(id)sender {
    NSURL *appStpre = [NSURL URLWithString:self.recommondADModel.url];
    [[UIApplication sharedApplication] openURL:appStpre];
    
    [self dismissViewControllerAnimated:YES completion:nil];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
