class MoviesController < ApplicationController

  def show
    id = params[:id] # retrieve movie ID from URI route
    @movie = Movie.find(id) # look up movie by unique ID
    # will render app/views/movies/show.<extension> by default
  end

  def index
    @all_ratings = Movie.all_ratings

    if (params[:commit] == 'Refresh')
      @all_ratings.each do |rating|
        params[rating] = params[rating] || '0'
      end
    end
    params.delete(:commit)

    if ((@all_ratings.select { |r| params[r] == '1'}).length == 0)
      @all_ratings.each do |rating|
        params[rating] = session[:movies_index_params][rating]
      end
    end

    (session[:movies_index_params] || []).each do |k, v|
      params[k] = params[k] || v
    end
    session[:movies_index_params] = params

    order_by = params[:order_by] || 'none'
    if (['title', 'release_date'].include? order_by)
      order_by += ' ASC'
    end

    @movies = Movie.where(((@all_ratings.select {|rating|
      (params[rating] == '1')
    }).map { |rating|
      "rating = '" + rating + "'"
    }).join(' OR '), params).order(order_by)
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
