SampleApp.Repo.insert!(%SampleApp.Accounts.User{
  name: "Example User",
  email: "sample@gmail.com",
  password_hash: Pbkdf2.hash_pwd_salt("foobar"),
  admin: true
})

for n <- 1..99 do
  SampleApp.Repo.insert!(%SampleApp.Accounts.User{
    name: Faker.Person.name(),
    email: "example-#{n}@example.com",
    password_hash: Pbkdf2.hash_pwd_salt("foobar")
  })
end
