from flask import got_request_exception
from time import strftime
import os
import rollbar
import rollbar.contrib.flask

def init_rollbar(app):
  # @app.before_first_request
  rollbar_access_token = os.getenv('ROLLBAR_ACCESS_TOKEN')
  """init rollbar module"""
  rollbar.init(
    rollbar_access_token,
    'production',
    root = os.path.dirname(os.path.realpath(__file__)),
    allow_logging_basic_config = False
  )
  got_request_exception.connect(rollbar.contrib.flask.report_exception, app)
  return rollbar