class GetCountryCode {
  static const Map<String, String> dialCodeToIso = {
    '+91': 'IN',
    '+1': 'US',
    '+44': 'GB',
    '+971': 'AE',
    '+32': 'BE',
    '+61': 'AU',
    '+81': 'JP',
    '+49': 'DE',
    '+33': 'FR',
    '+966': 'SA',
    '+974': 'QA',
    '+965': 'KW',
    '+968': 'OM',
    '+880': 'BD',
    '+94': 'LK',
    '+254': 'KE',
    '+27': 'ZA',
    '+43': 'AT',
    '+93': 'AF',
    '+55': 'BR',
    '+54': 'AR',
    '+20': 'EG',
    '+7': 'RU',
    '+34': 'ES',
    '+39': 'IT',
    '+62': 'ID',
    '+63': 'PH',
    '+52': 'MX',
    '+82': 'KR',
    '+90': 'TR',
    '+1-868': 'TT',
    '+1-787': 'PR',
    '+1-876': 'JM',
    '+1-441': 'BM',
    '+1-664': 'MS',
    '+1-345': 'KY',
    '+1-242': 'BS',
    '+1-246': 'BB',
    '+1-671': 'GU',
    '+1-340': 'VI',
    '+86': 'CN',
    '+1-473': 'GD',
  };

  static const Set<String> canadaAreaCodes = {
    '204',
    '226',
    '236',
    '249',
    '250',
    '289',
    '306',
    '343',
    '365',
    '387',
    '403',
    '416',
    '418',
    '431',
    '437',
    '438',
    '450',
    '506',
    '514',
    '519',
    '548',
    '579',
    '581',
    '587',
    '604',
    '613',
    '639',
    '647',
    '672',
    '705',
    '709',
    '742',
    '778',
    '782',
    '807',
    '819',
    '825',
    '867',
    '873',
    '902',
    '905',
  };

  String getIsoCodeFromDialCode(String dialCode) {
    return dialCodeToIso[dialCode] ?? 'IN';
  }

  String getIsoCodeFromFullNumber(String fullNumber) {
    if (fullNumber.startsWith('+1') && fullNumber.length >= 5) {
      final areaCode = fullNumber.substring(2, 5);
      if (canadaAreaCodes.contains(areaCode)) return 'CA';
      return 'US';
    }

    final sortedDialCodes =
        dialCodeToIso.keys.toList()
          ..sort((a, b) => b.length.compareTo(a.length));

    for (final code in sortedDialCodes) {
      if (fullNumber.startsWith(code)) {
        return dialCodeToIso[code]!;
      }
    }

    return 'IN';
  }
}
