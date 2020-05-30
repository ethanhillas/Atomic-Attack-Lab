import jinja2
import os

class ConfigurationModel():

  # List of file paths relative to the root directory
  template_file_paths = {"terraform.tfvars": "terraform/terraform.tfvars"}

  def __init__(self):
    

  def render_templates(self):
    cwd = os.getcwd()
    for template in template_file_paths:
      template.key