class ContentsController < ApplicationController
  before_filter :init_content, :action => {:edit, :update, :show, :destroy}

  def index
    @contents = Content.all
  end

  def show
    redirect_to edit_content_path(@content)
  end

  def new
    @content = Content.new()
  end

  def create
    @content = Content.new(params[:content])
    if @content.save
      redirect_to edit_content_path(@content), :notice => "Content successfully created"
    else
      render :action => 'new'
    end
  end

  def edit; end

  def update
    if @content.update_attributes(params[:content])
      redirect_to edit_content_path(@content), :notice => "Content successfully updated"
    else
      render :action => 'edit'
    end
  end

  def destroy
    @content.destroy if @content.destroyable?
    redirect_to contents_path
  end

  private

    def init_content
      init_current_object { @content = Content.find_by_id(params[:id])}
    end

    def init_current_object
      @current_object = yield
    end
end
