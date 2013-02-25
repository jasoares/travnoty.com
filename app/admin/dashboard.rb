ActiveAdmin.register_page "Dashboard" do

  menu :priority => 1, :label => proc{ I18n.t("active_admin.dashboard") }

  content :title => proc{ I18n.t("active_admin.dashboard") } do
    div :class => "blank_slate_container", :id => "dashboard_default_message" do
      span :class => "blank_slate" do
        span I18n.t("active_admin.dashboard_welcome.welcome")
        small I18n.t("active_admin.dashboard_welcome.call_to_action")
      end
    end

    # Here is an example of a simple dashboard with columns and panels.
    #
    # columns do
    #   column do
    #     panel "Recent Posts" do
    #       ul do
    #         Post.recent(5).map do |post|
    #           li link_to(post.title, admin_post_path(post))
    #         end
    #       end
    #     end
    #   end

    #   column do
    #     panel "Info" do
    #       para "Welcome to ActiveAdmin."
    #     end
    #   end
    # end
  end # content
end

ActiveAdmin::Dashboards.build do
  section "Rounds finished recently" do
    table_for Round.ended.where('end_date > ?', 5.days.ago).order('updated_at desc').limit(10) do
      column :server do |round|
        link_to round.server.name, [:admin, round.server]
      end
      column :hub do |round|
        link_to round.server.hub.name, [:admin, round.server.hub]
      end
      column :start_date
      column :end_date
      column :version
    end
    strong { link_to "View All Rounds", admin_rounds_path }
  end

  section "Restarting rounds" do
    table_for Round.restarting.order('start_date desc') do
      column :server do |round|
        link_to round.server.name, [:admin, round.server]
      end
      column :hub do |round|
        link_to round.server.hub.name, [:admin, round.server.hub]
      end
      column :start_date
      column :end_date
      column :version
    end
    strong { link_to "View All Rounds", admin_rounds_path }
  end
end