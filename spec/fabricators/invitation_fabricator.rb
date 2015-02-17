Fabricator(:invitation) do
  guest_email {Faker::Internet.email}
  token {SecureRandom.urlsafe_base64}
  guest_name {Faker::Name.name}
  invitation_message  {Faker::Lorem.paragraph(2)}
  user
end
