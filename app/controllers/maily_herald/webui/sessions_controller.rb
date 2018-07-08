module MailyHerald
	class Webui::SessionsController < Webui::ApplicationController
    def switch_setting
      settings.toggle params[:setting]

      redirect_back(fallback_location: root_path)
    end

    private

    def setting_cookie_name setting
      "maily_settings_#{setting}"
    end
  end
end
