//
//  ViewController.m
//  myBART
//
//  Created by Taiyaba Sultana on 1/23/17.
//  Copyright © 2017 Abdul Kareem. All rights reserved.
//

#import "ViewController.h"

@interface ViewController () {
    id realData;
}

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    [self makeBARTAPIcall];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)makeBARTAPIcall {
    NSString * departureEstAPI = @"http://api.bart.gov/api/etd.aspx?cmd=etd&orig=FRMT&key=MW9S-E7SL-26DU-VV8V&dir=n&json=y";
    NSURL * departureEstAPIURL = [NSURL URLWithString:departureEstAPI];
    NSLog(@"URl is: %@ \n\n", departureEstAPIURL);
    NSURLSession * mySession = [NSURLSession sharedSession];
    NSLog(@"Session created \n\n");
    [[mySession dataTaskWithURL:departureEstAPIURL completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        if (error) {
            NSLog(@"Unable to establish connection with the server due to one or more reasons");
            return;
        }
        NSHTTPURLResponse * httpResponseCode = (NSHTTPURLResponse *) response;
        NSLog(@"%ld", (long)httpResponseCode.statusCode);
        if (httpResponseCode.statusCode < 200 && httpResponseCode.statusCode >= 300) {
            NSLog(@"Connection error \n");
            NSLog(@"HTTP error status code %ld", (long)httpResponseCode.statusCode);
            return;
        }
        NSError * parseError;
        
        /*
        NSXMLParser * xmlResponse = [[NSXMLParser init]alloc];
        [xmlResponse initWithData:data];
        //NSLog(@"%@", xmlResponse);
        NSXMLParser *xmlParser;
        NSMutableArray *arrNeighboursData;
        NSMutableDictionary *dictTempDataStorage;
        NSMutableString *foundValue;
        NSString *currentElement;
         */
        
        realData = [NSJSONSerialization JSONObjectWithData:data options:0 error:&parseError];
        if (!realData) {
            NSLog(@"Parse error %@", parseError);
        }
        NSLog(@"%@", realData[@"root"][@"station"][0][@"etd"][0][@"estimate"][0][@"minutes"]);
        
        ///////////
        dispatch_async(dispatch_get_main_queue(), ^{
            
            self.minutesLabel.text = [NSString stringWithFormat:@"%@",realData[@"root"][@"station"][0][@"etd"][0][@"estimate"][0][@"minutes"]];
            
        });
        
    }]resume];
    
}

@end
