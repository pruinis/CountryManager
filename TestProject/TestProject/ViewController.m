//
//  ViewController.m
//  Test
//
//  Created by Anton Morozov on 25.11.15.
//  Copyright (c) 2015 Anton Morozov. All rights reserved.
//

#import "ViewController.h"
#import "CountryManager.h"


@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    
    [CountryManager sharedManager];
    
    NSArray *phoneCodes = [[CountryManager sharedManager] getCountriesPhoneCodes];
    NSLog(@"%@", phoneCodes);
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
