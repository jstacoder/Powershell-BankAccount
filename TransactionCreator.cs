using Powershell_Bank.Account;

namespace Powershell_Bank.TransactionCreation {

    class TransactionCreator<T> where T : IAccountTransaction, new() {

        public static T CreateTransaction(int dollarAmount, int decimalAmount){
            T transaction = new T();
            transaction.DollarAmount = dollarAmount;
            transaction.DecimalAmount = decimalAmount;
            return transaction;
        }
        
    }
}
