module Estatisticas
  class Hooks < Redmine::Hook::ViewListener
    
    def controller_timelog_edit_before_save(context={ })
		  if ((Date.today - context[:time_entry].spent_on).to_i!=0)
        #context[:params].save=false
      end
		  return ''
		
    end
    
    def view_timelog_edit_form_bottom(context={})
      
      #render_on :view_timelog_edit_form_bottom, :partial => 'issues/show_weight'
    end
    
  end
end