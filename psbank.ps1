using namespace System.Collections.Generic;
using namespace Powershell_Bank.AccountTransaction;

class FileSaver {
    static [string] $filepath = "tmpdata.json";
    
    static [void] SaveTransactions([IAccountTransaction[]]$transactions){
        $transactions | ConvertTo-JSON | Add-Content -Path "$([FileSaver]::filepath)";   
    }     
    static [List[IAccountTransaction]] LoadTransactions(){
        $transactions = Get-Content -Path "$([FileSaver]::filepath)" -Raw | ConvertFrom-JSON;
        [List[AccountTransaction]]$transactionList = [List[AccountTransaction]]::new();
        $transactions | %{
                $transactionList += [AccountTransaction]::new($_.dollarAmount, $_.decimalAmount, $_.transactionType)#;
       }
        return $transactionList;
    }
    static [bool] CheckForFile(){
        return Test-Path "$([FileSaver]::filepath)";
    }
}


class AccountTransaction {
    [Parameter(Mandatory=$true)]
    [int]$dollarAmount = 0;
    [int]$decimalAmount = 0;
    [datetime]$date = [datetime]::now;   
    [TransactionType] $transactionType;


    AccountTransaction([int] $dollarAmount, [int]$decimalAmount, [TransactionType]$type){
        $this.dollarAmount = $dollarAmount;
        $this.decimalAmount = $decimalAmount;
        $this.transactionType = $type;
    }

    AccountTransaction([int] $dollarAmount, [TransactionType]$type) {
        $this::new($dollarAmount, 0, $type);
    }    
    AccountTransaction([TransactionType]$type){
        $this::new(0,0,$type);
    }
    [Deposit] static MakeDeposit([AccountTransaction] $transaction){
        return new-object -typename Deposit -ArgumentList $transaction.dollarAmount, $transaction.decimalAmount
    }
    [Deposit] MakeDeposit(){
        return $this.MakeDeposit($this);
    }
}

class Deposit : AccountTransaction {
    Deposit([int]$dollarAmount, [int]$decimalAmount) : 
        base($dollarAmount, $decimalAmount, [TransactionType]::DepositType){}
    Deposit([int]$dollarAmount){
        $this::new($dollarAmount,0);
    }
    Deposit(){
        $this::new(0,0);
    }
}

class Withdrawl : AccountTransaction {
    Withdrawl([int]$dollarAmount, [int]$decimalAmount) : 
        base($dollarAmount, $decimalAmount, [TransactionType]::WithdrawlType){}
    Withdrawl([int]$dollarAmount){
        $this::new($dollarAmount,0);
    }
    Withdrawl(){
        $this::new(0,0);
    }
}


class BankAccount {
    [int] hidden $totalDollarAmount = 0;
    [int] hidden $totalDecimalAmount = 0;
    [List[Deposit]] hidden $deposits = $(new-object -typename List[Deposit]);
    [Withdrawl[]] hidden $withdrawls = @();
    [string] hidden $total; 

    [FileSaver] static $Saver = $(new-object -typename FileSaver);

    BankAccount([int]$dollarAmount, [int]$decimalAmount){
        $this.totalDollarAmount = $dollarAmount;
        $this.totalDecimalAmount = $decimalAmount;        
        if($this::Saver::CheckForFile()){
            $this::Saver::LoadTransactions()|%{
            if($_.transactionType -is [TransactionType]::DepositType){
                    $_;
                    $this.MakeDeposit($_);
        #        }else{
        #             #$this.MakeWithdrawl($transaction);
                 }
            }
        }
    }

    BankAccount([int]$dollarAmount){
        $this::new($dollarAmount, 0);
    }

    BankAccount(){
        $this::new(0, 0);
    }

    [void] MakeDeposit([AccountTransaction] $deposit){
        $this.MakeDeposit($deposit.dollarAmount, $deposit.decimalAmount);
    }
    [void] MakeDeposit([Deposit] $deposit){
        $this.totalDollarAmount += $deposit.dollarAmount;
        $this.totalDecimalAmount += $deposit.decimalAmount;
        if($this.totalDecimalAmount -ge 100){
            [int]$remainder = $this.totalDecimalAmount - 100;
            $this.totalDollarAmount += 1;
            $this.totalDecimalAmount = $remainder;
        }
        $this.SetTotal();
        $this.deposits += $deposit;        
    }

    [void] MakeDeposit([int]$dollarAmount, [int]$decimalAmount){
        $deposit = [Deposit]::new($dollarAmount, $decimalAmount);
        $this.MakeDeposit($deposit);
    }
    
    [void] MakeDeposit([int]$dollarAmount){
        $this.MakeDeposit($dollarAmount, 0);
    }

    [List[Deposit]] GetDeposits(){
        return $this.deposits;
    }

    
    [string] GetTotal(){
        if($this.total -eq $null){
            $this.SetTotal();
        }
        return $this.total;
    }
    [void] hidden SetTotal(){
        $dollarAmount = $this.totalDollarAmount;
        [string]$decimalAmount = $this.totalDecimalAmount;
        [Console]::WriteLine($decimalAmount);
        
        if($decimalAmount.Length -ne 2){
            $decimalAmount = "0${decimalAmount}";
        }
        [Console]::WriteLine($decimalAmount);
        $this.total = "`$${dollarAmount}.${decimalAmount}";
    }
}
