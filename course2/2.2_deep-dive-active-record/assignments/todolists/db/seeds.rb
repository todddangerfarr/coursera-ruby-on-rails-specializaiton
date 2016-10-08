# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

# destroy all instances in the database
User.destroy_all
Profile.destroy_all
TodoList.destroy_all
TodoItem.destroy_all

due_date = Date.today + 1.year

User.create! [
  {username: 'Fiorina', password_digest: 'tothetop'},
  {username: 'Trump', password_digest: 'alwayswinnng'},
  {username: 'Carson', password_digest: 'whipsers'},
  {username: 'Clinton', password_digest: 'personalemails'}
]

User.find_by(username: 'Fiorina').create_profile(
  gender: 'female', birth_year: 1954, first_name: 'Carly', last_name: 'Fiorina')
User.find_by(username: 'Trump').create_profile(
  gender: 'male', birth_year: 1946, first_name: 'Donald', last_name: 'Trump')
User.find_by(username: 'Carson').create_profile(
  gender: 'male', birth_year: 1951, first_name: 'Ben', last_name: 'Carson')
User.find_by(username: 'Clinton').create_profile(
  gender: 'female', birth_year: 1947, first_name: 'Hillary', last_name: 'Clinton')

User.find_by(username: 'Fiorina').todo_lists.create!(
  list_name: 'Run for President', list_due_date: due_date)
User.find_by(username: 'Trump').todo_lists.create!(
  list_name: 'Build a Wall', list_due_date: due_date)
User.find_by(username: 'Carson').todo_lists.create!(
  list_name: 'Study Brains', list_due_date: due_date)
User.find_by(username: 'Clinton').todo_lists.create!(
  list_name: 'Delete E-mails', list_due_date: due_date)

TodoList.find_by(list_name: 'Run for President').todo_items.create! [
  { due_date: due_date, title: 'Find VP',
    description: "Need to find a VP to run with" },
  { due_date: due_date, title: 'Raise Money',
    description: "We need a lot a lot of money" },
  { due_date: due_date, title: 'Make Fiorina 2020 posters',
    description: "Thinking a picture of my face should do" },
  { due_date: due_date, title: 'Get Tax returns ready',
    description: "Need to release these to the public soon" },
  { due_date: due_date, title: 'Get my nails done',
    description: "Can't have bad nails if I run for president" }
]

TodoList.find_by(list_name: 'Build a Wall').todo_items.create! [
  { due_date: due_date, title: 'Draw Plans for wall',
    description: "I'm the best drawer, seriously the best I know" },
  { due_date: due_date, title: 'Make America Great Again',
    description: "Seriously folks, we need to do this, need to do this" },
  { due_date: due_date, title: 'Remove the Losers',
    description: "There's no room for losers here folks. None at all." },
  { due_date: due_date, title: 'Treat Women Poorly',
    description: "It's who I am and who I will always be" },
  { due_date: due_date, title: 'Force Mexico to Pay',
    description: "I'll force them to pay, I'm the best, seriously the best" }
]

TodoList.find_by(list_name: 'Study Brains').todo_items.create! [
  { due_date: due_date, title: 'Try not to be creepy',
    description: "But I'm studying brains, this may be hard" },
  { due_date: due_date, title: "Where's Waldo",
    description: "I seriously need to find this guy" },
  { due_date: due_date, title: 'Work on Debate Skills',
    description: "Debate with self in the mirror each morning" },
  { due_date: due_date, title: 'Mystery Meat',
    description: "Find out what brains are made from" },
  { due_date: due_date, title: 'Work on people skills',
    description: "People thing I'm a little creepy" }
]

TodoList.find_by(list_name: 'Delete E-mails').todo_items.create! [
  { due_date: due_date, title: 'Clear Inbox',
    description: "Delete all e-mails from inbox" },
  { due_date: due_date, title: 'Destroy Hard Drives',
    description: "Put hard drives in the microwave" },
  { due_date: due_date, title: 'Delete personal accounts',
    description: "Deactivate g-mail and yahoo accounts" },
  { due_date: due_date, title: 'Obtain Amnesia',
    description: "What e-mails????" },
  { due_date: due_date, title: 'Iron my pant suit',
    description: "Looking a little wrinkly these days" }
]
