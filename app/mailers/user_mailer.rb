class UserMailer < ApplicationMailer
  def reset_password(name, email, new_password)
    @name = name
    @email = email
    @new_password = new_password
    mail(to:@email, subject: 'Senha gerada para Roupa Livre')
  end
end
