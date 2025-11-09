import 'package:cuty_app/common/component/custom_app_bar.dart';
import 'package:cuty_app/common/component/custom_text_field.dart';
import 'package:cuty_app/common/layout/screen_layout.dart';
import 'package:cuty_app/config/app_colors.dart';
import 'package:cuty_app/models/document.dart';
import 'package:cuty_app/services/document_service.dart';
import 'package:cuty_app/services/image_service.dart';
import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';
import 'package:file_picker/file_picker.dart';
import 'dart:typed_data';
import 'dart:io';

class PdfViewerScreen extends StatefulWidget {
  final Document document;

  const PdfViewerScreen({
    super.key,
    required this.document,
  });

  @override
  State<PdfViewerScreen> createState() => _PdfViewerScreenState();
}

class _PdfViewerScreenState extends State<PdfViewerScreen> {
  final DocumentService _documentService = DocumentService();
  final ImageService _imageService = ImageService();
  final PdfViewerController _pdfViewerController = PdfViewerController();
  bool _isDeleting = false;
  bool _isUpdating = false;

  @override
  void initState() {
    super.initState();
  }

  void _showMenuOptions() {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return Container(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text(
                '서류 관리',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 20),
              _buildMenuOption(
                icon: Icons.edit,
                label: '서류 수정',
                onTap: () {
                  Navigator.pop(context);
                  _showFileSourceModal();
                },
                color: AppColors.primaryColor,
              ),
              const SizedBox(height: 16),
              _buildMenuOption(
                icon: Icons.delete,
                label: '서류 삭제',
                onTap: () {
                  Navigator.pop(context);
                  _deleteDocument();
                },
                color: Colors.red,
              ),
              const SizedBox(height: 20),
            ],
          ),
        );
      },
    );
  }

  Widget _buildMenuOption({
    required IconData icon,
    required String label,
    required VoidCallback onTap,
    required Color color,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
        decoration: BoxDecoration(
          color: color.withOpacity(0.1),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Row(
          children: [
            Icon(icon, color: color, size: 24),
            const SizedBox(width: 16),
            Text(
              label,
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w500,
                color: color,
              ),
            ),
          ],
        ),
      ),
    );
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
          child: _DocumentEditBottomSheet(
            document: widget.document,
            onUpdate: (String? name, Uint8List? pdfBytes, String? filename) async {
              if (pdfBytes != null && filename != null) {
                // 파일도 함께 업데이트
                await _updateDocument(pdfBytes, filename, name: name);
              } else {
                // 이름만 업데이트
                await _updateDocumentName(name);
              }
            },
          ),
        );
      },
    );
  }


  Future<void> _updateDocument(Uint8List pdfBytes, String filename, {String? name}) async {
    try {
      setState(() {
        _isUpdating = true;
      });

      print('=== PDF 수정 업로드 시작 ===');
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

      // 2. S3에 업로드
      print('2단계: S3 업로드 시작...');
      await _imageService.uploadToS3(
        url: presignedResponse.upload.url,
        fields: presignedResponse.upload.fields,
        bytes: pdfBytes,
        contentType: 'application/pdf',
      );
      print('S3 업로드 완료');

      // 3. 서류 수정
      print('3단계: 서류 수정 시작...');
      await _documentService.updateDocument(
        documentId: widget.document.id,
        imageStoreId: presignedResponse.image.id,
        name: name,
      );
      print('서류 수정 완료');

      print('=== PDF 수정 성공 ===');
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('서류가 성공적으로 수정되었습니다.')),
        );
        Navigator.of(context).pop(true); // 수정 성공을 알림
      }
    } catch (e) {
      print('=== PDF 수정 실패 ===');
      print('에러: ${e.toString()}');
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('수정 실패: ${e.toString()}')),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isUpdating = false;
        });
      }
    }
  }

  Future<void> _updateDocumentName(String? name) async {
    try {
      setState(() {
        _isUpdating = true;
      });

      print('=== 서류 이름 수정 시작 ===');
      print('이름: $name');

      await _documentService.updateDocument(
        documentId: widget.document.id,
        name: name,
      );

      print('=== 서류 이름 수정 성공 ===');
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('서류 이름이 성공적으로 수정되었습니다.')),
        );
        Navigator.of(context).pop(true); // 수정 성공을 알림
      }
    } catch (e) {
      print('=== 서류 이름 수정 실패 ===');
      print('에러: ${e.toString()}');
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('이름 수정 실패: ${e.toString()}')),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isUpdating = false;
        });
      }
    }
  }

  Future<void> _deleteDocument() async {
    final shouldDelete = await showDialog<bool>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('서류 삭제'),
          content: const Text('이 서류를 삭제하시겠습니까?\n삭제된 서류는 복구할 수 없습니다.'),
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
        );
      },
    );

    if (shouldDelete == true) {
      try {
        setState(() {
          _isDeleting = true;
        });

        await _documentService.deleteDocument(widget.document.id);

        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('서류가 삭제되었습니다.')),
          );
          Navigator.of(context).pop(true); // 삭제 성공을 알림
        }
      } catch (e) {
        if (mounted) {
          setState(() {
            _isDeleting = false;
          });
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('삭제 실패: ${e.toString()}')),
          );
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    if (widget.document.documentImageUrl == null) {
      return Scaffold(
        appBar: CustomAppBar(
          title: widget.document.name ?? widget.document.documentType.displayName,
        ),
        body: const ScreenLayout(
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.error_outline, size: 64, color: Colors.red),
                SizedBox(height: 16),
                Text('PDF URL이 없습니다.'),
              ],
            ),
          ),
        ),
      );
    }

    return Scaffold(
      appBar: CustomAppBar(
        title: widget.document.name ?? widget.document.documentType.displayName,
        actions: [
          IconButton(
            onPressed: (_isDeleting || _isUpdating) ? null : _showMenuOptions,
            icon: (_isDeleting || _isUpdating)
              ? const SizedBox(
                  width: 20,
                  height: 20,
                  child: CircularProgressIndicator(strokeWidth: 2),
                )
              : const Icon(Icons.more_vert),
            tooltip: '메뉴',
          ),
        ],
      ),
      body: ScreenLayout(
        child: SfPdfViewer.network(
          widget.document.documentImageUrl!,
          controller: _pdfViewerController,
          onDocumentLoadFailed: (PdfDocumentLoadFailedDetails details) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('PDF 로드 실패: ${details.error}')),
            );
          },
        ),
      ),
    );
  }

  @override
  void dispose() {
    _pdfViewerController.dispose();
    super.dispose();
  }
}

class _DocumentEditBottomSheet extends StatefulWidget {
  final Document document;
  final Function(String? name, Uint8List? pdfBytes, String? filename) onUpdate;

  const _DocumentEditBottomSheet({
    required this.document,
    required this.onUpdate,
  });

  @override
  State<_DocumentEditBottomSheet> createState() => _DocumentEditBottomSheetState();
}

class _DocumentEditBottomSheetState extends State<_DocumentEditBottomSheet> {
  final TextEditingController _nameController = TextEditingController();
  bool _isUpdating = false;

  @override
  void initState() {
    super.initState();
    _nameController.text = widget.document.name ?? '';
  }

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  Future<void> _updateNameOnly() async {
    try {
      setState(() {
        _isUpdating = true;
      });

      final name = _nameController.text.trim();
      await widget.onUpdate(name.isEmpty ? null : name, null, null);
      
      if (mounted) {
        Navigator.pop(context);
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('이름 수정 실패: ${e.toString()}')),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isUpdating = false;
        });
      }
    }
  }

  Future<void> _pickAndUpdateFile() async {
    try {
      FilePickerResult? result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['pdf'],
        allowMultiple: false,
      );
      
      if (result != null && result.files.single.path != null) {
        setState(() {
          _isUpdating = true;
        });

        final file = File(result.files.single.path!);
        final bytes = await file.readAsBytes();
        final filename = result.files.single.name;
        
        final name = _nameController.text.trim();
        
        await widget.onUpdate(
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
          SnackBar(content: Text('파일 수정 실패: ${e.toString()}')),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isUpdating = false;
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
            '서류 수정',
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
          
          // 이름만 수정 버튼
          SizedBox(
            width: double.infinity,
            child: ElevatedButton.icon(
              onPressed: _isUpdating ? null : _updateNameOnly,
              icon: _isUpdating 
                  ? const SizedBox(
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        color: Colors.white,
                      ),
                    )
                  : const Icon(Icons.edit),
              label: Text(_isUpdating ? '수정 중...' : '이름만 수정'),
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
          const SizedBox(height: 12),
          
          // 파일과 이름 함께 수정 버튼
          SizedBox(
            width: double.infinity,
            child: OutlinedButton.icon(
              onPressed: _isUpdating ? null : _pickAndUpdateFile,
              icon: const Icon(Icons.folder_open),
              label: const Text('새 파일로 교체'),
              style: OutlinedButton.styleFrom(
                foregroundColor: AppColors.primaryColor,
                side: const BorderSide(color: AppColors.primaryColor),
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
            ),
          ),
          const SizedBox(height: 8),
          
          Text(
            '이름을 비우면 "${widget.document.documentType.displayName}"으로 표시됩니다.',
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
