import 'dart:async';

import 'package:cuty_app/common/component/custom_app_bar.dart';
import 'package:flutter/material.dart';
import 'package:cuty_app/common/component/search_text_field.dart';
import 'package:cuty_app/common/layout/screen_layout.dart';
import 'package:cuty_app/common/component/card_container.dart';

class InfiniteScrollSelectorPage<T> extends StatefulWidget {
  final String title;
  final String searchHint;
  final Future<Map<String, dynamic>> Function(int page, String search) onLoad;
  final String Function(T item) itemDisplayName;
  final List<T> Function(Map<String, dynamic> data) itemsFromData;
  final void Function(T selected) onSelect;
  final void Function(T selected)? onSelectComplete;

  const InfiniteScrollSelectorPage({
    super.key,
    required this.title,
    required this.searchHint,
    required this.onLoad,
    required this.itemDisplayName,
    required this.itemsFromData,
    required this.onSelect,
    this.onSelectComplete,
  });

  @override
  State<InfiniteScrollSelectorPage<T>> createState() =>
      _InfiniteScrollSelectorPageState<T>();
}

class _InfiniteScrollSelectorPageState<T>
    extends State<InfiniteScrollSelectorPage<T>> {
  final _scrollController = ScrollController();
  final _searchController = TextEditingController();
  final List<T> _items = [];
  bool _isLoading = false;
  bool _hasMore = true;
  int _currentPage = 1;
  String _currentSearch = '';

  @override
  void initState() {
    super.initState();
    _loadMore();
    _scrollController.addListener(_onScroll);
  }

  Future<void> _loadMore() async {
    if (_isLoading || !_hasMore) return;

    setState(() {
      _isLoading = true;
    });

    try {
      final data = await widget.onLoad(_currentPage, _currentSearch);
      final newItems = widget.itemsFromData(data);
      final total = data['total'] as int;
      final totalPages = data['pages'] as int;

      setState(() {
        _items.addAll(newItems);
        _hasMore = _currentPage < totalPages;
        _currentPage++;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(e.toString())),
        );
      }
    }
  }

  void _onScroll() {
    if (_scrollController.position.pixels >=
        _scrollController.position.maxScrollExtent - 200) {
      _loadMore();
    }
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(
            Icons.search_off,
            size: 64,
            color: Colors.grey,
          ),
          const SizedBox(height: 16),
          Text(
            _currentSearch.isEmpty
                ? '데이터가 없습니다'
                : '"$_currentSearch" 검색 결과가 없습니다',
            style: const TextStyle(
              fontSize: 16,
              color: Colors.grey,
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(title: widget.title),
      body: ScreenLayout(
        child: Column(
          children: [
            SearchTextField(
              controller: _searchController,
              hintText: widget.searchHint,
              onSubmitted: (_) {
                if (_currentSearch != _searchController.text) {
                  setState(() {
                    _currentSearch = _searchController.text;
                    _items.clear();
                    _currentPage = 1;
                    _hasMore = true;
                  });
                  _loadMore();
                }
              },
            ),
            const SizedBox(height: 16),
            Expanded(
              child: !_isLoading && _items.isEmpty
                  ? _buildEmptyState()
                  : ListView.builder(
                      controller: _scrollController,
                      itemCount: _items.length + (_hasMore ? 1 : 0),
                      itemBuilder: (context, index) {
                        if (index == _items.length) {
                          return const Center(
                            child: Padding(
                              padding: EdgeInsets.all(8.0),
                              child: CircularProgressIndicator(),
                            ),
                          );
                        }

                        final item = _items[index];
                        return CardContainer(
                          onTap: () {
                            widget.onSelect(item);
                            if (widget.onSelectComplete != null) {
                              widget.onSelectComplete!(item);
                            }
                          },
                          child: Text(
                            widget.itemDisplayName(item),
                            style: const TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        );
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _scrollController.dispose();
    _searchController.dispose();
    super.dispose();
  }
}
