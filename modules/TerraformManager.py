#from python_terraform import *
import python_terraform


class TerraformManager():

  def __init__(self):
    self.terraform = python_terraform.Terraform(working_dir='./terraform/')

  def build(self):
    self.terraform.apply(no_color=python_terraform.IsFlagged, capture_output='yes', skip_plan=True)

  def destroy(self):
    self.terraform.destroy(no_color=python_terraform.IsFlagged, capture_output='yes')

  def refresh(self): 
    self.terraform.cmd("refresh", no_color=python_terraform.IsFlagged, capture_output='yes')