class CreditCard {
  String holderName;
  String cardNumber;
  int expirationMonth;
  int expirationYear;
  String cvv;

  CreditCard(
    this.holderName,
    this.cardNumber,
    this.expirationMonth,
    this.expirationYear,
    this.cvv
  );

  CreditCard.fromJson(Map<String,dynamic> json) {
    this.holderName       = json['holder_name'];
    this.cardNumber       = json['card_number'];
    this.expirationMonth  = json['expiration_month'];
    this.expirationYear   = json['expiration_year'];
    this.cvv              = json['cvv'];
  }

  Map<String,dynamic> toJson() => {
    'holder_name'       : this.holderName,
    'card_number'       : this.cardNumber,
    'expiration_month'  : this.expirationMonth,
    'expiration_year'   : this.expirationYear,
    'cvv'               : this.cvv,
  };
}