using Powershell_Bank.Account;
using AccountTransaction = Powershell_Bank.Account.AccountTransaction;

namespace Powershell_Bank.TransactionTypes {
    public class Withdrawl : AccountTransaction,IAccountTransaction {
        new public int DollarAmount { get; set; }
        new public int DecimalAmount { get; set; }
        new public TransactionType transactionType = TransactionType.WithdrawlType;

        Withdrawl(int dollarAmount, int decimalAmount) : base(dollarAmount, decimalAmount) {}
        Withdrawl(int dollarAmount) : base(dollarAmount) {}
    }

    public class Deposit : AccountTransaction, IAccountTransaction {
        new public int DollarAmount { get; set; }
        new public int DecimalAmount { get; set; }
        new public TransactionType transactionType = TransactionType.DepositType;

        Deposit(int dollarAmount, int decimalAmount) : base(dollarAmount, decimalAmount) {}
        Deposit(int dollarAmount) : base(dollarAmount) {}
        
    }
}
