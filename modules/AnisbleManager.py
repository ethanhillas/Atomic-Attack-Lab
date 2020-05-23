import ansible_runner



class AnsibleManager():

  def __init__(self, private_data_dir, playbook):
    self.private_data_dir = private_data_dir
    self.playbook = playbook

  def run(self):
    runner = ansible_runner.run(private_data_dir= self.private_data_dir, playbook=self.playbook, rotate_artifacts=1)
    print(runner.stats)