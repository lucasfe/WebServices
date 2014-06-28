//
//  ViewController.m
//  WebServices
//
//  Created by ios4357 on 27/06/14.
//  Copyright (c) 2014 lgrmobile. All rights reserved.
//

#import "ViewController.h"
#import <AFNetworking/AFNetworking.h>

#define URL @"http://api.kivaws.org/v1/loans/search.json?status=fundraising"

@interface ViewController ()

@end

@implementation ViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.navigationItem.title = @"loans";
    [self carregaEmprestimos];
    
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


-(NSInteger) numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
 
    return [self.emprestimos count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString * pool = @"pool";
    UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:pool];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:pool];
    }
    NSDictionary * emprestimo = self.emprestimos[indexPath.row];
    [self configuraCelula:cell comEmprestimo:emprestimo];
    return cell;
}

-(void) configuraCelula:(UITableViewCell *)cell comEmprestimo:(NSDictionary*)emprestimo {
    
    NSString * nome = emprestimo[@"name"];
    NSDictionary * loc = emprestimo[@"location"];
    NSString * pais = loc[@"country"];
    NSNumber * qtd = emprestimo[@"loan_amount"];
    NSString * motivo = emprestimo[@"use"];
    
    cell.textLabel.text = [NSString stringWithFormat:@"%@ from %@", nome, pais];
    cell.detailTextLabel.text = [NSString stringWithFormat:@"Needs %@ USD %@", qtd, motivo];
    
}

-(void)carregaEmprestimos {
    NSMutableURLRequest * req = [[AFJSONRequestSerializer serializer] requestWithMethod:@"GET" URLString:URL parameters:nil error:nil];
    [req setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    
    AFHTTPRequestOperation * op = [[AFHTTPRequestOperation alloc] initWithRequest:req];
    op.responseSerializer = [AFJSONResponseSerializer serializer];
    [op.responseSerializer setAcceptableContentTypes:[NSSet setWithObject:@"application/json"]];
    [op setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSDictionary * response = (NSDictionary*) responseObject;
        self.emprestimos = response[@"loans"];
        [self.tableView reloadData];
        NSLog(@"Emprestimos: %@", self.emprestimos);
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Erro ao obter emprestimos: %@", error);
        
    }];
    [op start];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
