## Flask
from flask import request,g

## Decorators
from aws_xray_sdk.core import xray_recorder
from lib.cognito_jwt_token import jwt_required
from flask_cors import cross_origin

## Services
from services.users_short import UsersShort
from services.update_profile import UpdateProfile
from services.user_activities import UserActivities

## Helpers
from lib.helpers import model_json

def load(app):
  @app.route("/api/users/@<string:handle>/short", methods=['GET'])
  def data_users_short(handle):
    data = UsersShort.run(handle)
    return data, 200

  @app.route("/api/profile/update", methods=['POST','OPTIONS'])
  @cross_origin()
  @jwt_required()
  def data_update_profile():
    bio          = request.json.get('bio',None)
    display_name = request.json.get('display_name',None)
    model = UpdateProfile.run(
      cognito_user_id=g.cognito_user_id,
      bio=bio,
      display_name=display_name
    )
    return model_json(model)

  @app.route("/api/activities/@<string:handle>", methods=['GET'])
  @xray_recorder.capture('activities-users')
  def data_handle(handle):
    return return_model(UserActivities.run(handle))