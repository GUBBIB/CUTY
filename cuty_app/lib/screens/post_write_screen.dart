import 'package:cuty_app/config/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:cuty_app/models/category_item.dart';
import 'package:cuty_app/services/post_service.dart';
import 'package:cuty_app/models/post.dart';
import 'package:cuty_app/common/component/custom_app_bar.dart';
import 'package:cuty_app/common/component/custom_text_field.dart';
import 'package:cuty_app/common/component/custom_button.dart';
import 'package:cuty_app/common/layout/screen_layout.dart';

class PostWriteScreen extends StatefulWidget {
  const PostWriteScreen({super.key});

  @override
  State<PostWriteScreen> createState() => _PostWriteScreenState();
}

class _PostWriteScreenState extends State<PostWriteScreen> {
  final _titleController = TextEditingController();
  final _contentController = TextEditingController();
  final _postService = PostService();
  bool _isLoading = false;
  String _selectedCategory = 'free';
  Post? _post;

  final List<CategoryItem> _categories = [
    CategoryItem(label: '자유', value: 'free'),
    CategoryItem(label: '중고', value: 'market'),
    CategoryItem(label: '질문', value: 'question'),
  ];

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final args =
          ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>?;
      if (args != null) {
        if (args.containsKey('category')) {
          setState(() {
            _selectedCategory = args['category'] as String;
          });
        }
        if (args.containsKey('post')) {
          final post = args['post'] as Post;
          setState(() {
            _post = post;
            _titleController.text = post.title;
            _contentController.text = post.content;
            _selectedCategory = post.category;
          });
        }
      }
    });
  }

  Future<void> _submit() async {
    if (_titleController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('제목을 입력해주세요')),
      );
      return;
    }

    if (_contentController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('내용을 입력해주세요')),
      );
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      if (_post != null) {
        await _postService.updatePost(
          postId: _post!.id,
          title: _titleController.text,
          content: _contentController.text,
          category: _selectedCategory,
        );
      } else {
        await _postService.createPost(
          title: _titleController.text,
          content: _contentController.text,
          category: _selectedCategory,
        );
      }

      if (mounted) {
        Navigator.pop(context, true);
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(e.toString())),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        title: _post != null ? '글 수정' : '글 쓰기',
      ),
      body: ScreenLayout(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      DropdownButtonFormField<String>(
                        value: _selectedCategory,
                        decoration: InputDecoration(
                          filled: true,
                          fillColor: AppColors.backgroundGrayColor,
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                            borderSide: BorderSide.none,
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                            borderSide: BorderSide.none,
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                            borderSide: BorderSide.none,
                          ),
                        ),
                        items: _categories.map((category) {
                          return DropdownMenuItem(
                            value: category.value,
                            child: Text(category.label),
                          );
                        }).toList(),
                        onChanged: (value) {
                          if (value != null) {
                            setState(() {
                              _selectedCategory = value;
                            });
                          }
                        },
                      ),
                      const SizedBox(height: 16),
                      CustomTextField(
                        controller: _titleController,
                        hintText: '제목',
                        maxLength: 100,
                      ),
                      const SizedBox(height: 16),
                      CustomTextField(
                        controller: _contentController,
                        hintText: '내용',
                        maxLines: 10,
                        maxLength: 2000,
                      ),
                    ],
                  ),
                ),
              ),
              CustomButton(
                text: _post != null ? '수정' : '작성',
                onPressed: _submit,
                isLoading: _isLoading,
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _titleController.dispose();
    _contentController.dispose();
    super.dispose();
  }
}
