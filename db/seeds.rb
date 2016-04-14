def create_admin_if_new(email, name)
  admin = Admin.find_by(email: email)
  if !admin
    admin = Admin.new(name: name, uid: email, email: email, password: "abcdabcd", password_confirmation: "abcdabcd")
    admin.skip_confirmation!
    admin.save!
  end
end

create_admin_if_new("admin@nucleo235.com.br", "Henrique")
