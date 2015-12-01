//
//  KDNImageUploadViewController.m
//  KDNScenePath
//
//  Created by Kien Nguyen Duy on 12/1/15.
//  Copyright © 2015 Kien Nguyen Duy. All rights reserved.
//

#import "KDNImageUploadViewController.h"
#import "KDNConstants.h"
#import <AFNetworking.h>

@interface KDNImageUploadViewController ()
@property (weak, nonatomic) IBOutlet UIButton *cancelButton;
@property (weak, nonatomic) IBOutlet UIButton *uploadButton;

@property (strong, nonatomic) AFHTTPRequestOperationManager *manager;

@property (nonatomic) BOOL uploadSucceeded;

@end

@implementation KDNImageUploadViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self.imageView setImage:self.image];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(uploadImageSucceeded:) name:kUploadImageSucceed object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(uploadImageFailed:) name:kUploadImageFailed object:nil];
    
    self.manager = [AFHTTPRequestOperationManager manager];
    self.uploadSucceeded = NO;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/
- (IBAction)cancelButtonClicked:(id)sender {
    if (self.uploadSucceeded == NO) {
        [self.manager.operationQueue cancelAllOperations];
    }
    [self dismissViewControllerAnimated:YES completion:nil];
}
- (IBAction)uploadButtonClicked:(id)sender {
    [self changeButtonWhenBeginUploading];
    
    self.manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/plain"];
    
    NSData *imageData = UIImageJPEGRepresentation(self.image, 0.5);
    NSDictionary *parameters = [[NSDictionary alloc] init];
    AFHTTPRequestOperation *op = [self.manager POST:kImageUploadUrl parameters:parameters constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
        //do not put image inside parameters dictionary as I did, but append it!
        [formData appendPartWithFileData:imageData name:@"name1.jpg" fileName:@"photo.jpg" mimeType:@"image/jpeg"];
    } success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"Success: %@ ***** %@", operation.responseString, responseObject);
        
        [[NSNotificationCenter defaultCenter] postNotificationName:kUploadImageSucceed object:nil];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Error: %@ ***** %@", operation.responseString, error);
        
        [[NSNotificationCenter defaultCenter] postNotificationName:kUploadImageFailed object:nil];
    }];
    [op start];
}

-(void)changeButtonWhenBeginUploading {
    [self.uploadButton setEnabled:NO];
    
    [self.uploadButton setTitle:kImageUploadUploadingTitle forState:UIControlStateDisabled];
    [self.uploadButton setTitle:kImageUploadUploadingTitle forState:UIControlStateNormal];
}

-(void)changeButtonWhenFinishedUploading {
    [self.uploadButton setEnabled:YES];
    
    [self.uploadButton setTitle:kImageUploadUploadTitle forState:UIControlStateDisabled];
    [self.uploadButton setTitle:kImageUploadUploadTitle forState:UIControlStateNormal];
}

-(void)uploadImageSucceeded:(NSNotification*)notification {
    [self changeButtonWhenFinishedUploading];
    [self.uploadButton setEnabled:NO];
    
    self.uploadSucceeded = YES;
    [self.cancelButton setTitle:kImageUploadDoneTitle forState:UIControlStateNormal];
}

-(void)uploadImageFailed:(NSNotification*)notification {
    [self changeButtonWhenFinishedUploading];
}


@end
