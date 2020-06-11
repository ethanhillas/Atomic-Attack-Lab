import jinja2
import os
import yaml

class ConfigurationModel():

  def __init__(self, conf_file_path):
    self.conf_file_path = conf_file_path
    with open(self.conf_file_path, 'r') as yaml_file:
      self.config = yaml.safe_load(yaml_file)


  def validate(self):
    for config_item, config_values in self.config.items():
      for sub_config_item, value in config_values.items():
        if value is None:
          print(sub_config_item + ' requires a value')
          exit(1)
    print('config is valid')


  def render_templates(self):
    # Hardcode templating till I find a better way to do it...
    templateLoader = jinja2.FileSystemLoader(searchpath="./templates")
    templateEnv = jinja2.Environment(loader=templateLoader)
    
    # terraform.tfvars
    TFVARS_TEMPLATE = 'terraform.tfvars.jinja2'
    TFVARS_FILE = './terraform/terraform.tfvars'
    template = templateEnv.get_template(TFVARS_TEMPLATE)
    rendered_template = template.render(
          aws_credential_profile = self.config['aws']['aws_credential_profile'],
          project_name = self.config['project']['project_name'],
          ssh_public_key_file = self.config['certs']['ssh_public_key_file'],
          win_rsa_public_key_file = self.config['certs']['win_rsa_public_key_file'],
          ovpn_instance_type = self.config['aws']['ovpn_instance_type'],
          trusted_network = self.config['aws']['trusted_network'],
          caldera_instance_type = self.config['aws']['caldera_instance_type'],
          win_rsa_private_key_file = self.config['certs']['win_rsa_private_key_file'],
          DC_instance_type = self.config['aws']['DC_instance_type'],
          Server2016_instance_type = self.config['aws']['Server2016_instance_type'], 
          Server2012R2_instance_type = self.config['aws']['Server2012R2_instance_type'] # python doesnt allow variables to start with a number...!
    )
    with open(TFVARS_FILE, "w") as outfile:
      outfile.write(rendered_template)
      print("Writing " + TFVARS_FILE)

    ## ansible-runner extravars file (caldera & ovpn)
    EXTRAVARS_TEMPLATE = 'extravars_linux.jinja2'
    EXTRAVARS_FILES = ['./ansible/ovpn/env/extravars', './ansible/caldera/env/extravars']
    template = templateEnv.get_template(EXTRAVARS_TEMPLATE)
    rendered_template = template.render(
              ssh_private_key_file = self.config['certs']['ssh_private_key_file']
    )
    for extravars in EXTRAVARS_FILES:
      with open(extravars, 'w') as outfile:
        outfile.write(rendered_template)
        print("Writing " + extravars)


  def get_init_values(self):
    init_values = {}
    init_values['bucket'] = self.config['aws']['terraform_s3_backend_bucket_name']
    init_values['dynamodb_table'] = self.config['aws']['terraform_dynamodb_backend_table_name']
    init_values['key'] = self.config['aws']['terraform_s3_backend_key']
    init_values['region'] = self.config['aws']['terraform_s3_backend_region']
    return init_values


  def cleanup(self):
    os.remove('./terraform/terraform.tfvars')
