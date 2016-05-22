ActiveAdmin.register_page "Dashboard" do

  menu priority: 1, label: proc{ I18n.t("active_admin.dashboard") }

  content title: proc{ I18n.t("active_admin.dashboard") } do

    columns do
      column do
        panel "Recent Ideas" do
          ul do
            Idea.limit(5).map do |idea|
              li link_to(idea.title, admin_idea_path(idea))
            end
          end
        end
      end
      column do
        panel "Recent Users" do
          ul do
            User.order(created_at: :desc).limit(5).map do |user|
              li link_to(user.name, admin_user_path(user))
            end
          end
        end
      end
    end
  end
end
