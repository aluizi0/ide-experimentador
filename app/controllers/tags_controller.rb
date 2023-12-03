class TagsController < ApplicationController
  skip_forgery_protection
  # get all tags
  def get_all
    render json: Tag.all
  end

  def create
    tag = Tag.new(params.require(:tag).permit(:name, :color))
    if tag.save
      render json: tag
    else
      render json: tag.errors
    end
  end
end
