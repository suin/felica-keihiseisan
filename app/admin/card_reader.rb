ActiveAdmin.register CardReader do
  menu priority: 500
  permit_params :name, :token

  controller do
    # Custom new method
    def new
      super do |format|
        @card_reader.token = SecureRandom.urlsafe_base64
      end
    end
  end

  form do |f|
    f.inputs do
      f.input :name
      f.input :token
    end
    f.actions
  end
end
