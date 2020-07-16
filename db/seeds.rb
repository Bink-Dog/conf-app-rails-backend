# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

user1 = User.create(name: "Test User #1", email: "test1@test.com")

event1 = Event.create(name: "Tuturial Event")

user_event1 = UserEvent.create(user_id: user1.id, event_id: event1.id)

