ActiveAdmin.register Emotion do


  index do
    column :name
    column :emotion_type
    column "Actions" do |emotion|
      span link_to "View", admin_emotion_path(emotion)
    end
  end

  form do |f|                         
    f.inputs "Emotion Details" do       
      f.input :emotion_type                  
      f.input :name 
      f.input :enabled_image 
      f.input :disabled_image            
      f.input :order 
    end                               
    f.actions                         
  end  
 
end
