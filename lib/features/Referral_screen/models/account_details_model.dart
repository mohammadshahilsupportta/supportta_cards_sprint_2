class SettleAccountDetails {
  final String transactionId;
  final String? upiID;
  final String? upiUserName;
  final String? accountHolderName;
  final String? bankName;
  final String? ifsc;
  final int? accountNumber;
  final String? branch;

  SettleAccountDetails({
    required this.transactionId,
    this.upiID,
    this.upiUserName,
    this.accountHolderName,
    this.bankName,
    this.ifsc,
    this.accountNumber,
    this.branch,
  });

  Map<String, dynamic> toAccountDetailsJson() {
    return {
      'transactionId': transactionId,
      if (upiID != null) 'upiID': upiID,
      if (upiUserName != null) 'upiUserName': upiUserName,
      if (accountHolderName != null) 'accountHolderName': accountHolderName,
      if (bankName != null) 'bankName': bankName,
      if (ifsc != null) 'ifsc': ifsc,
      if (accountNumber != null) 'accountNumber': accountNumber,
      if (branch != null) 'branch': branch,
    };
  }

  Map<String, dynamic> toJson() {
    return {'accountDetails': toAccountDetailsJson()};
  }
}
