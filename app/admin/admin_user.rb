ActiveAdmin.register AdminUser do     
  index do                            
    column :email                     
    column :current_sign_in_at        
    column :last_sign_in_at           
    column :sign_in_count             
    default_actions                   
  end                                 

  filter :email                       

  form do |f|                         
    f.inputs "Admin Details" do       
      f.input :email                  
      f.input :password               
      f.input :password_confirmation  
    end                               
    f.actions                         
  end                                 
end                                   

ActiveAdmin.register Hub do
  scope :all, :default => true
  scope :mirrors

  index do
    column :name
    column :host
    column :code
    column :language
    default_actions
  end
end

ActiveAdmin.register Server do
  scope :all, :default => true
  scope :ended
  scope :running
  scope :restarting

  index do
    column :code
    column :host
    column :name
    column :speed
    column :world_id
    column :hub
    column :start_date, sortable: false
    column :end_date, sortable: false
    default_actions
  end
end

ActiveAdmin.register Round do
  scope :all, :default => true
  scope :ended
  scope :restarting
  scope :running

  index do
    column :server
    column :start_date
    column :end_date
    column :version
    default_actions
  end
end
