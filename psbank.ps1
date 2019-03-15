using namespace System.Collections.Generic;

enum TransactionType  {
    DepositType
    WithdrawlType
}


class AccountTransaction {
    [Parameter(Mandatory=$true)]
    [int]$dollarAmount = 0;
    [int]$decimalAmount = 0;
    [datetime]$date = [datetime]::now;   
    [TransactionType] $transactionType;

    AccountTransaction([int] $dollarAmount, [int]$decimalAmount){
        $this.dollarAmount = $dollarAmount;
        $this.decimalAmount = $decimalAmount;
    }

    AccountTransaction([int] $dollarAmount) {
        $this::new($dollarAmount, 0);
    }    

}

class Deposit : AccountTransaction {
    Deposit(){
        $this::new(0,0);
    }
    Deposit([int]$dollarAmount){
        $this::new($dollarAmount,0);
    }
    Deposit([int]$dollarAmount, [int]$decimalAmount) : base($dollarAmount, $decimalAmount){
        $this.transactionType = [TransactionType]::DepositType;
    }
}

class Withdrawl : AccountTransaction {
    Withdrawl(){
        $this::new(0,0);
    }
    Withdrawl([int]$dollarAmount){
        $this::new($dollarAmount,0);
    }
    Withdrawl([int]$dollarAmount, [int]$decimalAmount) : base($dollarAmount, $decimalAmount){
        $this.transactionType = [TransactionType]::WithdrawlType;
    }
}


class BankAccount {
    [int] hidden $totalDollarAmount = 0;
    [int] hidden $totalDecimalAmount = 0;
    [List[Deposit]] hidden $deposits = $(new-object -typename List[Deposit]);
    [Withdrawl[]] hidden $withdrawls = @();
    [string] hidden $total; 

    BankAccount([int]$dollarAmount, [int]$decimalAmount){
        $this.totalDollarAmount = $dollarAmount;
        $this.totalDecimalAmount = $decimalAmount;        
    }

    BankAccount([int]$dollarAmount){
        $this::new($dollarAmount, 0);
    }

    BankAccount(){
        $this::new(0, 0);
    }

    [void] MakeDeposit([int]$dollarAmount, [int]$decimalAmount){
        $deposit = [Deposit]::new($dollarAmount, $decimalAmount);
        $this.totalDollarAmount += $dollarAmount;
        $this.totalDecimalAmount += $decimalAmount;
        if($this.totalDecimalAmount -ge 100){
            [int]$remainder = $this.totalDecimalAmount - 100;
            $this.totalDollarAmount += 1;
            $this.totalDecimalAmount = $remainder;
        }
        $this.SetTotal();
        $this.deposits += $deposit;        
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
