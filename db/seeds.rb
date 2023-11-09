# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: "Star Wars" }, { name: "Lord of the Rings" }])
#   Character.create(name: "Luke", movie: movies.first)


repo_1 = Repository.create!(name: "repo-test-1", 
                          description: "repo_1 for testing")
                          
user_1=User.create!(github_login:'user_1')
pr_1=repo_1.pull_requests.create!(title: "pr_1", author: user_1)
review_1 = pr_1.reviews.create!(author: user_1, state: 1)
stat_1 = Statistic.create!(repository: repo_1, user: user_1, year: 2023, month: 10)




10.times do |i|
  github_login = "User #{i+1}"
  User.create!(github_login:github_login)
end


20.times do |i|
  title="PR #{i+1}"
  PullRequest.create!(title:'pr-test-1',author: user_1, repository: repo_1)
end





