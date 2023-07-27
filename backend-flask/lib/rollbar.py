from flask import got_request_exception
from time import strftime
import os
import rollbar
import rollbar.contrib.flask

## XXX hack to make request data work with pyrollbar <= 0.16.3
def _get_flask_request():
    print("Getting flask request")
    from flask import request
    print("request:", request)
    return request
rollbar._get_flask_request = _get_flask_request

def _build_request_data(request):
    return rollbar._build_werkzeug_request_data(request)
rollbar._build_request_data = _build_request_data
## XXX end hack

def init_rollbar(app):
  # @app.before_first_request
  rollbar_access_token = os.getenv('ROLLBAR_ACCESS_TOKEN')
  flask_env = os.getenv('FLASK_ENV')
  """init rollbar module"""
  rollbar.init(
    rollbar_access_token,
    flask_env,
    root = os.path.dirname(os.path.realpath(__file__)),
    allow_logging_basic_config = False
  )
  got_request_exception.connect(rollbar.contrib.flask.report_exception, app)
  return rollbar