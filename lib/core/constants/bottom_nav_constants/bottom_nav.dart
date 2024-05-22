import 'package:flutter/material.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'bottom_nav.g.dart';

class BottomNav {
  final List<Icon> selectedIcons = [
    getIcon(Icons.home),
    getIcon(Icons.chat),
    getIcon(Icons.favorite),
    getIcon(Icons.person),
  ];
  final List<Icon> unSelectedIcons = [
    getIcon(Icons.home_outlined),
    getIcon(Icons.chat_outlined),
    getIcon(Icons.favorite_outline),
    getIcon(Icons.person_outline),
  ];
  final Icon floatingActionBtnIcon = const Icon(Icons.add);
  final List<Widget> pages = [
    Container(),
    Container(),
    Container(),
    Container()
  ];
}

Icon getIcon(IconData data) => Icon(
      data,
      size: 28,
      weight: .3,
    );

@riverpod
BottomNav bottomNav(BottomNavRef ref) {
  return BottomNav();
}
