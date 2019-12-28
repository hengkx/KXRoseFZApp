import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:rose_fz/store/models/user_model.dart';

class Store {
  static BuildContext context;
  static of(BuildContext context) {
    Store.context ??= context;
    return context;
  }

  static init({child, context}) {
    Store.context ??= context;
    return MultiProvider(
      child: child,
      providers: [
        ChangeNotifierProvider(create: (context) => UserModel()),
      ],
    );
  }

  static T value<T>([BuildContext context]) {
    context ??= Store.context;
    return Provider.of<T>(context);
  }
}
