# frozen_string_literal: true

Sequel.seed(:development) do
  def run
    puts 'Seeding cates'
    create_cates
  end
end
  
require 'yaml'
DIR = File.dirname(__FILE__)
CATES_INFO = YAML.load_file("#{DIR}/cates_seed.yml")

  
def create_cates
  CATES_INFO.each do |cate_info|
    Howtosay::Cate.create(cate_info)
  end
end
  
# def create_owned_projects
#     OWNER_INFO.each do |owner|
#       account = Credence::Account.first(username: owner['username'])
#       owner['proj_name'].each do |proj_name|
#         proj_data = PROJ_INFO.find { |proj| proj['name'] == proj_name }
#         Credence::CreateProjectForOwner.call(
#           owner_id: account.id, project_data: proj_data
#         )
#       end
#     end
#   end
  
#   def create_documents
#     doc_info_each = DOCUMENT_INFO.each
#     projects_cycle = Credence::Project.all.cycle
#     loop do
#       doc_info = doc_info_each.next
#       project = projects_cycle.next
#       Credence::CreateDocumentForProject.call(
#         project_id: project.id, document_data: doc_info
#       )
#     end
#   end
  
#   def add_collaborators
#     contrib_info = CONTRIB_INFO
#     contrib_info.each do |contrib|
#       proj = Credence::Project.first(name: contrib['proj_name'])
#       contrib['collaborator_email'].each do |email|
#         collaborator = Credence::Account.first(email: email)
#         proj.add_collaborator(collaborator)
#       end
#     end
#   end