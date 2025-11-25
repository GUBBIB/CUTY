import 'package:flutter/material.dart';
import 'package:cuty_app/models/school.dart';
import 'package:cuty_app/models/college.dart';
import 'package:cuty_app/models/department.dart';
import 'package:cuty_app/services/auth_service.dart';
import 'package:cuty_app/services/school_service.dart';
import 'package:cuty_app/common/screen/infinite_scroll_selector_screen.dart';
import 'package:cuty_app/services/country_service.dart';
import 'package:cuty_app/models/country.dart';
import 'package:cuty_app/common/component/custom_text_field.dart';
import 'package:cuty_app/common/component/selection_text_field.dart';
import 'package:cuty_app/common/component/custom_app_bar.dart';
import 'package:cuty_app/config/app_colors.dart';
import 'package:cuty_app/common/component/custom_button.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _passwordConfirmController = TextEditingController();
  final _nameController = TextEditingController();
  final _authService = AuthService();
  final _schoolService = SchoolService();
  final _countryService = CountryService();
  bool _isLoading = false;

  Country? _selectedCountry;
  School? _selectedSchool;
  College? _selectedCollege;
  Department? _selectedDepartment;

  Future<void> _selectCountry() async {
    await Navigator.push<Country>(
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
                _selectedCollege = null;
                _selectedDepartment = null;
              }
            });
          },
          onSelectComplete: (country) {
            Navigator.pop(context);
          },
        ),
      ),
    );
  }

  Future<void> _selectSchool() async {
    await Navigator.push<School>(
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
                _selectedCollege = null;
                _selectedDepartment = null;
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

  Future<void> _selectCollege() async {
    if (_selectedSchool == null) return;

    await Navigator.push<College>(
      context,
      MaterialPageRoute(
        builder: (context) => InfiniteScrollSelectorPage<College>(
          title: '단과대학 선택',
          searchHint: '단과대학 검색',
          onLoad: (page, search) => _schoolService.getColleges(
            _selectedSchool!.id,
            page: page,
            search: search,
          ),
          itemDisplayName: (college) => college.name,
          itemsFromData: (data) => (data['colleges'] as List<College>),
          onSelect: (college) {
            setState(() {
              if (_selectedCollege?.id != college.id) {
                _selectedCollege = college;
                _selectedDepartment = null;
              }
            });
          },
          onSelectComplete: (college) {
            Navigator.pop(context);
          },
        ),
      ),
    );
  }

  Future<void> _selectDepartment() async {
    if (_selectedSchool == null ||
        _selectedCollege == null) return;

    await Navigator.push<Department>(
      context,
      MaterialPageRoute(
        builder: (context) => InfiniteScrollSelectorPage<Department>(
          title: '학과 선택',
          searchHint: '학과 검색',
          onLoad: (page, search) => _schoolService.getDepartments(
            _selectedSchool!.id,
            _selectedCollege!.id,
            page: page,
            search: search,
          ),
          itemDisplayName: (department) => department.name,
          itemsFromData: (data) => (data['departments'] as List<Department>),
          onSelect: (department) {
            setState(() {
              _selectedDepartment = department;
            });
          },
          onSelectComplete: (department) {
            Navigator.pop(context);
          },
        ),
      ),
    );
  }

  Future<void> _register() async {
    if (!_formKey.currentState!.validate()) return;
    if (_selectedCountry == null ||
        _selectedSchool == null ||
        _selectedCollege == null ||
        _selectedDepartment == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('국가, 학교, 단과대학, 학과를 모두 선택해주세요')),
      );
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      await _authService.register(
        email: _emailController.text,
        password: _passwordController.text,
        name: _nameController.text,
        countryId: _selectedCountry!.id,
        schoolId: _selectedSchool!.id,
        collegeId: _selectedCollege!.id,
        departmentId: _selectedDepartment!.id,
      );

      if (mounted) {
        Navigator.pushReplacementNamed(context, '/home');
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(e.toString().replaceAll('Exception: ', ''))),
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
      appBar: const CustomAppBar(title: '회원가입'),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      CustomTextField(
                        controller: _emailController,
                        hintText: '이메일',
                        keyboardType: TextInputType.emailAddress,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return '이메일을 입력해주세요';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 16),
                      CustomTextField(
                        controller: _passwordController,
                        hintText: '비밀번호',
                        obscureText: true,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return '비밀번호를 입력해주세요';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 16),
                      CustomTextField(
                        controller: _passwordConfirmController,
                        hintText: '비밀번호 확인',
                        obscureText: true,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return '비밀번호를 다시 입력해주세요';
                          }
                          if (value != _passwordController.text) {
                            return '비밀번호가 일치하지 않습니다';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 16),
                      CustomTextField(
                        controller: _nameController,
                        hintText: '이름',
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return '이름을 입력해주세요';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 16),
                      SelectionTextField(
                        value: _selectedCountry?.name ?? '',
                        hintText: '국가 선택',
                        onTap: _selectCountry,
                      ),
                      const SizedBox(height: 16),
                      SelectionTextField(
                        value: _selectedSchool?.name ?? '',
                        hintText: '학교 선택',
                        onTap: _selectSchool,
                        enabled: _selectedCountry != null,
                      ),
                      const SizedBox(height: 16),
                      SelectionTextField(
                        value: _selectedCollege?.name ?? '',
                        hintText: '단과대학 선택',
                        onTap: _selectCollege,
                        enabled: _selectedSchool != null,
                      ),
                      const SizedBox(height: 16),
                      SelectionTextField(
                        value: _selectedDepartment?.name ?? '',
                        hintText: '학과 선택',
                        onTap: _selectDepartment,
                        enabled: _selectedCollege != null,
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 16),
              CustomButton(
                text: '회원가입',
                onPressed: _register,
                isLoading: _isLoading,
              ),
              const SizedBox(height: 16),
              TextButton(
                onPressed: () {
                  Navigator.pushNamed(context, '/login');
                },
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      '이미 계정이 있으신가요?',
                      style: TextStyle(
                        color: AppColors.textPrimary,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Text(
                      '로그인',
                      style: TextStyle(
                        color: AppColors.primaryColor,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _passwordConfirmController.dispose();
    _nameController.dispose();
    super.dispose();
  }
}
