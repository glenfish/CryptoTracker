def encrypt(unencrypted_password)
    encrypted = Base64.encode64(unencrypted_password)
    return encrypted.chomp
  end
  
  def decrypt(encrypted_password)
    unencrypted = Base64.decode64(encrypted_password)
    return unencrypted
  end