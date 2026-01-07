import 'package:cuty_app/common/layout/screen_layout.dart';
import 'package:cuty_app/models/category_item.dart';
import 'package:cuty_app/services/country_service.dart';
import 'package:flutter/material.dart';
import 'package:cuty_app/models/post.dart';
import 'package:cuty_app/services/post_service.dart';
import 'package:cuty_app/services/user_service.dart';
import 'package:cuty_app/services/school_service.dart';
import 'package:cuty_app/models/country.dart';
import 'package:cuty_app/models/school.dart';
import 'package:cuty_app/common/screen/infinite_scroll_selector_screen.dart';
import 'package:cuty_app/models/user.dart';
import 'package:cuty_app/config/app_colors.dart';
import 'package:cuty_app/common/component/post_list_item.dart';
import 'package:cuty_app/common/component/search_text_field.dart';

class PostListScreen extends StatefulWidget {
  const PostListScreen({super.key});

  @override
  State<PostListScreen> createState() => _PostListScreenState();
}

class _PostListScreenState extends State<PostListScreen> {
  final _scrollController = ScrollController();
  final _searchController = TextEditingController();
  final _postService = PostService();
  final _schoolService = SchoolService();
  final _countryService = CountryService();
  final List<Post> _posts = [];
  bool _isLoading = false;
  bool _hasMore = true;
  int _currentPage = 1;
  String _currentSearch = '';
  String _currentCategory = 'free';

  Country? _selectedCountry;
  School? _selectedSchool;

  // 게시판 카테고리
  final List<CategoryItem> _categories = [
    CategoryItem(label: '자유', value: 'free'),
    CategoryItem(label: '중고', value: 'market'),
    CategoryItem(label: '질문', value: 'question'),
  ];

  final _userService = UserService();
  bool _isLoggedIn = false;
  School? _mySchool;
  User? _currentUser;

  @override
  void initState() {
    super.initState();
    _initializeData();
    _scrollController.addListener(_onScroll);
  }

  Future<void> _initializeData() async {
    await _checkLoginStatus();
    if (mounted) {
      _loadMore();
    }
  }

  // 로그인 확인 및 학교 게시판 연결
  Future<void> _checkLoginStatus() async {
    try {
      final user = await _userService.getCurrentUser();
      if (mounted) {
        setState(() {
          _isLoggedIn = true;
          _mySchool = user.school;
          _currentUser = user;
          // 로그인 상태이고 학교 정보가 있으면 자동으로 내 학교로 설정
          if (user.school != null && _selectedSchool == null) {
            _selectedCountry = user.country;
            _selectedSchool = user.school;
          }
        });
      }
    } catch (e) {
      print(e);
      if (mounted) {
        setState(() {
          _isLoggedIn = false;
          _mySchool = null;
          _currentUser = null;
        });
      }
    }
  }

  // 국가 검색
  Future<void> _selectCountry() async {
    final country = await Navigator.push<Country>(
      context,
      MaterialPageRoute(
        builder: (context) => InfiniteScrollSelectorPage<Country>(
          title: '국가 선택',
          searchHint: '국가 검색',
          onLoad: (page, search) => _countryService.getCountries(
            page: page,
            search: search,
          ),
          itemDisplayName: (country) => country.name,
          itemsFromData: (data) => (data['countries'] as List<Country>),
          onSelect: (country) {
            setState(() {
              if (_selectedCountry?.id != country.id) {
                _selectedCountry = country;
                _selectedSchool = null;
                _refresh();
              }
            });
          },
          onSelectComplete: (country) {
            Navigator.pop(context);
            _selectSchool();
          },
        ),
      ),
    );
  }

  // 학교  ( 국가 선택 후 나옴 )
  Future<void> _selectSchool() async {
    if (_selectedCountry == null) return;

    final school = await Navigator.push<School>(
      context,
      MaterialPageRoute(
        builder: (context) => InfiniteScrollSelectorPage<School>(
          title: '학교 선택',
          searchHint: '학교 검색',
          onLoad: (page, search) => _schoolService.getSchools(
            page: page,
            search: search,
          ),
          itemDisplayName: (school) => school.name,
          itemsFromData: (data) => (data['schools'] as List<School>),
          onSelect: (school) {
            setState(() {
              if (_selectedSchool?.id != school.id) {
                _selectedSchool = school;
                _refresh();
              }
            });
          },
          onSelectComplete: (school) {
            Navigator.pop(context);
          },
        ),
      ),
    );
  }

  // 스크롤 시, 로딩 더 시키기
  Future<void> _loadMore() async {
    if (_isLoading || !_hasMore) return;

    setState(() {
      _isLoading = true;
    });

    try {
      final data = await _postService.getPosts(
        page: _currentPage,
        search: _currentSearch,
        category: _currentCategory,
        schoolId: _selectedSchool?.id,
      );

      setState(() {
        _posts.addAll(data['posts'] as List<Post>);
        _hasMore = _currentPage < (data['pages'] as int);
        _currentPage++;
        _isLoading = false;
        _selectedSchool = data['currentFilters']['school'];
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

  void _search() {
    if (_currentSearch != _searchController.text) {
      setState(() {
        _currentSearch = _searchController.text;
        _posts.clear();
        _currentPage = 1;
        _hasMore = true;
      });
      _loadMore();
    }
  }

  void _refresh() {
    setState(() {
      _posts.clear();
      _currentPage = 1;
      _hasMore = true;
    });
    _loadMore();
  }

  //
  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(
            Icons.article_outlined,
            size: 64,
            color: Colors.grey,
          ),
          const SizedBox(height: 16),
          Text(
            _currentSearch.isEmpty
                ? '게시글이 없습니다'
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

  Widget _buildCategories() {
    return Container(
      alignment: Alignment.centerLeft,
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          children: _categories.map((category) {
            final isSelected = category.value == _currentCategory;
            return Padding(
              padding: const EdgeInsets.only(right: 8.0),
              child: GestureDetector(
                onTap: () {
                  setState(() {
                    _currentCategory = category.value;
                    _posts.clear();
                    _currentPage = 1;
                    _hasMore = true;
                  });
                  _loadMore();
                },
                child: Container(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 16.0, vertical: 8.0),
                  decoration: BoxDecoration(
                    color: isSelected
                        ? Theme.of(context).colorScheme.primary
                        : AppColors.backgroundGrayColor,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    category.label,
                    style: TextStyle(
                      color: isSelected ? Colors.white : AppColors.textHint,
                      fontSize: 16,
                    ),
                  ),
                ),
              ),
            );
          }).toList(),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Padding(
          padding: const EdgeInsets.only(left: 8.0),
          child: GestureDetector(
            onTap: _selectCountry,
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  _selectedSchool?.name ?? '학교 선택',
                  style: const TextStyle(fontSize: 16),
                ),
                const Icon(Icons.arrow_drop_down, size: 20),
              ],
            ),
          ),
        ),
        centerTitle: false,
        actions: [
          if (_isLoggedIn &&
              _mySchool != null &&
              _selectedSchool?.id != _mySchool?.id)
            IconButton(
              icon: const Icon(Icons.school),
              tooltip: '내 학교로 가기',
              onPressed: () async {
                try {
                  final user = await _userService.getCurrentUser();
                  if (user.school == null) {
                    if (mounted) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('등록된 학교 정보가 없습니다')),
                      );
                    }
                    return;
                  }

                  setState(() {
                    _selectedCountry = user.country;
                    _selectedSchool = user.school;
                    _refresh();
                  });
                } catch (e) {
                  if (mounted) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('내 학교 정보를 불러오는데 실패했습니다')),
                    );
                  }
                }
              },
            ),
        ],
      ),
      body: ScreenLayout(
        child: Column(
          children: [
            Column(
              children: [
                SearchTextField(
                  controller: _searchController,
                  hintText: '게시글 검색',
                  onSubmitted: (_) => _search(),
                ),
                const SizedBox(height: 8),
                _buildCategories(),
              ],
            ),
            Expanded(
              child: !_isLoading && _posts.isEmpty
                  ? _buildEmptyState()
                  : ListView.builder(
                      controller: _scrollController,
                      itemCount: _posts.length + (_hasMore ? 1 : 0),
                      itemBuilder: (context, index) {
                        if (index == _posts.length) {
                          return const Center(
                            child: Padding(
                              padding: EdgeInsets.all(8.0),
                              child: CircularProgressIndicator(),
                            ),
                          );
                        }

                        final post = _posts[index];
                        return PostListItem(
                          post: post,
                          onTap: () {
                            Navigator.pushNamed(
                              context,
                              '/post',
                              arguments: {'postId': post.id},
                            );
                          },
                        );
                      },
                    ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          if (!_isLoggedIn || _currentUser == null) {
            if (mounted) {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('글을 작성하려면 로그인이 필요합니다'),
                ),
              );
              Navigator.pushNamed(context, '/login');
            }
            return;
          }

          if (_selectedSchool == null) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('학교를 선택해주세요')),
            );
            return;
          }

          if (_currentUser!.school!.id != _selectedSchool?.id) {
            if (mounted) {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('자신의 학교에서만 글을 작성할 수 있습니다'),
                ),
              );
            }
            return;
          }

          if (mounted) {
            final result = await Navigator.pushNamed(
              context,
              '/write',
              arguments: {'category': _currentCategory},
            );

            if (result == true) {
              _refresh();
            }
          }
        },
        backgroundColor: Theme.of(context).colorScheme.primary,
        shape: const CircleBorder(),
        child: const Icon(Icons.add, color: Colors.white),
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
