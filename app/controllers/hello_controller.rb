class HelloController < ApplicationController
  def world
    @texto = "teste"
  end
  def index
    render json: "teste1"
  end
end
