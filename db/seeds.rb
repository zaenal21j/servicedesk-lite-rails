# This file should ensure the existence of records required to run the application in every environment (production,
# development, test). The code here should be idempotent so that it can be executed at any point in every environment.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Example:
#
#   ["Action", "Comedy", "Drama", "Horror"].each do |genre_name|
#     MovieGenre.find_or_create_by!(name: genre_name)
#   end
workspace = Workspace.find_or_create_by!(slug: "northstar-support") { |w| w.name = "Northstar Support" }
user = User.find_or_initialize_by(email: "demo@servicedesk.test")
user.update!(password: "demo1234", workspace: workspace, role: "admin", api_token: "demo-api-token")
acme = Customer.find_or_initialize_by(email: "maya@acme.example")
acme.update!(name: "Maya Chen", company: "Acme Labs", phone: "+1 555 0142", workspace: workspace)
north = Customer.find_or_initialize_by(email: "leo@northstar.example")
north.update!(name: "Leo Martins", company: "Northstar Studio", phone: "+351 210 555 019", workspace: workspace)
Ticket.find_or_create_by!(subject: "CSV export drops accented characters") { |t| t.assign_attributes(customer: acme, description: "The weekly customer export replaces accented characters. Preserve UTF-8 and add a regression test.", status: "open", priority: "high") }
Ticket.find_or_create_by!(subject: "Webhook retries create duplicate records") { |t| t.assign_attributes(customer: north, description: "Add idempotency handling to the inbound webhook workflow and document the behavior.", status: "in_progress", priority: "medium") }
