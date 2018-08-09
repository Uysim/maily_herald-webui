module MailyHerald
	class Webui::DispatchesController < Webui::ResourcesController
    def index
      super do |scope|
        scope.not_archived
      end
    end

    def archived
      scope = resource_spec.scope.archived
       @items = smart_listing_create(:items, scope, :partial => resource_spec.items_partial || "items")
      render "index"
    end

    def update_form
      new
      @item.attributes = item_params
    end

    def destroy
      if @item.archived? && params[:really_destroy] == 'true'
        if @item.destroy
          flash[:notice] = "destroyed"
          redirect_to :action => :index
        else
          flash[:notice] = @item.errors.full_messages.to_sentence
          redirect_back(fallback_location: root_path)
        end
      else
        @item.archive!

        render_containers ["details", "subscribers"]
        render_update
      end
    end

    def toggle
      find_item

      unless @item.enabled?
        @item.enable!
      else
        @item.disable!
      end

      render_containers ["details", "subscribers"]
      render_update
    end
  end
end
