class MoviesController < ApplicationController
  
  def index
    case params[:duration].to_i
    when 1 then query = "runtime_in_minutes < 90"
    when 2 then query = "runtime_in_minutes BETWEEN 90 and 120"
    when 3 then query = "runtime_in_minutes > 120"
    end
    @movies =  Movie.order(:title)
                    .where('title LIKE ?', "%#{params[:title]}%")
                    .where('director LIKE ?', "%#{params[:director]}%")
                    .where(query)
  end

  def show
    @movie = Movie.find(params[:id])
  end

  def new
    @movie = Movie.new
  end

  def edit
    @movie = Movie.find(params[:id])
  end

  def create
    @movie = Movie.new(movie_params)

    if @movie.save
      redirect_to movies_path, notice: "#{@movie.title} was submitted successfully!"
    else
      render :new
    end
  end

  def update
    @movie = Movie.find(params[:id])

    if @movie.update_attributes(movie_params)
      redirect_to movie_path(@movie)
    else
      render :edit
    end
  end

  def destroy
    @movie = Movie.find(params[:id])
    @movie.destroy
    redirect_to movies_path
  end

  protected

  def movie_params
    params.require(:movie).permit(
      :title, :release_date, :director, :runtime_in_minutes, :poster_image_url, :description, :image
    )
  end

end
