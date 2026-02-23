import React, { useState } from 'react';

export default function BaseProfileForm({ onSubmit }) {
    const [formData, setFormData] = useState({
        name: '',
        age: 23,
        nationality: '',
        region: '서울',
        university: '',
        major: '',
        grade: '3학년',
        topik: '0',
        kiip: '0',
        secondaryLanguages: [{ lang: '', level: 'none' }, { lang: '', level: 'none' }]
    });

    const handleChange = (e) => {
        const { name, value } = e.target;
        if (name === 'region') {
            // Reset university when region changes
            setFormData(prev => ({ ...prev, [name]: value, university: '' }));
        } else {
            setFormData(prev => ({ ...prev, [name]: value }));
        }
    };

    const handleSecondaryLanguageChange = (index, field, value) => {
        const newLangs = [...formData.secondaryLanguages];
        newLangs[index] = { ...newLangs[index], [field]: value };
        setFormData(prev => ({ ...prev, secondaryLanguages: newLangs }));
    };

    const addSecondaryLanguage = () => {
        setFormData(prev => ({ ...prev, secondaryLanguages: [...prev.secondaryLanguages, { lang: '', level: 'none' }] }));
    };

    const removeSecondaryLanguage = (index) => {
        if (formData.secondaryLanguages.length <= 1) return;
        const newLangs = formData.secondaryLanguages.filter((_, i) => i !== index);
        setFormData(prev => ({ ...prev, secondaryLanguages: newLangs }));
    };

    const universitiesByRegion = {
        '서울': {
            '4년제 대학교': ['서울대학교', '연세대학교', '고려대학교', '서강대학교', '성균관대학교', '한양대학교', '중앙대학교', '경희대학교', '한국외국어대학교', '서울시립대학교', '이화여자대학교', '건국대학교', '동국대학교', '홍익대학교', '국민대학교', '숭실대학교', '세종대학교', '단국대학교', '명지대학교', '상명대학교', '가톨릭대학교', '덕성여자대학교', '동덕여자대학교', '서울과학기술대학교', '서울여자대학교', '성신여자대학교', '한성대학교', '서경대학교', '삼육대학교', '성공회대학교', '추계예술대학교', '광운대학교', '서울교육대학교', '한국예술종합학교', '한국체육대학교', '감리교신학대학교', '장로회신학대학교', '총신대학교', '강서대학교(KC대)', '한국성서대학교', '서울한영대학교', '서울기독대학교', '디지털서울문화예술대학교', '사이버한국외국어대학교', '서울디지털대학교', '서울사이버대학교', '기타 4년제 대학교'],
            '2~3년제 전문대학': ['명지전문대학', '동양미래대학교', '인덕대학교', '서일대학교', '배화여자대학교', '숭의여자대학교', '한양여자대학교', '서울여자간호대학교', '삼육보건대학교', '백석예술대학교', '정화예술대학교', '국제예술대학교', '기타 2~3년제 전문대학']
        },
        '경기/인천': {
            '4년제 대학교': ['인하대학교', '인천대학교', '가천대학교', '경기대학교', '아주대학교', '단국대학교(죽전)', '성균관대학교(자연과학캠퍼스)', '한양대학교(ERICA)', '경희대학교(국제)', '한국항공대학교', '한국외국어대학교(글로벌)', '동국대학교(바이오메디)', '강남대학교', '수원대학교', '용인대학교', '한신대학교', '협성대학교', '안양대학교', '성결대학교', '평택대학교', '한경국립대학교', '신한대학교', '을지대학교', '차의과학대학교', '루터대학교', '대진대학교', '인천가톨릭대학교', '중부대학교(고양)', '청운대학교(인천)', '한세대학교', '화성의과학대학교(신경대)', '아세아연합신학대학교', '예원예술대학교(양주)', '중앙승가대학교', '서울신학대학교', '서울장신대학교', '경인교육대학교', '기타 4년제 대학교'],
            '2~3년제 전문대학': ['인하공업전문대학', '부천대학교', '동남보건대학교', '경기과학기술대학교', '오산대학교', '수원과학대학교', '경인여자대학교', '재능대학교', '연성대학교', '대림대학교', '신구대학교', '동서울대학교', '유한대학교', '장안대학교', '안산대학교', '여주대학교', '청강문화산업대학교', '한국관광대학교', '한국복지대학교', '경민대학교', '서정대학교', '두원공과대학교', '농협대학교', '용인예술과학대학교', '계원예술대학교', '서울예술대학교', '동아방송예술대학교', '김포대학교', '수원여자대학교', '용인송담대학교', '웅지세무대학교', '인천재능대학교', '기타 2~3년제 전문대학']
        },
        '부산/경남': {
            '4년제 대학교': ['부산대학교', '부경대학교', '한국해양대학교', '동아대학교', '동의대학교', '경성대학교', '신라대학교', '인제대학교', '영산대학교', '동서대학교', '부산가톨릭대학교', '부산외국어대학교', '고신대학교', '경상국립대학교', '창원대학교', '경남대학교', '울산대학교', '울산과학기술원(UNIST)', '창신대학교', '가야대학교', '한국국제대학교', '부산교육대학교', '진주교육대학교', '기타 4년제 대학교'],
            '2~3년제 전문대학': ['부산과학기술대학교', '경남정보대학교', '동의과학대학교', '대동대학교', '마산대학교', '연암공과대학교', '동주대학교', '부산여자대학교', '거제대학교', '김해대학교', '진주보건대학교', '창원문성대학교', '춘해보건대학교', '동원과학기술대학교', '한국승강기대학교', '울산과학대학교', '기타 2~3년제 전문대학']
        },
        '대구/경북': {
            '4년제 대학교': ['경북대학교', '영남대학교', '계명대학교', '대구대학교', '대구가톨릭대학교', '국립안동대학교', '금오공과대학교', '경운대학교', '경일대학교', '동국대학교(WISE)', '김천대학교', '대구한의대학교', '위덕대학교', '포항공과대학교(POSTECH)', '한동대학교', '대구경북과학기술원(DGIST)', '영남신학대학교', '대신대학교', '대구교육대학교', '기타 4년제 대학교'],
            '2~3년제 전문대학': ['영진전문대학교', '대구보건대학교', '대구과학대학교', '계명문화대학교', '경북전문대학교', '구미대학교', '수성대학교', '안동과학대학교', '호산대학교', '선린대학교', '포항대학교', '대경대학교', '문경대학교', '가톨릭상지대학교', '대구공업대학교', '영남이공대학교', '기타 2~3년제 전문대학']
        },
        '광주/전라': {
            '4년제 대학교': ['전남대학교', '조선대학교', '광주대학교', '호남대학교', '전북대학교', '우석대학교', '원광대학교', '전주대학교', '국립목포대학교', '국립순천대학교', '국립군산대학교', '광주과학기술원(GIST)', '동신대학교', '남부대학교', '초당대학교', '광주가톨릭대학교', '국립목포해양대학교', '한국에너지공과대학교(KENTECH)', '광주여자대학교', '전주교육대학교', '광주교육대학교', '호원대학교', '예수대학교', '한일장신대학교', '광주신학대학교', '기타 4년제 대학교'],
            '2~3년제 전문대학': ['광주보건대학교', '조선이공대학교', '기독간호대학교', '원광보건대학교', '전주비전대학교', '동강대학교', '서영대학교', '순천제일대학교', '동아보건대학교', '전남과학대학교', '광양보건대학교', '전북과학대학교', '군장대학교', '백제예술대학교', '기타 2~3년제 전문대학']
        },
        '대전/충청': {
            '4년제 대학교': ['충남대학교', '국립한밭대학교', '한남대학교', '목원대학교', '배재대학교', '우송대학교', '충북대학교', '청주대학교', '한국기술교육대학교(KOREATECH)', '순천향대학교', '백석대학교', '선문대학교', '호서대학교', '남서울대학교', '건양대학교', '대전대학교', '국립공주대학교', '세명대학교', '유원대학교', '한국교통대학교', '카이스트(KAIST)', '건국대학교(글로컬)', '고려대학교(세종)', '홍익대학교(세종)', '극동대학교', '서원대학교', '단국대학교(천안)', '상명대학교(천안)', '나사렛대학교', '꽃동네대학교', '금강대학교', '중원대학교', '청주교육대학교', '공주교육대학교', '침례신학대학교', '기타 4년제 대학교'],
            '2~3년제 전문대학': ['대전보건대학교', '우송정보대학', '대덕대학교', '충청대학교', '백석문화대학교', '신성대학교', '연암대학교', '대전과학기술대학교', '아주자동차대학교', '한국영상대학교', '혜전대학교', '충북도립대학교', '충남도립대학교', '대원대학교', '기타 2~3년제 전문대학']
        },
        '강원/제주': {
            '4년제 대학교': ['강원대학교', '한림대학교', '연세대학교(미래캠퍼스)', '상지대학교', '국립강릉원주대학교', '제주대학교', '제주국제대학교', '가톨릭관동대학교', '경동대학교', '한라대학교', '춘천교육대학교', '기타 4년제 대학교'],
            '2~3년제 전문대학': ['한림성심대학교', '강원도립대학교', '제주한라대학교', '제주관광대학교', '한국골프대학교', '송호대학교', '세경대학교', '송곡대학교', '기타 2~3년제 전문대학']
        }
    };

    const handleSubmit = (e) => {
        e.preventDefault();
        // Validation
        if (!formData.name || !formData.nationality || !formData.university || !formData.major) {
            alert('필수 정보를 모두 입력해주세요.');
            return;
        }
        onSubmit(formData);
    };

    const inputClasses = "w-full bg-slate-800/80 border border-slate-600 rounded-xl px-4 py-3 text-white focus:outline-none focus:border-cyan-400 focus:ring-1 focus:ring-cyan-400 transition-colors";
    const labelClasses = "block text-sm font-semibold text-slate-300 mb-2";

    return (
        <div className="min-h-screen bg-kvti-bg text-white flex flex-col justify-center items-center p-6 relative overflow-hidden">
            {/* Background */}
            <div className="absolute top-1/4 -left-32 w-96 h-96 bg-cyan-500/10 rounded-full blur-[100px]"></div>
            <div className="absolute bottom-1/4 -right-32 w-96 h-96 bg-blue-500/10 rounded-full blur-[100px]"></div>

            <div className="max-w-2xl w-full z-10">
                <div className="text-center mb-10">
                    <span className="inline-block px-4 py-1 rounded-full bg-white/10 text-cyan-300 text-xs font-bold tracking-widest uppercase mb-4 border border-white/10">Phase 0</span>
                    <h1 className="text-3xl md:text-4xl font-black mb-4">프로필 기본 정보 입력</h1>
                    <p className="text-slate-400">
                        더욱 정밀한 비자 가시권 및 커리어 분석을 위해<br />기본적인 학적 및 신원 정보를 입력해 주세요.
                    </p>
                </div>

                <form onSubmit={handleSubmit} className="bg-[#1a1c29]/80 backdrop-blur-md border border-slate-700/50 p-8 md:p-10 rounded-3xl shadow-2xl space-y-6">
                    <div className="grid grid-cols-1 md:grid-cols-2 gap-6">
                        {/* Name */}
                        <div>
                            <label className={labelClasses}>이름 (Name) <span className="text-rose-400">*</span></label>
                            <input type="text" name="name" value={formData.name} onChange={handleChange} className={inputClasses} placeholder="영문 또는 국문 이름" required />
                        </div>
                        {/* Age */}
                        <div>
                            <label className={labelClasses}>나이 (만 나이) <span className="text-rose-400">*</span></label>
                            <input type="number" name="age" value={formData.age} onChange={handleChange} className={inputClasses} min="18" max="60" required />
                        </div>
                        {/* Nationality */}
                        <div>
                            <label className={labelClasses}>국적 (Nationality) <span className="text-rose-400">*</span></label>
                            <select name="nationality" value={formData.nationality} onChange={handleChange} className={inputClasses} required>
                                <option value="" disabled>국적을 선택해 주세요 (Select Nationality)</option>
                                <option value="Afghanistan">Afghanistan (아프가니스탄)</option>
                                <option value="Albania">Albania (알바니아)</option>
                                <option value="Algeria">Algeria (알제리)</option>
                                <option value="Andorra">Andorra (안도라)</option>
                                <option value="Angola">Angola (앙골라)</option>
                                <option value="Antigua and Barbuda">Antigua and Barbuda (앤티가 바부다)</option>
                                <option value="Argentina">Argentina (아르헨티나)</option>
                                <option value="Armenia">Armenia (아르메니아)</option>
                                <option value="Australia">Australia (호주)</option>
                                <option value="Austria">Austria (오스트리아)</option>
                                <option value="Azerbaijan">Azerbaijan (아제르바이잔)</option>
                                <option value="Bahamas">Bahamas (바하마)</option>
                                <option value="Bahrain">Bahrain (바레인)</option>
                                <option value="Bangladesh">Bangladesh (방글라데시)</option>
                                <option value="Barbados">Barbados (바베이도스)</option>
                                <option value="Belarus">Belarus (벨라루스)</option>
                                <option value="Belgium">Belgium (벨기에)</option>
                                <option value="Belize">Belize (벨리즈)</option>
                                <option value="Benin">Benin (베냉)</option>
                                <option value="Bhutan">Bhutan (부탄)</option>
                                <option value="Bolivia">Bolivia (볼리비아)</option>
                                <option value="Bosnia and Herzegovina">Bosnia and Herzegovina (보스니아 헤르체고비나)</option>
                                <option value="Botswana">Botswana (보츠와나)</option>
                                <option value="Brazil">Brazil (브라질)</option>
                                <option value="Brunei">Brunei (브루나이)</option>
                                <option value="Bulgaria">Bulgaria (불가리아)</option>
                                <option value="Burkina Faso">Burkina Faso (부르키나파소)</option>
                                <option value="Burundi">Burundi (부룬디)</option>
                                <option value="Cabo Verde">Cabo Verde (카보베르데)</option>
                                <option value="Cambodia">Cambodia (캄보디아)</option>
                                <option value="Cameroon">Cameroon (카메룬)</option>
                                <option value="Canada">Canada (캐나다)</option>
                                <option value="Central African Republic">Central African Republic (중앙아프리카 공화국)</option>
                                <option value="Chad">Chad (차드)</option>
                                <option value="Chile">Chile (칠레)</option>
                                <option value="China">China (중국)</option>
                                <option value="Colombia">Colombia (콜롬비아)</option>
                                <option value="Comoros">Comoros (코모로)</option>
                                <option value="Congo, Democratic Republic of the">Congo, Democratic Republic of the (콩고 민주 공화국)</option>
                                <option value="Congo, Republic of the">Congo, Republic of the (콩고 공화국)</option>
                                <option value="Costa Rica">Costa Rica (코스타리카)</option>
                                <option value="Croatia">Croatia (크로아티아)</option>
                                <option value="Cuba">Cuba (쿠바)</option>
                                <option value="Cyprus">Cyprus (키프로스)</option>
                                <option value="Czechia">Czechia (체코)</option>
                                <option value="Denmark">Denmark (덴마크)</option>
                                <option value="Djibouti">Djibouti (지부티)</option>
                                <option value="Dominica">Dominica (도미니카)</option>
                                <option value="Dominican Republic">Dominican Republic (도미니카 공화국)</option>
                                <option value="Ecuador">Ecuador (에콰도르)</option>
                                <option value="Egypt">Egypt (이집트)</option>
                                <option value="El Salvador">El Salvador (엘살바도르)</option>
                                <option value="Equatorial Guinea">Equatorial Guinea (적도 기니)</option>
                                <option value="Eritrea">Eritrea (에리트레아)</option>
                                <option value="Estonia">Estonia (에스토니아)</option>
                                <option value="Eswatini">Eswatini (에스와티니)</option>
                                <option value="Ethiopia">Ethiopia (에티오피아)</option>
                                <option value="Fiji">Fiji (피지)</option>
                                <option value="Finland">Finland (핀란드)</option>
                                <option value="France">France (프랑스)</option>
                                <option value="Gabon">Gabon (가봉)</option>
                                <option value="Gambia">Gambia (감비아)</option>
                                <option value="Georgia">Georgia (조지아)</option>
                                <option value="Germany">Germany (독일)</option>
                                <option value="Ghana">Ghana (가나)</option>
                                <option value="Greece">Greece (그리스)</option>
                                <option value="Grenada">Grenada (그레나다)</option>
                                <option value="Guatemala">Guatemala (과테말라)</option>
                                <option value="Guinea">Guinea (기니)</option>
                                <option value="Guinea-Bissau">Guinea-Bissau (기니비사우)</option>
                                <option value="Guyana">Guyana (가이아나)</option>
                                <option value="Haiti">Haiti (아이티)</option>
                                <option value="Honduras">Honduras (온두라스)</option>
                                <option value="Hungary">Hungary (헝가리)</option>
                                <option value="Iceland">Iceland (아이슬란드)</option>
                                <option value="India">India (인도)</option>
                                <option value="Indonesia">Indonesia (인도네시아)</option>
                                <option value="Iran">Iran (이란)</option>
                                <option value="Iraq">Iraq (이라크)</option>
                                <option value="Ireland">Ireland (아일랜드)</option>
                                <option value="Israel">Israel (이스라엘)</option>
                                <option value="Italy">Italy (이탈리아)</option>
                                <option value="Jamaica">Jamaica (자메이카)</option>
                                <option value="Japan">Japan (일본)</option>
                                <option value="Jordan">Jordan (요르단)</option>
                                <option value="Kazakhstan">Kazakhstan (카자흐스탄)</option>
                                <option value="Kenya">Kenya (케냐)</option>
                                <option value="Kiribati">Kiribati (키리바시)</option>
                                <option value="Korea, North">Korea, North (북한)</option>
                                <option value="Kuwait">Kuwait (쿠웨이트)</option>
                                <option value="Kyrgyzstan">Kyrgyzstan (키르기스스탄)</option>
                                <option value="Laos">Laos (라오스)</option>
                                <option value="Latvia">Latvia (라트비아)</option>
                                <option value="Lebanon">Lebanon (레바논)</option>
                                <option value="Lesotho">Lesotho (레소토)</option>
                                <option value="Liberia">Liberia (라이베리아)</option>
                                <option value="Libya">Libya (리비아)</option>
                                <option value="Liechtenstein">Liechtenstein (리히텐슈타인)</option>
                                <option value="Lithuania">Lithuania (리투아니아)</option>
                                <option value="Luxembourg">Luxembourg (룩셈부르크)</option>
                                <option value="Madagascar">Madagascar (마다가스카르)</option>
                                <option value="Malawi">Malawi (말라위)</option>
                                <option value="Malaysia">Malaysia (말레이시아)</option>
                                <option value="Maldives">Maldives (몰디브)</option>
                                <option value="Mali">Mali (말리)</option>
                                <option value="Malta">Malta (몰타)</option>
                                <option value="Marshall Islands">Marshall Islands (마셜 제도)</option>
                                <option value="Mauritania">Mauritania (모리타니)</option>
                                <option value="Mauritius">Mauritius (모리셔스)</option>
                                <option value="Mexico">Mexico (멕시코)</option>
                                <option value="Micronesia">Micronesia (미크로네시아)</option>
                                <option value="Moldova">Moldova (몰도바)</option>
                                <option value="Monaco">Monaco (모나코)</option>
                                <option value="Mongolia">Mongolia (몽골)</option>
                                <option value="Montenegro">Montenegro (몬테네그로)</option>
                                <option value="Morocco">Morocco (모로코)</option>
                                <option value="Mozambique">Mozambique (모잠비크)</option>
                                <option value="Myanmar">Myanmar (미얀마)</option>
                                <option value="Namibia">Namibia (나미비아)</option>
                                <option value="Nauru">Nauru (나우루)</option>
                                <option value="Nepal">Nepal (네팔)</option>
                                <option value="Netherlands">Netherlands (네덜란드)</option>
                                <option value="New Zealand">New Zealand (뉴질랜드)</option>
                                <option value="Nicaragua">Nicaragua (니카라과)</option>
                                <option value="Niger">Niger (니제르)</option>
                                <option value="Nigeria">Nigeria (나이지리아)</option>
                                <option value="North Macedonia">North Macedonia (북마케도니아)</option>
                                <option value="Norway">Norway (노르웨이)</option>
                                <option value="Oman">Oman (오만)</option>
                                <option value="Pakistan">Pakistan (파키스탄)</option>
                                <option value="Palau">Palau (팔라우)</option>
                                <option value="Palestine">Palestine (팔레스타인)</option>
                                <option value="Panama">Panama (파나마)</option>
                                <option value="Papua New Guinea">Papua New Guinea (파푸아뉴기니)</option>
                                <option value="Paraguay">Paraguay (파라과이)</option>
                                <option value="Peru">Peru (페루)</option>
                                <option value="Philippines">Philippines (필리핀)</option>
                                <option value="Poland">Poland (폴란드)</option>
                                <option value="Portugal">Portugal (포르투갈)</option>
                                <option value="Qatar">Qatar (카타르)</option>
                                <option value="Romania">Romania (루마니아)</option>
                                <option value="Russia">Russia (러시아)</option>
                                <option value="Rwanda">Rwanda (르완다)</option>
                                <option value="Saint Kitts and Nevis">Saint Kitts and Nevis (세인트키츠 네비스)</option>
                                <option value="Saint Lucia">Saint Lucia (세인트루시아)</option>
                                <option value="Saint Vincent and the Grenadines">Saint Vincent and the Grenadines (세인트빈센트 그레나딘)</option>
                                <option value="Samoa">Samoa (사모아)</option>
                                <option value="San Marino">San Marino (산마리노)</option>
                                <option value="Sao Tome and Principe">Sao Tome and Principe (상투메 프린시페)</option>
                                <option value="Saudi Arabia">Saudi Arabia (사우디아라비아)</option>
                                <option value="Senegal">Senegal (세네갈)</option>
                                <option value="Serbia">Serbia (세르비아)</option>
                                <option value="Seychelles">Seychelles (세이셸)</option>
                                <option value="Sierra Leone">Sierra Leone (시에라리온)</option>
                                <option value="Singapore">Singapore (싱가포르)</option>
                                <option value="Slovakia">Slovakia (슬로바키아)</option>
                                <option value="Slovenia">Slovenia (슬로베니아)</option>
                                <option value="Solomon Islands">Solomon Islands (솔로몬 제도)</option>
                                <option value="Somalia">Somalia (소말리아)</option>
                                <option value="South Africa">South Africa (남아프리카 공화국)</option>
                                <option value="South Sudan">South Sudan (남수단)</option>
                                <option value="Spain">Spain (스페인)</option>
                                <option value="Sri Lanka">Sri Lanka (스리랑카)</option>
                                <option value="Sudan">Sudan (수단)</option>
                                <option value="Suriname">Suriname (수리남)</option>
                                <option value="Sweden">Sweden (스웨덴)</option>
                                <option value="Switzerland">Switzerland (스위스)</option>
                                <option value="Syria">Syria (시리아)</option>
                                <option value="Taiwan">Taiwan (대만)</option>
                                <option value="Tajikistan">Tajikistan (타지키스탄)</option>
                                <option value="Tanzania">Tanzania (탄자니아)</option>
                                <option value="Thailand">Thailand (태국)</option>
                                <option value="Timor-Leste">Timor-Leste (동티모르)</option>
                                <option value="Togo">Togo (토고)</option>
                                <option value="Tonga">Tonga (통가)</option>
                                <option value="Trinidad and Tobago">Trinidad and Tobago (트리니다드 토바고)</option>
                                <option value="Tunisia">Tunisia (튀니지)</option>
                                <option value="Turkey">Turkey (튀르키예)</option>
                                <option value="Turkmenistan">Turkmenistan (투르크메니스탄)</option>
                                <option value="Tuvalu">Tuvalu (투발루)</option>
                                <option value="Uganda">Uganda (우간다)</option>
                                <option value="Ukraine">Ukraine (우크라이나)</option>
                                <option value="United Arab Emirates">United Arab Emirates (아랍에미리트)</option>
                                <option value="United Kingdom">United Kingdom (영국)</option>
                                <option value="United States">United States (미국)</option>
                                <option value="Uruguay">Uruguay (우루과이)</option>
                                <option value="Uzbekistan">Uzbekistan (우즈베키스탄)</option>
                                <option value="Vanuatu">Vanuatu (바누아투)</option>
                                <option value="Vatican City">Vatican City (바티칸 시국)</option>
                                <option value="Venezuela">Venezuela (베네수엘라)</option>
                                <option value="Vietnam">Vietnam (베트남)</option>
                                <option value="Yemen">Yemen (예멘)</option>
                                <option value="Zambia">Zambia (잠비아)</option>
                                <option value="Zimbabwe">Zimbabwe (짐바브웨)</option>
                                <option value="Other">Other (기타)</option>
                            </select>
                        </div>
                        {/* Region */}
                        {/* Region */}
                        <div>
                            <label className={labelClasses}>거주 지역 (Region) <span className="text-rose-400">*</span></label>
                            <select name="region" value={formData.region} onChange={handleChange} className={inputClasses}>
                                <option value="서울">서울 (Seoul)</option>
                                <option value="경기/인천">경기/인천 (Gyeonggi/Incheon)</option>
                                <option value="부산/경남">부산/경남 (Busan/Gyeongnam)</option>
                                <option value="대구/경북">대구/경북 (Daegu/Gyeongbuk)</option>
                                <option value="광주/전라">광주/전라 (Gwangju/Jeolla)</option>
                                <option value="대전/충청">대전/충청 (Daejeon/Chungcheong)</option>
                                <option value="강원/제주">강원/제주 (Gangwon/Jeju)</option>
                            </select>
                        </div>
                        {/* University */}
                        <div>
                            <label className={labelClasses}>현재 소속 학교 (University) <span className="text-rose-400">*</span></label>
                            <select name="university" value={formData.university} onChange={handleChange} className={inputClasses} required>
                                <option value="" disabled>소속 대학을 선택해 주세요</option>
                                {universitiesByRegion[formData.region] && Object.entries(universitiesByRegion[formData.region]).map(([groupName, unvs]) => (
                                    <optgroup key={groupName} label={groupName}>
                                        {unvs.map(univ => (
                                            <option key={univ} value={univ}>{univ}</option>
                                        ))}
                                    </optgroup>
                                ))}
                            </select>
                            <p className="text-xs text-slate-500 mt-2 ml-1">리스트에 없을 경우 가장 비슷한 캠퍼스나 '기타 대학교'를 선택해 주세요.</p>
                        </div>
                        {/* Major */}
                        <div>
                            <label className={labelClasses}>전공 (Major) <span className="text-rose-400">*</span></label>
                            <select name="major" value={formData.major} onChange={handleChange} className={inputClasses} required>
                                <option value="" disabled>전공을 선택해 주세요</option>
                                <optgroup label="인문사회계열 (Humanities & Social Sciences)">
                                    <option value="국어국문학">국어국문학 (Korean Language & Literature)</option>
                                    <option value="한국어교육학">한국어교육학 (Korean Language Education)</option>
                                    <option value="영어영문학">영어영문학 (English Language & Literature)</option>
                                    <option value="중어중문학">중어중문학 (Chinese Language & Literature)</option>
                                    <option value="일어일문학">일어일문학 (Japanese Language & Literature)</option>
                                    <option value="경영학">경영학 (Business Administration)</option>
                                    <option value="경제학">경제학 (Economics)</option>
                                    <option value="국제통상학">국제통상학 / 무역학 (International Trade)</option>
                                    <option value="회계세무학">회계학 / 세무학 (Accounting & Taxation)</option>
                                    <option value="행정학">행정학 (Public Administration)</option>
                                    <option value="정치외교학">정치외교학 (Political Science & Diplomacy)</option>
                                    <option value="사회학">사회학 (Sociology)</option>
                                    <option value="사회복지학">사회복지학 (Social Welfare)</option>
                                    <option value="미디어커뮤니케이션학">미디어커뮤니케이션 / 신문방송학 (Media & Communication)</option>
                                    <option value="광고홍보학">광고홍보학 (Advertising & Public Relations)</option>
                                    <option value="관광경영학">관광경영학 (Tourism Management)</option>
                                    <option value="호텔경영학">호텔경영학 (Hotel Management)</option>
                                    <option value="항공서비스학">항공서비스 / 객실운항 (Aviation Service / Cabin Crew)</option>
                                    <option value="외식경영학">외식경영학 (Food Service Management)</option>
                                    <option value="비서사무행정">비서 / 사무행정 (Secretarial Studies / Office Admin)</option>
                                    <option value="유아교육학">유아교육 / 보육 (Early Childhood Education)</option>
                                    <option value="사학">사학 (History)</option>
                                    <option value="철학">철학 (Philosophy)</option>
                                    <option value="심리학">심리학 (Psychology)</option>
                                    <option value="문헌정보학">문헌정보학 (Library & Information Science)</option>
                                    <option value="교육학">교육학 / 사범계열 (Education)</option>
                                    <option value="국제학부">국제학부 / 글로벌스터디 (International Studies)</option>
                                    <option value="법학">법학 (Law)</option>
                                    <option value="기타 인문사회">기타 인문/사회/상경계열 (Other Humanities/Social Sciences)</option>
                                </optgroup>
                                <optgroup label="이공계열 (STEM)">
                                    <option value="컴퓨터공학">컴퓨터공학 (Computer Engineering)</option>
                                    <option value="소프트웨어공학">소프트웨어공학 (Software Engineering)</option>
                                    <option value="정보보안학">정보보안학 (Information Security)</option>
                                    <option value="인공지능학">인공지능 / 데이터엔지니어링 (AI / Data Engineering)</option>
                                    <option value="전자공학">전자공학 / 반도체공학 (Electronic Engineering)</option>
                                    <option value="전기공학">전기공학 (Electrical Engineering)</option>
                                    <option value="정보통신공학">정보통신공학 (Information & Communication Eng.)</option>
                                    <option value="기계공학">기계공학 (Mechanical Engineering)</option>
                                    <option value="자동차공학">자동차공학 (Automotive Engineering)</option>
                                    <option value="항공우주공학">항공우주공학 (Aerospace Engineering)</option>
                                    <option value="화학공학">화학공학 (Chemical Engineering)</option>
                                    <option value="신소재공학">신소재공학 / 재료공학 (Materials Science & Eng.)</option>
                                    <option value="생명공학">생명공학 (Bioengineering)</option>
                                    <option value="환경공학">환경공학 (Environmental Engineering)</option>
                                    <option value="건축공학">건축학 / 건축공학 (Architecture & Architectural Eng.)</option>
                                    <option value="토목공학">토목공학 (Civil Engineering)</option>
                                    <option value="도시공학">도시공학 (Urban Engineering)</option>
                                    <option value="산업공학">산업공학 (Industrial Engineering)</option>
                                    <option value="스마트팩토리학">스마트팩토리 / 메카트로닉스 (Smart Factory / Mechatronics)</option>
                                    <option value="해양조선공학">해양 / 조선공학 (Maritime / Naval Architecture)</option>
                                    <option value="게임영상공학">게임공학 / 멀티미디어 (Game Engineering / Multimedia)</option>
                                    <option value="부사관경찰">소방 / 경찰 / 부사관 (Fire Safety / Police / NCO)</option>
                                    <option value="기타 이공계">기타 이공/공학계열 (Other STEM / Engineering)</option>
                                </optgroup>
                                <optgroup label="자연과학계열 (Natural Sciences)">
                                    <option value="수학">수학 (Mathematics)</option>
                                    <option value="통계학">통계학 / 데이터사이언스 (Statistics / Data Science)</option>
                                    <option value="물리학">물리학 (Physics)</option>
                                    <option value="천문학">천문학 (Astronomy)</option>
                                    <option value="화학">화학 (Chemistry)</option>
                                    <option value="생명과학">생명과학 / 생물학 (Life Sciences / Biology)</option>
                                    <option value="식품영양학">식품영양학 (Food & Nutrition)</option>
                                    <option value="조리과학">조리과학 / 제과제빵 (Culinary Science / Baking)</option>
                                    <option value="농생명과학">농생명과학 / 농업 (Agricultural & Life Sciences)</option>
                                    <option value="반려동물학">반려동물 / 펫케어 (Pet Care / Animal Science)</option>
                                    <option value="지질지구과학">지질학 / 지구과학 (Geology / Earth Science)</option>
                                    <option value="향장화장품학">향장 / 화장품과학 (Cosmetics & Fragrance)</option>
                                    <option value="기타 자연과학">기타 자연과학계열 (Other Natural Sciences)</option>
                                </optgroup>
                                <optgroup label="예체능 및 의약보건계열 (Arts, Physical & Health)">
                                    <option value="시각디자인">시각디자인 (Visual Design)</option>
                                    <option value="산업디자인">산업디자인 (Industrial Design)</option>
                                    <option value="영상디자인">영상디자인 / 미디어디자인 (Video & Media Design)</option>
                                    <option value="패션디자인">패션디자인 / 의류학 (Fashion Design)</option>
                                    <option value="사진만화애니">사진 / 만화 / 애니메이션 (Photography / Animation)</option>
                                    <option value="순수예술">순수미술 (Fine Arts)</option>
                                    <option value="실용음악">실용음악 / 성악 / 기악 (Applied Music / Vocal / Instrumental)</option>
                                    <option value="무용연극영화">무용 / 연극영화 (Dance / Theater & Film)</option>
                                    <option value="방송엔터테인먼트">방송연예 / 엔터테인먼트 (Broadcasting / Entertainment)</option>
                                    <option value="미용뷰티">미용 / 뷰티케어 (Beauty & Cosmetics)</option>
                                    <option value="헤어메이크업">헤어디자인 / 메이크업 (Hair Design / Makeup)</option>
                                    <option value="체육학">체육학 / 스포츠과학 (Physical Education / Sports Science)</option>
                                    <option value="경호무도학">경호무도학 (Security & Martial Arts)</option>
                                    <option value="보건행정학">보건행정 / 병원경영 (Health Admin / Hospital Mgmt)</option>
                                    <option value="간호학">간호학 (Nursing)</option>
                                    <option value="물리치료학">물리치료학 (Physical Therapy)</option>
                                    <option value="재활작업치료">재활 / 작업치료 (Rehabilitation / Occupational Therapy)</option>
                                    <option value="치위생학">치위생 / 응급구조 (Dental Hygiene / Paramedic)</option>
                                    <option value="의약학">의학 / 약학 / 수의학 (Medicine / Pharmacy / Veterinary)</option>
                                    <option value="기타 예체능보건">기타 예체능/보건계열 (Other Arts/Physical/Health)</option>
                                </optgroup>
                            </select>
                            <p className="text-xs text-rose-400/80 mt-2 ml-1">※ 본인의 세부전공과 가장 흡사/동일한 범주를 선택해 주세요.</p>
                        </div>
                        {/* Grade */}
                        <div className="md:col-span-2">
                            <label className={labelClasses}>현재 학년 (Grade) <span className="text-rose-400">*</span></label>
                            <div className="grid grid-cols-3 md:grid-cols-6 gap-3">
                                {['1학년', '2학년', '3학년', '4학년', '석박사', '졸업'].map((g) => (
                                    <label key={g} className={`cursor-pointer text-center py-3 rounded-xl border transition-all ${formData.grade === g ? 'bg-cyan-500/20 border-cyan-400 text-cyan-300 font-bold' : 'bg-slate-800 border-slate-700 text-slate-400 hover:border-slate-500'}`}>
                                        <input type="radio" name="grade" value={g} checked={formData.grade === g} onChange={handleChange} className="hidden" />
                                        {g}
                                    </label>
                                ))}
                            </div>
                        </div>
                        {/* Language Specs (New for Phase 1) */}
                        <div className="md:col-span-2 pt-4 border-t border-slate-700/50 mt-2">
                            <h3 className="text-lg font-bold text-cyan-400 mb-4">어학 능력 (Language Spec)</h3>
                            <div className="grid grid-cols-1 md:grid-cols-3 gap-6">
                                <div>
                                    <label className={labelClasses}>한국어능력시험 (TOPIK)</label>
                                    <select name="topik" value={formData.topik} onChange={handleChange} className={inputClasses}>
                                        <option value="0">없음 / 준비 중</option>
                                        <option value="1">1급</option>
                                        <option value="2">2급</option>
                                        <option value="3">3급</option>
                                        <option value="4">4급</option>
                                        <option value="5">5급</option>
                                        <option value="6">6급</option>
                                    </select>
                                </div>
                                <div>
                                    <label className={labelClasses}>사회통합프로그램 (KIIP)</label>
                                    <select name="kiip" value={formData.kiip} onChange={handleChange} className={inputClasses}>
                                        <option value="0">미이수 / 모름</option>
                                        <option value="1">1단계 수료</option>
                                        <option value="2">2단계 수료</option>
                                        <option value="3">3단계 수료</option>
                                        <option value="4">4단계 수료</option>
                                        <option value="5">5단계 수료</option>
                                    </select>
                                </div>
                                <div className="col-span-1 md:col-span-3">
                                    <div className="flex justify-between items-center mb-2">
                                        <label className={labelClasses}>기타 제2외국어 / 모국어</label>
                                        <button
                                            type="button"
                                            onClick={addSecondaryLanguage}
                                            className="text-xs bg-cyan-500/20 text-cyan-400 hover:bg-cyan-500/40 px-3 py-1 rounded-full border border-cyan-500/50 transition-colors flex items-center gap-1"
                                        >
                                            <span>➕</span> 언어 추가
                                        </button>
                                    </div>
                                    <div className="flex flex-col gap-3">
                                        {formData.secondaryLanguages.map((item, idx) => (
                                            <div key={idx} className="flex gap-2 items-center">
                                                <div className="flex-1 grid grid-cols-2 gap-2">
                                                    <select
                                                        value={item.lang}
                                                        onChange={(e) => handleSecondaryLanguageChange(idx, 'lang', e.target.value)}
                                                        className={inputClasses}
                                                    >
                                                        <option value="" disabled>언어 선택 (Language)</option>
                                                        <option value="영어">영어 (English)</option>
                                                        <option value="중국어">중국어 (Chinese)</option>
                                                        <option value="일본어">일본어 (Japanese)</option>
                                                        <option value="베트남어">베트남어 (Vietnamese)</option>
                                                        <option value="프랑스어">프랑스어 (French)</option>
                                                        <option value="스페인어">스페인어 (Spanish)</option>
                                                        <option value="독일어">독일어 (German)</option>
                                                        <option value="러시아어">러시아어 (Russian)</option>
                                                        <option value="포르투갈어">포르투갈어 (Portuguese)</option>
                                                        <option value="이탈리아어">이탈리아어 (Italian)</option>
                                                        <option value="몽골어">몽골어 (Mongolian)</option>
                                                        <option value="우즈베크어">우즈베크어 (Uzbek)</option>
                                                        <option value="카자흐어">카자흐어 (Kazakh)</option>
                                                        <option value="인도네시아어">인도네시아어/말레이어 (Indonesian/Malay)</option>
                                                        <option value="태국어">태국어 (Thai)</option>
                                                        <option value="미얀마어">미얀마어 (Burmese)</option>
                                                        <option value="캄보디아어">캄보디아어 (Khmer)</option>
                                                        <option value="네팔어">네팔어 (Nepali)</option>
                                                        <option value="힌디어">힌디어 (Hindi)</option>
                                                        <option value="아랍어">아랍어 (Arabic)</option>
                                                        <option value="튀르키예어">튀르키예어(터키어) (Turkish)</option>
                                                        <option value="기타">기타 (Others)</option>
                                                    </select>
                                                    <select
                                                        value={item.level}
                                                        onChange={(e) => handleSecondaryLanguageChange(idx, 'level', e.target.value)}
                                                        className={inputClasses}
                                                    >
                                                        <option value="none">수준 선택 (선택 안함/기초)</option>
                                                        <option value="basic">일상 소통 가능 (Intermediate)</option>
                                                        <option value="business">비즈니스 가능 (Advanced)</option>
                                                        <option value="native">원어민 수준 (Native)</option>
                                                    </select>
                                                </div>
                                                {formData.secondaryLanguages.length > 1 && (
                                                    <button
                                                        type="button"
                                                        onClick={() => removeSecondaryLanguage(idx)}
                                                        className="p-2 text-rose-400 hover:text-rose-300 hover:bg-rose-400/10 rounded-lg transition-colors border border-transparent hover:border-rose-400/30"
                                                        title="삭제"
                                                    >
                                                        ✖
                                                    </button>
                                                )}
                                            </div>
                                        ))}
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>

                    <div className="pt-6">
                        <button type="submit" className="w-full bg-gradient-to-r from-cyan-500 to-blue-600 hover:from-cyan-400 hover:to-blue-500 text-white font-bold text-lg py-4 rounded-xl shadow-[0_0_20px_rgba(6,182,212,0.3)] transition-all transform hover:scale-[1.02]">
                            기본 정보 저장 및 진단 시작
                        </button>
                    </div>
                </form>
            </div>
        </div>
    );
}
