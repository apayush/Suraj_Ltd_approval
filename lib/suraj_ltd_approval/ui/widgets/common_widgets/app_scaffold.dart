import 'package:flutter/material.dart';
import 'package:shared_component/widgets/footer.dart';

class AppScaffold extends StatelessWidget {
  final Key? scaffoldKey;
  final PreferredSizeWidget? appBar;
  final Drawer? drawer;
  final Widget? bottomNavigationBar;
  final Widget body;
  final Widget? floatingActionButton;
  final Widget? endDrawerContent;
  final bool showFooter;

  const AppScaffold({
    super.key,
    this.scaffoldKey,
    this.appBar,
    this.drawer,
    this.bottomNavigationBar,
    this.floatingActionButton,
    required this.body,
    this.endDrawerContent,
    this.showFooter = false,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: scaffoldKey,
      appBar: appBar,
      drawer: drawer,
      endDrawer: endDrawerContent != null
          ? Drawer(
        child: endDrawerContent,
      )
          : null,
      bottomNavigationBar: showFooter
          ? const Footer() // Replace with your actual footer widget
          : bottomNavigationBar,
      floatingActionButton: floatingActionButton,
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      body: SafeArea(
        child: body,
      ),
    );
  }
}
