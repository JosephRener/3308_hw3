class MoviesController < ApplicationController

  def show
    id = params[:id] # retrieve movie ID from URI route
    @movie = Movie.find(id) # look up movie by unique ID
    # will render app/views/movies/show.<extension> by default
  end

  def index
    @all_ratings = Movie.all_ratings

    session.clear
    sparams = session[:movies_index_params] || Hash.new;

    # fix params if all boxes unchecked
    (@all_ratings.select { |r| params[r] == '1' }).length == 0 &&
      @all_ratings.each { |r| params[r] = (sparams[r] == '1' ? '1' : nil ) }

    refresh = false
    # set all missing params to their saved counterparts
    sparams.each { |k, v|
      !(@all_ratings.include? k) &&
        (params[k] = params[k] || ((refresh = true) && v)) }

    # set new params in session
    session[:movies_index_params] = params

    # set order_by variable
    order_by = (['title', 'release_date'].include? params[:order_by]) ? params[:order_by] : 'none'

    # filter and order the movies for display
    @movies = Movie.where(((@all_ratings.select {|rating|
      params[rating] == '1'
    }).map { |rating|
      "rating = '" + rating + "'"
    }).join(' OR '), params).order(
      (order_by != 'none') && (order_by + ' ASC'))

    # refresh if params do not match url
    refresh &&
      (flash.keep && redirect_to(sort_movies_path(order_by, params)))
  end

  def new
    # default: render 'new' template
  end

  def create
    @movie = Movie.create!(params[:movie])
    flash[:notice] = "#{@movie.title} was successfully created."
    redirect_to movies_path
  end

  def edit
    @movie = Movie.find params[:id]
  end

  def update
    @movie = Movie.find params[:id]
    @movie.update_attributes!(params[:movie])
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
