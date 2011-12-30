class PeopleController < ApplicationController

	before_filter :authenticate, :except => [:login, :new, :create]

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

		if @person.save
	    respond_to do |format|
      	flash[:notice] = "User was successfully created."
        format.html { redirect_to (posts_path) }
    		format.json  { render :json => @person }
      end
    else
    	respond_to do |format|
        flash[:error] = "User can\'t be created"
        format.html { render :action => "new" }
        format.json  { render :json => @person.errors }
      end
    end
	end


	# GET /posts/people/login - renders login form
  # POST /posts/people/login - processes the login
  def login
    session[:id] = nil
    if request.post?
			person = Person.find_by_login_and_password(params[:login], params[:password])
      if person
       	session[:id] = person.id
				session[:firstname] = person.firstname
				session[:name] = person.name
        session[:login] = person.login
        session[:password] = person.password
       
				respond_to do |format|
					flash[:notice] = "Authentication is successful !"
          format.html { redirect_to(posts_path) }
      		format.json  { render :json => @person}    			
					format.js
				end 
      else
        person = nil
        params[:password] = nil

        respond_to do |format|
					flash[:error] = "Authentication error !"
        	format.html { redirect_to(posts_path) }
        	format.json  { render :json => @person.errors }    			
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
			flash[:notice] = "Successful disconnection !"
      format.html { redirect_to(posts_path) }
   		format.json  { render :json => @person }
		end
  end	


	# GET /posts/person/:id
  def show
    @person = Person.find(params[:person_id])
		if session[:id].nil?
	 		respond_to do |format|
        flash[:error] = "User account can not be viewed !"
        format.html { redirect_to(posts_path) }
        format.json  { render :json => @person.errors }
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
    @person = Person.find(params[:person_id])
  end


	# PUT /posts/person/:id
  def update
    @person = Person.find(params[:person_id])
		@person.firstname = params[:firstname]
		@person.name = params[:name]
		@person.login = params[:login]
		@person.password = params[:password]
		
		if @person.save
	    respond_to do |format|
      	flash[:notice] = "User account was successfully updated !"
        format.html { redirect_to(show_person_path) }
    		format.json  { render :json => @person }
      end
    else
    	respond_to do |format|
        flash[:error] = "User can\'t be updated"
        format.html { render :action => "edit" }
        format.json  { render :json => @person.errors }
      end
    end
  end  


	# DELETE /posts/person/:id
  def delete
    @person = Person.find(params[:person_id])
		if session[:id].nil?
    	respond_to do |format|
        flash[:error] = "User account can not be destroyed !"
        format.html { redirect_to(posts_path) }
        format.json  { render :json => @person.errors }    
			end
		else
			@person.destroy
			session[:id] = nil
		  session[:firstname] = nil
		  session[:name] = nil
		  session[:login] = nil
		  session[:password] = nil

    	respond_to do |format|
        flash[:notice] = "User account was successfully destroyed !"
      	format.html { redirect_to(posts_path) }
      	format.json  { head :ok }
			end
    end
  end

end
