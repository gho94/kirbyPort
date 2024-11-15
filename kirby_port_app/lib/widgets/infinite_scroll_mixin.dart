import 'package:flutter/material.dart';

mixin InfiniteScrollMixin {
  final ScrollController _scrollController = ScrollController();
  ScrollController get scrollController => _scrollController;

  final double _scrollThreshold = 200.0;

  void _onScroll() {
    if (_scrollController.position.maxScrollExtent - _scrollController.position.pixels <= _scrollThreshold) {
      onScroll();
    }
  }

  void onScroll();

  void initScrollListener() {
    _scrollController.addListener(_onScroll);
  }

  void disposeScrollListener() {
    _scrollController.removeListener(_onScroll);
  }
}
