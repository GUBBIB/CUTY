import 'package:flutter/material.dart';

class OnboardingProvider extends ChangeNotifier {
  int _currentStep = 0;
  
  String? _nationality;
  String? _region;
  String? _school;

  // 1. Nationality Data (Alphabetical)
  final List<String> nationalities = [
    'Afghanistan', 'Albania', 'Algeria', 'Andorra', 'Angola', 'Antigua and Barbuda', 'Argentina', 'Armenia', 'Australia', 'Austria', 'Azerbaijan',
    'Bahamas', 'Bahrain', 'Bangladesh', 'Barbados', 'Belarus', 'Belgium', 'Belize', 'Benin', 'Bhutan', 'Bolivia', 'Bosnia and Herzegovina', 'Botswana', 'Brazil', 'Brunei', 'Bulgaria', 'Burkina Faso', 'Burundi',
    'Cabo Verde', 'Cambodia', 'Cameroon', 'Canada', 'Central African Republic', 'Chad', 'Chile', 'China', 'Colombia', 'Comoros', 'Congo (Congo-Brazzaville)', 'Costa Rica', 'Croatia', 'Cuba', 'Cyprus', 'Czechia (Czech Republic)',
    'Democratic Republic of the Congo', 'Denmark', 'Djibouti', 'Dominica', 'Dominican Republic',
    'Ecuador', 'Egypt', 'El Salvador', 'Equatorial Guinea', 'Eritrea', 'Estonia', 'Eswatini (fmr. "Swaziland")', 'Ethiopia',
    'Fiji', 'Finland', 'France',
    'Gabon', 'Gambia', 'Georgia', 'Germany', 'Ghana', 'Greece', 'Grenada', 'Guatemala', 'Guinea', 'Guinea-Bissau', 'Guyana',
    'Haiti', 'Holy See', 'Honduras', 'Hungary',
    'Iceland', 'India', 'Indonesia', 'Iran', 'Iraq', 'Ireland', 'Israel', 'Italy', 'Ivory Coast',
    'Jamaica', 'Japan', 'Jordan',
    'Kazakhstan', 'Kenya', 'Kiribati', 'Kuwait', 'Kyrgyzstan',
    'Laos', 'Latvia', 'Lebanon', 'Lesotho', 'Liberia', 'Libya', 'Liechtenstein', 'Lithuania', 'Luxembourg',
    'Madagascar', 'Malawi', 'Malaysia', 'Maldives', 'Mali', 'Malta', 'Marshall Islands', 'Mauritania', 'Mauritius', 'Mexico', 'Micronesia', 'Moldova', 'Monaco', 'Mongolia', 'Montenegro', 'Morocco', 'Mozambique', 'Myanmar (formerly Burma)',
    'Namibia', 'Nauru', 'Nepal', 'Netherlands', 'New Zealand', 'Nicaragua', 'Niger', 'Nigeria', 'North Korea', 'North Macedonia', 'Norway',
    'Oman',
    'Pakistan', 'Palau', 'Palestine State', 'Panama', 'Papua New Guinea', 'Paraguay', 'Peru', 'Philippines', 'Poland', 'Portugal',
    'Qatar',
    'Romania', 'Russia', 'Rwanda',
    'Saint Kitts and Nevis', 'Saint Lucia', 'Saint Vincent and the Grenadines', 'Samoa', 'San Marino', 'Sao Tome and Principe', 'Saudi Arabia', 'Senegal', 'Serbia', 'Seychelles', 'Sierra Leone', 'Singapore', 'Slovakia', 'Slovenia', 'Solomon Islands', 'Somalia', 'South Africa', 'South Korea', 'South Sudan', 'Spain', 'Sri Lanka', 'Sudan', 'Suriname', 'Sweden', 'Switzerland', 'Syria',
    'Tajikistan', 'Tanzania', 'Thailand', 'Timor-Leste', 'Togo', 'Tonga', 'Trinidad and Tobago', 'Tunisia', 'Turkey', 'Turkmenistan', 'Tuvalu',
    'Uganda', 'Ukraine', 'United Arab Emirates', 'United Kingdom', 'United States of America', 'Uruguay', 'Uzbekistan',
    'Vanuatu', 'Venezuela', 'ietnam', 'Yemen', 'Zambia', 'Zimbabwe', 'Other'
  ];

  // 2. Region Data
  final List<String> regions = [
    'Seoul', 'Busan', 'Daegu', 'Incheon', 'Gwangju', 'Daejeon', 'Ulsan', 'Sejong',
    'Gyeonggi-do', 'Gangwon-do', 'Chungcheongbuk-do', 'Chungcheongnam-do', 
    'Jeollabuk-do (Jeonbuk)', 'Jeollanam-do (Jeonnam)', 
    'Gyeongsangbuk-do (Gyeongbuk)', 'Gyeongsangnam-do (Gyeongnam)', 'Jeju-do'
  ];

  // 3. Regional University Mapping
  final Map<String, List<String>> regionalSchools = {
    'Seoul': [
      'Seoul National Univ', 'Yonsei Univ', 'Korea Univ', 'Sogang Univ', 'Sungkyunkwan Univ', 'Hanyang Univ', 
      'Chung-Ang Univ', 'Kyung Hee Univ', 'Hankuk Univ of Foreign Studies', 'City Univ of Seoul', 
      'Ewha Womans Univ', 'Konkuk Univ', 'Dongguk Univ', 'Hongik Univ', 'Sookmyung Women\'s Univ', 
      'Kookmin Univ', 'Soongsil Univ', 'Sejong Univ', 'Dankook Univ', 'Kwangwoon Univ', 
      'Myongji Univ', 'Sangmyung Univ', 'Duksung Women\'s Univ', 'Dongduk Women\'s Univ', 
      'Seoul Women\'s Univ', 'Sungshin Women\'s Univ', 'Seokyeong Univ', 'Sahmyook Univ', 
      'Hansung Univ', 'Chongshin Univ', 'KC Univ', 'Methodist Theological Univ', 'Other'
    ],
    'Busan': [
      'Pusan National Univ', 'Pukyong National Univ', 'Dong-A Univ', 'Kyungsung Univ', 
      'Dong-Eui Univ', 'Silla Univ', 'Tongmyong Univ', 'Dongseo Univ', 'Kosin Univ', 
      'Catholic Univ of Pusan', 'Busan Univ of Foreign Studies', 'Other'
    ],
    'Daegu': [
      'Kyungpook National Univ', 'Keimyung Univ', 'Daegu Univ', 'Yeungnam Univ (Gyeongsan)', 
      'Daegu Catholic Univ', 'Daegu Haany Univ', 'Other'
    ],
    'Incheon': [
      'Inha Univ', 'Incheon National Univ', 'Gachon Univ (Medical)', 'Ghent Univ Global Campus', 
      'George Mason Univ Korea', 'SUNY Korea', 'Utah Univ Asia Campus', 'Other'
    ],
    'Gwangju': [
      'Chonnam National Univ', 'Chosun Univ', 'Honam Univ', 'Gwangju Univ', 'Gwangju Women\'s Univ', 
      'Nambu Univ', 'Songwon Univ', 'Other'
    ],
    'Daejeon': [
      'KAIST', 'Chungnam National Univ', 'Hanbat National Univ', 'Hannam Univ', 'Mokwon Univ', 
      'Paichai Univ', 'Woosong Univ', 'Daejeon Univ', 'Eulji Univ (Daejeon)', 'Other'
    ],
    'Ulsan': [
      'UNIST', 'University of Ulsan', 'Other'
    ],
    'Sejong': [
      'Korea Univ (Sejong)', 'Hongik Univ (Sejong)', 'Global Cyber Univ', 'Other'
    ],
    'Gyeonggi-do': [
      'Ajou Univ', 'Gachon Univ', 'Kyonggi Univ', 'Dankook Univ (Jukjeon)', 
      'Hankuk Univ of Foreign Studies (Global)', 'Hanyang Univ (ERICA)', 'Sungkyunkwan Univ (Suwon)', 
      'Myongji Univ (Yongin)', 'Yong In Univ', 'Kangnam Univ', 'The Catholic Univ of Korea', 
      'Seoul Theological Univ', 'Sungkyul Univ', 'Anyang Univ', 'Eulji Univ (Seongnam)', 
      'CHA Univ', 'Hanseo Univ', 'Hanshin Univ', 'Hyupsung Univ', 'Pyeongtaek Univ', 
      'Hankyong National Univ', 'Korea Aerospace Univ', 'Other'
    ],
    'Gangwon-do': [
      'Kangwon National Univ', 'Yonsei Univ (Mirae)', 'Hallym Univ', 'Catholic Kwandong Univ', 
      'Gangneung-Wonju National Univ', 'Sangji Univ', 'Kyungdong Univ', 'Other'
    ],
    'Chungcheongbuk-do': [
      'Chungbuk National Univ', 'Cheongju Univ', 'Korea National Univ of Transportation', 
      'Seowon Univ', 'Semyung Univ', 'Far East Univ', 'U1 Univ', 'Jungwon Univ', 'Other'
    ],
    'Chungcheongnam-do': [
      'Kongju National Univ', 'Soonchunhyang Univ', 'Hoseo Univ', 'Sun Moon Univ', 
      'Korea Univ of Tech & Edu (Koreatech)', 'Baekseok Univ', 'Sangmyung Univ (Cheonan)', 
      'Namseoul Univ', 'Nazarene Univ', 'Konyang Univ', 'Joongbu Univ', 'Other'
    ],
    'Jeollabuk-do (Jeonbuk)': [
      'Jeonbuk National Univ', 'Jeonju Univ', 'Woosuk Univ', 'Wonkwang Univ', 
      'Kunsan National Univ', 'Howon Univ', 'Other'
    ],
    'Jeollanam-do (Jeonnam)': [
      'Mokpo National Univ', 'Suncheon National Univ', 'Mokpo National Maritime Univ', 
      'Dongshin Univ', 'Sehan Univ', 'Chodang Univ', 'Other'
    ],
    'Gyeongsangbuk-do (Gyeongbuk)': [
      'Yeungnam Univ', 'Daegu Univ', 'Handong Global Univ', 'Kumoh National Inst of Tech', 
      'POSTECH', 'Andong National Univ', 'Dongguk Univ (WISE)', 'Kyungil Univ', 
      'Daegu Catholic Univ (Hayang)', 'Gimcheon Univ', 'Kyung운 Univ', 'Other'
    ],
    'Gyeongsangnam-do (Gyeongnam)': [
      'Gyeongsang National Univ', 'Changwon National Univ', 'Inje Univ', 'Kyungnam Univ', 
      'Youngsan Univ', 'Kaya Univ', 'Changshin Univ', 'Other'
    ],
    'Jeju-do': [
      'Jeju National Univ', 'Jeju International Univ', 'Other'
    ]
  };

  int get currentStep => _currentStep;
  String? get nationality => _nationality;
  String? get region => _region;
  String? get school => _school;

  // Logic to return schools based on selected region
  List<String> get availableSchools {
    if (_region != null && regionalSchools.containsKey(_region)) {
      return regionalSchools[_region]!;
    }
    return ['Other']; // fallback if region not selected or not mapped
  }

  void nextStep() {
    if (_currentStep < 3) {
      _currentStep++;
      notifyListeners();
    }
  }

  void updateNationality(String? val) {
    _nationality = val;
    notifyListeners();
  }

  void updateRegion(String? val) {
    if (_region != val) {
      _region = val;
      _school = null; // Reset school when region changes
      notifyListeners();
    }
  }

  void updateSchool(String? val) {
    _school = val;
    notifyListeners();
  }

  void reset() {
    _currentStep = 0;
    _nationality = null;
    _region = null;
    _school = null;
    notifyListeners();
  }
}
