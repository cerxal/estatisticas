# Plugin's routes
# See: http://guides.rubyonrails.org/routing.html

get '/project/:project_id/estatisticas', :to => 'estatisticas#mostrar'
