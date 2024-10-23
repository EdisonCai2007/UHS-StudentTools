import 'dart:io';

const _androidAppStoreLink = '';
const _appleAppStoreLink = '';

String? get storeUrl {
  if (Platform.isAndroid) {
    return _androidAppStoreLink;
  } else if (Platform.isIOS) {
    return _appleAppStoreLink;
  }

  return null;
}