class PeopleController < ApplicationController

	# GET /posts/people/login - renders login form
  # POST /posts/people/login - processes the login
  def login
    session[:id] = nil
    if request.post?
      person = Person.find_by_login_and_password(params[:people][:login], params[:people][:password])
      if person
       	session[:id] = person.id
				session[:firstname] = person.firstname
				session[:name] = person.name
        session[:login] = person.login
        session[:password] = person.password
       
				respond_to do |format|
					flash[:notice] = "Authentification reussie !"
          format.html { redirect_to(posts_path) }
      		format.json  { render :json => @person, status: :created, location: @person }    			
					format.js
				end 
				
      else
        person = nil
        params[:password] = nil

        respond_to do |format|
					flash[:error] = "Erreur d'authentification !"
        	format.html { redirect_to(posts_path) }
        	format.json  { render :json => @person.errors, :status => :unprocessable_entity }    			
					format.js
				end
      end
    end
  end

	# GET /posts/people/logout
  def logout
    session[:id] = nil
    session[:firstname] = nil
    session[:name] = nil
    session[:login] = nil
    session[:password] = nil
    
		respond_to do |format|
			flash[:notice] = "Deconnexion reussie !"
      format.html { redirect_to(posts_path) }
   		format.json  { render :json => @person, status: :created, location: @person }
		end
  end	

  # GET /posts/person/new
  def new
    @person = Person.new

		respond_to do |format|
      format.html
      format.json  { render :json => @person }
    end
  end	

	# POST /posts/person
  def create
    @person = Person.new
		@person.firstname = params[:firstname]
		@person.name = params[:name]
		@person.login = params[:login]
		@person.password = params[:password]

		begin
      Person.transaction do
       @person.save!
        respond_to do |format|
          flash[:notice] = "Nouveau compte cree !"
          format.html { redirect_to(posts_path) }
      		format.json  { render :json => @person, status: :created, location: @person }
        end
      end
    rescue
      respond_to do |format|
        flash[:error] = "Impossible de creer le nouveau compte !"
        format.html { render :action => "new" }
        format.json  { render :json => @person.errors, :status => :unprocessable_entity }
      end
    end
	end

	# GET /posts/person/:id
  def show
    @person = Person.find(params[:id])
		if session[:id].nil?
	 		respond_to do |format|
        flash[:error] = "Impossible de visualiser le compte !"
        format.html { redirect_to(posts_path) }
        format.json  { render :json => @person.errors, :status => :unprocessable_entity }
			end
		else
	  	@firstname = @person.firstname
    	@name = @person.name
			@login = @person.login
			@password = @person.password
   
			respond_to do |format|
    	  format.html # show.html.erb
    	  format.json  { render :json => @person }
   		end
		end
  end
 

  # GET /posts/person/:id/edit
  def edit
    @person = Person.find(params[:id])
    if session[:id].nil?
    	respond_to do |format|
        flash[:error] = "Impossible de modifier le compte !"
        format.html { redirect_to(posts_path) }
        format.json  { render :json => @person.errors, :status => :unprocessable_entity }
			end
    end
  end

	# PUT /posts/person/:id
  def update
    @person = Person.find(params[:id])
		@person.firstname = params[:firstname]
		@person.name = params[:name]
		@person.login = params[:login]
		@person.password = params[:password]
		@person.save
    
		respond_to do |format|
      flash[:notice] = "Compte modifie !"
      format.html { redirect_to(show_person_path) }
    	format.json  { render :json => @person, status: :edited, location: @person }
    end
  end  

	# DELETE /posts/person/:id
  def delete
    @person = Person.find(params[:id])
		if session[:id].nil?
    	respond_to do |format|
        flash[:error] = "Impossible de supprimer le compte !"
        format.html { redirect_to(posts_path) }
        format.json  { render :json => @person.errors, :status => :unprocessable_entity }    
			end
		else
			@person.destroy
			session[:id] = nil
		  session[:firstname] = nil
		  session[:name] = nil
		  session[:login] = nil
		  session[:password] = nil

    	respond_to do |format|
        flash[:notice] = "Compte supprime !"
      	format.html { redirect_to(posts_path) }
      	format.json  { head :ok }
			end
    end
  end

	# GET /posts/people/search
  def search
    @query = params[:query]
    @people = Person.search(@query, params[:page])
    
    respond_to do |format|
      format.html # search.html.erb
      format.xml { render :xml => @people }
    end
  end
end
