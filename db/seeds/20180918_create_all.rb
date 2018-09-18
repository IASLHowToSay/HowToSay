# frozen_string_literal: true

Sequel.seed(:development) do
  def run
    puts 'Seeding system, organizations, cates, details, sources, questions'
    create_system
    create_organizations
    create_cates
    create_details
    create_sources
    create_questions
  end
end
  
require 'yaml'
DIR = File.dirname(__FILE__)
SYSTEM_INFO = YAML.load_file("#{DIR}/system_seeds.yml")
ORGANIZATIONS_INFO = YAML.load_file("#{DIR}/organization_seeds.yml")
CATES_INFO = YAML.load_file("#{DIR}/cate_seeds.yml")
DETAILS_INFO = YAML.load_file("#{DIR}/detail_seeds.yml")
SOURCES_INFO = YAML.load_file("#{DIR}/source_seeds.yml")
QUESTIONS_INFO = YAML.load_file("#{DIR}/question_seeds.yml")

def create_system
  SYSTEM_INFO.each do |system_info|
    Howtosay::System.create(system_info)
  end
end

def create_organizations
  ORGANIZATIONS_INFO.each do |organization_info|
    Howtosay::Organization.create(organization_info)
  end
end
  
def create_cates
  CATES_INFO.each do |cate_info|
    Howtosay::Cate.create(cate_info)
  end
end

def create_details
  DETAILS_INFO.each do |detail_info|
    cate = Howtosay::Cate.first(name: detail_info['cate'])
    detail ={
        name: detail_info['name'],
        cate_id: cate.id,
        description: detail_info['description']
    }
    Howtosay::Detail.create(detail)
  end
end

def create_sources
  SOURCES_INFO.each do |source_info|
    Howtosay::Source.create(source_info)
  end
end

def create_questions
  system = Howtosay::System.first()
  rewrite_people = system.rewrite_people
  grade_people = system.grade_people
  QUESTIONS_INFO.each do |question_info|
    cate = Howtosay::Cate.first(name: question_info['cate'])
    source = Howtosay::Source.first(name: question_info['source'])
    question ={
      cate_id: cate.id,
      source_id: source.id,
      content: question_info['content'],
      rewrite_people: rewrite_people,
      grade_people: grade_people
    }
    Howtosay::Question.create(question)
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