"""Controllers package - Architecture MVC

Les controllers gèrent la logique métier et font le lien entre
les models (données) et les views (templates).
"""

from app.controllers.auth_controller import auth_bp
from app.controllers.home_controller import home_bp
from app.controllers.qcm_controller import qcm_bp
from app.controllers.chatbot_controller import chatbot_bp

__all__ = ['auth_bp', 'home_bp', 'qcm_bp', 'chatbot_bp']
