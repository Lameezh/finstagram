delete '/likes' do
like = Like.find(params[:id])
like.destroy
redirect(back)
end


post '/likes' do 
    finstagram_post_id = params[:finstagram_post_id]
    like= Like.new({ finstagram_post_id: finstagram_post_id, user_id: current_user.id})
    like.save

    redirect(back)
end


post '/comments' do

  text = params[:text]
  finstagram_post_id = params[:finstagram_post_id]

  comment = Comment.new({ text: text, finstagram_post_id: finstagram_post_id, user_id: current_user.id })

  comment.save

  redirect(back)
end

helpers do
  def current_user
    User.find_by(id: session[:new_user_id])
  end
end

get '/' do 
    @finstagram_posts = FinstagramPost.order(created_at: :desc)
    @current_user = User.find_by(id: session[:new_user_id])
    erb(:index)
end 

get '/logout' do
    session[:new_user_id] = nil
    redirect to ('/')
end

get '/signup' do
    @new_user = User.new
    erb(:signup)
end


post '/signup' do
    email = params[:email]
    avatar_url = params[:avatar_url]
    username = params[:username] 
    password = params[:password]


    @new_user = User.new({ email: email, avatar_url: avatar_url, username: username, password: password})
   

    if @new_user.save
       redirect to ('login')
    else
        erb(:signup)
    end
end

get '/login' do
    erb(:login)
end

post '/login' do
    username = params[:username]
    password = params[:password]

    @new_user= User.find_by(username: username)    

    if @new_user && @new_user.password == password
        session[:new_user_id] = @new_user.id
        redirect to ('/')
        "Success! User with id #{session[:new_user_id]} is logged in!"
    else
        @error_message = "Login failed!"
        erb(:login)
    end
end

get '/finstagram_posts/new' do
    @finstagram_post = FinstagramPost.new
    erb(:"finstagram_posts/new")
end
post '/finstagram_posts' do
  photo_url = params[:photo_url]

  @finstagram_post = FinstagramPost.new({ photo_url: photo_url, user_id: current_user.id })

  if @finstagram_post.save
    redirect(to('/'))
  else
    erb(:"finstagram_posts/new")
  end
end
  get '/finstagram_posts/:id' do
    @finstagram_post = FinstagramPost.find(params[:id])   # find the finstagram post with the ID from the URL
    erb(:"finstagram_posts/show")               # render app/views/finstagram_posts/show.erb
    end








