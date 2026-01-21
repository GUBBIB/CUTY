from flask import Flask
from flask_migrate import Migrate
import logging
from src.models import (
    db
)

from src.routes import init_routes
from src.config.env import (
    SECRET_KEY,
    FLASK_ENV,
    DEBUG,
    PORT
)
from src.config.database import DatabaseConfig
from flask_cors import CORS
from flasgger import Swagger
from werkzeug.middleware.proxy_fix import ProxyFix

def create_app(config_name='local'):
    app = Flask(__name__)
    app.config.from_object(DatabaseConfig())
    app.config['SECRET_KEY'] = SECRET_KEY
    app.config['DEBUG'] = DEBUG
    
    CORS(app, resources={
        r"/api/*": {
            "orifins": ["http://localhost:5173", "http://127.0.0.1:5173", "https://cutyweb.duckdns.org", ],
            "methods": ["GET","POST","PUT","PATCH","DELETE"],
            "allow_headers": ["Authorization","Content-Type"],
            "supports_credentials": False,

        }
    })

    # 로깅 설정
    if DEBUG:
        app.logger.setLevel(logging.DEBUG)
        formatter = logging.Formatter(
            '[%(asctime)s] %(levelname)s in %(module)s: %(message)s'
        )
        handler = logging.StreamHandler()
        handler.setFormatter(formatter)
        app.logger.addHandler(handler)
    
    db.init_app(app)
    Migrate(app, db)
    
    # 라우트 등록
    init_routes(app)
    
    # swagger 등록
    app.wsgi_app = ProxyFix(
        app.wsgi_app, x_for=1, x_proto=1, x_host=1, x_prefix=1
    )
    
    swagger_template = {
        "swagger": "2.0",
        "info": {
            "title": "My University API", 
            "description": "API 명세서입니다.", 
            "version": "1.0.0"
        },
        "schemes": ["https", "http"], 
        "securityDefinitions": {
            "Bearer": {
                "type": "apiKey",
                "name": "Authorization",
                "in": "header",
                "description": "Bearer Token을 입력하세요."
            }
        },
    }
    
    swagger_config = {
        "headers": [],
        "specs": [
            {
                "endpoint": 'apispec_1',
                "route": '/apispec_1.json',
                "rule_filter": lambda rule: True,
                "model_filter": lambda tag: True,
            }
        ],
        "static_url_path": "/flasgger_static",
        "swagger_ui": True,
        "specs_route": "/apidocs/"
    }
    
    Swagger(app, template=swagger_template, config=swagger_config)

    return app

app = create_app(FLASK_ENV)

if __name__ == '__main__':
    print(f"Running on port {PORT}")
    app.run(host='0.0.0.0', port=PORT)
