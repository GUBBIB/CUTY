import 'package:cuty_app/common/component/custom_app_bar.dart';
import 'package:cuty_app/common/component/card_container.dart';
import 'package:cuty_app/common/component/custom_text_field.dart';
import 'package:cuty_app/common/layout/screen_layout.dart';
import 'package:cuty_app/config/app_colors.dart';
import 'package:cuty_app/models/document.dart';
import 'package:cuty_app/services/document_service.dart';
import 'package:cuty_app/services/image_service.dart';
import 'package:cuty_app/screens/pdf_viewer_screen.dart';
import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'package:pdfx/pdfx.dart';
import 'package:http/http.dart' as http;
import 'dart:typed_data';
import 'dart:io';

class DocumentDetailScreen extends StatefulWidget {
  final DocumentType documentType;

  const DocumentDetailScreen({
    super.key,
    required this.documentType,
  });

  @override
  State<DocumentDetailScreen> createState() => _DocumentDetailScreenState();
}

class _DocumentDetailScreenState extends State<DocumentDetailScreen> {
  final DocumentService _documentService = DocumentService();
  final ImageService _imageService = ImageService();
  
  List<Document> _documents = [];
  bool _isLoading = true;
  bool _isUploading = false;
  bool _isSelectionMode = false;
  Set<int> _selectedDocumentIds = {};
  bool _isDeleting = false;

  @override
  void initState() {
    super.initState();
    _loadDocuments();
  }

  Future<void> _loadDocuments() async {
    try {
      setState(() {
        _isLoading = true;
      });

      final result = await _documentService.getDocuments(
        documentType: widget.documentType,
        perPage: 100, // 충분히 많은 수로 설정
      );

      if (mounted) {
        setState(() {
          _documents = result['documents'] as List<Document>;
          _isLoading = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('서류를 불러오는데 실패했습니다: ${e.toString()}')),
        );
      }
    }
  }

  void _showFileSourceModal() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (BuildContext context) {
        return Padding(
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(context).viewInsets.bottom,
          ),
          child: _DocumentUploadBottomSheet(
            documentType: widget.documentType,
            onUpload: (String? name, Uint8List pdfBytes, String filename) async {
              await _uploadPdf(pdfBytes, filename, name: name);
            },
          ),
        );
      },
    );
  }


  Future<void> _uploadPdf(Uint8List pdfBytes, String filename, {String? name}) async {
    try {
      setState(() {
        _isUploading = true;
      });

      print('=== PDF 업로드 시작 ===');
      print('파일명: $filename');
      print('파일 크기: ${pdfBytes.length} bytes');

      // 1. Presigned URL 요청
      print('1단계: Presigned URL 요청 중...');
      final presignedResponse = await _imageService.getPresignedUrl(
        contentType: 'application/pdf',
        fileSize: pdfBytes.length,
        filename: filename,
      );
      print('Presigned URL 요청 완료');
      print('업로드 URL: ${presignedResponse.upload.url}');
      print('이미지 ID: ${presignedResponse.image.id}');
      print('필드 개수: ${presignedResponse.upload.fields.length}');

      // 2. S3에 업로드
      print('2단계: S3 업로드 시작...');
      await _imageService.uploadToS3(
        url: presignedResponse.upload.url,
        fields: presignedResponse.upload.fields,
        bytes: pdfBytes,
        contentType: 'application/pdf',
      );
      print('S3 업로드 완료');

      // 3. 서류 생성
      print('3단계: 서류 생성 시작...');
      await _documentService.createDocument(
        documentType: widget.documentType,
        imageStoreId: presignedResponse.image.id,
        name: name,
      );
      print('서류 생성 완료');

      // 4. 목록 새로고침
      print('4단계: 목록 새로고침...');
      await _loadDocuments();
      print('목록 새로고침 완료');

      print('=== PDF 업로드 성공 ===');
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('서류가 성공적으로 업로드되었습니다.')),
        );
      }
    } catch (e) {
      print('=== PDF 업로드 실패 ===');
      print('에러: ${e.toString()}');
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('업로드 실패: ${e.toString()}')),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isUploading = false;
        });
      }
    }
  }

  void _toggleSelectionMode() {
    setState(() {
      _isSelectionMode = !_isSelectionMode;
      _selectedDocumentIds.clear();
    });
  }

  void _toggleDocumentSelection(int documentId) {
    setState(() {
      if (_selectedDocumentIds.contains(documentId)) {
        _selectedDocumentIds.remove(documentId);
      } else {
        _selectedDocumentIds.add(documentId);
      }
    });
  }

  void _selectAllDocuments() {
    setState(() {
      if (_selectedDocumentIds.length == _documents.length) {
        _selectedDocumentIds.clear();
      } else {
        _selectedDocumentIds = _documents.map((doc) => doc.id).toSet();
      }
    });
  }

  Future<void> _deleteSelectedDocuments() async {
    if (_selectedDocumentIds.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('삭제할 서류를 선택해주세요.')),
      );
      return;
    }

    // 삭제 확인 다이얼로그
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('서류 삭제'),
        content: Text('선택한 ${_selectedDocumentIds.length}개의 서류를 삭제하시겠습니까?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text('취소'),
          ),
          TextButton(
            onPressed: () => Navigator.of(context).pop(true),
            style: TextButton.styleFrom(
              foregroundColor: Colors.red,
            ),
            child: const Text('삭제'),
          ),
        ],
      ),
    );

    if (confirmed != true) return;

    try {
      setState(() {
        _isDeleting = true;
      });

      final result = await _documentService.deleteMultipleDocuments(
        _selectedDocumentIds.toList(),
      );

      if (mounted) {
        // 선택 모드 해제
        setState(() {
          _isSelectionMode = false;
          _selectedDocumentIds.clear();
        });

        // 성공 메시지 표시
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(result['message'])),
        );

        // 목록 새로고침
        await _loadDocuments();
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('삭제 실패: ${e.toString()}')),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isDeleting = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        title: _isSelectionMode 
            ? '${_selectedDocumentIds.length}개 선택됨'
            : widget.documentType.displayName,
        actions: _documents.isNotEmpty ? [
          if (_isSelectionMode) ...[
            // 전체 선택/해제 버튼
            IconButton(
              onPressed: _selectAllDocuments,
              icon: Icon(
                _selectedDocumentIds.length == _documents.length
                    ? Icons.deselect
                    : Icons.select_all,
              ),
              tooltip: _selectedDocumentIds.length == _documents.length
                  ? '전체 해제'
                  : '전체 선택',
            ),
            // 삭제 버튼
            IconButton(
              onPressed: _isDeleting ? null : _deleteSelectedDocuments,
              icon: _isDeleting
                  ? const SizedBox(
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        color: Colors.red,
                      ),
                    )
                  : const Icon(Icons.delete, color: Colors.red),
              tooltip: '선택 삭제',
            ),
            // 취소 버튼
            IconButton(
              onPressed: _toggleSelectionMode,
              icon: const Icon(Icons.close),
              tooltip: '취소',
            ),
          ] else
            // 삭제 모드 진입 버튼
            IconButton(
              onPressed: _toggleSelectionMode,
              icon: const Icon(Icons.delete_outline),
              tooltip: '삭제',
            ),
        ] : null,
      ),
      body: ScreenLayout(
        child: Stack(
          children: [
            if (_isLoading)
              const Center(child: CircularProgressIndicator())
            else
              _buildDocumentList(),
            
            // + 버튼 (선택 모드가 아닐 때만 표시)
            if (!_isSelectionMode)
              Positioned(
                bottom: 20,
                left: 0,
                right: 0,
                child: Center(
                  child: FloatingActionButton(
                    onPressed: _isUploading ? null : _showFileSourceModal,
                    backgroundColor: Theme.of(context).colorScheme.primary,
                    shape: const CircleBorder(),
                    child: _isUploading 
                      ? const SizedBox(
                          width: 20,
                          height: 20,
                          child: CircularProgressIndicator(
                            color: Colors.white,
                            strokeWidth: 2,
                          ),
                        )
                      : const Icon(
                          Icons.add,
                          color: Colors.white,
                        ),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildDocumentList() {
    if (_documents.isEmpty) {
      return const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.description,
              size: 64,
              color: Colors.grey,
            ),
            SizedBox(height: 16),
            Text(
              '업로드된 서류가 없습니다.',
              style: TextStyle(
                fontSize: 16,
                color: Colors.grey,
              ),
            ),
            SizedBox(height: 8),
            Text(
              '하단의 + 버튼을 눌러 PDF 서류를 추가해보세요.',
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey,
              ),
            ),
          ],
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.all(16.0),
      itemCount: _documents.length,
      itemBuilder: (context, index) {
        final document = _documents[index];
        return _buildDocumentTile(document);
      },
    );
  }

  Widget _buildDocumentTile(Document document) {
    final isSelected = _selectedDocumentIds.contains(document.id);
    
    return CardContainer(
      onTap: () async {
        if (_isSelectionMode) {
          _toggleDocumentSelection(document.id);
        } else {
          final result = await Navigator.push<bool>(
            context,
            MaterialPageRoute(
              builder: (context) => PdfViewerScreen(document: document),
            ),
          );
          
          // PDF 뷰어에서 삭제된 경우 목록 새로고침
          if (result == true) {
            _loadDocuments();
          }
        }
      },
      child: Row(
        children: [
          // 선택 모드일 때 체크박스 표시
          if (_isSelectionMode) ...[
            Checkbox(
              value: isSelected,
              onChanged: (value) => _toggleDocumentSelection(document.id),
              activeColor: Theme.of(context).colorScheme.primary,
            ),
            const SizedBox(width: 8),
          ],
          // PDF 썸네일
          Container(
            width: 60,
            height: 80,
            decoration: BoxDecoration(
              color: Colors.grey.shade100,
              borderRadius: BorderRadius.circular(8),
              border: Border.all(
                color: _isSelectionMode && isSelected
                    ? Theme.of(context).colorScheme.primary
                    : Colors.grey.shade300,
                width: _isSelectionMode && isSelected ? 2 : 1,
              ),
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: Stack(
                children: [
                  _PdfThumbnail(
                    pdfUrl: document.documentImageUrl,
                    width: 60,
                    height: 80,
                  ),
                  // 선택 모드에서 선택된 경우 오버레이
                  if (_isSelectionMode && isSelected)
                    Container(
                      width: 60,
                      height: 80,
                      decoration: BoxDecoration(
                        color: Theme.of(context).colorScheme.primary.withOpacity(0.2),
                        borderRadius: BorderRadius.circular(6),
                      ),
                    ),
                ],
              ),
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  document.name ?? widget.documentType.displayName,
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                    color: _isSelectionMode && isSelected
                        ? Theme.of(context).colorScheme.primary
                        : null,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  document.createdAt != null 
                    ? '업로드: ${_formatDate(document.createdAt!)}'
                    : '업로드 날짜 없음',
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey.shade600,
                  ),
                ),
              ],
            ),
          ),
          if (!_isSelectionMode)
            Icon(
              Icons.arrow_forward_ios,
              size: 16,
              color: Colors.grey.shade400,
            ),
        ],
      ),
    );
  }

  String _formatDate(DateTime dateTime) {
    return '${dateTime.year}.${dateTime.month.toString().padLeft(2, '0')}.${dateTime.day.toString().padLeft(2, '0')}';
  }
}

class _PdfThumbnail extends StatefulWidget {
  final String? pdfUrl;
  final double width;
  final double height;

  const _PdfThumbnail({
    required this.pdfUrl,
    required this.width,
    required this.height,
  });

  @override
  State<_PdfThumbnail> createState() => _PdfThumbnailState();
}

class _PdfThumbnailState extends State<_PdfThumbnail> {
  Uint8List? _thumbnailData;
  bool _isLoading = true;
  bool _hasError = false;

  @override
  void initState() {
    super.initState();
    _generateThumbnail();
  }

  Future<void> _generateThumbnail() async {
    if (widget.pdfUrl == null) {
      setState(() {
        _isLoading = false;
        _hasError = true;
      });
      return;
    }

    try {
      // PDF 다운로드
      final response = await http.get(Uri.parse(widget.pdfUrl!));
      if (response.statusCode != 200) {
        throw Exception('PDF 다운로드 실패');
      }

      // PDF 문서 열기
      final document = await PdfDocument.openData(response.bodyBytes);
      
      // 첫 번째 페이지 가져오기
      final page = await document.getPage(1);
      
      // 페이지를 이미지로 렌더링
      final pageImage = await page.render(
        width: (widget.width * 2), // 고해상도를 위해 2배 크기로 렌더링
        height: (widget.height * 2),
      );

      if (mounted && pageImage?.bytes != null) {
        setState(() {
          _thumbnailData = pageImage!.bytes;
          _isLoading = false;
        });
      } else if (mounted) {
        setState(() {
          _isLoading = false;
          _hasError = true;
        });
      }

      // 리소스 정리
      await page.close();
      await document.close();
    } catch (e) {
      print('썸네일 생성 실패: $e');
      if (mounted) {
        setState(() {
          _isLoading = false;
          _hasError = true;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return Container(
        width: widget.width,
        height: widget.height,
        color: Colors.grey.shade200,
        child: const Center(
          child: SizedBox(
            width: 20,
            height: 20,
            child: CircularProgressIndicator(strokeWidth: 2),
          ),
        ),
      );
    }

    if (_hasError || _thumbnailData == null) {
      return Container(
        width: widget.width,
        height: widget.height,
        color: Colors.grey.shade200,
        child: const Icon(
          Icons.picture_as_pdf,
          color: AppColors.primaryColor,
          size: 24,
        ),
      );
    }

    return Image.memory(
      _thumbnailData!,
      width: widget.width,
      height: widget.height,
      fit: BoxFit.cover,
    );
  }
}

class _DocumentUploadBottomSheet extends StatefulWidget {
  final DocumentType documentType;
  final Function(String? name, Uint8List pdfBytes, String filename) onUpload;

  const _DocumentUploadBottomSheet({
    required this.documentType,
    required this.onUpload,
  });

  @override
  State<_DocumentUploadBottomSheet> createState() => _DocumentUploadBottomSheetState();
}

class _DocumentUploadBottomSheetState extends State<_DocumentUploadBottomSheet> {
  final TextEditingController _nameController = TextEditingController();
  bool _isUploading = false;

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  Future<void> _pickPdfFile() async {
    try {
      FilePickerResult? result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['pdf'],
        allowMultiple: false,
      );
      
      if (result != null && result.files.single.path != null) {
        setState(() {
          _isUploading = true;
        });

        final file = File(result.files.single.path!);
        final bytes = await file.readAsBytes();
        final filename = result.files.single.name;
        
        final name = _nameController.text.trim();
        
        await widget.onUpload(
          name.isEmpty ? null : name,
          bytes,
          filename,
        );
        
        if (mounted) {
          Navigator.pop(context);
        }
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('PDF 파일 선택 실패: ${e.toString()}')),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isUploading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Text(
            '서류 업로드',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 20),
          
          // 이름 입력 필드
          CustomTextField(
            controller: _nameController,
            hintText: '서류 이름 (선택사항)',
            decoration: InputDecoration(
              labelText: '서류 이름 (선택사항)',
              hintText: '예: 2024년 1학기 성적표',
              prefixIcon: const Icon(Icons.edit),
            ),
          ),
          const SizedBox(height: 16),
          
          // 파일 선택 버튼
          SizedBox(
            width: double.infinity,
            child: ElevatedButton.icon(
              onPressed: _isUploading ? null : _pickPdfFile,
              icon: _isUploading 
                  ? const SizedBox(
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        color: Colors.white,
                      ),
                    )
                  : const Icon(Icons.folder_open),
              label: Text(_isUploading ? '업로드 중...' : 'PDF 파일 선택'),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primaryColor,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
            ),
          ),
          const SizedBox(height: 8),
          
          Text(
            '이름을 입력하지 않으면 "${widget.documentType.displayName}"으로 표시됩니다.',
            style: TextStyle(
              fontSize: 12,
              color: Colors.grey.shade600,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 20),
        ],
      ),
    );
  }
}

