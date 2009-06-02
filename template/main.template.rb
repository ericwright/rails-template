# template.rb
@template = @root + "/../template" # This is a big assumption, but I use it everywhere -- FIXME
@app = @root.split('/').last # new name of the app

# other templates
load_template "#{@template}/authlogic.template.rb"

# gems
gem "haml"
gem 'sqlite3-ruby', :lib => 'sqlite3'
rake('gems:install', :sudo => true)
run "haml --rails #{@root}"

# remove cruft
run "rm public/index.html"
run "rm README"
run "rm public/index.html"
run "rm public/favicon.ico"
run "rm public/robots.txt"
run "rm -f public/javascripts/*"
run "rm -f public/images/*"

# add jquery helpers in application.js
run "cp #{@template}/application.js public/javascripts/application.js"

# add reset.css
run "cp #{@template}/reset.css public/stylesheets/reset.css"

# application.haml layout
run "cp #{@template}/application.haml app/views/layouts/application.haml"

# create sample data w users
run "cp #{@template}/users.yml test/fixtures/users.yml"

# create mkdb script and run it
run "cp #{@template}/mkdb script/mkdb; chmod +x script/mkdb; ./script/mkdb"

# new repo
git :init

# Set up .gitignore files
run "touch tmp/.gitignore log/.gitignore vendor/.gitignore"
run %{find . -type d -empty | grep -v "vendor" | grep -v ".git" | grep -v "tmp" | xargs -I xxx touch xxx/.gitignore}

file '.gitignore', <<-END
.DS_Store
log/*.log
tmp/**/*
config/database.yml
db/*.sqlite3
END

git :add => "."
git :commit => "-a -m 'Initial commit'"

# finish
puts "--- Template Finished ---"
