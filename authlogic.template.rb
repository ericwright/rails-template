# authlogic.template.rb

gem 'authlogic'
rake 'gems:install', :sudo => true
 
# MVC for user

generate(:model, "user", "email:string", "crypted_password:string", "password_salt:string", "persistence_token:string") 

file "app/models/user.rb", <<-END
class User < ActiveRecord::Base
  acts_as_authentic
end
END

run "cp #{@template}/users_controller.rb app/controllers/users_controller.rb"
run "cp #{@template}/application_controller.rb app/controllers/application_controller.rb"

file "app/views/users/index.haml", <<-END
%h2 User List
%ul
- @users.each do |u|
  %li= u.email
END

file "app/views/users/edit.haml", <<-END
%h2 Edit Profile
= render :partial => 'form'
END

file "app/views/users/new.haml", <<-END
%h2 New Profile
= render :partial => 'form'
END

file "app/views/users/_form.haml", <<-END
- form_for @user do |f|
  = f.error_messages
  %p
    = f.label :email
    %br
    = f.text_field :email
  %p
    = f.label :password
    %br
    = f.password_field :password
  %p
    = f.label :password_confirmation
    %br
    = f.password_field :password_confirmation
  %p
    = f.submit "Submit"
END

# MVC for user_session

generate(:session, "user_session")
generate(:controller, "user_sessions")
run "cp #{@template}/user_sessions_controller.rb app/controllers/user_sessions_controller.rb"

file "app/views/user_sessions/new.haml", <<-END
%h2 Login
- form_for @user_session do |f|
  = f.error_messages
  %p
    = f.label :email
    %br
    = f.text_field :email
  %p
    = f.label :password
    %br
    = f.password_field :password
  %p
    = f.submit "Submit"
END

# add routes

file "config/routes.rb", <<-END
ActionController::Routing::Routes.draw do |map|
  map.login "login", :controller => "user_sessions", :action => "new"
  map.logout "logout", :controller => "user_sessions", :action => "destroy"

  map.resources :user_sessions
  map.resources :users

  map.root :users

  map.connect ':controller/:action/:id'
  map.connect ':controller/:action/:id.:format'
end
END

# run migrations

rake "db:migrate"

 

