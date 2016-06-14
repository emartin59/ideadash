ActiveAdmin.register Payment do
  actions :all, :except => [:edit, :update, :destroy]

  index do
    id_column
    column :sender
    column :recipient
    column :amount
    column :paypal_status
    column :created_at
    actions
  end

  controller do
    def scoped_collection
      Payment.where("paypal_status = 'approved' OR paypal_id IS NULL")
    end
  end
end
