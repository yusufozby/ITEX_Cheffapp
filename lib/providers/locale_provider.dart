import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:itm_cheffapp/l10n/l10n.dart';
import 'package:shared_preferences/shared_preferences.dart';




class LocaleProvider extends StateNotifier<Locale> {

  LocaleProvider() : super(L10n.all[0]);
  
  void setLocale(Locale loc)  async {
 SharedPreferences prefs = await SharedPreferences.getInstance();
  state = loc;
  prefs.setString('lan',loc == L10n.all[0] ? 'tr' : 'en');
   
  }
  

}


final localeProvider = StateNotifierProvider<LocaleProvider,Locale>((ref){
  return LocaleProvider();
});