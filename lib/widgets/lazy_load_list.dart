import 'package:flutter/material.dart';

class LazyLoadListView extends StatefulWidget {
  final List<dynamic> items;
  final Widget Function(BuildContext, int) itemBuilder;
  final int initialLoadCount;
  final int loadMoreCount;
  final bool addAutomaticKeepAlives;

  const LazyLoadListView({
    super.key,
    required this.items,
    required this.itemBuilder,
    this.initialLoadCount = 15,
    this.loadMoreCount = 10,
    this.addAutomaticKeepAlives = true,
  });

  @override
  State<LazyLoadListView> createState() => _LazyLoadListViewState();
}

class _LazyLoadListViewState extends State<LazyLoadListView> {
  late int _displayedItemCount;
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _displayedItemCount = widget.initialLoadCount;
    _scrollController.addListener(_onScroll);
  }

  void _onScroll() {
    if (_scrollController.position.pixels == _scrollController.position.maxScrollExtent) {
      _loadMore();
    }
  }

  void _loadMore() {
    setState(() {
      _displayedItemCount = (_displayedItemCount + widget.loadMoreCount)
          .clamp(0, widget.items.length);
    });
  }

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      controller: _scrollController,
      itemCount: _displayedItemCount,
      itemBuilder: widget.itemBuilder,
    );
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }
} 