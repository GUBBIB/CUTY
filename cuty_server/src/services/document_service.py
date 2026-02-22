from datetime import datetime
import logging
from flask import current_app
from sqlalchemy import and_
from src.models import db, Document, ImageStore, User, PointLog
from src.models.enums import DocumentType
from src.utils.formatters import get_document_data
from pypdf import PdfWriter, PdfReader
import img2pdf
from src.services.s3_service import s3_client, BUCKET_NAME
import io

# 로거 설정
logger = logging.getLogger(__name__)

class DocumentService:
    @staticmethod
    def get_documents(user_id, page=1, per_page=10, document_type=None):
        """사용자의 서류 목록을 조회합니다 (삭제된 서류 제외)."""
        try:
            # 기본 필터 조건
            filter_conditions = [
                Document.user_id == user_id,
                Document.deleted_at == None
            ]
            
            # 서류 타입 필터링 추가
            if document_type:
                if not isinstance(document_type, str) or document_type not in DocumentType.__members__:
                    raise ValueError("유효하지 않은 서류 타입입니다")
                filter_conditions.append(Document.document_type == DocumentType[document_type])
            
            documents_query = Document.query.filter(
                and_(*filter_conditions)
            ).order_by(Document.created_at.desc())
            
            documents = documents_query.paginate(
                page=page,
                per_page=per_page,
                error_out=False
            )
            
            document_list = []
            for document in documents.items:
                document_data = get_document_data(document)
                document_list.append(document_data)
            
            return {
                'documents': document_list,
                'total': documents.total,
                'pages': documents.pages,
                'current_page': documents.page,
                'per_page': documents.per_page,
                'has_next': documents.has_next,
                'has_prev': documents.has_prev
            }
            
        except Exception as e:
            current_app.logger.error(f"서류 목록 조회 중 오류 발생: {str(e)}")
            raise ValueError("서류 목록을 가져오는 중 오류가 발생했습니다")
    
    @staticmethod
    def get_document_by_id(document_id, user_id):
        """서류 상세 정보를 조회합니다."""
        try:
            # 먼저 서류가 존재하는지 확인
            document = Document.query.filter(
                and_(
                    Document.id == document_id,
                    Document.user_id == user_id
                )
            ).first()
            
            if not document:
                raise ValueError("서류를 찾을 수 없습니다")
            
            # 삭제된 서류인지 확인
            if document.is_deleted:
                raise ValueError("삭제된 서류입니다")
            
            return get_document_data(document)
            
        except ValueError:
            raise
        except Exception as e:
            current_app.logger.error(f"서류 조회 중 오류 발생: {str(e)}")
            raise ValueError("서류를 가져오는 중 오류가 발생했습니다")
    
    @staticmethod
    def create_document(user_id, name, document_type, image_store_id):
        """새로운 서류를 생성합니다."""
        try:
            # 서류 타입 검증
            if not isinstance(document_type, str) or document_type not in DocumentType.__members__:
                raise ValueError("유효하지 않은 서류 타입입니다")
            
            # 이미지 스토어 존재 확인
            image_store = ImageStore.query.get(image_store_id)
            
            if not image_store:
                raise ValueError("이미지를 찾을 수 없습니다")
            
            # 사용자 존재 확인
            user = User.query.get(user_id)
            if not user or user.is_deleted:
                raise ValueError("사용자를 찾을 수 없습니다")
            
            target_document_type = DocumentType[document_type]
            existing_document = Document.query.filter_by(
                user_id=user_id,
                document_type=target_document_type
            ).first()

            is_first_registration = (existing_document is None)

            # 서류 생성
            new_document = Document(
                name=name,
                document_type=DocumentType[document_type],
                user_id=user_id,
                image_store_id=image_store_id
            )
            
            db.session.add(new_document)

            if is_first_registration:
                new_point_log = PointLog(
                    user_id=user_id,
                    amount=300,
                    description= f"{document_type} 서류 첫 등록 보상"
                )
                db.session.add(new_point_log)
                user.points += 300

            db.session.commit()
            
            return get_document_data(new_document)
            
        except ValueError:
            raise
        except Exception as e:
            current_app.logger.error(f"서류 생성 중 오류 발생: {str(e)}")
            db.session.rollback()
            raise ValueError("서류 생성 중 오류가 발생했습니다")
    
    @staticmethod
    def update_document(document_id, user_id, name=None, document_type=None, image_store_id=None):
        """서류 정보를 업데이트합니다."""
        try:
            # 먼저 서류가 존재하는지 확인
            document = Document.query.filter(
                and_(
                    Document.id == document_id,
                    Document.user_id == user_id
                )
            ).first()
            
            if not document:
                raise ValueError("서류를 찾을 수 없습니다")
            
            # 삭제된 서류인지 확인
            if document.is_deleted:
                raise ValueError("삭제된 서류입니다")
            
            # 서류 이름 업데이트
            if name is not None:  # None 체크를 통해 빈 문자열도 허용
                document.name = name
            
            # 서류 타입 업데이트
            if document_type:
                if not isinstance(document_type, str) or document_type not in DocumentType.__members__:
                    raise ValueError("유효하지 않은 서류 타입입니다")
                document.document_type = DocumentType[document_type]
            
            # 이미지 스토어 업데이트
            if image_store_id:
                image_store = ImageStore.query.get(image_store_id)
                
                if not image_store:
                    raise ValueError("이미지를 찾을 수 없습니다")
                    
                document.image_store_id = image_store_id
            
            db.session.commit()
            
            return get_document_data(document)
            
        except ValueError:
            raise
        except Exception as e:
            current_app.logger.error(f"서류 업데이트 중 오류 발생: {str(e)}")
            db.session.rollback()
            raise ValueError("서류 업데이트 중 오류가 발생했습니다")
    
    @staticmethod
    def delete_document(document_id, user_id):
        """서류를 논리적으로 삭제합니다."""
        try:
            # 먼저 서류가 존재하는지 확인
            document = Document.query.filter(
                and_(
                    Document.id == document_id,
                    Document.user_id == user_id
                )
            ).first()
            
            if not document:
                raise ValueError("서류를 찾을 수 없습니다")
            
            # 이미 삭제된 서류인지 확인
            if document.is_deleted:
                raise ValueError("삭제된 서류입니다")
            
            # 논리적 삭제
            document.soft_delete()
            db.session.commit()
            
            return True
            
        except ValueError:
            raise
        except Exception as e:
            current_app.logger.error(f"서류 삭제 중 오류 발생: {str(e)}")
            db.session.rollback()
            raise ValueError("서류 삭제 중 오류가 발생했습니다")
    
    @staticmethod
    def delete_multiple_documents(document_ids, user_id):
        """여러 서류를 한 번에 논리적으로 삭제합니다."""
        try:
            if not document_ids or not isinstance(document_ids, list):
                raise ValueError("삭제할 서류 ID 목록이 필요합니다")
            
            if len(document_ids) == 0:
                raise ValueError("삭제할 서류가 선택되지 않았습니다")
            
            # 중복 제거
            unique_document_ids = list(set(document_ids))
            
            # 해당 사용자의 서류들만 조회 (삭제되지 않은 것들만)
            documents = Document.query.filter(
                and_(
                    Document.id.in_(unique_document_ids),
                    Document.user_id == user_id,
                    Document.deleted_at == None
                )
            ).all()
            
            if not documents:
                raise ValueError("삭제할 수 있는 서류가 없습니다")
            
            # 찾은 서류 ID들
            found_document_ids = [doc.id for doc in documents]
            
            # 요청된 ID 중에서 찾지 못한 것들
            not_found_ids = [doc_id for doc_id in unique_document_ids if doc_id not in found_document_ids]
            
            # 모든 서류를 논리적으로 삭제
            deleted_count = 0
            for document in documents:
                document.soft_delete()
                deleted_count += 1
            
            db.session.commit()
            
            result = {
                'deleted_count': deleted_count,
                'deleted_ids': found_document_ids,
                'total_requested': len(unique_document_ids)
            }
            
            # 찾지 못한 서류가 있다면 정보 추가
            if not_found_ids:
                result['not_found_ids'] = not_found_ids
                result['not_found_count'] = len(not_found_ids)
            
            return result
            
        except ValueError:
            raise
        except Exception as e:
            current_app.logger.error(f"다중 서류 삭제 중 오류 발생: {str(e)}")
            db.session.rollback()
            raise ValueError("서류 삭제 중 오류가 발생했습니다")
    
    @staticmethod
    def get_document_types():
        """사용 가능한 서류 타입 목록을 반환합니다."""
        return [
            {
                'value': doc_type.value,
                'name': doc_type.name
            }
            for doc_type in DocumentType
        ]

    @staticmethod
    def get_merged_pdf(user_id):
        """
        특정 유저의 모든 PDF/이미지 서류를 하나로 합쳐서 반환
        """

        user = User.query.get(user_id)
        if not user:
            raise ValidationError("사용자를 찾을 수 없습니다.")
            
        if not user.documents:
            raise ValidationError("서류가 없습니다.")

        pdf_writer = PdfWriter()

        for doc in user.documents:
            if not doc.image_store:
                continue

            try:
                file_obj = s3_client.get_object(
                    Bucket=BUCKET_NAME, 
                    Key=doc.image_store.relative_path
                )
                file_content = file_obj['Body'].read() 

                filename = doc.image_store.original_filename.lower() if doc.image_store.original_filename else ""                
                
                if filename.endswith(('.jpg', '.jpeg', '.png')):
                    img_pdf_bytes = img2pdf.convert(file_content)
                    pdf_writer.append(io.BytesIO(img_pdf_bytes))

                elif filename.endswith('.pdf'):
                    pdf_writer.append(io.BytesIO(file_content))
                
                else:
                    print(f"지원하지 않는 파일 형식입니다: {filename}")
                    continue

            except Exception as e:
                print(f"파일 병합 중 오류 발생 ({doc.id}): {e}")
                continue

        output_stream = io.BytesIO()
        pdf_writer.write(output_stream)
        output_stream.seek(0) 
        
        return output_stream