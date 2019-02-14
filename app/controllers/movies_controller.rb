class MoviesController < ApplicationController

  def movie_params
    params.require(:movie).permit(:title, :rating, :description, :release_date)
  end

  def show
    id = params[:id] # retrieve movie ID from URI route
    @movie = Movie.find(id) # look up movie by unique ID
    # will render app/views/movies/show.<extension> by default
  end

  def index
    @ratings = params[:ratings]
    
    if params[:ratings] && params[:sort] =='sortByTitle'
      @movies = Movie.where(:rating => params[:ratings].keys).order('title')
       @title_header = 'hilite'
    elsif params[:ratings] && params[:sort] =='sortByReleaseDate'
      @movies = Movie.where(:rating => params[:ratings].keys).order('release_date')
      @rd_header = 'hilite'
    elsif params[:ratings] && !params[:sort]
      @movies = Movie.where(:rating => params[:ratings].keys)
    elsif !params[:ratings] && params[:sort] =='sortByReleaseDate'
      @movies = Movie.order('release_date')
      @rd_header = 'hilite'
    elsif !params[:ratings] && params[:sort] =='sortByTitle'
      @movies = Movie.order('title')
      @title_header = 'hilite'
    else  
      @movies = Movie.all
    end
    
    @all_ratings = Movie.all_ratings
   
    if !@set_ratings
      @set_ratings =Hash.new
    end
    #comment
  end

  def new
    # default: render 'new' template
  end

  def create
    @movie = Movie.create!(movie_params)
    flash[:notice] = "#{@movie.title} was successfully created."
    redirect_to movies_path
  end

  def edit
    @movie = Movie.find params[:id]
  end

  def update
    @movie = Movie.find params[:id]
    @movie.update_attributes!(movie_params)
    flash[:notice] = "#{@movie.title} was successfully updated."
    redirect_to movie_path(@movie)
  end

  def destroy
    @movie = Movie.find(params[:id])
    @movie.destroy
    flash[:notice] = "Movie '#{@movie.title}' deleted."
    redirect_to movies_path
  end

end
