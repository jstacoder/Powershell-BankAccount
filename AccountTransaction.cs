using System;
using System.Collections.Generic;

namespace Powershell_Bank.Account {

    public enum TransactionType  {
        DepositType,
        WithdrawlType
    }

    public interface IAccountTransaction {
        int DollarAmount { get; set; }
        int DecimalAmount { get; set; }
        DateTime Date { get; }
        TransactionType transactionType { get; }
    }

    public class AccountTransaction: IAccountTransaction {
        
         public int DollarAmount {get; set; } = 0;
         public int DecimalAmount { get; set; } = 0;
         public DateTime Date { get; } = DateTime.Now;  
         public TransactionType transactionType { get; }


        public AccountTransaction(int dollarAmount, int decimalAmount){
            DollarAmount = dollarAmount;
            DecimalAmount = decimalAmount;                        
        }

        public AccountTransaction(int dollarAmount) : this(dollarAmount, 0) { }    
        public AccountTransaction() : this(0,0) {}

    }
}

/*
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
}*/
