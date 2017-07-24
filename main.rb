require 'sinatra'
require 'sinatra/reloader'
require 'haml'
require 'sequel'
require 'mysql2'
require 'yaml'

configure do
  env = ENV['RACK_ENV']
  #db = Sequel.connect(YAML.load(File.open('database.yml'))[env])
#  db = Sequel.connect(YAML.load(File.open('database.yml')))
#  db = Sequel.connect(:adapter => 'mysql2', :user => 'root',
#                      :password => "xnynzn987", :host => "localhost" , :database => "sitepointtodo")
  @db = Sequel.connect('mysql2://root:xnynzn987@localhost/sitepointtodo')
end

class Task < Sequel::Model
#  register Sinatra::SequelExtension # this one
#
#  @completed_at
end




get '/index' do
  @title = "to-do"
  haml  :index
end

get '/' do
    @tasks = Task.all
    haml :index
end

get '/see_tasks' do
  @tasks = Task.all
  haml :see_tasks
end


get '/:task' do   #colon-> named parameter, extracted from params hash
  @task = params[:task].split('-').join(' ').capitalize
  haml :task_split
end

#post '/task' do
#  haml :new
#nd

post '/new' do
  Task.create params[:task]
  redirect to('/see_tasks')
end

delete '/task/:id' do
#  Task.get(params[:id]).destroy
  Task[:id].delete
  redirect to('/see_tasks')
end

get '/delete/:id' do
  par= params[:id].split('-')
  @dd=par[0]
  @nn=par[1]
  t=Task.new
  t[:id] =@dd
  t.delete[@dd]
  @just_deleted = @dd
  @just_deleted23 =@nn
  haml :deleted_task
#  haml :see_tasks
end

post '/complete2' do
#      @db[:tasks].where(
#      :id => params[:_id]).update(
#                 completed_at:Time.now)
#     insert_ds = @db["UPDATE TASKS SET COMPLETED_AT = #{Time.now} WHERE ID= #{params[:_id]}"]
#     puts insert_ds

@db[:tasks].where(:id => params[:_id]).update(:completed_at => Time.now)


end

post '/complete/:id' do
  par= params[:id].split('-')
  @di=par[0]
  @nn=par[1]
  t=Task.new
  t[:id] = @di
  t[:name] = @nn
#  #task.completed_at = task.completed_at.nil? ? Time.now  : nil
  t.completed_at =  Time.now

  t.save
  params.inspect
  @just_updated = :id
  haml :deleted_task
end
