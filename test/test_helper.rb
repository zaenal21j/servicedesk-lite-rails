ENV["RAILS_ENV"] ||= "test"
require_relative "../config/environment"
require "rails/test_help"

module ActiveSupport
  class TestCase
    # Run tests in parallel with specified workers
    parallelize(workers: :number_of_processors, with: :threads)

    # Setup all fixtures in test/fixtures/*.yml for all tests in alphabetical order.
    # Add more helper methods to be used by all tests here...
  end
end

class ActionDispatch::IntegrationTest
  def demo_user
    workspace = Workspace.find_or_create_by!(slug: "test-workspace") { |record| record.name = "Test Workspace" }
    User.find_or_create_by!(email: "demo@servicedesk.test") do |user|
      user.assign_attributes(password: "demo1234", workspace: workspace, role: "admin")
    end
  end

  def sign_in(user = demo_user)
    post login_url, params: { email: user.email, password: "demo1234" }
  end
end
