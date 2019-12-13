import 'package:flutter/material.dart';
import 'package:groto_shop/enums/connectivity_state.dart';
import 'package:groto_shop/models/retailer_model.dart';
import 'package:groto_shop/services/authentication_service.dart';
import 'package:groto_shop/services/connectivity_service.dart';
import 'package:groto_shop/shared/retailer.dart';
import 'package:groto_shop/shared/strings.dart';
import 'package:groto_shop/shared/widgets.dart';
import 'package:groto_shop/views/add_custom_item_view.dart';
import 'package:groto_shop/views/connectivity_view.dart';
import 'package:groto_shop/views/forgot_password_view.dart';
import 'package:groto_shop/views/items_view.dart';
import 'package:groto_shop/views/login_view.dart';
import 'package:groto_shop/views/orders_view.dart';
import 'package:groto_shop/views/past_orders_view.dart';
import 'package:groto_shop/views/profile_view.dart';
import 'package:groto_shop/views/signup_view.dart';
import 'package:groto_shop/views/store_view.dart';
import 'package:provider/provider.dart';

void main() async {
  Retailer retailer = await AuthService().isLoggedIn();
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(
            builder: (context) => (retailer == null)
                ? RetailerModel()
                : RetailerModel(retailer: retailer)),
        StreamProvider<ConnectivityState>(
          builder: (context) =>
              ConnectivityService().connectivityStreamController.stream,
        ),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        home: (retailer == null) ? LoginView() : Home(),
        routes: {
          homeView: (context) => Home(),
          signupView: (context) => SignUpView(),
          loginView: (context) => LoginView(),
          addCustomItemView: (context) => AddCustomItemView(),
          pastOrdersView: (context) => PastOrdersView(),
          forgotPasswordView: (context) => ForgotPasswordView()
        },
        theme: ThemeData(
            brightness: Brightness.light,
            primaryColor: Colors.white,
            accentColor: Colors.black,
            scaffoldBackgroundColor: Colors.white),
      ),
    ),
  );
}

class Home extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ConnectivityView(
      child: DefaultTabController(
        length: 4,
        child: Scaffold(
          appBar: AppBar(
            centerTitle: true,
            title: scaffoldTitle(),
            elevation: 1.0,
            bottom: TabBar(
              tabs: [
                Tab(
                  text: 'Store',
                ),
                Tab(
                  text: 'Items',
                ),
                Tab(
                  text: 'Orders',
                ),
                Tab(
                  text: 'Profile',
                ),
              ],
            ),
          ),
          body: TabBarView(
            children: [
              StoreView(),
              ItemsView(),
              OrdersView(),
              ProfileView(),
            ],
          ),
        ),
      ),
    );
  }
}
