require 'securerandom'

class GoogleSignIn::AuthorizationsController < GoogleSignIn::BaseController
  skip_forgery_protection only: :create

  def create
    redirect_to login_url(scope: "openid profile email #{GoogleSignIn.extra_scopes&.join(" ")}", state: state),
      allow_other_host: true, flash: { proceed_to: params.require(:proceed_to), state: state }
  end

  private
    def login_url(**params)
      if GoogleSignIn.require_refresh_token
        client.auth_code.authorize_url(access_type: :offline, approval_prompt: :force, **params)
      else
        client.auth_code.authorize_url(prompt: 'login', **params)
      end
    end

    def state
      @state ||= SecureRandom.base64(24)
    end
end
