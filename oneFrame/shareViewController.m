//
//  shareViewController.m
//  One Frame
//
//  Created by Saswata Basu on 3/23/14.
//  Copyright (c) 2014 Saswata Basu. All rights reserved.
//
#define IS_TALL_SCREEN ( [ [ UIScreen mainScreen ] bounds ].size.height == 568 )
#define screenSpecificSetting(tallScreen, normal) ((IS_TALL_SCREEN) ? tallScreen : normal)


#import "shareViewController.h"
#import <Social/Social.h>
#import <QuartzCore/QuartzCore.h>
#import "Flurry.h"

@interface shareViewController ()
@property(nonatomic,retain) UIDocumentInteractionController *documentationInteractionController;
@property(nonatomic, strong)  UIDocumentInteractionController* docController;
@end

@implementation shareViewController


- (void)viewDidLoad
{
    [super viewDidLoad];
//    if (!IS_TALL_SCREEN) {
//        self.shareView.frame = CGRectMake(0, 0, 320, 436);  // for 3.5 screen; remove autolayout
//    }
    CGRect frame = CGRectMake(0, 0, 125, 40);
    UILabel *label = [[UILabel alloc] initWithFrame:frame];
//    label.backgroundColor = [UIColor clearColor];
    label.font = [UIFont systemFontOfSize:18.0];
    label.textAlignment = NSTextAlignmentCenter;
    label.textColor = [UIColor whiteColor];
    label.text = @"SHARE";
    self.navigationItem.titleView = label;
	// Do any additional setup after loading the view.
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"CANCEL" style:UIBarButtonItemStyleBordered target:self action:@selector(cancel)];
    NSLog(@"self.image is %@",self.image);
    [self setupCircles];

}

- (void) setupCircles {
    int radius = 30;
    self.imageView1.layer.cornerRadius = radius;
    self.imageView2.layer.cornerRadius = radius;
    self.imageView3.layer.cornerRadius = radius;
//    self.imageView4.layer.cornerRadius = radius;
//    self.imageView5.layer.cornerRadius = radius;
    self.imageView6.layer.cornerRadius = radius;
    self.imageView7.layer.cornerRadius = radius;
    self.imageView8.layer.cornerRadius = radius;
}
- (void)cancel {
    [self dismissViewControllerAnimated: NO completion: nil];
}

- (IBAction)postToFacebook:(id)sender {
    [Flurry logEvent:@"Facebook"];
//    NSLog(@"share to facebook");
//    if([SLComposeViewController isAvailableForServiceType:SLServiceTypeFacebook]) {
    // check whether facebook is (likely to be) installed or not
    if ([[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:@"fb://"]]) {
        // Safe to launch the facebook app
//        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"fb://profile/200538917420"]];
//    }
//        NSLog(@"share to facebook1");

        SLComposeViewController *controller = [SLComposeViewController composeViewControllerForServiceType:SLServiceTypeFacebook];
        
        [controller setInitialText:@"#OneFrame created with One Frame app"];
        [controller addImage:self.image];
        
        [self presentViewController:controller animated:YES completion:nil];
        
    }
}

- (IBAction)postToTwitter:(id)sender {
    [Flurry logEvent:@"Twitter"];
//    if ([SLComposeViewController isAvailableForServiceType:SLServiceTypeTwitter])
//    {
    if ([[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:@"twitter://"]]) {

        SLComposeViewController *tweetSheet = [SLComposeViewController
                                               composeViewControllerForServiceType:SLServiceTypeTwitter];
        [tweetSheet setInitialText:@"#OneFrame created with @oneframeapp"];
        [tweetSheet addImage:self.image];
        [self presentViewController:tweetSheet animated:YES completion:nil];
    }
}

//- (IBAction)postToSinaWeibo:(id)sender {
////    if([SLComposeViewController isAvailableForServiceType:SLServiceTypeSinaWeibo]) {
//    if ([[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:@"sinaweibo://"]]) {
//
//        SLComposeViewController *controller = [SLComposeViewController composeViewControllerForServiceType:SLServiceTypeSinaWeibo];
//        
//        [controller setInitialText:@"#One Frame created with @One Frame"];
//        [controller addImage:self.image];
//        
//        [self presentViewController:controller animated:YES completion:nil];
//        
//    }
//}
//- (IBAction)postToTenCentWeibo:(id)sender {
////    if([SLComposeViewController isAvailableForServiceType:SLServiceTypeTencentWeibo]) {
//    if ([[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:@"tencentweibo://"]]) {
//
//        SLComposeViewController *controller = [SLComposeViewController composeViewControllerForServiceType:SLServiceTypeTencentWeibo];
//        
//        [controller setInitialText:@"#One Frame created with @One Frame"];
//        [controller addImage:self.image];
//        
//        [self presentViewController:controller animated:YES completion:nil];
//        
//    }
//}
- (IBAction)postToInstagram:(UIButton *)sender  {

    [Flurry logEvent:@"Instagram"];
    //    UIImageView *drawingImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0,0,612,612)];
    //    drawingImageView.image = self.albumImage.image;
    //    UIImage* instaImage = [self cropImage:self.albumImage.image :drawingImageView];  //this works it just chops the top/bottom off
    NSString *imagePath;
//    if (isImage){
//        UIImageView *temp = [[UIImageView alloc] initWithImage:self.image];
    
//        UIImage* instaImage = [self captureView:temp];
        //    UIImage *instaImage = self.albumImage.image;  //chops off top and bottom
        
        imagePath = [NSString stringWithFormat:@"%@/image.igo", [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject]];
        [[NSFileManager defaultManager] removeItemAtPath:imagePath error:nil];
        [UIImagePNGRepresentation(self.image) writeToFile:imagePath atomically:YES];
//        NSLog(@"image size: %@", NSStringFromCGSize(instaImage.size));
    
    _docController = [UIDocumentInteractionController interactionControllerWithURL:[NSURL fileURLWithPath:imagePath]];
    _docController.delegate=self;
    //key to open Instagram app - need to make sure docController is "strong"
    _docController.UTI = @"com.instagram.exclusivegram";
    _docController.annotation = [NSDictionary dictionaryWithObject:@"#OneFrame created with @oneframeapp" forKey:@"InstagramCaption"];
    [_docController presentOpenInMenuFromRect:self.view.frame inView:self.view animated:YES];
    
    //    [_docController release];
    //    NSURL *instagramURL = [NSURL URLWithString:@"instagram://media?id=MEDIA_ID"];
    //    if ([[UIApplication sharedApplication] canOpenURL:instagramURL]) {
    //        [[UIApplication sharedApplication] openURL:instagramURL];
    //    }
    //
    //    else {
    //        NSLog(@"No Instagram Found");
    //    }
}

- (void) documentInteractionControllerDidDismissOpenInMenu:(UIDocumentInteractionController *) controller
{  _docController = nil;
}

- (UIImage*)captureView:(UIView *)view
{
    
    //    CGRect rect = view.frame;//[[UIScreen mainScreen] bounds];
    UIView *viewFull = [[UIView alloc] initWithFrame:CGRectMake(0, 0, view.frame.size.width+40, view.frame.size.height)];
    
    UIView *viewA = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 20, view.frame.size.height)];
    viewA.backgroundColor=[UIColor whiteColor];
    [viewFull addSubview:viewA];
    
    UIView *viewB = [[UIView alloc] initWithFrame:CGRectMake(20, 0, view.frame.size.width, view.frame.size.height)];
    [viewB addSubview:view];
    [viewFull addSubview:viewB];
    
    UIView *viewC = [[UIView alloc] initWithFrame:CGRectMake(20+view.frame.size.width, 0, 20, view.frame.size.height)];
    viewC.backgroundColor=[UIColor whiteColor];
    [viewFull addSubview:viewC];
    
    
    //    UIGraphicsBeginImageContext(rect.size);
    UIGraphicsBeginImageContextWithOptions(viewFull.frame.size, YES, 0.0);  //v1.0 bookly use this instead of withoutOptions and 2.0 magnification to give a sharper image  //v1.0g bookly Scaling at 2.0 is too much pixels and too big of an image to email.  0.0 goes to default image size of the device which makes it pretty large.  So the optimum is 1.25 scaling with 0.6 compression to keep most images at around 50kB.
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    [viewFull.layer renderInContext:context];
    UIImage *img = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    NSLog(@"img%@",img);
    return img;
}

- (IBAction)sendMail:(UIButton *)sender  
{
    [Flurry logEvent:@"Email"];
    NSLog(@"send mail");
    MFMailComposeViewController *pickerMail = [[MFMailComposeViewController alloc] init];
    pickerMail.mailComposeDelegate = self;
    
    [pickerMail setSubject:@"I created One Frame!"];
    
    // Fill out the email body text
//    NSString *temp = @"bookly";
//    NSString *booklyMediaId = [temp stringByAppendingString:[labelContents objectForKey:@"id"]];
//    NSString *encodedString = [inputData base64EncodedString];      //encode
    NSString *string= @"Check it out!  \n\n______\nCreated using One Frame app.  Download for FREE! \nhttp://itunes.apple.com/app/id866641636";
//    if (isImage)
//        string= [NSString stringWithFormat:@"http://getbooklyapp.com/image.php?mediaId=%@",encodedString];
//    else
//        string= [NSString stringWithFormat:@"http://getbooklyapp.com/video.php?mediaId=%@",encodedString];
    
    
    NSString *emailBody = string;
    
    [pickerMail setMessageBody:emailBody isHTML:NO];
    
    // Attach an image to the email
    //    if (isImage)
    [pickerMail addAttachmentData:UIImagePNGRepresentation(self.image)  mimeType:@"image/png" fileName:@"attach"];
    //    else
    //        [pickerMail addAttachmentData:img mimeType:@"video/mpeg" fileName:@"tmp.mp4"];
    [[UINavigationBar appearance] setTintColor:[UIColor blueColor]];

    //    [self presentModalViewController:pickerMail animated:YES];
    [self presentViewController:pickerMail animated:YES completion:nil];
    //    [[[[pickerMail viewControllers] lastObject] navigationItem] setTitle:@"Email"];
    
    pickerMail=nil;
}

#pragma mark MFMailComposeViewControllerDelegate

- (void) mailComposeController:(MFMailComposeViewController*)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError*)error
{
    //	[self dismissModalViewControllerAnimated:YES];
    [[UINavigationBar appearance] setTintColor:[UIColor whiteColor]];

    [ self dismissViewControllerAnimated: YES completion:nil];
}

- (void) mmsSend {  //sms or mms
    UIPasteboard *pasteboard = [UIPasteboard generalPasteboard];
    pasteboard.persistent = YES;
    pasteboard.image = self.image;
    
    NSString *phoneToCall = @"sms:";
    NSString *phoneToCallEncoded = [phoneToCall stringByAddingPercentEscapesUsingEncoding:NSASCIIStringEncoding];
    NSURL *url = [[NSURL alloc] initWithString:phoneToCallEncoded];
    [[UIApplication sharedApplication] openURL:url];
}

- (IBAction)showSMS:(UIButton *)sender  {
    [Flurry logEvent:@"SMS"];
    if(![MFMessageComposeViewController canSendText]) {
        UIAlertView *warningAlert = [[UIAlertView alloc] initWithTitle:@"Error" message:@"Your device doesn't support SMS!" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [warningAlert show];
        return;
    }
//    NSArray *recipents = @[@"12345678", @"72345524"];
    NSString *message = [NSString stringWithFormat:@"Created using One Frame app.  Download for FREE! \nhttp://itunes.apple.com/app/id866641636"];
    MFMessageComposeViewController *messageController = [[MFMessageComposeViewController alloc] init];
    [messageController addAttachmentData:UIImagePNGRepresentation(self.image) typeIdentifier:@"public.data" filename:@"image.png"];
    messageController.messageComposeDelegate = self;
//    [messageController setRecipients:recipents];
    [messageController setBody:message];
    // Present message view controller on screen
    [self presentViewController:messageController animated:YES completion:nil];
}
- (void)messageComposeViewController:(MFMessageComposeViewController *)controller didFinishWithResult:(MessageComposeResult) result
{
    switch (result) {
        case MessageComposeResultCancelled:
            break;
            
        case MessageComposeResultFailed:
        {
            UIAlertView *warningAlert = [[UIAlertView alloc] initWithTitle:@"Error" message:@"Failed to send SMS!" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
            [warningAlert show];
            break;
        }
            
        case MessageComposeResultSent:
            break;
            
        default:
            break;
    }
    
    [self dismissViewControllerAnimated:YES completion:nil];
}
- (IBAction)whatsApp:(UIButton *)sender {
    [Flurry logEvent:@"Others"];
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,     NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSString *getImagePath = [documentsDirectory stringByAppendingPathComponent:@"savedImage.png"];
    NSURL *imageFileURL =[NSURL fileURLWithPath:getImagePath];
    NSLog(@"image %@",imageFileURL);
    [UIImagePNGRepresentation(self.image) writeToFile:getImagePath atomically:YES];

    self.documentationInteractionController.delegate = self;
//    self.documentationInteractionController.UTI = @"net.whatsapp.image";
    self.documentationInteractionController = [self setupControllerWithURL:imageFileURL usingDelegate:self];
    [self.documentationInteractionController presentOpenInMenuFromRect:CGRectZero inView:self.view animated:YES];
}

- (UIDocumentInteractionController *) setupControllerWithURL: (NSURL*) fileURL
                                               usingDelegate: (id <UIDocumentInteractionControllerDelegate>) interactionDelegate {
    self.documentationInteractionController = [UIDocumentInteractionController interactionControllerWithURL: fileURL];
    self.documentationInteractionController.delegate = interactionDelegate;
    return self.documentationInteractionController;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
