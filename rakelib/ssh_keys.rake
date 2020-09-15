# frozen_string_literal: true

##############################################################################################
# SSH KEY RETRIEVAL
##############################################################################################

# This is an example of retrieving SSH key material from HCAP Deploy.
servers.each do |server|
  # Assume an output name to read from.
  key_name = "#{server.name}-ssh_key_pem"

  # This simple task collects an SSH key from HCAP Deploy (assuming SERVERNAME-ssh_key_pem as an output name)
  task target("ssh-keys/#{server.name}-key.pem") => all_layer_output_files do
    key_material = find_first_output key_name
    if key_material.nil? || key_material.empty?
      warn "Unable to retrieve SSH key material for server: #{server.name}"
    else
      info "Downloading SSH key material for server: #{server.name}"
      rm_f target("ssh-keys/#{server.name}-key.pem")
      mkdir_p target('ssh-keys')
      File.write target("ssh-keys/#{server.name}-key.pem"), key_material

      # Because SSH keys are secrets, we don't want them hanging around in Jenkins.
      at_exit { rm_f target("ssh-keys/#{server.name}-key.pem") }

      # Some tools refuse to use keys if permissions are not restrictive enough.
      chmod 0400, target("ssh-keys/#{server.name}-key.pem")
    end
  end
end
