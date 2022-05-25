import 'package:currency_exchange/cubits/currency/currency_cubit.dart';
import 'package:currency_exchange/repositories/currency_repository.dart';
import 'package:currency_exchange/services/currency_api_services.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'pages/homepage.dart';

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return RepositoryProvider(
      create: (_) =>
          CurrencyRepository(currencyApiServices: CurrencyApiServices()),
      child: BlocProvider(
        create: (context) => CurrencyCubit(
            currencyRepository: context.read<CurrencyRepository>()),
        child: MaterialApp(
          debugShowCheckedModeBanner: false,
          title: 'Flutter Demo',
          theme: ThemeData(
            primarySwatch: Colors.blue,
          ),
          home: const HomePage(),
        ),
      ),
    );
  }
}
